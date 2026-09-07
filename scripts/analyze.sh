#!/usr/bin/env bash

# Task 07: complete this script.
# Usage: ./scripts/analyze.sh FILE

# TODO: validate arguments
# TODO: validate file existence
# TODO: print:
# Total ERROR: <number>
# Top Code: <code>

if [[ $# -ne 1 ]]; then
  echo "Usage: ./scripts/analyze.sh FILE"
  exit 1
fi

f="$1"

if [[ ! -f "$f" ]]; then
  echo "Error: file $f does not exist"
  exit 1
fi

err_num=$(grep -c "ERROR" "$f")
top_code=$(grep "ERROR" "$f" | awk '{print $NF}' | sed 's/code=//' | sort | uniq -c | sort -nr | head -n1 | awk '{print $2}')

echo "Total ERROR: $err_num"
echo "Top Code: $top_code"
exit 0
