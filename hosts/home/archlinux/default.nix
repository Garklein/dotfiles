{
  imports =
    with builtins;
    map (fn: ./${fn}) (filter (fn: (fn != "default.nix") && (fn != "gpg-public.asc")) (attrNames (readDir ./.)));
  # home.sessionVariables = {
  #   LD_LIBRARY_PATH = "/usr/lib";
  # };
}
