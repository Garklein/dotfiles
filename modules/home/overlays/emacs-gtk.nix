{ ... }:

{
  # transparent emacs
  nixpkgs.overlays = [
    (final: prev: {
      emacs-gtk = prev.emacs-gtk.overrideAttrs (old: {
        patches = old.patches ++ [
          ../../../patches/exwm-gaps.patch
        ];
      });
    })
  ];
}
