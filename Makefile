# Runs the checks of this repository: each test file and each example is loaded
# into its own HOL Light, and what it reports is asserted on. See
# scripts/check.sh and scripts/check.hl.
#
# The three targets below can run in parallel because the OCaml code their checks
# compile and load back goes to a fixed path under the directory each one is
# named after -- tests/out.hl, tame/out.hl, examples/out_first.hl and so on -- so
# no two of them write the same file. A new check has to keep that true.
#
# HOL Light is not built from here. Point HOLLIGHT_DIR at one that is already
# built; the default is a sibling checkout.
#
#   make HOLLIGHT_DIR=/path/to/hol-light test

HOLLIGHT_DIR ?= ../hol-light

# One HOL Light per check: the files are not written to share a session, and the
# rewrite rules examples/compute.hl leaves behind make examples/compile.hl fail.
CHECK := scripts/check.sh $(HOLLIGHT_DIR)/hol.sh

test: test-tests test-tame test-examples

# tests/all.hl is the entry point of the test suite.
test-tests:
	$(CHECK) tests/all.hl

# The unit tests for the tame hypermap definitions only. tame/tests.hl also runs
# tame/test_tame.hl and tame/test_tame_performance.hl, which take hours.
test-tame:
	$(CHECK) tame/test_tame_unit.hl

# The examples are the documentation of the two tools, so loading them keeps them
# from going stale. The examples in compile.hl which are meant to fail are
# wrapped there so that they are checked rather than stopping the load; see
# expect_failure in examples/compile.hl.
test-examples:
	$(CHECK) examples/compute.hl
	$(CHECK) examples/compile.hl

# The logs of the checks, and the OCaml code the checks compile and load back.
clean:
	rm -f ci-*.log tests/out*.hl tame/out*.hl examples/out*.hl

.PHONY: test test-tests test-tame test-examples clean
