#!/bin/bash
# Test the QuickLook extension after building

APP=$(ls -d ~/Library/Developer/Xcode/DerivedData/QuickLookMarkDown-*/Build/Products/Debug/QuickLookMarkDown.app 2>/dev/null)

if [ -z "$APP" ]; then
    echo "Error: App not found. Run the build first."
    exit 1
fi

echo "Opening $APP..."
open "$APP"
sleep 2
osascript -e 'quit app "QuickLookMarkDown"'
echo "Testing preview..."
qlmanage -p test-files/table-test.md
