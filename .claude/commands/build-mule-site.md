
You are building a new MuleSoft demo site for a Solution Engineer. `$PRODUCT` is always `MuleSoft`.

**Arguments provided:** $ARGUMENTS

---

## CRITICAL: Always start fresh — no memory of previous runs

**Every invocation of this skill is a brand-new build.** Regardless of what `$ARGUMENTS` contains — even if it names a company, opportunity, or use case you have built a demo for before — you must:

- **Never** check whether a project directory already exists for this company or use case
- **Never** inspect, read from, or modify any previously generated demo project
- **Never** carry over any decisions, topology, actions, or branding from a prior run of this skill
- **Always** run the full Q&A (Step 0a onward) and show the complete pre-build plan (Step 0e) before writing any code — no shortcuts, no skipping ahead because "we did this before"

If the target project path (`~/claude-projects/<name>-demo/`) already exists on disk, create a new directory with an incrementing suffix (e.g. `-v2`, `-v3`) rather than writing into the existing one. Tell the SE which path you used.

Treat `$ARGUMENTS` as raw input only — not as a signal to skip steps, reuse previous work, or infer that a prior session's choices still apply.

---

## Step 0: Gather requirements

**Before writing any code**, always start with the interactive Q&A below — do not wait for or require arguments. If `$ARGUMENTS` contains pre-filled shortcut fields (`Company:`, `Use Case:`, `Stack:`, etc.) or a `Transcript:` path, use those as pre-answers and skip only the questions already covered.

---

### Step 0b — Use case / setup (always run first)

Run one `AskUserQuestion` call with this question as the **first and only question in this call**:

- **"How would you like to set up this demo?"** (`header: "Get Started"`, `multiSelect: false`)
  - `"I have discovery notes"` — description: `"Copy a prompt into NotebookLM, Google Docs, or wherever your notes live and paste the output back here"`
  - `"Quote to Cash"` — description: `"CPQ → ERP → billing automation"`
  - `"Healthcare Sync"` — description: `"EHR, LIMS, and Health Cloud integration — patient data, lab results, and care coordination"`
  - `"Core Banking & Digital Channels"` — description: `"Connect legacy core banking systems to Salesforce FSC, digital banking portals, and data platforms"`
  - Other: `"Describe your own use case"`

If `$ARGUMENTS` already contains a recognizable use case or `Use Case:` field, skip this question and go straight to Step 0d.

---

### Step 0b3 — Business Outcomes discovery

Skip this step if discovery notes or a transcript was provided — the extraction in Step 0c captures equivalent context.

**Why this matters:** The Business Outcomes panel is one of the most impactful sections during a live demo — it's what the champion uses to build the business case internally. The inputs gathered here determine whether the value points feel genuinely prospect-specific or generic. One extra Q&A call here pays off significantly in demo quality.

Run one `AskUserQuestion` call with up to 4 questions:

1. **"What is the primary business driver for this initiative?"** (`header: "Business Driver"`, `multiSelect: false`)
   - `"Operational efficiency — reduce manual work, errors, or rework"` — description: `"Time savings, headcount reallocation, error rate reduction"`
   - `"Compliance or regulatory requirement"` — description: `"Audit readiness, GDPR/HIPAA/SOX, data residency, or risk mitigation"`
   - `"Revenue growth — faster time-to-market or better customer experience"` — description: `"New digital channel, cross-sell enablement, or real-time personalization"`
   - `"Cost reduction — legacy system retirement or vendor consolidation"` — description: `"Infrastructure savings, license reduction, or build-vs-buy justification"`

2. **"Who is the primary decision-maker evaluating this?"** (`header: "Decision Maker"`, `multiSelect: false`)
   - `"CIO / CTO — platform and architecture"` — description: `"Frame outcomes as platform consolidation, developer productivity, and technical debt reduction"`
   - `"CDO / VP of Data — data strategy and quality"` — description: `"Frame outcomes as trusted data, governed pipelines, data quality scores, and analytics enablement"`
   - `"COO / VP Operations — process and efficiency"` — description: `"Frame outcomes as SLA improvement, headcount savings, and operational reliability"`
   - `"CFO / Finance — ROI and cost"` — description: `"Frame outcomes as cost avoidance, build-vs-buy ROI, and time-to-value"`

3. **"Do you have any current-state metrics to anchor the value story?"** (`header: "Metrics"`, `multiSelect: false`)
   - `"Yes — I have specific numbers"` — description: `"Type them in the Other field (e.g. '8 hrs/week manual entry', '23% duplicate rate', '3-day lag to Salesforce update', '$2M annual rework cost')"`
   - `"No — use industry benchmark estimates"` — description: `"I'll apply realistic estimates for the use case and vertical — clearly marked as estimates so the SE can swap in real numbers later"`

4. **"What does winning look like for this prospect?"** (`header: "Success Criteria"`, `multiSelect: false`)
   - `"Operational: specific time or error reduction target"` — description: `"e.g. 'Eliminate the weekend batch job', 'Cut reconciliation from 3 days to same-day'"`
   - `"Strategic: single platform or single source of truth"` — description: `"e.g. 'One integration layer for all systems', 'Golden customer record published to Data Cloud'"`
   - `"Revenue / growth: new capability or channel enabled"` — description: `"e.g. 'Enable real-time personalization', 'Support new digital channel launch before Q3'"`
   - Other: `"Describe their specific success criteria in the Other field"`

Store the answers from this step as `$BUSINESS_DRIVER`, `$DECISION_MAKER`, `$METRICS`, and `$SUCCESS_CRITERIA`. Reference all four when building the Value Panel in Step 10.

---

### Step 0c — AI notes path (if "I have discovery notes" is selected)

First, ask how they want to share their notes using `AskUserQuestion`:

- **"How would you like to share your discovery notes?"** (`header: "Share Notes"`, `multiSelect: false`)
  - `"Copy a prompt and paste the output"` — description: `"I'll give you a prompt to run in NotebookLM, Google Docs, or any AI tool — paste the output back here"`
  - `"Share a link to a doc"` — description: `"Paste a Google Doc URL, PDF link, or any other publicly accessible document and I'll read it directly"`

---

**If "Copy a prompt and paste the output" is selected:**

Display the following in a clearly formatted fenced code block so it is easy to copy, preceded by the instruction: **"Copy this prompt into NotebookLM, Google Docs, or wherever your discovery notes and call transcripts live:"**

```
Based on the discovery call notes and transcripts in this notebook, please summarize the following:

1. Use Cases & Integration Scenarios — What business processes or workflows came up? What are they trying to connect, automate, or modernize?

2. Pain Points — What current challenges, manual steps, or inefficiencies did they describe? What's broken, slow, or frustrating today?

3. Desired Future State — What does success look like for them? How do they see MuleSoft solving these problems, and what outcomes are they expecting?

4. Tech Stack — What systems are they currently running (CRM, ERP, data platforms, middleware, etc.)? Are there any new platforms they're evaluating or planning to bring on?

5. Company & Context — What's the company name, their industry, and any key business priorities or decision-maker concerns that came up?

6. Business Outcomes & Success Metrics — Who is the key decision-maker (CIO, CDO, COO, CFO)? What quantifiable metrics were mentioned — hours per week, error rates, duplicate record counts, lag times, dollar values? What does success look like for them, and what is driving the timeline or urgency of this initiative?

Where possible, use the prospect's own words — especially for pain points, future state, and success metrics, as those will be used to personalize the Business Outcomes panel in the live demo.
```

Then output this message to the user and wait for their reply — do NOT use `AskUserQuestion` here:

> **Paste your notes below.** Type or paste the full output from your AI tool into the chat.
> _(Type "go back" to return to the previous question.)_

If the user types "go back", re-run Step 0a from the beginning. Otherwise, treat whatever they send as the notes and proceed to extraction.

---

**If "Share a link to a doc" is selected:**

Output this message to the user and wait for their reply — do NOT use `AskUserQuestion` here:

> **Paste your doc link below.** Share a Google Doc URL, PDF, or any other publicly accessible document.
>
> **Using Google Docs?** Make sure the doc is set to "Anyone with the link can view" — otherwise I won't be able to read it. To check: open the doc → Share → General access → set to **Anyone with the link**.
>
> _(Type "go back" to return to the previous question.)_

If the user types "go back", re-run Step 0a from the beginning. Otherwise, use the `WebFetch` tool to retrieve the document content at the URL they provided, with the prompt: "Extract all content from this document — return the full text as-is." If the fetch fails or the document is access-restricted, tell the user and ask them to either make the doc publicly viewable or use the "paste the output" path instead.

Once the notes are received, extract:
- **Use cases** — integration scenarios and workflows discussed
- **Pain points** — current problems, manual steps, or friction described
- **Future state** — desired outcomes and how MuleSoft fits in
- **Tech stack** — every current system plus future acquisitions or evaluations
- **Company & context** — company name, industry, priorities, stakeholder concerns
- **Business outcomes context** — decision-maker role, any quantifiable metrics mentioned (time, cost, error rates), and what success looks like for them

---

Show a confirmation summary:

```
Here's what I extracted from your notes:

- Company: <name and industry>
- Use cases: <list>
- Pain points: <list>
- Future state: <summary>
- Stack: <list of systems>

Does this look right? Let me know any corrections, and I'll ask about branding next.
```

**Scope filter — apply before confirming.** After extracting use cases, classify each one based on `$PRODUCT`:

**If $PRODUCT = MuleSoft:** classify as **MuleSoft-powered** (MuleSoft is the integration layer moving, transforming, or routing the data) or **out of scope** (native platform-to-platform flows that bypass MuleSoft, Salesforce-internal flows, or platform-only capabilities). Example:
```
✓ In scope (MuleSoft-powered):
  - IDP invoice pipeline: distributor PDF email → MuleSoft IDP → Macola ERP
  - Competitive intel extraction: PDF → MuleSoft → Salesforce Account

✗ Out of scope (no MuleSoft integration layer):
  - Teams Voice → Salesforce native integration
```

Salesforce ecosystem systems (Data Cloud / Data 360, Health Cloud, Service Cloud, etc.) are valid **destinations** — they appear on the right side of the topology. What matters is that MuleSoft is doing the integration work to get data there.

Wait for confirmation, then run one `AskUserQuestion` to collect branding (company name, logo, brand colors), show the pre-build plan (Step 0e), and wait for confirmation before building.

**When building from AI notes:** use the extracted pain points to name and frame demo actions (each action should address a specific pain point or step toward the future state), and echo the prospect's own language in outcome `reasoning` bullets and `nextSteps`.

---

### Step 0d — Transcript path (if `$ARGUMENTS` contains `Transcript: <path>`)

Read the file using the Read tool. Extract use cases, pain points, tech stack, and company context from the transcript — same extraction targets as Step 0c.

Apply the scope filter for the confirmed `$PRODUCT` (see above). Do not extract branding. Show a confirmation summary, wait for corrections, then ask about branding via `AskUserQuestion`. Then proceed to Step 0f.

---

### Step 0e — Remaining Q&A (manual use case selected or shortcut fields provided)

For every field still missing after Step 0b or shortcut parsing, ask using `AskUserQuestion`:

- **Company name** (required) — "What's the prospect or customer name?" Options: `"Generic Demo"` (description: `"No specific branding"`), `"This is for a specific prospect"` (description: `"Type the company name in the Other field"`).
- **Logo** — "Do you have a company logo?" Options: `"Skip — no logo (Recommended)"`, `"Yes — I have a logo"` (description: `"Type the full path in the Other field, e.g. ~/Downloads/logo.png"`).
- **Brand colors** — "Any brand colors?" Options: `"Skip — derive from logo or choose automatically (Recommended)"` (description: `"If you provided a logo, I'll extract the dominant brand color from it"`), `"Yes — I have hex codes"` (description: `"Type one or two hex values in the Other field, e.g. #FF6B00"`).
- **Tech stack** — "What systems are in scope?" with options relevant to the use case and `$PRODUCT`. `multiSelect: true`.

**Key rule:** NEVER use a two-step pattern. Logo path, hex codes, and company name are all collected via the auto-added Other field — if the user types in it, that IS the answer, do not ask again.

Combine up to 4 missing fields per `AskUserQuestion` call; split into two calls if more than 4 remain.

Once all inputs are collected, proceed to **Step 0f**.

---

### Step 0f — Pre-Build Plan (REQUIRED — always runs before any code is written)

After all inputs are collected (via any path above), **always** show a complete pre-build plan and wait for the SE to confirm, modify, or redirect. Do NOT write a single file until this is approved.

**1. Detect the vertical** from the use case, industry, or stack:
- **Service** → case management, work orders, field service, entitlements, Service Cloud / ServiceNow
- **Healthcare** → patients, EHRs, FHIR, benefits, claims, prior auth, health systems
- **Financial Services** → banking, insurance, wealth, loans, KYC/AML, FSC
- **B2C Commerce** → product catalog, orders, inventory, shoppers, Commerce Cloud / SFCC
- **Other** → manufacturing, logistics, telecom, etc.

**2. Identify platform assets** based on `$PRODUCT`:
- **MuleSoft** → Anypoint Exchange connectors, API templates, DataWeave libraries, platform services (e.g. Anypoint IDP). Map each system in the stack to the most specific available asset.

**3. Derive the use cases / actions** from the prospect's pain points and selected product(s). Each action = one demo button. Only include actions where the selected product(s) are doing the work:
- **MuleSoft actions**: MuleSoft is moving, transforming, or routing data

**4. Present the plan** using the topology format that matches `$PRODUCT`:

**If $PRODUCT = MuleSoft:**
```
Here's my build plan — please review before I write any code:

**Product:** MuleSoft
**Vertical:** <Service | Healthcare | Financial Services | B2C Commerce | Other>

**Integration topology:**
- Sources (left): <system 1>, <system 2>, ...
- MuleSoft middle: Experience API: <name> → Process APIs: <name 1>, <name 2> → System APIs: <module 1>, <module 2>
- Destinations (right): <system 1 + objects>, <system 2 + objects>

**Planned actions:** (8–12 total)
1. <Action label> — <one-line description>
...
N. Build complete <Company> 360 — <summary action>

**Anypoint Exchange assets:**
- <Asset name> · <Connector | API Template | DataWeave Library | Platform Service>

**Value points (5 customer-centric outcomes):**
1. <Short title> — "<pain point quote>" → <future state> · metric: <before → after>
...

**Branding:** <Company> · Colors: <hex or "auto-selected: #XXXXXX"> · Logo: <path or "none">
**Port:** auto-detected at build time (first open port ≥ 3001)
**Project path:** ~/claude-projects/<kebab-name>-demo/

Confirm to build, or tell me what to change.
```

Wait for the SE to respond. If they approve ("confirm", "yes", "looks good", etc.), proceed to build. If they request changes, update the plan and show it again before building.

---

## Product accent color

- **MuleSoft** (all verticals): `#00a0df` (`mule-blue`) — always the MuleSoft API tier color; never override with brand colors

## Vertical accent colors (use for brand/packet color when no brand color is provided)

- **Service** (case management, work orders, field service, ServiceNow): `#00a9e0`
- **Healthcare** (patients, EHR, FHIR, claims, prior auth): `#0d9488`
- **Financial Services** (banking, insurance, wealth, KYC/AML): `#1d4ed8`
- **B2C Commerce** (product catalog, orders, inventory, storefront): `#7c3aed`
- **Other** (manufacturing, logistics, aviation, telecom, etc.): choose a color that fits the industry — e.g. `#0f4c8a` for aviation/industrial, `#047857` for energy/utilities, `#b45309` for logistics/supply chain

---

## What to build

A Next.js 14 (App Router) + TypeScript + Tailwind CSS + Framer Motion demo site that visually narrates a Data Foundations flow for the given use case and `$PRODUCT`. Follow the architecture patterns, animation conventions, color tokens, and component structure defined in this skill exactly.

**Topology middle-layer:** 3-tier dashed box — Experience API → Process APIs → System APIs (mule-blue `#00a0df`)

---

## Step-by-step instructions

### 1. Review the spec in this skill before writing any code
Internalize the following sections defined below before generating anything:
- **Packet animation** — WAAPI + CSS `offset-path` approach (never Framer Motion for packets); phase-gated by flow order
- **Layout** — 3-column grid: sources · MuleSoft 3-tier dashed box · destinations
- **Phase timing** — the `simulateFlow` sequence and cumulative node-lighting rules
- **Color tokens** — `mule-blue #00a0df`, `sf-blue`, `brand-primary`, `fhir-teal #0d9488` and their Tailwind names
- **In-memory data store** — API route pattern with global Map, no external services
- **Basic auth middleware** — `middleware.ts` pattern

Do NOT skip this step. All color tokens, animation patterns, and component conventions are fully defined in this skill.

### 2. Determine the integration topology for the requested use case

**Use the approved plan from Step 0e as the authoritative blueprint.** Do not deviate from the agreed-upon topology, actions list, or Exchange assets without telling the SE.

Additionally, ensure:
- **Source system names** match exactly what the SE provided or what the prospect uses — do not substitute generic names
- **MuleSoft middle tier module names** are derived from the actual integration patterns for this use case — name them after what they do (e.g. "Opportunity Orchestration Process API", "IDP Document Process API", "NetSuite System API")
- **Destination objects** are real Salesforce or target system object names (e.g. `Cases`, `Work Orders`, not just "records")
- **StageId union** in `lib/types.ts` is derived from the actual node IDs used in the topology

### 3. Apply company branding

If a **Company** name was provided:
- Set `<title>` and `<meta description>` in `layout.tsx` to `"<Company> × MuleSoft — <Use Case> Demo"`
- Show the company name in the page header (top-left) with:
  1. An **industry icon** (SVG or emoji) immediately before the company name — infer the industry from the use case, vertical, or company context and pick a fitting icon. Examples:
     - Dental / oral health → 🦷 or a tooth SVG
     - General healthcare / hospital → ⚕️ or a medical cross SVG
     - Financial services / banking → 🏦 or a building SVG
     - Insurance → 🛡️
     - Retail / commerce → 🛒
     - Manufacturing → ⚙️
     - Logistics / supply chain → 🚚
     - Energy / utilities → ⚡
     - Telecom → 📡
     - Education → 🎓
     - Real estate → 🏠
     - Government / public sector → 🏛️
     - Technology / SaaS → 💻
     - If the industry is unclear, use a generic integration icon: `◈` or a simple node-graph SVG
  2. The company name as text
  3. A `×` separator followed by a **product badge** — a `mule-blue` (`#00a0df`) pill with text "MuleSoft"
- Update `Footer.tsx` to reference the company name in value prop copy

If a **Logo** was provided:
- Copy the logo file into `public/logo.<ext>` (preserving the original extension)
- Add an `<img src="/logo.<ext>" />` to the header component (top-left, max height 32px), replacing the industry icon
- Do NOT hardcode the logo as base64 in the source — reference it via the public path

If **Colors** were provided:
- Register the first color as `brand.primary` in `tailwind.config.ts` and use it as the accent color throughout (topology packet color, action button active ring, outcome panel border, etc.)
- If a second color is provided, register it as `brand.secondary` and use it for hover states and secondary badges
- Keep ALL existing color tokens (mule-blue, sf-blue, sf-navy, fhir-teal, fhir-light) — only ADD the brand tokens

If a **Stack** was provided:
- Use the exact system names as node labels in the topology — do not substitute generic names
- If any system in the stack maps to a recognizable logo/icon (SAP, Salesforce, NetSuite, Workday, Oracle, ServiceNow, etc.), add a small SVG or emoji icon next to the label in the node box

### 3b. Detect an open port (REQUIRED — do this before writing any files)

Run the following Bash command to find the first available port starting from 3001:

```bash
port=3001; while lsof -ti tcp:$port > /dev/null 2>&1; do port=$((port + 1)); done; echo $port
```

Capture the output as the project's port. Use this value everywhere a port number is needed — `package.json` dev/start scripts, `docker-compose.yml`, `.claude/launch.json`, and the final "how to run" instructions. Never hardcode 3001 if the detection step returns a different number.

Tell the SE which port was selected: `"Port 3001 is in use — using 3003 instead."` (or whatever was detected).

### 4. Create the project
Create a new directory at `~/claude-projects/<kebab-case-company-or-usecase>-demo/` and scaffold:

```
app/
  page.tsx               ← tab switcher (if multi-tab) or single-tab root
  layout.tsx             ← copy from reference, update title/description with company name
  globals.css            ← copy from reference
  api/data/[...path]/route.ts  ← in-memory data store route (like fhir-store pattern)
components/
  Header.tsx             ← NEW: industry icon (or logo if provided) + company name + product badge(s)
  <UseCaseName>Topology.tsx    ← topology map (adapt from BenefitsTopology.tsx)
  <UseCaseName>ActionsPanel.tsx
  <UseCaseName>ResultCards.tsx
  <UseCaseName>OutcomePanel.tsx  ← reuse BenefitsOutcomePanel.tsx pattern exactly
  <UseCaseName>SummaryPanel.tsx  ← optional, if there's a record summary view
  <UseCaseName>ValuePanel.tsx    ← 5 customer-centric value points (see Step 4 layout rules)
  TerminalLog.tsx          ← copy from reference
  ExchangeAssets.tsx       ← connector-first, use-case-driven (see Step 9 below)
  Footer.tsx               ← update value props copy for the use case + company name
lib/
  types.ts                ← StageId union for this topology + Outcome types
  <usecase>.ts            ← sample data + DataWeave snippets for this use case
  transform.ts            ← field mapping helpers
public/
  logo.<ext>             ← company logo copied here (if provided)
middleware.ts             ← copy from reference (Basic auth gate)
.env.example              ← copy from reference
.gitignore                ← copy from reference
next.config.js            ← copy from reference
postcss.config.js         ← copy from reference
tailwind.config.ts        ← copy from reference (keep all same color tokens) + brand colors
package.json              ← copy from reference
tsconfig.json             ← copy from reference
docker-compose.yml        ← copy from reference pattern
Dockerfile                ← copy from reference
README.md                 ← use-case specific deploy instructions
```

### 4. Page layout rules — give topology the hero position

The topology is the visual centerpiece. It must get the most horizontal space so the pipe animation is legible during a live demo.

**Required `app/page.tsx` layout** (12-col grid, 2 rows):
```tsx
<main className="flex-1 grid grid-cols-12 grid-rows-[auto_1fr] gap-3 p-3 min-h-0">

  {/* Row 1: Topology — 8 cols */}
  <div className="col-span-8 bg-white border border-slate-200 rounded-md shadow-sm p-3 flex-shrink-0">
    <UseCaseTopology ... />
  </div>

  {/* Row 1: Outcome panel — 2 cols, between topology and actions */}
  <div className="col-span-2 flex flex-col gap-3 min-h-0 overflow-auto scrollbar-thin">
    <OutcomePanel ... />
    {summary && <SummaryPanel ... />}
    {!outcome && !summary && <empty state dashed placeholder />}
  </div>

  {/* Row 1: Actions sidebar — 2 cols */}
  <div className="col-span-2 min-h-0">
    <ActionsPanel ... />
  </div>

  {/* Row 2: Terminal log — 2 cols (narrow strip) */}
  <div className="col-span-2 min-h-0 overflow-auto scrollbar-thin">
    <TerminalLog ... />
  </div>

  {/* Row 2: Exchange Assets — 5 cols (equal width to Value panel) */}
  <div className="col-span-5 min-h-0 overflow-auto scrollbar-thin">
    <ExchangeAssets />
  </div>

  {/* Row 2: Business Outcomes panel — 5 cols (equal width to Exchange Assets) */}
  <div className="col-span-5 min-h-0 overflow-auto scrollbar-thin">
    <ValuePanel />
  </div>

</main>
```

Column layout: `8 + 2 + 2 = 12` (row 1), `2 + 5 + 5 = 12` (row 2).

This layout gives:
- Topology 8/12 ≈ 67% of page width — wide enough for the pipe animation to be readable
- Outcome panel is visible alongside the topology, sandwiched between topology and actions
- Exchange Assets and Business Outcomes panel are **equal width** (5 cols each) — they dominate the bottom row
- Terminal log is a narrow 2-col strip — visible but secondary; the content panels get the majority
- Value panel header: use "Business Outcomes" (or "Value Drivers" / "Measurable ROI") — not "Integration Value"

### 4a. Topology internal grid rules
- **Inner grid**: `grid-cols-[1fr_320px_1fr]` — the MuleSoft integration layer gets a fixed width (320px) wide enough for the 2-column API grid to be readable, while source/dest columns each take equal flexible space so SVG pipe paths are as long as possible.
- **Min height**: `style={{ minHeight: '540px' }}`
- **Left column** (sources): 3–6 boxes, spread top-to-bottom with `justify-between flex-1`. Each node card must have `max-w-[160px]` — keeps boxes compact and left-aligned so the pipe starts at the card's right edge with visible space before the MuleSoft box.
- **Middle column** (MuleSoft): 3-tier dashed-box — Experience API → Process APIs → System APIs, named after the actual integration patterns for this use case, each in its own colored sub-panel
- **Right column** (destination): target system nodes, spread top-to-bottom. Each node card must have `max-w-[160px] ml-auto` — right-aligns the card so the pipe ends at the card's left edge with visible space after the MuleSoft box.
- SVG pipe layer uses DOM `useLayoutEffect` + `ResizeObserver` to measure real positions — copy this exactly from `Topology.tsx`, do NOT hardcode coordinates
- All node boxes use the same `SimpleBox`/`ModuleBox` component pattern with `glow-pulse` ring on active

### 4a. Animation rules — make the data flow slow, visible, and narration-friendly

The goal is for a Solution Engineer to narrate each hop while watching the data visibly travel through every API tier and system. Every node, pipe, and packet must reinforce exactly where the data is at any moment.

**Action timing — REQUIRED (total flow: ~11 seconds minimum):**
- Every action handler must use a `simulateFlow()` async function structured as a staged sequence with the following delays:
  ```ts
  async function simulateFlow() {
    setPhase('source');       // 0ms      — source system lights up, "Fetching records…"
    await delay(2000);
    setPhase('experience');   // 2000ms   — Experience API activates, packets depart source
    await delay(1800);
    setPhase('process');      // 3800ms   — Process API tier activates, "Transforming payload…"
    await delay(1800);
    setPhase('system');       // 5600ms   — System API tier activates, "Routing to connectors…"
    await delay(1500);
    setPhase('destination');  // 7100ms   — destination nodes activate, "Writing to <system>…"
    await delay(5000);        // needs ≥4000ms — dest packets (RIGHT_DUR=3.5s) need time to complete their first trip
    setPhase('complete');     // 12100ms  — all nodes hold lit, "Sync complete", busy=false
  }
  ```
- Pass `phase` as a prop to the Topology component. The `busy` flag stays `true` for the entire duration.
- **Cumulative lighting:** once a node lights up, it stays lit for the rest of the flow. Do NOT turn it off when the next phase begins — every tier that was activated stays visually on until the next action clears everything.

**Node status labels — REQUIRED:**
- Every active node must show a short status message that updates as `phase` advances. Use a `statusLabel` prop on each node box. Messages should be specific to the use case — for example:
  - Source system: `"Fetching records…"` → (stays visible through completion)
  - Experience API: `"Routing request…"`
  - Process API: `"Transforming payload…"`
  - System API: `"Invoking connector…"`
  - Destination: `"Writing to <system>…"` → on `'complete'`: `"✓ Synced"`
- Status labels appear inside the node box below the system name, in a small muted font (`text-xs text-slate-400`). On `'complete'` the destination label turns accent-colored and bold to signal success.

**Packet animation — REQUIRED:**
- Packet sizes: inner circle `r=9`, outer halo `r=18` (both at `cx=0 cy=0` — the `<g>` element moves, not the circles)
- Send **5 staggered packets per segment** with `delay: i * 0.8` between them — creates a visible data train the SE can point to
- Durations: `LEFT_DUR=6.5`, `MID_DUR=5.0`, `RIGHT_DUR=3.5`
- Packet color shifts by segment: source→mule packets use the brand accent color (`#38bdf8`), mule-internal packets use `mule-blue` (`#00a0df`), mule→destination packets use `#60a5fa` (blue-400). **Never use dark navy (`#1e3a5f`) for packets — it's invisible on a white SVG background.**
- **No text labels on packets.** Do NOT add any text inside packet circles. The dots travel unlabeled.
- **Use WAAPI + CSS `offset-path` — REQUIRED. Do NOT use Framer Motion for packets.** Framer Motion's SVG element handler (`motion.g`, `motion.circle`) passes CSS-only properties like `offsetDistance` from the `animate` prop as DOM *attributes* instead of CSS properties, causing React warnings and non-functional animation. The correct pattern uses the Web Animations API directly via `useEffect`:
  ```tsx
  import { useLayoutEffect, useRef, useState, memo, useEffect } from 'react';
  // No framer-motion import needed for the Packet component

  const Packet = memo(function Packet({
    fill, pathD, duration, delay,
  }: {
    fill: string;
    pathD: string;
    duration: number;
    delay: number;
  }) {
    const ref = useRef<SVGGElement>(null);

    useEffect(() => {
      const el = ref.current;
      if (!el) return;
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      (el.style as any).offsetPath = "path('" + pathD + "')";
      const anim = el.animate(
        [{ offsetDistance: '0%' }, { offsetDistance: '100%' }],
        { duration: duration * 1000, delay: delay * 1000, iterations: Infinity, easing: 'linear', fill: 'both' as FillMode },
      );
      return () => anim.cancel();
    }, [pathD, duration, delay]);

    return (
      <g ref={ref}>
        <circle cx={0} cy={0} r={18} fill={fill} opacity={0.18} filter="url(#bigGlow)" />
        <circle cx={0} cy={0} r={9} fill={fill} filter="url(#glow)" />
      </g>
    );
  });
  ```
  The key insight: `pathD` is the **exact same bezier path string** used to draw the SVG pipe line. Compute it once and pass it to both the `<path d={...}>` element and the `Packet`. This makes packets follow the actual drawn curve, not an approximation.

  **Packet groups are phase-gated — REQUIRED.** All three groups live inside a single `{streaming && (<>...</>)}` block, but each group has its own phase condition. This makes packets visually follow the data: sources fire first, then the API tier processes, then data lands at the destination.

  ```tsx
  {streaming && (
    <>
      {/* Source → MuleSoft: active from the start */}
      {SOURCES.filter((src) => activeSources.includes(src.id)).map((src, si) => {
        const cpx = s.x + (layout.muleIn.x - s.x) * 0.6;
        const pathD = 'M ' + s.x + ' ' + s.y + ' C ' + cpx + ' ' + s.y + ', ' + cpx + ' ' + layout.muleIn.y + ', ' + layout.muleIn.x + ' ' + layout.muleIn.y;
        return Array.from({ length: PACKET_COUNT }, (_, i) => (
          <Packet key={'src-' + src.id + '-' + i}
            fill="#38bdf8" pathD={pathD}
            duration={LEFT_DUR} delay={si * 0.4 + i * 0.8} />
        ));
      })}

      {/* MuleSoft internal: only once the Experience API activates */}
      {phaseGte(phase, 'experience') && Array.from({ length: 3 }, (_, i) => {
        const pathD = 'M ' + layout.muleIn.x + ' ' + layout.muleIn.y + ' L ' + layout.muleOut.x + ' ' + layout.muleOut.y;
        return <Packet key={'mid-' + i} fill="#00a0df" pathD={pathD} duration={MID_DUR} delay={i * 1.0} />;
      })}

      {/* MuleSoft → Destination: only once the destination phase starts */}
      {phaseGte(phase, 'destination') && DESTS.filter((dst) => activeDestinations.includes(dst.id)).map((dst, di) => {
        const cpx = layout.muleOut.x + (dest.x - layout.muleOut.x) * 0.5;
        const pathD = 'M ' + layout.muleOut.x + ' ' + layout.muleOut.y + ' C ' + cpx + ' ' + layout.muleOut.y + ', ' + cpx + ' ' + dest.y + ', ' + dest.x + ' ' + dest.y;
        return Array.from({ length: PACKET_COUNT }, (_, i) => (
          <Packet key={'dst-' + dst.id + '-' + i}
            fill="#60a5fa" pathD={pathD}
            duration={RIGHT_DUR} delay={di * 0.15 + i * 0.3} />
        ));
      })}
    </>
  )}
  ```
  Use string concatenation (not template literals) for `pathD` to avoid potential encoding issues from the Edit tool. `React.memo` with primitive props (`fill`, `pathD`, `duration`, `delay`) ensures the `useEffect` only re-fires when the layout actually changes, so animation runs uninterrupted across parent re-renders.

**Pipe path highlight — REQUIRED:**
- For every pipe segment, render a second "lit" SVG path on top of the gray base path. Use the accent gradient, `strokeWidth=6`, `opacity=0.85`.
- Lit paths appear and stay — they do NOT turn off when a later phase begins:
  - Source → MuleSoft: lights on `phase === 'experience'`, stays lit through `'complete'`
  - MuleSoft internal (exp→process, process→system): lights on `phase === 'process'`, stays lit through `'complete'`
  - MuleSoft → Destination: lights on `phase === 'destination'`, stays lit through `'complete'`
- When all three segments are lit simultaneously (during `'destination'` and `'complete'` phases), the full end-to-end route glows at once — this is the visual payoff.
- Active pipe `strokeWidth` scales with phase: `4` on first activation, `6` when the segment immediately ahead is also active.

**Node highlight behavior — REQUIRED:**
- Source nodes: on `phase === 'source'` or later, apply `ring-4 ring-offset-2` + background tint (`bg-brand-primary/10`). Scale up slightly: `scale-[1.03]`.
- MuleSoft tier boxes: sequential activation — Experience API glows on `'experience'`, Process API boxes on `'process'`, System API boxes on `'system'`. Each tier box that activates stays glowing.
- Destination nodes: on `phase === 'destination'` or `'complete'`, apply a bold accent ring (`ring-4`) and `scale-[1.05]` pop. On `'complete'`, transition to a settled green-tinted highlight.
- On `phase === 'complete'` (busy=false), the entire active path stays visually lit with a unified "settled" style (`ring-2 opacity-75`) across all nodes and pipes. Do NOT snap anything back to gray. Clear only when the NEXT action starts.

**Terminal log entries — REQUIRED:**
- Each phase transition must append a realistic log line to the TerminalLog. Lines should reference the actual API names and system names from the approved topology:
  - `'source'`: `→ [source system name] record retrieved (id: <record-id>)`
  - `'experience'`: `GET /api/experience/<use-case-slug>  200 OK  142ms`
  - `'process'`: `POST /api/process/transform  200 OK  87ms  payload: { <2–3 real field names> }`
  - `'system'`: `GET /api/system/<connector-name>/<id>  200 OK  218ms`
  - `'destination'`: `PUT /api/system/<dest-connector>/upsert  201 Created  334ms`
  - `'complete'`: `✓ [action label] complete — [destination system] updated`
- Use the real system names, API names, and field names from the approved plan — not generic placeholders.

### 5. Actions panel design rules
- **Use the exact action list approved in Step 0e** — do not add or remove actions without SE approval
- **Every action must be MuleSoft-powered.** If MuleSoft is not moving, transforming, or routing data in the middle tier, the action does not belong. Salesforce systems (Data Cloud, Service Cloud, Health Cloud, etc.) can be targets — but MuleSoft must be doing the integration work to get data there.
- Group actions by the phase groupings shown in the plan (e.g. "Case Management", "Migration", "Asset Intelligence")
- Each action button shows a spinner when busy, a checkmark when it was the last run
- 8–12 actions minimum
- Every action except the final "Build Complete [X] 360" action must set an outcome
- The final bulk/complete action only shows the summary panel (no outcome card) — same as `buildBenefits360` in the reference

### 6. Outcome panel
- Reuse `BenefitsOutcomePanel.tsx` verbatim (or copy it) — do not redesign it
- Each outcome must have: `headline`, `decision`, `facts` (6 key/value pairs), `reasoning` (3–5 bullets), `nextSteps` (3 bullets), `auditTrail` (4 hops)
- Status: `eligible` | `approved` | `pending` | `denied` | `complete` — pick the semantically correct one per action
- When building from discovery notes: echo the prospect's own language in `reasoning` bullets and `nextSteps`

### 7. In-memory data store
- Seed with 3–5 realistic records for the use case (like pat-001/002/003 in the healthcare demo)
- Support GET (list + by ID), POST, PUT — same pattern as `lib/fhir-store.ts`
- No external services; everything runs in-process

### 8. Color and styling rules
- Keep ALL Tailwind color tokens from the reference (`mule-blue`, `sf-blue`, `sf-navy`, `fhir-teal`, `fhir-light`) — they are in `tailwind.config.ts`
- **Color priority — follow this order:**
  1. **Explicit hex codes provided** → register as `brand.primary` (and `brand.secondary` if two were given)
  2. **Logo provided, no explicit colors** → read the logo file using the Read tool, identify the dominant brand color visually, and register it as `brand.primary`. State the chosen hex in the pre-build plan as `"extracted from logo: #XXXXXX"`
  3. **Neither logo nor colors** → use the accent color from the **Vertical accent colors** section above for the detected vertical
- Use `brand.primary` as the accent color everywhere: topology packets, active button rings, outcome panel borders, action button highlights
- `mule-blue` always remains the primary MuleSoft API layer color — never replace it with brand colors
- Font sizes, spacing, border-radius, shadow classes — copy from reference exactly

### 9. Platform assets — connector-first, use-case-driven

`ExchangeAssets.tsx` must feature the Anypoint Exchange assets that best tell the story for this specific prospect:

- List 5–7 assets. Every asset must map directly to a system in the stack or a use case from the notes
- Priority: named connector > generic HTTP connector > API template
- Include platform services like **Anypoint IDP** if document extraction is in scope
- Asset descriptions must reference the specific systems and outcomes for this prospect
- Type badges: `Connector` · `API Template` · `DataWeave Library` · `Platform Service`
- No `Accelerator` badge

### 10. Value panel — customer-centric outcomes

`<UseCaseName>ValuePanel.tsx` sits in row 2, col 10–12 (3 cols, equal width to Exchange Assets). It shows 5 customer-facing value points derived from the prospect's pain points and future state from the discovery notes. Header label: **"Business Outcomes"** (preferred), or "Value Drivers" / "Measurable ROI" — never "Integration Value".

**Rules:**
- Derive all 5 points from the prospect's actual pain points and future state — do NOT use generic MuleSoft marketing benefits. If built from AI notes, use the prospect's own words verbatim in quotes.
- Each value point has four parts:
  1. **Title** — short imperative phrase (e.g. "Eliminate Manual Re-Entry", "Master the Customer Record", "Cut Compliance Audit Time")
  2. **Quote** — a direct quote or paraphrase of the pain in the prospect's voice, in italics, with a left brand-accent border
  3. **Future state** — one sentence describing what MuleSoft makes possible (no jargon, outcome-focused)
  4. **Metric** — a before/after number or compliance label (e.g. "3 hrs → 0", "SOC 2 compliant", "23% dupes → <1%", "real-time")

**Using Step 0b3 inputs to sharpen the value story (if captured):**

- **`$BUSINESS_DRIVER`**: At least 2 of the 5 value points must directly address the primary driver:
  - Operational efficiency → focus on time savings and error elimination
  - Compliance → two points should quantify risk reduction or audit readiness
  - Revenue growth → emphasize speed-to-capability and customer experience uplift
  - Cost reduction → show license/infrastructure savings and build-vs-buy delta

- **`$DECISION_MAKER`**: Tailor the language, framing, and metric types to the persona:
  - CIO/CTO → platform consolidation, developer productivity, system count reduction, scalability
  - CDO/VP Data → data quality score improvement, duplicate rate, lineage coverage, trusted data SLAs
  - COO/Operations → cycle time reduction, manual hours saved, SLA compliance rate, headcount reallocation
  - CFO/Finance → cost avoidance ($), ROI timeline, FTE equivalent savings, vendor license reduction

- **`$METRICS`**: If specific numbers were provided, use them verbatim as the "before" value in the Metric field. Mark them with a ✓ indicator to signal they came from the prospect. If no metrics were provided, apply industry-benchmark estimates for the vertical and label them as `"est."` so the SE knows to replace them (e.g. `"est. 8 hrs/wk → 0"`).

- **`$SUCCESS_CRITERIA`**: Make the **fifth and final value point** directly mirror the prospect's stated success criterion. This is the "landing" value point — the one that should resonate most with the decision-maker and be memorable after the demo ends.

- Style: white card, `border border-slate-100 bg-slate-50/60 rounded p-2`, compact text (`text-[10px]`–`text-[11px]`), metric in `brand.primary` bold
- The panel is scrollable (`overflow-auto scrollbar-thin`) — all 5 cards should be visible on scroll without taking up more than row-2 height

### 11. Final check
Before declaring done:
- [ ] `docker compose up -d --build` builds and starts on the detected port without error
- [ ] Topology SVG pipes render and animate correctly
- [ ] Every action runs without throwing errors
- [ ] Outcome panel appears after each non-360 action
- [ ] Summary/record panel appears after the 360 action
- [ ] Highlights persist after action completes, clear on next action
- [ ] Value panel is visible below the actions sidebar with 5 prospect-specific value points
- [ ] Animated packets stop when `busy=false` (no streaming after completion)
- [ ] README includes local run + Vercel deploy instructions
- [ ] Actions panel matches the approved list from Step 0e exactly

---

## Output
When finished, tell the user:
1. The project path
2. How to start it locally (`npm install && npm run dev` or `docker compose up -d --build`), with the exact URL including the detected port
3. The list of actions implemented (confirming they match the approved plan)
4. Design decisions made: Exchange assets chosen and why, topology shape, accent/brand colors, exact system names in topology, logo placement (if any), data model
