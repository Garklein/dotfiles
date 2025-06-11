# languages
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    python3 perl snobol4 gcc ngn-k ghc cargo ruby
  ];
}
