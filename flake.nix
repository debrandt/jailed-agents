{
  description = "Secure Nix sandbox for LLM agents - Run AI coding agents in isolated environments with controlled access";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    jail-nix.url = "sourcehut:~alexdavid/jail.nix";
    llm-agents.url = "github:numtide/llm-agents.nix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      jail-nix,
      llm-agents,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        jail = jail-nix.lib.init pkgs;
        commonPkgs = with pkgs; [
          bashInteractive
          curl
          wget
          jq
          git
          which
          ripgrep
          gnugrep
          gawkInteractive
          ps
          findutils
          gzip
          unzip
          gnutar
          diffutils
        ];

        commonJailOptions = with jail.combinators; [
          network
          time-zone
          no-new-session
          mount-cwd
        ];

        customCombinators = import ./combinators jail.combinators;

        makeJailedAgent =
          {
            name,
            pkg,
            configPaths,
            extraPkgs ? [ ],
            extraReadwriteDirs ? [ ],
            extraReadonlyDirs ? [ ],
            baseJailOptions ? commonJailOptions,
            basePackages ? commonPkgs,
          }:
          let
            jailedPkg = jail name pkg (
              with jail.combinators;
              (
                baseJailOptions
                ++ (map (p: readwrite (noescape p)) (configPaths ++ extraReadwriteDirs))
                ++ (map (p: readonly (noescape p)) extraReadonlyDirs)
                ++ [ (add-pkg-deps basePackages) ]
                ++ [ (add-pkg-deps extraPkgs) ]
              )
            );
            ensurePaths = pkgs.lib.concatMapStrings (
              path:
              let
                expanded = builtins.replaceStrings [ "~" ] [ "$HOME" ] path;
              in
              ''
                ensure_config_path "${expanded}"
              ''
            ) (configPaths ++ extraReadwriteDirs);
          in
          pkgs.writeShellScriptBin name ''
            ensure_config_path() {
              local _path="$1"
              if [[ "$(basename "$_path")" =~ \.(json|toml|yaml|yml|conf|ini|cfg|txt)$ ]]; then
                mkdir -p "$(dirname "$_path")"
                [[ -e "$_path" ]] || touch "$_path"
              else
                mkdir -p "$_path"
              fi
            }
            ${ensurePaths}
            exec ${jailedPkg}/bin/${name} "$@"
          '';

        makeJailedClaudeCode = import ./claude-code {
          inherit
            makeJailedAgent
            llm-agents
            system
            commonJailOptions
            commonPkgs
            ;
        };

        makeJailedCrush = import ./crush {
          inherit
            makeJailedAgent
            llm-agents
            system
            commonJailOptions
            commonPkgs
            ;
        };

        makeJailedGeminiCli = import ./gemini-cli {
          inherit
            makeJailedAgent
            llm-agents
            system
            commonJailOptions
            commonPkgs
            ;
        };

        makeJailedOpencode = import ./opencode {
          inherit
            makeJailedAgent
            llm-agents
            system
            commonJailOptions
            commonPkgs
            ;
        };

        makeJailedPi = import ./pi {
          inherit
            makeJailedAgent
            llm-agents
            system
            commonJailOptions
            commonPkgs
            ;
        };

      in
      {
        lib = {
          inherit commonJailOptions;
          inherit customCombinators;

          inherit makeJailedAgent;
          inherit makeJailedClaudeCode;
          inherit makeJailedCrush;
          inherit makeJailedGeminiCli;
          inherit makeJailedOpencode;
          inherit makeJailedPi;

          internals = {
            inherit jail;
          };
        };

        packages = {
          jailed-claude-code = makeJailedClaudeCode { };
          jailed-crush = makeJailedCrush { };
          jailed-gemini-cli = makeJailedGeminiCli { };
          jailed-opencode = makeJailedOpencode { };
          jailed-pi = makeJailedPi { };
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.nixd
            pkgs.nixfmt
            pkgs.statix
            (makeJailedOpencode {
              extraPkgs = [
                pkgs.nixd
                pkgs.nixfmt
                pkgs.statix
              ];
            })
          ];
        };
      }
    );
}
