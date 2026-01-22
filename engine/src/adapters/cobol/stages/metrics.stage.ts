import type { Stage } from "../../../core/pipeline/Stage.js";
import type { ProducedByMeta } from "../../../core/artifacts/ArtifactTypes.js";

import type { MetricsArtifactV1 } from "../metrics.types.js";
import type { CallGraphArtifactV1 } from "../callgraph.types.js";

export const MetricsStage: Stage = {
    id: "metrics.compute",
    version: "1.0.0",
    inputs: ["callgraph"],
    outputs: ["metrics"],

    async run(ctx) {
        const producedBy: ProducedByMeta = { stageId: this.id, stageVersion: this.version };

        const callgraphMeta = ctx.artifacts.require("callgraph");
        const graph = await readJson<CallGraphArtifactV1>(ctx, callgraphMeta.path);

        const programCount = graph.nodes.filter((n) => n.kind === "program" && n.id.startsWith("program:") && !n.id.includes("#")).length;
        const copybookCount = graph.nodes.filter((n) => n.kind === "copybook").length;

        const callEdges = graph.edges.filter((e) => e.kind === "CALL");
        const performEdges = graph.edges.filter((e) => e.kind === "PERFORM");
        const copyEdges = graph.edges.filter((e) => e.kind === "COPY");

        const externalCallCount = callEdges.filter((e) => e.to.startsWith("external:")).length;

        const artifact: MetricsArtifactV1 = {
            schemaVersion: "1.0",
            adapter: "cobol",
            generatedFrom: { callgraphArtifactId: "callgraph" },

            programCount,
            callCount: callEdges.length,

            nodeCount: graph.nodes.length,
            edgeCount: graph.edges.length,
            externalCallCount,
            performCount: performEdges.length,
            copybookCount,
        };

        await ctx.artifacts.putJson("metrics", artifact, producedBy);
    }
};

async function readJson<T>(ctx: any, relPath: string): Promise<T> {
    const fs = await import("node:fs/promises");
    const path = await import("node:path");
    const abs = path.join(ctx.config.outDir, relPath);
    const raw = await fs.readFile(abs, "utf-8");
    return JSON.parse(raw) as T;
}
