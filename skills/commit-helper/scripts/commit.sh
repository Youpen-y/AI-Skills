#!/usr/bin/env bash
# Commit Helper Script
# Generates conventional commit messages with AI assistance

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if we're in a git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    exit 1
fi

# Check if there are changes
if git diff --quiet && git diff --cached --quiet; then
    echo -e "${YELLOW}No changes to commit${NC}"
    exit 0
fi

# Get git diff
echo -e "${BLUE}Analyzing changes...${NC}"
DIFF=$(git diff --cached 2>/dev/null || git diff)

# Prompt for commit type
echo ""
echo "Select commit type:"
echo "  1) feat       - New feature"
echo "  2) fix        - Bug fix"
echo "  3) docs       - Documentation"
echo "  4) style      - Code formatting"
echo "  5) refactor   - Code refactor"
echo "  6) perf       - Performance"
echo "  7) test       - Tests"
echo "  8) build      - Build system"
echo "  9) ci         - CI configuration"
echo " 10) chore      - Other changes"
echo " 11) revert     - Revert commit"
read -p "Choice [1-11]: " type_choice

TYPE_MAP=(
    "feat"
    "fix"
    "docs"
    "style"
    "refactor"
    "perf"
    "test"
    "build"
    "ci"
    "chore"
    "revert"
)

TYPE="${TYPE_MAP[$((type_choice-1))]}"

# Prompt for scope
read -p "Scope (optional, press to skip): " scope

# Prompt for description
read -p "Description: " description

# Build commit message
if [ -n "$scope" ]; then
    SUBJECT="$type($scope): $description"
else
    SUBJECT="$type: $description"
fi

# Preview
echo ""
echo -e "${GREEN}Preview:${NC}"
echo "$SUBJECT"
echo ""

# Prompt for body
read -p "Add body? [y/N]: " add_body
if [[ $add_body =~ ^[Yy]$ ]]; then
    echo "Enter body (empty line to finish):"
    BODY_LINES=()
    while IFS= read -r line; do
        [[ -z "$line" ]] && break
        BODY_LINES+=("$line")
    done
fi

# Prompt for footer
read -p "Add footer (issue references, breaking changes)? [y/N]: " add_footer
if [[ $add_footer =~ ^[Yy]$ ]]; then
    read -p "Footer: " footer
fi

# Build full message
MESSAGE="$SUBJECT"
if [ ${#BODY_LINES[@]} -gt 0 ]; then
    MESSAGE="$MESSAGE\n\n${BODY_LINES[*]}"
fi
if [ -n "$footer" ]; then
    MESSAGE="$MESSAGE\n\n$footer"
fi

# Final confirmation
echo ""
echo -e "${BLUE}Full commit message:${NC}"
echo -e "$MESSAGE"
echo ""
read -p "Commit? [Y/n]: " confirm

if [[ ! $confirm =~ ^[Nn]$ ]]; then
    if git diff --cached --quiet; then
        git add -A
    fi
    git commit -m "$MESSAGE"
    echo -e "${GREEN}✓ Committed successfully${NC}"
else
    echo -e "${YELLOW}Commit cancelled${NC}"
    exit 0
fi
