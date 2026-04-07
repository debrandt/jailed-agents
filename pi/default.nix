{
  makeJailedAgent,
  llm-agents,
  system,
  commonJailOptions,
  commonPkgs,
}:
{
  name ? "jailed-pi",
  pkg ? llm-agents.packages.${system}.pi,
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
    "~/.pi"
  ];
}
