# Computations in HOL Light

A collection of tools for performing computations in HOL Light with equational theorems.

## Compilation of equational theorems to OCaml code

`eval_compile.hl` is a compiler which takes HOL Light equational theorems and produces OCaml functions which evaluate corresponding theorems for the given arguments. All evaluations are done with HOL Light primitive inference rules and all results are HOL Light theorems.

See [examples/compile.hl](examples/compile.hl) for additional information and examples.
[examples/example_out.hl](examples/example_out.hl) is an example of compiled definitions.

## Tame hypermaps

A port of Isabelle tame hypermap generation code can be found in [tame](tame/). See [tame/test_tame.hl](tame/test_tame.hl) for a working example.

## Tests

See [tests](tests/)

`make test` loads [tests/all.hl](tests/all.hl),
[tame/test_tame_unit.hl](tame/test_tame_unit.hl) and the [examples](examples/)
into HOL Light and checks what they report. It does not build HOL Light: point
`HOLLIGHT_DIR` at one that is already built, or leave it at its default of a
sibling checkout.

```
make HOLLIGHT_DIR=/path/to/hol-light test
```

`make test-tests`, `make test-tame` and `make test-examples` run the checks of
one directory only, and `make -j3 test` runs the three in parallel. Every push
and pull request runs `make test` against a pinned HOL Light revision, on Linux
and on MacOS.
