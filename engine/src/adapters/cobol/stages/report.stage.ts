import type { Stage } from "../../../core/pipeline/Stage.js";
import type { ProducedByMeta } from "../../../core/artifacts/ArtifactTypes.js";

import type { CallGraphArtifactV1 } from "../callgraph.types.js";
import type { MetricsArtifactV1 } from "../metrics.types.js";
import type { RisksArtifactV1 } from "../risks.types.js";

export const ReportStage: Stage = {
    id: "report.render",
    version: "1.0.0",
    inputs: ["callgraph", "metrics", "risks"],
    outputs: ["report"],

    async run(ctx) {
        const producedBy: ProducedByMeta = { stageId: this.id, stageVersion: this.version };

        const callgraphMeta = ctx.artifacts.require("callgraph");
        const metricsMeta = ctx.artifacts.require("metrics");
        const risksMeta = ctx.artifacts.require("risks");

        const graph = await readJson<CallGraphArtifactV1>(ctx, callgraphMeta.path);
        const metrics = await readJson<MetricsArtifactV1>(ctx, metricsMeta.path);
        const risks = await readJson<RisksArtifactV1>(ctx, risksMeta.path);

        const md = renderReport(ctx.runId, metrics, graph, risks);
        await ctx.artifacts.putText("report", "markdown", md, producedBy);
    }
};

function renderReport(
    runId: string,
    metrics: MetricsArtifactV1,
    graph: CallGraphArtifactV1,
    risks: RisksArtifactV1
): string {
    const programs = graph.nodes
        .filter((n) => n.id.startsWith("program:") && !n.id.includes("#"))
        .map((n) => n.label)
        .sort((a, b) => a.localeCompare(b));

    const externals = graph.nodes
        .filter((n) => n.id.startsWith("external:"))
        .map((n) => n.label)
        .sort((a, b) => a.localeCompare(b));

    const risksSorted = [...risks.risks].sort((a, b) => {
        const sev = (s: string) => (s === "high" ? 0 : s === "medium" ? 1 : 2);
        return sev(a.severity) - sev(b.severity) || a.id.localeCompare(b.id);
    });

    const lines: string[] = [];

    lines.push(`# Black Box Whisperer - Analysis Report`);
    lines.push(``);
    lines.push(`## Run Information`);
    lines.push(`- Run ID: ${runId}`);
    lines.push(`- Adapter: ${metrics.adapter}`);
    lines.push(``);

    lines.push(`## Metrics`);
    lines.push(`- Programs: ${metrics.programCount}`);
    lines.push(`- CALL edges: ${metrics.callCount}`);
    lines.push(`- PERFORM edges: ${metrics.performCount}`);
    lines.push(`- COPYBOOK nodes: ${metrics.copybookCount}`);
    lines.push(`- Nodes: ${metrics.nodeCount}`);
    lines.push(`- Edges: ${metrics.edgeCount}`);
    lines.push(``);

    lines.push(`## Detected Programs`);
    if (programs.length === 0) {
        lines.push(`(none)`);
    } else {
        for (const p of programs) lines.push(`- ${p}`);
    }
    lines.push(``);

    lines.push(`## External Dependencies`);
    if (externals.length === 0) {
        lines.push(`(none)`);
    } else {
        for (const e of externals) lines.push(`- ${e}`);
    }
    lines.push(``);

    lines.push(`## Risks`);
    if (risksSorted.length === 0) {
        lines.push(`(none)`);
    } else {
        for (const r of risksSorted) {
            lines.push(`### ${r.severity.toUpperCase()} - ${r.title}`);
            lines.push(`${r.description}`);
            if (r.evidence.length > 0) {
                lines.push(``);
                lines.push(`Evidence:`);
                for (const ev of r.evidence) {
                    const loc =
                        ev.file && ev.line ? `${ev.file}:${ev.line}` : ev.file ? ev.file : "";
                    const note = ev.note ? ` - ${ev.note}` : "";
                    const raw = ev.raw ? ` - \`${ev.raw.trim()}\`` : "";
                    lines.push(`- ${ev.artifactId}${loc ? ` @ ${loc}` : ""}${note}${raw}`);
                }
            }
            lines.push(``);
        }
    }

    return lines.join("\n").trimEnd() + "\n";
}

async function readJson<T>(ctx: any, relPath: string): Promise<T> {
    const fs = await import("node:fs/promises");
    const path = await import("node:path");
    const abs = path.join(ctx.config.outDir, relPath);
    const raw = await fs.readFile(abs, "utf-8");
    return JSON.parse(raw) as T;
}
