export type EventLevel = "debug" | "info" | "warn" | "error";

export type EngineEvent =
	| RunStartEvent
	| RunEndEvent
	| StageStartEvent
	| StageEndEvent
	| ArtifactWrittenEvent
	| EngineErrorEvent;

export interface BaseEvent {
	type: EngineEvent["type"];
	level: EventLevel;
	at: string; // ISO string
}

export interface RunStartEvent extends BaseEvent {
	type: "run.start";
	runId: string;
	adapter: string;
	projectRoot: string;
	outDir: string;
}

export interface RunEndEvent extends BaseEvent {
	type: "run.end";
	runId: string;
	success: boolean;
}

export interface StageStartEvent extends BaseEvent {
	type: "stage.start";
	runId: string;
	stageId: string;
	stageVersion: string;
}

export interface StageEndEvent extends BaseEvent {
	type: "stage.end";
	runId: string;
	stageId: string;
	stageVersion: string;
	success: boolean;
}

export interface ArtifactWrittenEvent extends BaseEvent {
	type: "artifact.written";
	runId: string;
	artifactId: string;
	artifactPath: string;
	sha256: string;
}

export interface EngineErrorEvent extends BaseEvent {
	type: "error";
	runId: string;
	message: string;
	code?: string;
	cause?: unknown;
}
