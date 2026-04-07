{
  makeJailedAgent,
  llm-agents,
  system,
  commonJailOptions,
  commonPkgs,
}:
{
  name ? "jailed-crush",
  pkg ? llm-agents.packages.${system}.crush,
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
    "~/.config/crush"
    "~/.local/share/crush"
  ];
}
