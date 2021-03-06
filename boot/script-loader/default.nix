{ fetchurl
, mruby
, mrbgems
}:

mruby.builder {
  pname = "mobile-nixos-script-loader";
  version = "0.2.0";

  src = ./.;

  # `main.rb` is where the magic happens.
  buildPhase = ''
    makeBin loader main.rb
  '';

  # This script loader handles all "applets" and scripts that will run during
  # stage-1.
  gems = with mrbgems; [
    { core = "mruby-exit"; }
    { core = "mruby-io"; }
    { core = "mruby-sleep"; }
    { core = "mruby-time"; }
    mruby-dir
    mruby-dir-glob
    mruby-env
    mruby-file-stat
    mruby-json
    mruby-logger
    mruby-lvgui
    mruby-open3
    mruby-regexp-pcre
    mruby-singleton
    mruby-time-strftime

    # This needs to be the last gem
    mruby-require
  ];
}
