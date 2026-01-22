import fs from "node:fs";
import path from "node:path";

import { PipelineImpl } from "../core/pipeline/PipelineImpl.js";
import { InMemoryEventBus } from "../core/logging/EventBus.js";
import { ArtifactStoreFs } from "../core/artifacts/ArtifactStoreFs.js";
import type { ArtifactManifest } from "../core/artifacts/ArtifactManifest.js";
import { HelloStage } from "../adapters/cobol/stages/hello.stage.js";
import type { RunConfig } from "../core/pipeline/RunConfig.js";

function runId(): string {
    return "run-" + new Date().toISOString().replace(/[:.]/g, "-");
}

async function main(): Promise<void> {
    const projectRoot = process.argv[2] ?? ".";

    if (!fs.existsSync(projectRoot)) {
        throw new Error(`Project root does not exist: ${projectRoot}`);
    }

    const run = runId();
    const outDir = path.resolve("runs", run);
    fs.mkdirSync(outDir, { recursive: true });

    const manifest: ArtifactManifest = {
        schemaVersion: "1.0",
        runId: run,
        projectRoot: path.resolve(projectRoot),
        adapter: "cobol",
        createdAt: new Date().toISOString(),
        inputs: { files: [] },
        outputs: {}
    };

    const artifacts = new ArtifactStoreFs(outDir, manifest);
    const events = new InMemoryEventBus();

    const config: RunConfig = {
        projectRoot,
        outDir,
        adapter: "cobol",
        mode: "cli",
        strict: true
    };

    const ctx = {
        runId: run,
        config: config,
        inputs: { files: [] },
        scratch: {},
        artifacts,
        events
    };

    const pipeline = new PipelineImpl();
    await pipeline.run([HelloStage], ctx);

    fs.writeFileSync(
        path.join(outDir, "artifact_manifest.json"),
        JSON.stringify(manifest, null, 2),
        "utf-8"
    );

    console.log(`Run completed: ${run}`);
}

main().catch((err) => {
    console.error("FATAL ERROR");
    console.error(err instanceof Error ? err.stack : JSON.stringify(err, null, 2));
    process.exit(1);
});
