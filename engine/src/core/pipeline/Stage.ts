import { PipelineContext } from "./Context.js";

export interface Stage {
	id: string;
	version: string;
	inputs?: string[];
	outputs: string[];

	run(ctx: PipelineContext): Promise<void>;
}
