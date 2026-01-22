import type { Stage } from "../../../core/pipeline/Stage.js";
import type { ProducedByMeta } from "../../../core/artifacts/ArtifactTypes.js";

import type { CallGraphArtifactV1 } from "../callgraph.types.js";
import type { MetricsArtifactV1 } from "../metrics.types.js";
import type { RisksArtifactV1, RiskItem, RiskSeverity } from "../risks.types.js";

export const RisksStage: Stage = {
    id: "risks.compute",
    version: "1.0.0",
    inputs: ["callgraph", "metrics"],
    outputs: ["risks"],

    async run(ctx) {
        const producedBy: ProducedByMeta = { stageId: this.id, stageVersion: this.version };

        const callgraphMeta = ctx.artifacts.require("callgraph");
        const metricsMeta = ctx.artifacts.require("metrics");

        const graph = await readJson<CallGraphArtifactV1>(ctx, callgraphMeta.path);
        const metrics = await readJson<MetricsArtifactV1>(ctx, metricsMeta.path);

        const risks: RiskItem[] = [];

        const externalCallEdges = graph.edges.filter((e) => e.kind === "CALL" && e.to.startsWith("external:"));
        for (const e of externalCallEdges) {
            const target = e.to.replace(/^external:/, "");
            const sev: RiskSeverity = "medium";

            risks.push({
                id: `RISK_EXTERNAL_CALL_${safeId(target)}`,
                title: `External dependency via CALL "${target}"`,
                severity: sev,
                category: "dependency",
                description:
                    `Program performs an external CALL to "${target}". This creates a runtime dependency that may be hard to test or replace safely.`,
                evidence: e.evidence.map((ev) => ({
                    artifactId: "callgraph",
                    file: ev.file,
                    line: ev.line,
                    raw: ev.raw
                }))
            });
        }

        if (metrics.performCount >= 50) {
            risks.push({
                id: "RISK_HIGH_PERFORM_COUNT",
                title: "High number of PERFORM statements",
                severity: "medium",
                category: "maintainability",
                description:
                    `Detected a high number of PERFORM edges (${metrics.performCount}). This can indicate complex control flow and make reasoning/testing harder.`,
                evidence: [
                    { artifactId: "metrics", note: `performCount=${metrics.performCount}` }
                ]
            });
        }

        const density = metrics.nodeCount > 0 ? metrics.edgeCount / metrics.nodeCount : 0;
        if (density >= 2.5) {
            risks.push({
                id: "RISK_HIGH_GRAPH_DENSITY",
                title: "High callgraph density",
                severity: "high",
                category: "flow",
                description:
                    `Callgraph density is high (edgeCount/nodeCount=${metrics.edgeCount}/${metrics.nodeCount} = ${density.toFixed(
                        2
                    )}). This may indicate tightly coupled logic and higher regression risk.`,
                evidence: [
                    { artifactId: "metrics", note: `nodeCount=${metrics.nodeCount}, edgeCount=${metrics.edgeCount}` }
                ]
            });
        }

        risks.sort((a, b) => a.id.localeCompare(b.id));

        const artifact: RisksArtifactV1 = {
            schemaVersion: "1.0",
            adapter: "cobol",
            generatedFrom: { callgraphArtifactId: "callgraph", metricsArtifactId: "metrics" },
            risks
        };

        await ctx.artifacts.putJson("risks", artifact, producedBy);
    }
};

async function readJson<T>(ctx: any, relPath: string): Promise<T> {
    const fs = await import("node:fs/promises");
    const path = await import("node:path");
    const abs = path.join(ctx.config.outDir, relPath);
    const raw = await fs.readFile(abs, "utf-8");
    return JSON.parse(raw) as T;
}

function safeId(s: string): string {
    return s.toUpperCase().replace(/[^A-Z0-9]+/g, "_").replace(/^_+|_+$/g, "");
}
