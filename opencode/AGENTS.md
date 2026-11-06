<!-- context7 -->
Use Context7 MCP to fetch current documentation whenever the user asks about a library, framework, SDK, API, CLI tool, or cloud service — even well-known ones like React, Next.js, Prisma, Express, Tailwind, Django, or Spring Boot. This includes API syntax, configuration, version migration, porting code between libraries, platforms, or SQL dialects, library-specific debugging, setup instructions, and CLI tool usage. Use even when you think you know the answer — your training data may not reflect recent changes. Prefer this over web search for library docs.

Do not use for: refactoring, debugging, or reviewing code that does not depend on a library or platform API, or general programming concepts.

## Steps

1. Always start with `resolve-library-id` using the library name and what to look up in the library's documentation, unless the user provides an exact library ID in `/org/project` format
2. Pick the best match (ID format: `/org/project`) by: exact name match, description relevance, code snippet count, source reputation (High/Medium preferred), and benchmark score (higher is better). If results don't look right, try alternate names or queries (e.g., "next.js" not "nextjs", or rephrase the question). Use version-specific IDs when the user mentions a version
3. `query-docs` with the selected library ID and what to look up in the library's documentation (not single words), scoped to a single concept. If the question spans multiple distinct concepts (e.g. routing and auth and caching), make a separate `query-docs` call per concept with the same library ID, unless the question is about how the concepts interact — combined queries dilute ranking and return shallow results for each topic
4. Answer using the fetched docs
<!-- context7 -->

<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
<!-- CODEGRAPH_END -->

<!-- ENGRAM_START -->
## Engram Persistent Memory

Engram is the persistent memory system for decisions, discoveries, preferences, and completed work across sessions. Use the actual Engram tools exposed by OpenCode; their qualified names commonly use the `engram_mem_*` prefix.

### When to save

Call `mem_save` promptly, without waiting to be asked, after:

- Making an architecture, design, workflow, tool, or library decision.
- Completing a bug fix, feature, configuration change, or environment setup.
- Discovering a non-obvious codebase detail, gotcha, edge case, or established pattern.
- Learning or confirming a user preference, constraint, or direction.

Use a short searchable title, the appropriate type (`bugfix`, `decision`, `architecture`, `discovery`, `pattern`, `config`, or `preference`), and include what changed, why, where, and relevant lessons. Reuse a stable `topic_key` when updating the same evolving topic; use `mem_suggest_topic_key` when unsure.

### When to search

When the user asks about past work, first call `mem_context`; if it does not contain the answer, call `mem_search` and then `mem_get_observation` for the full matching record. Search proactively before starting work that may have been done before or when the user introduces an unfamiliar project, feature, or problem.

### Session lifecycle

Before saying that work is complete or ending a session, call `mem_session_summary` with the goal, user instructions or preferences, discoveries, accomplishments, next steps, and relevant files. After compaction or a context reset, call `mem_session_summary` immediately with the available pre-compaction summary before continuing; do not call `mem_context` automatically for this case.

Memory operations are internal bookkeeping and must be completed before the final user-facing response. Never invent or override `session_id`; the OpenCode adapter owns session binding and lifecycle. If Engram tools are unexpectedly unavailable, run `engram setup opencode` and restart OpenCode.
<!-- ENGRAM_END -->

<!-- OPENSPEC_START -->
## OpenSpec

Usa OpenSpec únicamente cuando el usuario mencione explícitamente "OpenSpec" o alguna de sus skills. Si no lo solicita de forma explícita, no inicies ni sigas el flujo de OpenSpec y atiende la tarea con el flujo normal.

OpenSpec is a spec-driven workflow for planning and implementing changes with an AI coding tool. Follow the [official installation guide](https://openspec.dev/docs/installation) and [project setup guide](https://openspec.dev/docs/setup).

TODOS los artefactos de openspec deben de estar en español en lo posible.

### Basic workflow

1. Use the installed OpenSpec explore workflow to understand an idea or requirement before coding.
2. Use the propose workflow to create a change proposal and its implementation tasks.
3. Use the apply-change workflow to implement the tasks from the proposal.
4. Update the change when the plan evolves, then verify the implementation when that workflow is available.
5. Sync updated specs and archive the completed change.

Prefer the workflows installed by `openspec init` (skills or tool-specific commands) instead of inventing a parallel process. Keep project-wide context in `openspec/config.yaml`, reusable requirements in `openspec/specs/`, and active work in `openspec/changes/`.

### Maintenance

- Run `openspec update` inside each initialized project to refresh generated skills and commands.
- Use `openspec config profile` to change the installed workflow profile or delivery mode.
<!-- OPENSPEC_END -->

<!-- BRAINSTORMING_START -->
## Brainstorming

Está bien que usés la skill de brainstorming, pero evita el flujo de specs a menos que se te sea pedido explícitamente. Inicialmente usa la skill solo para cuestionar decisiones y encontrar huecos en lógica.
<!-- BRAINSTORMING_END -->