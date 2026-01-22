# 🥇 Black Box Whisperer
*aka Legacy Neural Interface, Legacy Archaeologist*

## Overview

**Black Box Whisperer** is an AI-powered platform designed to **understand, secure, and operationalize opaque legacy systems without modifying them**.

It targets mission-critical legacy software that still runs core business operations but has become partially or totally incomprehensible over time due to missing documentation, loss of domain experts, or accumulated implicit behavior.

The goal is not to rewrite or replace these systems, but to reconstruct a **usable mental model** of how they actually work, based on observable signals. :contentReference[oaicite:0]{index=0}

---

## The Problem

Many organizations rely on legacy systems that combine:
- old and heterogeneous codebases (COBOL, C, C++, sometimes assembly)
- missing or outdated documentation
- implicit and undocumented dependencies
- poorly understood runtime behavior
- extremely high operational and business risk

These systems often work reliably, but **human understanding has been lost**.  
The real risk is not instability, but invisibility. :contentReference[oaicite:1]{index=1}

---

## Core Idea

Black Box Whisperer ingests **non-intrusive, observable artifacts** from a legacy system and reconstructs a coherent and exploitable understanding of its behavior.

### Input Signals
- legacy source code (partial or complete)
- application and system logs
- existing execution traces
- memory dumps
- observed inputs, outputs, and side effects

No refactoring.  
No instrumentation.  
No code changes. :contentReference[oaicite:2]{index=2}

---

## Modular-by-Design Architecture

Black Box Whisperer is built as a **language-agnostic analysis engine** surrounded by **pluggable adapters**.

### Why modular
- each legacy language has unique semantics (COBOL, C, C++, etc.)
- log and trace formats vary widely
- the core engine must remain stable, testable, and reusable

### Principle
- the core engine is independent of COBOL
- COBOL is the first input adapter (V1)
- additional languages can be added later without rewriting the engine :contentReference[oaicite:3]{index=3}

---

## V1 Focus: COBOL First

The first implementation focuses on **COBOL systems** as the initial vertical slice.

### What the COBOL adapter provides
- extraction of symbols (programs, sections, paragraphs)
- detection of calls (`CALL`, `PERFORM`, etc.)
- mapping of COPYBOOKs and file dependencies
- identification of input/output operations and database access

Even if COBOL analysis is partial at first, the engine remains valuable because:
- it correlates code structure with runtime behavior
- it produces actionable maps and risk indicators :contentReference[oaicite:4]{index=4}

---

## Deterministic Engine (First-Class Citizen)

The core engine produces a **verifiable and reproducible foundation**:

- normalization of logs and events
- correlation using IDs, time windows, and heuristics
- construction of call graphs and dependency graphs
- hotspot detection and metrics
- evidence-based risk scoring

All of this works **without AI**. :contentReference[oaicite:5]{index=5}

---

## Technical Stack & System Architecture

Black Box Whisperer is implemented as a **local, modular analysis platform** with a clear separation of concerns between UI, engine, and AI reasoning.

### High-Level Architecture

```
┌──────────────────┐
│   Flutter UI     │
│   (Desktop)      │
└────────┬─────────┘
         │
         │ HTTP / JSON (REST API)
         │
         ▼
┌──────────────────────────────────────┐
│  Analysis Engine                     │
│  Node.js + TypeScript + Fastify      │
├──────────────────────────────────────┤
│  • Parsing & Normalization           │
│  • Deterministic Analysis Pipelines  │
│  • Graph & Correlation Engine        │
│  • Risk Scoring & Metrics            │
└────────┬─────────────────────────────┘
         │
         │ Structured Artifacts
         │ (JSON, Graphs, Metrics)
         │
         ▼
┌──────────────────────────────────────┐
│  AI Reasoning Layer                  │
│  Gemini 3 Flash / Pro                │
├──────────────────────────────────────┤
│  • Semantic Reconstruction           │
│  • Hypothesis Generation             │
│  • Risk & Scenario Analysis          │
│  • Runbook & Spec Enrichment         │
└──────────────────────────────────────┘
```

---

### UI Layer (Flutter)

- **Technology**: Flutter (desktop-first: macOS, Linux, Windows)
- **Responsibilities**:
  - project selection and configuration
  - triggering analyses
  - visual exploration of graphs, risks, and reports
  - comparison between analysis runs
- **Rendering**:
  - diagrams via embedded web views (Mermaid, D3, Cytoscape)
  - structured reports and evidence navigation
- **Communication**:
  - consumes a local REST API exposed by the engine
  - no direct access to AI or parsing logic

Flutter is intentionally used only for **presentation and interaction**, not for analysis or parsing.

---

### Analysis Engine (Node.js + TypeScript)

- **Runtime**: Node.js
- **Language**: TypeScript (strict mode)
- **Server**: Fastify (or Express for simpler setups)
- **API**: REST / JSON over localhost
- **Core Responsibilities**:
  - parsing and normalization of inputs
  - deterministic analysis pipelines
  - correlation and graph construction
  - risk scoring and metrics
  - generation of structured artifacts (JSON, Mermaid, Markdown)

The engine can run:
- as a local background service
- headless (CLI or CI mode)
- independently of the UI

This guarantees reproducibility, testability, and automation.

---

### AI Layer (Gemini 3)

The AI layer operates **strictly on top of deterministic artifacts** produced by the engine.

#### Model Strategy
- **Gemini 3 Flash**
  - default model
  - fast, cost-efficient
  - used for low to medium complexity reasoning
- **Gemini 3 Pro**
  - automatically selected when:
    - confidence score is below threshold
    - task complexity is classified as high
    - cross-domain or deep causal reasoning is required

#### Responsibilities
- semantic reconstruction of business logic
- hypothesis generation with explicit evidence references
- failure and cascade scenario reasoning
- runbook enrichment
- specification and test generation

The AI never analyzes raw code or logs directly.  
It reasons only on **proven, structured, deterministic outputs**.

---

## Outputs Generated

Black Box Whisperer produces **structured, actionable deliverables**.

### System Understanding
- reconstructed business logic (hypotheses + evidence)
- functional and technical diagrams
- detailed data flows
- internal and external dependencies

### Risk & Resilience
- classified operational and technical risks
- critical technical debt zones
- probable failure scenarios
- identified breaking points

### Operations & Modernization
- human-readable operational runbooks
- OpenAPI specifications derived from observed behavior
- behavior-based non-regression test suites
- living, maintainable documentation :contentReference[oaicite:6]{index=6}

---

## Core Principle

We do not rewrite.  
We understand.  
We secure.  
We encapsulate.

Legacy systems remain untouched, but become understandable, controllable, and integrable. :contentReference[oaicite:7]{index=7}

---

## Typical Use Cases

- auditing critical systems before mergers or acquisitions
- securing legacy applications without operational risk
- accelerating onboarding of new engineering teams
- preparing safe, progressive modernization
- API encapsulation of COBOL systems
- reducing key-person dependency :contentReference[oaicite:8]{index=8}

---

## Rules & Guarantees (Phase B2)
 
 ### 1. Stage ID Stability
 - **Stage IDs (e.g., `cobol.index`, `graph.call`) are public contracts.**
 - They are recorded in the `artifact_manifest.json`.
 - Any change to a Stage ID is considered a **breaking change** and invalidates previous runs.
 - Cross-run comparisons and AI reasoning rely on these IDs being immutable.
 
 ### 2. The "No Source" Rule
 > [!IMPORTANT]
 > **The AI layer NEVER sees raw source code.**
 
 - The AI consumes *only* the structured, deterministic artifacts listed in `artifact_manifest.json`.
 - Direct access to source files or raw logs by the AI model is **forbidden by architecture**.
 - This ensures all insights are traceable to a proved, static evidence artifact produced by the deterministic engine.
 
 ---
 
 ## Status

Concept / prototype design with a clear execution path:
- V1: deterministic core + COBOL adapter + Flutter UI
- V2: additional adapters (C, C++, Java) and trace connectors
- V3: industrialization (security, reporting, multi-tenant)

---

## License

To be defined.
