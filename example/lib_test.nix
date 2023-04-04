let
  lib = import ./lib.nix;
in [
  {
    name = "lib.intersect: intersect zero sets";
    actual = lib.intersect [];
    expected = { };
  }
  {
    name = "lib.intersect: intersect one set";
    actual = lib.intersect [{ a = 1; }];
    expected = { a = 1; };
  }
  {
    name = "lib.intersect: intersect with an empty set";
    actual = lib.intersect [{ a = 1; } { }];
    expected = { };
  }
  {
    name = "lib.intersect: intersect two sets with no overlap";
    actual = lib.intersect [{ a = 1; } { b = 2; }];
    expected = { };
  }
  {
    name = "lib.intersect: intersect two sets with no conflicts";
    actual = lib.intersect [{ a = 1; } { a = 1; }];
    expected = { a = 1; };
  }
  {
    name = "lib.intersect: intersect two sets with conflicts";
    actual = lib.intersect [{ a = 1; b = 2; } { a = 1; b = 3; }];
    expected = { a = 1; b = 3; };
  }
  {
    name = "lib.intersect: intersect multiple sets";
    actual = lib.intersect [{ a = 0; } { b = 2; } { c = 3; } { a = 1; }];
    expected = { };
  }
]
