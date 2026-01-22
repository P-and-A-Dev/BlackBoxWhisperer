export type RiskSeverity = "low" | "medium" | "high";

export interface RiskEvidence {
    artifactId: "callgraph" | "metrics";
    file?: string;
    line?: number;
    raw?: string;
    note?: string;
}

export interface RiskItem {
    id: string;
    title: string;
    severity: RiskSeverity;
    category: string;
    description: string;
    evidence: RiskEvidence[];
}

export interface RisksArtifactV1 {
    schemaVersion: "1.0";
    adapter: "cobol";
    generatedFrom: {
        callgraphArtifactId: "callgraph";
        metricsArtifactId: "metrics";
    };
    risks: RiskItem[];
}
