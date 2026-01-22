import fs from "node:fs/promises";
import path from "node:path";
import crypto from "node:crypto";

import type { Stage } from "../../../core/pipeline/Stage.js";
import type { InputKind, InputFileRef } from "../../../core/pipeline/Context.js";

export const DiscoverFilesStage: Stage = {
    id: "discover.files",
    version: "1.0.0",
    outputs: [],

    async run(ctx) {
        const rootAbs = path.resolve(ctx.config.projectRoot);

        // Guardrails simples (constants déterministes)
        const maxFiles = 50_000;
        const maxFileSizeBytes = 10 * 1024 * 1024;

        const filesAbs: string[] = [];
        await walkDir(rootAbs, filesAbs, maxFiles);

        const refs: InputFileRef[] = [];
        for (const absPath of filesAbs) {
            const st = await fs.stat(absPath);
            if (!st.isFile()) continue;
            if (st.size > maxFileSizeBytes) continue;

            const rel = toPosix(path.relative(rootAbs, absPath));
            const kind = detectKind(absPath);
            const sha256 = await sha256File(absPath);

            refs.push({ path: rel, sha256, size: st.size, kind });
        }

        refs.sort((a, b) => a.path.localeCompare(b.path));
        ctx.inputs.files = refs;
    }
};

async function walkDir(rootAbs: string, out: string[], maxFiles: number): Promise<void> {
    // BFS with deterministic order: sort directory entries
    const queue: string[] = [rootAbs];

    while (queue.length > 0) {
        const dir = queue.shift();
        if (!dir) break;

        let entries = await fs.readdir(dir, { withFileTypes: true });
        entries = entries.sort((a, b) => a.name.localeCompare(b.name));

        for (const ent of entries) {
            const abs = path.join(dir, ent.name);

            // Basic ignores (keep small and safe for V1)
            if (ent.isDirectory()) {
                if (shouldIgnoreDir(ent.name)) continue;
                queue.push(abs);
                continue;
            }

            if (ent.isFile()) {
                out.push(abs);
                if (out.length >= maxFiles) return;
            }
        }
    }
}

function shouldIgnoreDir(name: string): boolean {
    const n = name.toLowerCase();
    return (
        n === "node_modules" ||
        n === ".git" ||
        n === ".svn" ||
        n === ".hg" ||
        n === "dist" ||
        n === "build" ||
        n === ".dart_tool" ||
        n === ".idea" ||
        n === ".vscode" ||
        n === "runs"
    );
}

function toPosix(p: string): string {
    return p.split(path.sep).join("/");
}

function detectKind(filePathAbs: string): InputKind {
    const ext = path.extname(filePathAbs).toLowerCase();

    // COBOL common extensions vary a lot, keep heuristics conservative
    if (ext === ".cbl" || ext === ".cob" || ext === ".cobol") return "cobol";
    if (ext === ".cpy" || ext === ".copy" || ext === ".copybook") return "copybook";
    if (ext === ".jcl") return "jcl";

    return "unknown";
}

async function sha256File(filePathAbs: string): Promise<string> {
    const h = crypto.createHash("sha256");
    const fh = await fs.open(filePathAbs, "r");

    try {
        const buf = Buffer.alloc(1024 * 1024); // 1MB chunks
        let pos = 0;

        while (true) {
            const { bytesRead } = await fh.read(buf, 0, buf.length, pos);
            if (bytesRead <= 0) break;
            h.update(buf.subarray(0, bytesRead));
            pos += bytesRead;
        }

        return h.digest("hex");
    } finally {
        await fh.close();
    }
}
