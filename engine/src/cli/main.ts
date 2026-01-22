import fs from "node:fs";
import path from "node:path";

import { PipelineImpl } from "../core/pipeline/PipelineImpl.js";
import { InMemoryEventBus } from "../core/logging/EventBus.js";
import { ArtifactStoreFs } from "../core/artifacts/ArtifactStoreFs.js";
import type { ArtifactManifest } from "../core/artifacts/ArtifactManifest.js";
import type { RunConfig } from "../core/pipeline/RunConfig.js";
import { DiscoverFilesStage } from "../core/pipeline/stages/discoverFiles.stage.js";
import type { PipelineContext } from "../core/pipeline/Context.js";
import { InputsSyncStage } from "../core/pipeline/stages/inputsSync.stage.js";
import { ManifestFinalizeStage } from "../core/artifacts/stages/manifestFinalize.stage.js";
import { AdapterRegistry } from "../core/registry/AdapterRegistry.js";

// Initialize registry (could be dynamic in future)
AdapterRegistry.init();

function runId(): string {
    return "run-" + new Date().toISOString().replace(/[:.]/g, "-");
}

async function main(): Promise<void> {
    const projectRoot = process.argv[2] ?? ".";
    // Can be passed via env or argv, defaulting to cobol for V1
    const adapterId = process.env.ADAPTER || "cobol";

    if (!fs.existsSync(projectRoot)) {
        throw new Error(`Project root does not exist: ${projectRoot}`);
    }

    // 1. Resolve Adapter
    const adapter = AdapterRegistry.get(adapterId);
    console.log(`Using adapter: ${adapter.id} - ${adapter.description}`);

    const run = runId();
    const outDir = path.resolve("runs", run);
    fs.mkdirSync(outDir, { recursive: true });

    // 2. Prepare Config & Context
    const manifest: ArtifactManifest = {
        schemaVersion: "1.0",
        runId: run,
        projectRoot: path.resolve(projectRoot),
        adapter: adapter.id, // from adapter
        createdAt: new Date().toISOString(),
        inputs: { files: [] },
        outputs: {}
    };

    const artifacts = new ArtifactStoreFs(outDir, manifest);
    const events = new InMemoryEventBus();

    const config: RunConfig = {
        projectRoot,
        outDir,
        adapter: adapter.id as any,
        mode: "cli",
        strict: true,
        kindMap: adapter.kindMap // Get kinds from adapter
    };

    const ctx: PipelineContext = {
        runId: run,
        config,
        inputs: { files: [] },
        artifacts,
        events
    };

    // 3. Build Pipeline
    const pipeline = new PipelineImpl();

    const stages = [
        DiscoverFilesStage,     // Core
        InputsSyncStage,        // Core
        ...adapter.getStages(), // Adapter specific
        ManifestFinalizeStage   // Core
    ];

    await pipeline.run(stages, ctx);

    console.log(`Discovered files: ${ctx.inputs.files.length}`);
    console.log(`Run completed: ${run}`);
}

main().catch((err) => {
    console.error("FATAL ERROR");
    console.error(err instanceof Error ? err.stack : JSON.stringify(err, null, 2));
    process.exit(1);
});
