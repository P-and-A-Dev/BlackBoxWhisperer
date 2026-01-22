import type { Stage } from "../../pipeline/Stage.js";

export const ManifestFinalizeStage: Stage = {
    id: "manifest.finalize",
    version: "1.0.0",
    outputs: [],

    async run(ctx) {
        // @ts-expect-error: we know that the concrete implementation exposes writeManifest
        await ctx.artifacts.writeManifest();
    }
};
