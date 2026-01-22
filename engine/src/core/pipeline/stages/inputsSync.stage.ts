import type { Stage } from "../../pipeline/Stage.js";

export const InputsSyncStage: Stage = {
    id: "inputs.sync",
    version: "1.0.0",
    outputs: [],

    async run(ctx) {
        // @ts-expect-error: we know that the concrete implementation exposes manifest
        const manifest = ctx.artifacts.manifest as any;

        manifest.inputs.files = ctx.inputs.files.map((f: any) => ({
            path: f.path,
            sha256: f.sha256,
            size: f.size,
            kind: f.kind
        }));
    }
};
