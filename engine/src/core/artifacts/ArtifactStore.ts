import type { ArtifactMeta, ArtifactType, ProducedByMeta } from "./ArtifactTypes.js";

export interface PutJsonOptions {
	schemaPath?: string;
	overwrite?: boolean;
}

export interface PutTextOptions {
	overwrite?: boolean;
}

export interface ArtifactStore {
	// reading
	has(id: string): boolean;

	require(id: string): ArtifactMeta; // throw if absent
	meta(id: string): ArtifactMeta | undefined;

	// writing
	putJson<T>(
		id: string,
		data: T,
		producedBy: ProducedByMeta,
		options?: PutJsonOptions
	): Promise<ArtifactMeta>;

	putText(
		id: string,
		type: Exclude<ArtifactType, "json">,
		content: string,
		producedBy: ProducedByMeta,
		options?: PutTextOptions
	): Promise<ArtifactMeta>;

	// listing
	list(): ArtifactMeta[];
}
