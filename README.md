# build-mule-site

A Claude Code skill for Solution Engineers that scaffolds a live, narrated MuleSoft integration demo site from a discovery call in minutes.

Generates a **Next.js 14 + TypeScript + Tailwind + Framer Motion** site with:
- Animated SVG topology — sources → MuleSoft 3-tier API hub → destinations
- Data packets that follow the actual bezier pipe curves, phase-gated to match the data flow
- 8–12 clickable demo actions, each with an outcome panel and activity log
- Business value panel with before/after metrics
- Basic auth gate + Docker support
- Branded for the prospect (logo, colors, company name)

---

## Installation

```bash
curl -s https://raw.githubusercontent.com/bradtjohns/build-mule-site/main/install.sh | bash
```

Then open Claude Code and type `/build-mule-site`.

---

## Usage

**Interactive Q&A (recommended for first run):**
```
/build-mule-site
```

**Shortcut with pre-filled fields:**
```
/build-mule-site Company: Acme Corp | Logo: ~/Downloads/acme-logo.png | Colors: #FF6B00 | Stack: SAP S/4HANA, Salesforce CPQ, NetSuite | Use Case: Quote to Cash
```

**From discovery notes or transcript:**
```
/build-mule-site Transcript: ~/Downloads/discovery-call.txt
```

The skill walks through Q&A, shows a full pre-build plan for approval, then generates the complete project.

---

## What gets generated

```
~/claude-projects/<company>-demo/
├── app/
│   ├── page.tsx          ← all demo actions + state machine
│   ├── layout.tsx        ← branded header
│   └── api/data/         ← in-memory data store
├── components/
│   ├── <Co>Topology.tsx  ← SVG pipe animation + packet motion
│   ├── OutcomePanel.tsx
│   ├── ValuePanel.tsx
│   └── ...
├── lib/
│   ├── types.ts
│   ├── store.ts
│   └── exchange-assets.ts
├── middleware.ts          ← basic auth
├── Dockerfile
├── docker-compose.yml
└── .claude/launch.json
```

---

## Prerequisites

- [Claude Code](https://claude.ai/code) installed
- Node.js 18+ (for running the generated site)
- Docker (optional, for containerized deployment)

---

Built by [@bradtjohns](https://github.com/bradtjohns)
