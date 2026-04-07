{
  makeJailedAgent,
  llm-agents,
  system,
  commonJailOptions,
  commonPkgs,
}:
{
  name ? "jailed-claude-code",
  pkg ? llm-agents.packages.${system}.claude-code,
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
    "~/.claude"
    "~/.claude.json"
  ];
}
