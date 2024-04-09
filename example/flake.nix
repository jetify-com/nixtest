{
  description = "A sample flake that uses nixtest";
  inputs = {
    # Import the nixtest flake as an input.
    # In normal usage you would reference the published repo:
    # 
    #  nixtest.url = "github:jetify-com/nixtest";
    # 
    # Inside the nixtest repo, we instead use the local path:
    nixtest.url = "../.";
  };
  outputs = { self, nixtest }: {
    tests = nixtest.run ./.;
  };
}
