export type ArtifactType = "json" | "markdown" | "mermaid";

export interface ProducedByMeta {
	stageId: string;
	stageVersion: string;
}

export interface ArtifactMeta {
	id: string;
	type: ArtifactType;
	path: string;
	sha256: string;
	schema?: string;
	producedBy: ProducedByMeta;
}
