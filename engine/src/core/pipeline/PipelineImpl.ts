import type { Stage } from "./Stage.js";
import type { PipelineContext } from "./Context.js";
import type { Pipeline } from "./Pipeline.js";

export class PipelineImpl implements Pipeline {
    async run(stages: Stage[], ctx: PipelineContext): Promise<void> {
        for (const stage of stages) {
            // dependencies verification
            if (stage.inputs) {
                for (const input of stage.inputs) {
                    if (!ctx.artifacts.has(input)) {
                        throw new Error(
                            `Stage ${stage.id} requires missing artifact: ${input}`
                        );
                    }
                }
            }

            ctx.events.emit({
                type: "stage:start",
                stageId: stage.id,
                stageVersion: stage.version
            });

            await stage.run(ctx);

            // outputs verification
            for (const output of stage.outputs) {
                if (!ctx.artifacts.has(output)) {
                    throw new Error(
                        `Stage ${stage.id} did not produce declared output: ${output}`
                    );
                }
            }

            ctx.events.emit({
                type: "stage:end",
                stageId: stage.id,
                stageVersion: stage.version
            });
        }
    }
}
