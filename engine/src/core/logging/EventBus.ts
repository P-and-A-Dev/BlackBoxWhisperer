export interface EngineEvent {
	type: string;
	[key: string]: unknown;
}

export interface EventBus {
	emit(event: EngineEvent): void;
}

export class InMemoryEventBus implements EventBus {
	private events: EngineEvent[] = [];

	emit(event: EngineEvent): void {
		this.events.push(event);
	}

	list(): EngineEvent[] {
		return [...this.events];
	}
}
