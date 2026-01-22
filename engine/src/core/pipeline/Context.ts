import type { RunConfig, RunId } from "./RunConfig.js";
import type { ArtifactStore } from "../artifacts/index.js";
import type { EventBus } from "../logging/EventBus.js";

export type InputKind = "cobol" | "copybook" | "jcl" | "unknown";

export interface InputFileRef {
	path: string;
	sha256: string;
	size: number;
	kind: InputKind;
}

export interface PipelineInputs {
	files: InputFileRef[];
}



export interface PipelineContext {
	runId: RunId;
	config: RunConfig;

	inputs: PipelineInputs;

	artifacts: ArtifactStore;
	events: EventBus;
}
