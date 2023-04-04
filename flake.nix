{
  description = "Simple unit testing for Nix";

  inputs = {};

  outputs = { ... } @ inputs:
    let
      lib = import ./src;
    in {
      run = lib.run;
    };
}
