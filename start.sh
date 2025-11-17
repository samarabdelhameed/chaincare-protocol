#!/bin/bash

# 🏥 ChainCARE Protocol - Unified Startup Script
# This script starts all components of the ChainCARE Protocol

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

# PID file to track running processes
PID_FILE="$PROJECT_ROOT/.chaincare_pids"
LOG_DIR="$PROJECT_ROOT/logs"
mkdir -p "$LOG_DIR"

# Cleanup function
cleanup() {
    echo -e "\n${YELLOW}🛑 Stopping all services...${NC}"
    if [ -f "$PID_FILE" ]; then
        while read -r pid; do
            if kill -0 "$pid" 2>/dev/null; then
                kill "$pid" 2>/dev/null || true
            fi
        done < "$PID_FILE"
        rm -f "$PID_FILE"
    fi
    echo -e "${GREEN}✅ All services stopped${NC}"
    exit 0
}

# Trap Ctrl+C
trap cleanup SIGINT SIGTERM

# Check prerequisites
check_prerequisites() {
    echo -e "${BLUE}🔍 Checking prerequisites...${NC}"
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        echo -e "${RED}❌ Node.js is not installed. Please install Node.js v18+${NC}"
        exit 1
    fi
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✅ Node.js: $NODE_VERSION${NC}"
    
    # Check npm
    if ! command -v npm &> /dev/null; then
        echo -e "${RED}❌ npm is not installed${NC}"
        exit 1
    fi
    NPM_VERSION=$(npm --version)
    echo -e "${GREEN}✅ npm: $NPM_VERSION${NC}"
    
    # Check Python (optional for oracle)
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version)
        echo -e "${GREEN}✅ Python: $PYTHON_VERSION${NC}"
        PYTHON_AVAILABLE=true
    else
        echo -e "${YELLOW}⚠️  Python3 not found. Oracle service will be skipped${NC}"
        PYTHON_AVAILABLE=false
    fi
    
    # Check Rust (optional for contracts)
    if command -v cargo &> /dev/null; then
        RUST_VERSION=$(cargo --version | cut -d' ' -f2)
        echo -e "${GREEN}✅ Rust/Cargo: $RUST_VERSION${NC}"
        RUST_AVAILABLE=true
    else
        echo -e "${YELLOW}⚠️  Rust/Cargo not found. Contract building will be skipped${NC}"
        RUST_AVAILABLE=false
    fi
    
    echo ""
}

# Install frontend dependencies
setup_frontend() {
    echo -e "${BLUE}📦 Setting up Frontend...${NC}"
    cd "$PROJECT_ROOT/frontend"
    
    if [ ! -d "node_modules" ]; then
        echo -e "${YELLOW}Installing frontend dependencies...${NC}"
        npm install
    else
        echo -e "${GREEN}✅ Frontend dependencies already installed${NC}"
    fi
    
    cd "$PROJECT_ROOT"
}

# Install oracle dependencies
setup_oracle() {
    if [ "$PYTHON_AVAILABLE" = false ]; then
        return
    fi
    
    echo -e "${BLUE}📦 Setting up Oracle...${NC}"
    cd "$PROJECT_ROOT/oracle"
    
    # Check if requirements.txt exists
    if [ -f "requirements.txt" ]; then
        if ! python3 -c "import substrateinterface" 2>/dev/null; then
            echo -e "${YELLOW}Installing oracle dependencies...${NC}"
            pip3 install -r requirements.txt || pip install -r requirements.txt || true
        else
            echo -e "${GREEN}✅ Oracle dependencies already installed${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  requirements.txt not found. Installing basic dependencies...${NC}"
        pip3 install substrate-interface bleak || pip install substrate-interface bleak || true
    fi
    
    cd "$PROJECT_ROOT"
}

# Start frontend
start_frontend() {
    echo -e "${BLUE}🚀 Starting Frontend...${NC}"
    cd "$PROJECT_ROOT/frontend"
    
    # Start in background
    npm run dev > "$LOG_DIR/frontend.log" 2>&1 &
    FRONTEND_PID=$!
    echo "$FRONTEND_PID" >> "$PID_FILE"
    
    echo -e "${GREEN}✅ Frontend started (PID: $FRONTEND_PID)${NC}"
    echo -e "${BLUE}   Logs: $LOG_DIR/frontend.log${NC}"
    echo -e "${BLUE}   URL: http://localhost:5173 (or check logs for actual port)${NC}"
    
    cd "$PROJECT_ROOT"
}

# Start oracle (optional)
start_oracle() {
    if [ "$PYTHON_AVAILABLE" = false ]; then
        echo -e "${YELLOW}⏭️  Skipping Oracle (Python not available)${NC}"
        return
    fi
    
    # Check if oracle should run (check for required env vars or config)
    if [ -z "$RPC_URL" ] && [ ! -f "$PROJECT_ROOT/oracle/config.json" ]; then
        echo -e "${YELLOW}⏭️  Skipping Oracle (no configuration found)${NC}"
        echo -e "${YELLOW}   Set RPC_URL and MNEMONIC env vars or create oracle/config.json to enable${NC}"
        return
    fi
    
    echo -e "${BLUE}🚀 Starting Oracle...${NC}"
    cd "$PROJECT_ROOT/oracle"
    
    # Start in background
    python3 oracle.py > "$LOG_DIR/oracle.log" 2>&1 &
    ORACLE_PID=$!
    echo "$ORACLE_PID" >> "$PID_FILE"
    
    echo -e "${GREEN}✅ Oracle started (PID: $ORACLE_PID)${NC}"
    echo -e "${BLUE}   Logs: $LOG_DIR/oracle.log${NC}"
    
    cd "$PROJECT_ROOT"
}

# Build contracts (optional)
build_contracts() {
    if [ "$RUST_AVAILABLE" = false ]; then
        echo -e "${YELLOW}⏭️  Skipping contract build (Rust not available)${NC}"
        return
    fi
    
    echo -e "${BLUE}🔨 Building Smart Contracts...${NC}"
    cd "$PROJECT_ROOT/contracts"
    
    # Check if already built
    if [ -d "target/ink" ] && [ "$(find target/ink -name '*.contract' | wc -l)" -gt 0 ]; then
        echo -e "${GREEN}✅ Contracts already built${NC}"
    else
        echo -e "${YELLOW}Building contracts (this may take a while)...${NC}"
        cargo contract build --release || {
            echo -e "${YELLOW}⚠️  Contract build failed or incomplete. Continuing...${NC}"
        }
    fi
    
    cd "$PROJECT_ROOT"
}

# Main execution
main() {
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║     🏥 ChainCARE Protocol - Unified Startup Script      ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}\n"
    
    # Initialize PID file
    > "$PID_FILE"
    
    # Run setup steps
    check_prerequisites
    setup_frontend
    setup_oracle
    
    # Optional: Build contracts (commented out by default as it's slow)
    # Uncomment if you want to build contracts on startup
    # build_contracts
    
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}🚀 Starting Services...${NC}\n"
    
    # Start services
    start_frontend
    echo ""
    start_oracle
    echo ""
    
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✅ All services started!${NC}\n"
    echo -e "${YELLOW}📝 Services running:${NC}"
    echo -e "   • Frontend: http://localhost:5173"
    if [ "$PYTHON_AVAILABLE" = true ] && [ -n "$RPC_URL" ] || [ -f "$PROJECT_ROOT/oracle/config.json" ]; then
        echo -e "   • Oracle: Running in background"
    fi
    echo -e "\n${YELLOW}📋 Logs:${NC}"
    echo -e "   • Frontend: $LOG_DIR/frontend.log"
    if [ "$PYTHON_AVAILABLE" = true ]; then
        echo -e "   • Oracle: $LOG_DIR/oracle.log"
    fi
    echo -e "\n${YELLOW}🛑 To stop all services: Press Ctrl+C${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    
    # Wait for all background processes
    wait
}

# Run main function
main

