# AURES NEUX

Aures NEUX is a set of Hyprland dotfiles designed to be visually appealing to everyone, not just developers.

# VERY VERY VERY ALPHA!! NOT ALL IS HERE!! DO NOT INSTALL!!

## Options

| Name | Description | Syntax | Default |
|------|-------------|--------|---------|
| 🏠 `wm` | What window manager to use as NEUX's base. | `hyprland`, `sway` | `hyprland` |
| 🏠 `favorites` | List of apps to pin to the base bar. | Standard **case-sensitive** reverse-DNS name, as defined by the [FreeDesktop Standard](https://specifications.freedesktop.org/desktop-entry/latest/file-naming.html). | `[ "org.mozilla.Firefox" "org.gnome.Nautilus" ]` |
| 🌐 `binaryCaches.enable` | Enable the binary caches when building. See [Binary Caches](#binary-caches) below. | Boolean | `false` |

🏠 - Home-Manager option, 🌐 - NixOS option

**Example home config**
```nix
# home.nix
neux {
  wm = "hyprland";
  favorites = [
    "org.mozilla.Firefox"
    "org.gnome.Nautilus"
  ];
}
```

## Additional Hyprland config
NEUX sets up a default Hyprland config that you can customize to your liking from your home-manager configuration. We also provide extra tooling and functions to make working with Hyprlua on Nix easier, just import `hyprlua` in your home-manager configuration alongside the NEUX home-manager module.

```nix
{ hyprlua, lib, ... }:
{
  neux.wm = "hyprland";
  wayland.windowManager.hyprland.settings = {
    bind = [
      (hyprlua.bind "SUPER + Z" (hyprlua.exec "zeditor"))
      (hyprlua.bindWith { locked = true; } "XF86Calc" (hyprlua.inline ''hl.dsp.exec_cmd("gnome-calculator")'')) # calculator keyboard key (funny)
    ];
    window_rule = [
      { match.class = "steam"; float = true; }
    ];
  };
```
See [home/wm/hyprland/lib.nix](home/wm/hyprland/lib.nix) for all functions available.

## Binary Caches

NEUX pulls packages from several third-party flakes that normally build from source (Hyprland, Vicinae, Ironbar), which can be very costly on hardware during rebuilds. On NixOS hosts you can opt in to using their upstream binary caches by using this one convienient **non-home-manager option**:

```nix
neux.binaryCaches.enable = true;
```

If you use only NEUX's home-manager module, add the same entries to your system config manually (see [caches.nix](caches.nix)). Building this flake directly will also offer the same caches automatically.

## Credits

**Qirkly** - designed the entire shell, gave me the inspo to make it real, backs 50% of all decisions in this project, cannot thank him enough

**@end-4** - created animations and certain keybinds