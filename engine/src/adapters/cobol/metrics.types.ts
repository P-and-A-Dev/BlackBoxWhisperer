export interface MetricsArtifactV1 {
    schemaVersion: "1.0";
    adapter: "cobol";
    generatedFrom: { callgraphArtifactId: "callgraph" };

    programCount: number;
    callCount: number;

    nodeCount: number;
    edgeCount: number;
    externalCallCount: number;
    performCount: number;
    copybookCount: number;
}
