import fs from "node:fs/promises";
import path from "node:path";

import type { Stage } from "../../../core/pipeline/Stage.js";
import type { ProducedByMeta } from "../../../core/artifacts/ArtifactTypes.js";
import type { InputFileRef } from "../../../core/pipeline/Context.js";
import type { CobolIndexArtifactV1, CobolProgramIndex } from "../types.js";

export const CobolIndexStage: Stage = {
    id: "cobol.index",
    version: "1.0.0",
    outputs: ["cobol_index"],

    async run(ctx) {
        const producedBy: ProducedByMeta = { stageId: this.id, stageVersion: this.version };
        const rootAbs = path.resolve(ctx.config.projectRoot);

        const cobolFiles = ctx.inputs.files.filter((f) => f.kind === "cobol" || f.kind === "copybook");

        const programs: CobolProgramIndex[] = [];
        for (const f of cobolFiles) {
            const abs = path.join(rootAbs, fromPosix(f.path));
            const content = await fs.readFile(abs, "utf-8");

            programs.push(indexOneFile(f, content));
        }

        programs.sort((a, b) => a.file.localeCompare(b.file));

        const artifact: CobolIndexArtifactV1 = {
            schemaVersion: "1.0",
            adapter: "cobol",
            generatedFrom: { fileCount: cobolFiles.length },
            programs
        };

        await ctx.artifacts.putJson("cobol_index", artifact, producedBy);
    }
};

function indexOneFile(fileRef: InputFileRef, content: string): CobolProgramIndex {
    const lines = splitLines(content);

    const calls: CobolProgramIndex["calls"] = [];
    const performs: CobolProgramIndex["performs"] = [];
    const copies: CobolProgramIndex["copies"] = [];
    let programId: string | undefined;

    for (let i = 0; i < lines.length; i++) {
        const lineNo = i + 1;
        const raw = lines[i];

        const l = normalizeLine(raw);
        if (!l) continue;

        if (!programId) {
            const pid = matchProgramId(l);
            if (pid) programId = pid;
        }

        const call = matchCall(l);
        if (call) calls.push({ target: call, raw: raw.trimEnd(), line: lineNo });

        const perf = matchPerform(l);
        if (perf) performs.push({ target: perf, raw: raw.trimEnd(), line: lineNo });

        const cpy = matchCopy(l);
        if (cpy) copies.push({ target: cpy, raw: raw.trimEnd(), line: lineNo });
    }

    calls.sort((a, b) => a.line - b.line || a.raw.localeCompare(b.raw));
    performs.sort((a, b) => a.line - b.line || a.raw.localeCompare(b.raw));
    copies.sort((a, b) => a.line - b.line || a.raw.localeCompare(b.raw));

    return {
        file: fileRef.path,
        sha256: fileRef.sha256,
        programId,
        calls,
        performs,
        copies
    };
}

function splitLines(s: string): string[] {
    return s.replace(/\r\n/g, "\n").replace(/\r/g, "\n").split("\n");
}

function normalizeLine(line: string): string | null {
    const trimmed = line.trim();
    if (!trimmed) return null;

    if (trimmed.startsWith("*") || trimmed.startsWith("*>")) return null;

    return trimmed.toUpperCase();
}

function matchProgramId(lineUpper: string): string | undefined {
    const m = lineUpper.match(/\bPROGRAM-ID\s*\.\s*([A-Z0-9_-]+)\s*\./);
    return m?.[1];
}

function matchCall(lineUpper: string): string | undefined {
    const m = lineUpper.match(/\bCALL\s+["']([^"']+)["']/);
    return m?.[1];
}

function matchPerform(lineUpper: string): string | undefined {
    const m = lineUpper.match(/\bPERFORM\s+([A-Z0-9_-]+)\b/);
    return m?.[1];
}

function matchCopy(lineUpper: string): string | undefined {
    const m1 = lineUpper.match(/\bCOPY\s+["']([^"']+)["']/);
    if (m1?.[1]) return m1[1];

    const m2 = lineUpper.match(/\bCOPY\s+([A-Z0-9_-]+)\s*\./);
    return m2?.[1];
}

function fromPosix(p: string): string {
    return p.split("/").join(path.sep);
}
