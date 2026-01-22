import type { Adapter } from "./Adapter.js";
import { CobolAdapter } from "../../adapters/cobol/CobolAdapter.js";

// Basic synchronous registry for V1
export class AdapterRegistry {
    private static adapters: Map<string, Adapter> = new Map();

    static register(adapter: Adapter) {
        this.adapters.set(adapter.id, adapter);
    }

    static get(id: string): Adapter {
        const adapter = this.adapters.get(id);
        if (!adapter) {
            throw new Error(`Unknown adapter: ${id}`);
        }
        return adapter;
    }

    static init() {
        // Hardcoded registration for now (can be dynamic later)
        this.register(CobolAdapter);
    }
}
