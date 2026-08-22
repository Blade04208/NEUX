{ lib }:
let
  toLua = lib.generators.toLua { };
  inline = lib.generators.mkLuaInline;
in
{
  inherit inline toLua;

  bind = keys: dispatcher: { _args = [ keys dispatcher ]; };

  bindWith =
    flags: keys: dispatcher:
    { _args = [ keys dispatcher flags ]; };

  exec = cmd: inline "hl.dsp.exec_cmd(${toLua (lib.strings.trim cmd)})";

  focusDirection =
    direction:
    inline "hl.dsp.focus({ direction = ${toLua direction} })";

  focusWorkspace =
    workspace:
    inline "hl.dsp.focus({ workspace = ${toLua workspace} })";

  moveToWorkspace =
    workspace:
    inline "hl.dsp.window.move({ workspace = ${toLua workspace} })";
}
