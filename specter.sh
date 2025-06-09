#!/bin/sh

echo "☠️  Specter has been summoned..."
touch /var/mobile/.specter_trigger
echo "⏳ Respringing..."
/var/jb/usr/bin/sbreload

# Close Terminal (kill its parent shell process)
# Optional: works best if user is in NewTerm
kill -9 $(ps -e | grep -i newterm | awk '{print $1}')
