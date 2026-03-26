#!/bin/bash
# TeammateIdle hook: Verify deliverables + uncommitted changes

INPUT=$(cat)
TEAMMATE=$(echo "$INPUT" | jq -r '.teammate_name // empty')
PROJ_DIR=$(echo "$INPUT" | jq -r '.cwd')

if [ -z "$TEAMMATE" ]; then
  exit 0
fi

# 1. Minimum deliverable verification per teammate
case "$TEAMMATE" in
  product-pm)
    if [ -z "$(ls -A "$PROJ_DIR/docs/product/" 2>/dev/null)" ] && [ -z "$(ls -A "$PROJ_DIR/docs/specs/" 2>/dev/null)" ]; then
      echo "product-pm: Write at least 1 document to docs/product/ or docs/specs/ before going idle." >&2
      exit 2
    fi
    ;;
  eng-*)
    if [ -z "$(find "$PROJ_DIR/src/" -name "*.ts" -o -name "*.js" -o -name "*.py" 2>/dev/null)" ]; then
      echo "eng agent: Write at least 1 code file to src/ before going idle." >&2
      exit 2
    fi
    ;;
  qa-tester)
    if [ -z "$(find "$PROJ_DIR/tests/" -name "*.test.*" -o -name "*.spec.*" 2>/dev/null)" ] && [ -z "$(find "$PROJ_DIR/e2e/" -name "*.test.*" -o -name "*.spec.*" 2>/dev/null)" ]; then
      echo "qa-tester: Write at least 1 test file to tests/ or e2e/ before going idle." >&2
      exit 2
    fi
    ;;
esac

# 2. Block uncommitted changes
UNCOMMITTED=$(cd "$PROJ_DIR" && git status --porcelain 2>/dev/null | grep -v '^\?\?' | head -20)
if [ -n "$UNCOMMITTED" ]; then
  FILE_LIST=$(echo "$UNCOMMITTED" | awk '{print $2}' | head -5 | tr '\n' ', ' | sed 's/,$//')
  echo "Uncommitted changes: $FILE_LIST. Commit your work before going idle." >&2
  exit 2
fi

exit 0
