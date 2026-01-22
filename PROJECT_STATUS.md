# Project Status: Black Box Whisperer

> **Current Phase**: V1 Engine (UI Pending)
> **Last Audit**: 2026-01-22

This document represents the authoritative state of the **Black Box Whisperer** project. It replaces all previous documentation.

## 1. Project Overview

Black Box Whisperer is a deterministic static analysis engine for opaque legacy systems.
**Current Status**: The core engine and COBOL adapter are fully functional (V1). The UI is not implemented.

### Core Principles Status
- ✅ **Deterministic-first**: Fully implemented via robust sorting and SHA256 hashing.
- ✅ **Artifact-driven**: All outputs are JSON/Markdown artifacts.
- ✅ **Evidence-based**: Risks and graphs are traceable to source lines.
- ✅ **Modular-by-design**: COBOL logic is isolated in `src/adapters/cobol`.
- ✅ **AI-safe**: No source code is exposed loosely; everything is in structured artifacts.

---

## 2. Feature Implementation Checklist

### A. Engine Core (Infrastructure)
| Feature | Status | Notes |
| :--- | :--- | :--- |
| Deterministic pipeline execution | ✅ **Implemented** | `PipelineImpl` executes stages sequentially. |
| Strictly typed Context | ✅ **Implemented** | `PipelineContext` defined in `Context.ts`. |
| Pluggable Adapter System | ✅ **Implemented** | `AdapterRegistry` loads adapters dynamically. |
| Deterministic File Discovery | ✅ **Implemented** | Files sorted by path, hashed via strict SHA256. |
| Artifact Integrity | ✅ **Implemented** | `ArtifactStoreFs` enforces content hashing. |
| Central Manifest | ✅ **Implemented** | `artifact_manifest.json` tracks all inputs/outputs. |
| Overwrite Protection | ✅ **Implemented** | Store throws error on duplicate artifact ID. |

### B. COBOL Adapter (Analysis)
| Feature | Status | Notes |
| :--- | :--- | :--- |
| File Detection | ✅ **Implemented** | supports `.cbl`, `.cpy`, `.cob`, etc. |
| Indexing (Regex) | ✅ **Implemented** | Extracts `PROGRAM-ID`, `CALL`, `PERFORM`, `COPY`. |
| Call Graph Generation | ✅ **Implemented** | Deterministic sorting of nodes and edges. |
| Metrics Computation | ✅ **Implemented** | Counts files, programs, edges, copybooks. |
| Risk Detection | ✅ **Implemented** | Detects static risk patterns (external calls, graph complexity, heuristics). |
| Markdown Reporting | ✅ **Implemented** | Generates detailed `report.md`. |

### C. Artifacts Produced
The engine currently produces the following valid artifacts:
- `cobol_index.json`
- `callgraph.json`
- `metrics.json`
- `risks.json`
- `report.md`
- `artifact_manifest.json`

### D. CLI & Tooling
| Feature | Status | Notes |
| :--- | :--- | :--- |
| CLI Entry Point | ✅ **Implemented** | `src/cli/main.ts` |
| Adapter Selection | ✅ **Implemented** | Via `ADAPTER` env var (default: `cobol`). |
| Reproducible Runs | ✅ **Implemented** | Output goes to `runs/run-<TIMESTAMP>`. |
| Project Samples | ⚠️ **Partial** | `engine/samples` exists. `docs/example-run` is outdated. |

### E. User Interface
| Feature | Status | Notes |
| :--- | :--- | :--- |
| Flutter Desktop App | ❌ **Not Implemented** | Folder `ui/` is empty. |
| Visualizers | ❌ **Not Implemented** | No GUI for graphs or reports. |

### F. Future / Roadmap
| Feature | Status | Notes |
| :--- | :--- | :--- |
| JSON Schema Validation | ❌ **Not Implemented** | Schemas exist but are unused (AJV not in use). |
| Cross-Language Linking | ❌ **Not Implemented** | Only single-adapter runs supported. |
| AI Reasoning Layer | ❌ **Not Implemented** | |
| Run Diffing | ❌ **Not Implemented** | |

---

## 3. Architecture Summary

The system follows a strict linear pipeline:

1.  **Discover**: Scan files -> Sort paths -> Hash content.
2.  **Sync**: Update manifest with inputs.
3.  **Adapter Execution** (COBOL):
    *   `Index`: Parse source -> `cobol_index`.
    *   `Graph`: Index -> `callgraph`.
    *   `Metrics`: Graph -> `metrics`.
    *   `Risks`: Graph + Metrics -> `risks`.
    *   `Report`: All Artifacts -> `report.md`.
4.  **Finalize**: Write `artifact_manifest.json` to disk.

### Key Directories
- `engine/src/core`: The language-agnostic runner.
- `engine/src/adapters/cobol`: The COBOL parsing logic.
- `engine/runs/`: Output directory (one folder per run).

---

## 4. Known Limitations
1.  **Memory Usage**: Files are loaded entirely into memory during indexing. Large monoliths may cause OOM.
2.  **Parser Fragility**: COBOL parsing is Regex-based, not grammar-based. Complex multi-line statements may be missed.
3.  **No UI**: The tool is currently CLI-only.
4.  **Outdated Docs**: The `docs/example-run` folder contains schemas that do not match the current engine output.

These limitations are explicit design choices for V1 and not considered architectural flaws.
