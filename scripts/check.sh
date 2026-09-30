#!/bin/sh
#
# Loads one HOL Light file and asserts on what it reports.
#
#   scripts/check.sh <path to hol.sh> <HOL Light file to load>
#
# Must be run from the root of this repository. This is what "make test" runs
# for each check; see scripts/check.hl for why the checks below look at the log
# rather than at an exit code.

set -eu

if [ $# -ne 2 ]; then
  echo "usage: $0 <path to hol.sh> <HOL Light file to load>" >&2
  exit 2
fi

hol_sh=$1
file=$2
log=ci-$(echo "$file" | tr / -).log

if [ ! -x "$hol_sh" ]; then
  echo "$0: no HOL Light at $hol_sh." >&2
  echo "$0: build one and point HOLLIGHT_DIR at it: make HOLLIGHT_DIR=... test" >&2
  exit 2
fi

echo "=== $file (HOL Light: $hol_sh, log: $log) ==="

COMPUTE_HOL_LIGHT_CI_FILE=$file
export COMPUTE_HOL_LIGHT_CI_FILE

# HOL Light reads its input from stdin, and echoes it, so the sentinel must not
# be mentioned here -- only check.hl is allowed to print it.
echo 'loadt "scripts/check.hl";;' | "$hol_sh" 2>&1 | tee "$log"

# The log has ANSI escapes from HOL Light's term printer in it, which makes grep
# treat it as binary; -a keeps the matching lines readable in the output.

# No sentinel means the toplevel itself never got to the end: it died, or was
# killed, or could not even start.
if ! grep -aq 'COMPUTE_HOL_LIGHT_CI_OK' "$log"; then
  echo "FAILED: the HOL Light toplevel did not finish; see $log" >&2
  exit 1
fi

# A phrase that raises, or that does not compile, stops the load of the file it
# is in, but HOL Light only reports that and carries on with the next phrase of
# the file that loaded it. This line is the report. A match preceded by a double
# quote is not one: that is HOL Light's Failure message for a load which was
# expected to fail, printed as part of a value, as examples/compile.hl does.
if grep -aE '(^|[^"])Error in included file' "$log"; then
  echo "FAILED: $file did not load cleanly (see above)" >&2
  exit 1
fi

# Every test file ends with formatted_results(), which prints a line like
# 'PASSED: 76/76, FAILED: 0'. The assertions in tests/common.hl only raise when
# the code under test raises: a plain wrong answer is counted and reported, so
# loading cleanly is not by itself enough.
if grep -aE 'FAILED: [1-9]' "$log"; then
  echo "FAILED: $file reported failing assertions (see above)" >&2
  exit 1
fi

grep -aE 'PASSED: [0-9]+/[0-9]+' "$log" || true
echo "=== $file: ok ==="
