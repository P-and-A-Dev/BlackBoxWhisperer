import type { Stage } from "./Stage.js";
import type { PipelineContext } from "./Context.js";

export interface Pipeline {
	run(stages: Stage[], ctx: PipelineContext): Promise<void>;
}
