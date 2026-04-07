{
  makeJailedAgent,
  llm-agents,
  system,
  commonJailOptions,
  commonPkgs,
}:
{
  name ? "jailed-gemini-cli",
  pkg ? llm-agents.packages.${system}.gemini-cli,
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
    "~/.gemini"
  ];
}
