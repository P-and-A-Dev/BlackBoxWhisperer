import type { EngineEvent } from "./events.js";

export type EventHandler = (event: EngineEvent) => void;

export interface EventBus {
	publish(event: EngineEvent): void;

	subscribe(handler: EventHandler): () => void;
}
