import type { Stage } from "../../../core/pipeline/Stage.js";
import type { ProducedByMeta } from "../../../core/artifacts/ArtifactTypes.js";

import type { CobolIndexArtifactV1 } from "../types.js";
import type {
    CallGraphArtifactV1,
    CallGraphEdge,
    CallGraphNode,
    EdgeKind
} from "../callgraph.types.js";

export const CallGraphStage: Stage = {
    id: "graph.call",
    version: "1.0.0",
    inputs: ["cobol_index"],
    outputs: ["callgraph"],

    async run(ctx) {
        const producedBy: ProducedByMeta = { stageId: this.id, stageVersion: this.version };

        const cobolIndexMeta = ctx.artifacts.require("cobol_index");
        const cobolIndex = await readJson<CobolIndexArtifactV1>(ctx, cobolIndexMeta.path);

        const nodes = new Map<string, CallGraphNode>();
        const edges = new Map<string, CallGraphEdge>();

        function upsertNode(node: CallGraphNode) {
            if (!nodes.has(node.id)) nodes.set(node.id, node);
        }

        function edgeKey(from: string, to: string, kind: EdgeKind): string {
            return `${from}::${kind}::${to}`;
        }

        function upsertEdge(from: string, to: string, kind: EdgeKind, ev: { file: string; line: number; raw: string }) {
            const key = edgeKey(from, to, kind);
            const existing = edges.get(key);
            if (!existing) {
                edges.set(key, { from, to, kind, evidence: [ev] });
                return;
            }
            existing.evidence.push(ev);
        }

        for (const p of cobolIndex.programs) {
            const isCopybook = p.file.toLowerCase().endsWith(".cpy") || p.file.toLowerCase().endsWith(".copy");
            const progName = p.programId ?? stripExt(p.file);

            const fromId = isCopybook ? `copybook:${progName}` : `program:${progName}`;
            upsertNode({
                id: fromId,
                label: progName,
                kind: isCopybook ? "copybook" : "program"
            });

            for (const c of p.calls) {
                if (!c.target) continue;
                const toId = `external:${c.target}`;
                upsertNode({ id: toId, label: c.target, kind: "external" });
                upsertEdge(fromId, toId, "CALL", { file: p.file, line: c.line, raw: c.raw });
            }

            for (const pe of p.performs) {
                if (!pe.target) continue;
                const toId = `${fromId}#${pe.target}`;
                upsertNode({ id: toId, label: pe.target, kind: "program" });
                upsertEdge(fromId, toId, "PERFORM", { file: p.file, line: pe.line, raw: pe.raw });
            }

            for (const cp of p.copies) {
                if (!cp.target) continue;
                const toId = `copybook:${cp.target}`;
                upsertNode({ id: toId, label: cp.target, kind: "copybook" });
                upsertEdge(fromId, toId, "COPY", { file: p.file, line: cp.line, raw: cp.raw });
            }
        }

        const nodeArr = [...nodes.values()].sort((a, b) => a.id.localeCompare(b.id));
        const edgeArr = [...edges.values()]
            .map((e) => ({
                ...e,
                evidence: [...e.evidence].sort((a, b) => a.line - b.line || a.raw.localeCompare(b.raw))
            }))
            .sort((a, b) => (a.from + a.kind + a.to).localeCompare(b.from + b.kind + b.to));

        const artifact: CallGraphArtifactV1 = {
            schemaVersion: "1.0",
            adapter: "cobol",
            generatedFrom: { cobolIndexArtifactId: "cobol_index" },
            nodes: nodeArr,
            edges: edgeArr
        };

        await ctx.artifacts.putJson("callgraph", artifact, producedBy);
    }
};

async function readJson<T>(ctx: any, relPath: string): Promise<T> {
    const fs = await import("node:fs/promises");
    const path = await import("node:path");
    const abs = path.join(ctx.config.outDir, relPath);
    const raw = await fs.readFile(abs, "utf-8");
    return JSON.parse(raw) as T;
}

function stripExt(file: string): string {
    const idx = file.lastIndexOf(".");
    return idx >= 0 ? file.slice(0, idx) : file;
}
