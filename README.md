# NixTest
### A tiny unit testing framework written in pure Nix
![License: Apache 2.0](https://img.shields.io/github/license/jetpack-io/nixtest)

## What is it?

NixTest is a simple unit testing framework for Nix, written in pure Nix.
It makes it easy to add tests throughout your nix code and run them all at once.

The framework was designed to be minimal: it is entirely self-contianed and
depends only on nix builtin functions. Specifically, it does *not* depend on `nixpkgs`,
which can get somewhat large as a dependency.

## Usage
### 1. Import the library
To use the nixtest library, import it as an input in the flake where you are
writing tests, and call `nixtest.run <dir>` on the root directory:

```nix
{
  inputs.nixtest.url = "github:jetpack-io/nixtest";
  outputs = { self, nixtest }: {
    # Will recursively look for _test.nix files in the current directory
    # and run them:
    tests = nixtest.run ./.;
  };
}
```

### 2. Write your tests
To write tests, create files ending in `_test.nix`. If you are trying to test
a file named `foo.nix`, you should name your test file `foo_test.nix`.

The test file should evaluate to a list of test results, where each result has
the following schema:
```
{
  name: string  # The name of the test
  actual: any   # The result from evaluating the expression you're trying to test
  expected: any # The expected result
}
```

The test framework will automatically check that `actual == expected`, and if it
isn't, it will throw an error indicating a failure.

This is what an example `lib_test.nix` file might look like:
```nix
let
  lib = import ./lib.nix;
in [
  {
    name = "Test function concatenate";
    actual = lib.concatenate "a" "b";
    expected = "ab";
  }
  {
    name = "Test function add";
    actual = lib.add 1 2;
    expected = 3;
  }
]
```

### 3. Run your tests
Use `nix eval` to run your tests.

For example, if your flake has a `tests` attribute as in the example above,
you can run your tests with:

```bash
nix eval .#tests
```

If all tests pass, you will see an output like this:
```
[PASS] 7/7 tests passed
```

If any tests fail, you will see an output like this:
```
error: 1/7 tests failed
       [FAIL] Test function add
         Got: 2
         Expected: 3
```

## Related Work
+ [runTests](https://nixos.org/manual/nixpkgs/stable/#function-library-lib.debug.runTests): A testing function included in `nixpkgs.lib.debug`. Probably the
  most commonly used testing library for Nix. We recommend using it for cases
  where you are ok depending on `nixpkgs`.
+ [Nixt](https://github.com/nix-community/nixt): Unit testing framework for Nix, written
  in Typescript. Depends on both `nixpkgs` and `typescript`.
