{
  # Function `intersect` takes a list of sets and intersects all of them.
  #
  # If two sets have the same keys, then the value from the last set overrides
  # the previous sets.
  #
  # Example:
  #  intersect [ { a = 1; b = 2; } { a = 1; b = 3; } ]
  #  => { a = 1; b = 3;}
  intersect = list:
    let
      foldResult = builtins.foldl' (a: b:
        # null is used as a sentinel value for the 'everything' set. That is, a set
        # that contains all keys.
        if a == null then
          b
        else if b == null then
          a
        else
          builtins.intersectAttrs a b
        ) null list;
    in
      if foldResult == null then
        {}
      else
        foldResult;
}