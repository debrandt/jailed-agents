{
  makeJailedAgent,
  llm-agents,
  system,
  commonJailOptions,
  commonPkgs,
}:
{
  name ? "jailed-opencode",
  pkg ? llm-agents.packages.${system}.opencode,
  extraPkgs ? [ ],
  extraReadwriteDirs ? [ ],
  extraReadonlyDirs ? [ ],
  baseJailOptions ? commonJailOptions,
  basePackages ? commonPkgs,
}:
makeJailedAgent {
  inherit
    name
    pkg
    extraPkgs
    extraReadwriteDirs
    extraReadonlyDirs
    baseJailOptions
    basePackages
    ;
  configPaths = [
    "~/.config/opencode"
    "~/.local/share/opencode"
    "~/.local/state/opencode"
  ];
}
