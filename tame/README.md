A port of Isabelle [tame hypermap enumeration code](https://www.isa-afp.org/entries/Flyspeck-Tame.html).

## Example

See [`test_tame.hl`](test_tame.hl) for an example. 

`load_path` should contain paths to `eval_*.hl` (e.g., `needs "eval_compile.hl"` should work).

## Main Files

- [`tame_defs.hl`](tame_defs.hl): main definitions. This is a slightly modified version of
HOL Light definitions written by J. Harrison. These definitions are derived from an OCaml translation by J. Blanchette and F. Wiedijk.

- [`tame_defs_unrolled.hl`](tame_defs_unrolled.hl): expanded versions of some definitions.

- [`tame_support.hl`](tame_support.hl): support functions for compiled tame definitions. 
This file loads the fast natural arithmetic library (from the inequality verification tool).

- [`tame_db.hl`](tame_db.hl): a database for producing compiled definitions.

- [`test_tame.hl`](test_tame.hl): examples and simple performance tests.

