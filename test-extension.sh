#!/bin/bash
# Test the QuickLook extension after building
#
# Usage:
#   ./test-extension.sh              # Test with table-test.md (default)
#   ./test-extension.sh math-test.md # Test specific file
#   ./test-extension.sh --list       # List available test files

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEST_DIR="$SCRIPT_DIR/test-files"
DEFAULT_FILE="table-test.md"

# Handle --list / -l
if [[ "$1" == "--list" || "$1" == "-l" ]]; then
    echo "Available test files:"
    ls -1 "$TEST_DIR"/*.md | xargs -n1 basename
    exit 0
fi

# Determine test file
if [ -n "$1" ]; then
    # If argument is a full path, use it; otherwise assume it's in test-files/
    if [[ "$1" == /* || "$1" == ./* ]]; then
        TEST_FILE="$1"
    else
        TEST_FILE="$TEST_DIR/$1"
    fi
else
    TEST_FILE="$TEST_DIR/$DEFAULT_FILE"
fi

# Verify test file exists
if [ ! -f "$TEST_FILE" ]; then
    echo "Error: Test file not found: $TEST_FILE"
    echo "Run './test-extension.sh --list' to see available files."
    exit 1
fi

APP=$(ls -d ~/Library/Developer/Xcode/DerivedData/QuickLookMarkDown-*/Build/Products/Debug/QuickLookMarkDown.app 2>/dev/null)

if [ -z "$APP" ]; then
    echo "Error: App not found. Run the build first."
    exit 1
fi

echo "Opening $APP..."
open "$APP"
sleep 2
osascript -e 'quit app "QuickLookMarkDown"'
echo "Testing preview: $(basename "$TEST_FILE")"
qlmanage -p "$TEST_FILE"
