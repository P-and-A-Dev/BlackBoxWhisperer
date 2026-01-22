import type { Stage } from "../../../core/pipeline/Stage.js";

export const HelloStage: Stage = {
    id: "hello",
    version: "1.0.0",
    outputs: ["hello"],

    async run(ctx) {
        await ctx.artifacts.putJson(
            "hello",
            { ok: true },
            { stageId: this.id, stageVersion: this.version }
        );
    }
};
