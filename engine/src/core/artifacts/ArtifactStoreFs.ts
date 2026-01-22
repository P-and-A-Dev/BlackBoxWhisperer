import fs from "node:fs/promises";
import path from "node:path";
import crypto from "node:crypto";

import type {
    ArtifactMeta,
    ArtifactType,
    ProducedByMeta
} from "./ArtifactTypes.js";
import type { ArtifactStore } from "./ArtifactStore.js";
import type { ArtifactManifest } from "./ArtifactManifest.js";

export class ArtifactStoreFs implements ArtifactStore {
    private outputs: Map<string, ArtifactMeta> = new Map();

    constructor(
        private readonly outDir: string,
        private readonly manifest: ArtifactManifest
    ) { }

    has(id: string): boolean {
        return this.outputs.has(id);
    }

    require(id: string): ArtifactMeta {
        const meta = this.outputs.get(id);
        if (!meta) {
            throw new Error(`Required artifact not found: ${id}`);
        }
        return meta;
    }

    meta(id: string): ArtifactMeta | undefined {
        return this.outputs.get(id);
    }

    list(): ArtifactMeta[] {
        return [...this.outputs.values()];
    }

    async putJson<T>(
        id: string,
        data: T,
        producedBy: ProducedByMeta
    ): Promise<ArtifactMeta> {
        const relPath = `${id}.json`;
        const absPath = path.join(this.outDir, relPath);

        const content = JSON.stringify(data, null, 2);
        await fs.writeFile(absPath, content, "utf-8");

        const sha256 = sha(content);

        const meta: ArtifactMeta = {
            id,
            type: "json",
            path: relPath,
            sha256,
            producedBy
        };

        this.outputs.set(id, meta);
        this.manifest.outputs[id] = meta;

        return meta;
    }

    async putText(
        id: string,
        type: Exclude<ArtifactType, "json">,
        content: string,
        producedBy: ProducedByMeta
    ): Promise<ArtifactMeta> {
        const ext = type === "markdown" ? "md" : "mmd";
        const relPath = `${id}.${ext}`;
        const absPath = path.join(this.outDir, relPath);

        await fs.writeFile(absPath, content, "utf-8");

        const sha256 = sha(content);

        const meta: ArtifactMeta = {
            id,
            type,
            path: relPath,
            sha256,
            producedBy
        };

        this.outputs.set(id, meta);
        this.manifest.outputs[id] = meta;

        return meta;
    }
}

function sha(content: string): string {
    return crypto.createHash("sha256").update(content).digest("hex");
}
