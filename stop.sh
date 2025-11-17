#!/bin/bash

# 🛑 ChainCARE Protocol - Stop All Services

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$PROJECT_ROOT/.chaincare_pids"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}🛑 Stopping all ChainCARE services...${NC}"

if [ ! -f "$PID_FILE" ]; then
    echo -e "${YELLOW}⚠️  No PID file found. Services may not be running.${NC}"
    exit 0
fi

STOPPED=0
while read -r pid; do
    if kill -0 "$pid" 2>/dev/null; then
        kill "$pid" 2>/dev/null && {
            echo -e "${GREEN}✅ Stopped process (PID: $pid)${NC}"
            STOPPED=$((STOPPED + 1))
        } || echo -e "${RED}❌ Failed to stop process (PID: $pid)${NC}"
    fi
done < "$PID_FILE"

rm -f "$PID_FILE"

if [ $STOPPED -eq 0 ]; then
    echo -e "${YELLOW}⚠️  No running processes found${NC}"
else
    echo -e "${GREEN}✅ Stopped $STOPPED service(s)${NC}"
fi

