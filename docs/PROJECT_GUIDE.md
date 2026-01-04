# Project Structure & Conventions

This document defines the **repository structure**, **runtime conventions**, and **Git workflow rules** for the Black Box Whisperer project.

The goal is to ensure:

* long-term maintainability
* deterministic and reproducible analyses
* easy collaboration and parallel development
* clean separation between UI, engine, and AI layers

---

## Repository Structure

```
black-box-whisperer/
│
├─ engine/                  # Analysis engine (Node.js + TypeScript)
│  ├─ src/
│  │  ├─ cli/               # CLI entrypoints
│  │  ├─ core/              # Core pipeline (scanner, analyzers, emitters)
│  │  ├─ adapters/          # Language/runtime adapters (COBOL, logs, etc.)
│  │  ├─ pipelines/         # Deterministic analysis pipelines
│  │  ├─ schemas/           # Internal TS + JSON schemas
│  │  └─ utils/
│  ├─ tests/
│  └─ package.json
│
├─ ui/                      # Flutter desktop UI
│  ├─ lib/
│  │  ├─ screens/
│  │  ├─ widgets/
│  │  ├─ models/
│  │  ├─ services/          # Engine communication (HTTP / local process)
│  │  └─ state/
│  └─ pubspec.yaml
│
├─ schemas/                 # Public JSON schemas for artifacts
│
├─ samples/                 # Small legacy projects for testing
│  ├─ cobol-mini/
│  └─ logs-sample/
│
├─ docs/                    # Example outputs and documentation
│
├─ out/                     # Generated analysis runs (gitignored)
│
└─ README.md
```

---

## Analysis Run Conventions

Each analysis execution produces a **self-contained, immutable run directory**.

### Run ID

```
<timestamp>-<short-hash>
```

Example:

```
2026-01-04T14-32-10Z-a9f3c2
```

### Output Layout

```
out/<run-id>/
│
├─ artifact_manifest.json
│
├─ inputs/
│  ├─ files.json
│  └─ logs.json
│
├─ symbols/
│  └─ symbols.json
│
├─ graphs/
│  ├─ callgraph.json
│  └─ callgraph.mmd
│
├─ metrics/
│  └─ metrics.json
│
├─ risks/
│  └─ risks.json
│
├─ runtime/
│  ├─ events.jsonl
│  ├─ sessions.json
│  └─ correlations.json
│
├─ ai/
│  ├─ input.json
│  ├─ decision.json
│  └─ output.md
│
├─ report/
│  └─ report.md
│
└─ engine.log
```

### Core Rules

* A run is **append-only** once completed
* Artifacts must be:

  * deterministic
  * reproducible
  * traceable via the manifest
* AI outputs are **never required** for a valid run

---

## Artifact Manifest Convention

`artifact_manifest.json` is the single source of truth.

It must contain:

* `schemaVersion`
* `runId`
* `projectRoot`
* `startTime` / `endTime`
* `inputs` (files, logs, adapters used)
* `outputs` (relative paths to generated artifacts)
* `engineVersion`

Every UI or automation feature must rely on the manifest, not on folder heuristics.

---

## Naming Conventions

### Files & Folders

* `kebab-case` for directories
* `snake_case.json` for JSON artifacts
* `camelCase.ts` / `PascalCase.ts` for TypeScript
* no spaces, no uppercase in paths

### JSON Keys

* `camelCase`
* explicit, no abbreviations unless standard
* always include `id`, `type`, and `evidence` when relevant

---

## Deterministic vs AI Outputs

| Category                | Rule                                    |
| ----------------------- | --------------------------------------- |
| Deterministic artifacts | Required, versioned, reproducible       |
| AI outputs              | Optional, additive, never authoritative |
| Risks                   | Must exist without AI                   |
| AI insights             | Must reference deterministic evidence   |

The AI layer **cannot invent structure**.
It can only interpret and enrich what already exists.

---

## Git Branching Strategy

This project uses a **clean, strict Git flow**.

### Main Branches

* `main`

  * always stable
  * reflects the latest usable state
  * no direct commits

* `dev`

  * integration branch
  * all features are merged here first

### Supporting Branches

* `feature/<scope>-<short-description>`

  * new features
  * example:

    ```
    feature/cobol-callgraph
    ```

* `fix/<scope>-<short-description>`

  * bug fixes
  * example:

    ```
    fix/mermaid-export
    ```

* `hotfix/<scope>-<short-description>`

  * urgent fixes on `main`

---

## Commit Message Convention

This project follows a **Conventional Commits–inspired format**.

### Format

```
<type>(<scope>): <short description>
```

### Types

* `feat` : new feature
* `fix` : bug fix
* `refactor` : internal restructuring, no behavior change
* `docs` : documentation only
* `test` : tests only
* `chore` : tooling, config, dependencies

### Examples

```
feat(engine): add COBOL CALL graph extraction
fix(ui): handle empty analysis runs gracefully
refactor(core): split analyzer pipeline into stages
docs: document artifact manifest schema
```

### Rules

* one logical change per commit
* no mixed concerns
* commits must be readable without context
* avoid “wip”, “temp”, or vague messages

---

## Merge Rules

* features are merged into `dev` via PR
* `dev` → `main` only when:

  * engine CLI works
  * artifacts validate against schemas
  * UI can load and display results
* squash merge is allowed, but commit messages must remain meaningful

---

## Guiding Principles

* structure over speed
* evidence over assumptions
* determinism before intelligence
* clarity before cleverness

This repository is designed to scale from a hackathon prototype to a long-lived industrial tool without structural debt.
