rec {
  # Function `run` takes a directory as an argument, finds all test files
  # matching the pattern `**/*.test.nix`, and runs all of those tests.
  #
  # Once the tests have run, it prints a summary of the results. If any of
  # the tests failed, it prints the summary by throwing an exception and
  # exiting with a non-zero exit code.
  #
  # This is the main entry point for the test runner. It's usually called by
  # creating a top level `tests.nix` with the following content:
  # ```
  # let
  #   testing = import ./testing;
  # in
  #   testing.run ./.
  # ```
  #
  # Note that every _test.nix file should evaluate to a list of tests. Each test
  # in the list should have the schema defined in `runTest`.
  run = dir:
    let
      results = runDir dir;
    in (
      assertTests results
    );

  # Function `runDir` takes a directory as an argument, finds all test files
  # matching the pattern `**/*.test.nix`, and runs all of those tests.
  #
  # It returns a list of results, one for each test.
  runDir = dir: (
    let
      fileTypes = builtins.readDir dir;
      filenames = builtins.attrNames fileTypes;
      results = builtins.foldl' (acc: filename:
        let
          path = dir + "/${filename}";
          fileType = builtins.getAttr filename fileTypes;
          isTestFile = (fileType == "regular") && (builtins.match ".*_test\.nix" filename) != null;
        in (
          if fileType == "directory" then
            acc ++ (runDir path)
          else if isTestFile then
            acc ++ (runTests (import path))
          else
            acc ++ []
        )
      ) [] filenames;
    in
     results
  );

  # Function runTests runs all of the given tests, by calling `runTest` on each
  # of them.
  #
  # It takes a list of tests as an argument.
  runTests = tests: (
    let
      results = builtins.map (test: runTest test) tests;
    in
      results
  );

  # Function `runTest` runs the gives test. A test is defined as a structure
  # with the following schema:
  # {
  #  name: string             # Name of the test
  #  actual:   any            # The return value from the functionality you want to test
  #  expected: any            # Expected return value of `fn(input)`
  # }
  runTest = test: (
    if test.actual == test.expected then {
      name = test.name;
      actual = test.actual;
      expected = test.expected;
      passed = true;
    } else {
      # We never get here since assertEqual will throw an error.
      name = test.name;
      actual = test.actual;
      expected = test.expected;
      passed = false;
    }
  );


  # Function `assertTests` takes in a list of test results (as returned by the
  # `run` functions) and throws an error if any of the tests failed.
  assertTests = results:
    let
      numTests = builtins.length results;
      failures = builtins.filter (test: test.passed == false) results;
      numFailures = builtins.length failures;
    in (
      if (builtins.length failures) == 0 then
        "[PASS] ${toString numTests}/${toString numTests} tests passed\n"
      else
        throw ("${toString numFailures}/${toString numTests} tests failed\n\n" +
        failureMsg failures)
    );

  failureMsg = results: (
    builtins.foldl' (acc: result:
      acc + ''
        [FAIL] ${result.name}
          Got: ${builtins.toJSON result.actual}
          Expected: ${builtins.toJSON result.expected}

      ''
    ) "" results
  );
}