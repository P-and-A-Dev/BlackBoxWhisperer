export type RunMode = "cli" | "api";
export type AdapterId = "cobol"; // v1 only

export interface RunLimits {
	maxFiles?: number;
	maxFileSizeBytes?: number;
}

export interface RunConfig {
	projectRoot: string;    // (source)
	outDir: string;         // run outputs (ex: runs/run-xxx)
	adapter: AdapterId;
	mode: RunMode;
	strict: boolean;        // fail-fast if missing artifact / invalid schema
	inputGlobs?: string[];  // optional (else adapter decide)
	limits?: RunLimits;
}

export type RunId = string;
