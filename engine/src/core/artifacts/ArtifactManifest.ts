import type { ArtifactMeta } from "./ArtifactTypes.js";

export type ManifestSchemaVersion = "1.0";

export interface ManifestInputFile {
	path: string;
	sha256: string;
	size: number;
	kind?: string;
}

export interface ArtifactManifest {
	schemaVersion: ManifestSchemaVersion;
	runId: string;
	projectRoot: string;
	adapter: string;

	createdAt: string; // ISO string

	inputs: {
		files: ManifestInputFile[];
	};

	// outputs[artifactId] = metadata
	outputs: Record<string, ArtifactMeta>;
}
