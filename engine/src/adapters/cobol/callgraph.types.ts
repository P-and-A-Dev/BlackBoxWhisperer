export type EdgeKind = "CALL" | "PERFORM" | "COPY";

export interface CallGraphNode {
    id: string;
    label: string;
    kind: "program" | "copybook" | "external";
}

export interface CallGraphEdgeEvidence {
    file: string;
    line: number;
    raw: string;
}

export interface CallGraphEdge {
    from: string;
    to: string;
    kind: EdgeKind;
    evidence: CallGraphEdgeEvidence[];
}

export interface CallGraphArtifactV1 {
    schemaVersion: "1.0";
    adapter: "cobol";
    generatedFrom: { cobolIndexArtifactId: "cobol_index" };
    nodes: CallGraphNode[];
    edges: CallGraphEdge[];
}
