import type { Stage } from "../pipeline/Stage.js";

export interface Adapter {
    id: string;
    description: string;
    getStages(): Stage[];
    kindMap: Record<string, string>;
}
