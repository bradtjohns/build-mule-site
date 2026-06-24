#!/bin/bash
# build-mule-site — one-line installer

REPO="https://raw.githubusercontent.com/johnson-brad/build-mule-site/main"
COMMANDS_DIR="$HOME/.claude/commands"

echo "Installing build-mule-site skill..."
mkdir -p "$COMMANDS_DIR"

curl -s "$REPO/.claude/commands/build-mule-site.md" -o "$COMMANDS_DIR/build-mule-site.md"

echo ""
echo "✓ Installed. Open Claude Code and type /build-mule-site to get started."
echo ""
echo "Usage:"
echo "  /build-mule-site                          — start with interactive Q&A"
echo "  /build-mule-site Company: Acme | Stack: SAP, Salesforce | Use Case: Quote to Cash"
echo "  /build-mule-site Transcript: ~/Downloads/discovery-call.txt"
