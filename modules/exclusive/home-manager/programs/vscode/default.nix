#
# VSCode - Visual Studio Code
#
# Explore available extensions:
#
# $ nix repl
# nix-repl> :lf github:nix-community/nix-vscode-extensions/c43d9089df96cf8aca157762ed0e2ddca9fcd71e
# nix-repl> t = extensions.<TAB>
# nix-repl> t = extensions.x86_64-linux
# nix-repl> t.<TAB>
#
# For more information: https://github.com/nix-community/nix-vscode-extensions#explore
{
  config,
  lib,
  pkgs,
  inputs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  extensions = inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.system};

  colors = {
    base00 = {
      name = "base00";
      value = "000000";
    };
    base01 = {
      name = "base01";
      value = "1a1a1a";
    };
    base02 = {
      name = "base02";
      value = "333333";
    };
    base03 = {
      name = "base03";
      value = "808080";
    };
    base04 = {
      name = "base04";
      value = "cccccc";
    };
    base05 = {
      name = "base05";
      value = "ffffff";
    };
    base06 = {
      name = "base06";
      value = "e6e6e6";
    };
    base07 = {
      name = "base07";
      value = "e6e6e6";
    };
    base08 = {
      name = "base08";
      value = "bf4040";
    };
    base09 = {
      name = "base09";
      value = "bf8040";
    };
    base0A = {
      name = "base0A";
      value = "bfbf40";
    };
    base0B = {
      name = "base0B";
      value = "80bf40";
    };
    base0C = {
      name = "base0C";
      value = "40bfbf";
    };
    base0D = {
      name = "base0D";
      value = "407fbf";
    };
    base0E = {
      name = "base0E";
      value = "7f40bf";
    };
    base0F = {
      name = "base0F";
      value = "bf40bf";
    };
  };

  # vscode-marketplace, open-vsx-release provides all the latest extensions including
  # those in the vscode-marketplace-release and open-vsx-release channels
  # If you want stable/released extensions, use vscode-marketplace-release and open-vsx-release
  vscodeMarketplaceExtensions = with extensions.vscode-marketplace; [
    golang.go # Go language support
    vlanguage.vscode-vlang # support for Vlang
    vue.vscode-typescript-vue-plugin # Vue
    vue.volar # language server for Vue
    ms-vscode.vscode-typescript-next # TypeScript
    ms-toolsai.jupyter # Jupyter - Jupyter notebook support
    decaycs.decay # Decay color scheme
    adolfdaniel.vscode-chromium-vector-icons # Chromium Vector Icons
    arrterian.nix-env-selector # Nix environment selector
    bbenoist.nix # Nix language support
    catppuccin.catppuccin-vsc # Catppuccin Macchiato color scheme
    christian-kohler.path-intellisense # Path Intellisense - autocompletion for file paths
    dbaeumer.vscode-eslint # ESLint - JavaScript linting
    eamodio.gitlens # GitLens - For enhanced Git integration
    esbenp.prettier-vscode # Prettier - Code formatter
    formulahendry.code-runner # Code Runner - run code snippet or code file for multiple languages
    ibm.output-colorizer # Output Colorizer - colorize the output in the debug console
    kamadorueda.alejandra # Alejandra formatter for nix
    ms-azuretools.vscode-docker # Docker - Docker support
    ms-python.python # Python - Python language support
    ms-python.vscode-pylance # Pylance - Python language server
    ms-vscode-remote.remote-ssh # Remote - SSH - SSH support
    ms-vscode.cpptools # C/C++ - C/C++ language support
    naumovs.color-highlight # Color Highlight - highlight web colors in your editor
    ms-python.black-formatter # Black - Python code formatter
    svelte.svelte-vscode # Svelte - Svelte language support
    ms-vsliveshare.vsliveshare # Live Share - Real-time collaborative development
    oderwat.indent-rainbow # Indent Rainbow - colorize indentation in front of your text
    pkief.material-icon-theme # Material Icon Theme - Material Design icons
    shardulm94.trailing-spaces # Trailing Spaces - highlight trailing spaces and delete them in a flash
    sumneko.lua # Lua - Lua language support
    timonwong.shellcheck # ShellCheck - Shell script linting
    usernamehw.errorlens # Error Lens - display diagnostics inline
    xaver.clang-format # Clang-Format - C/C++ code formatter
    yzhang.markdown-all-in-one # Markdown All in One - Markdown language support
    james-yu.latex-workshop # LaTeX Workshop - LaTeX language support
    redhat.vscode-yaml # YAML - YAML language support
    irongeek.vscode-env # .env - .env file support
    github.vscode-pull-request-github # GitHub Pull Requests - GitHub pull request support
    github.codespaces # GitHub Codespaces - GitHub Codespaces support
    astro-build.astro-vscode # Astro - Astro language support
    wakatime.vscode-wakatime # WakaTime - WakaTime support
    gpoore.codebraid-preview # Preview Pandoc Markdown in VS Code, and execute code blocks and inline code with Codebraid
  ];

  openVsxExtensions = with extensions.open-vsx; [
    rust-lang.rust-analyzer # Rust - Rust language support
  ];

  vscodeMarketplaceExtensionsRelease = with extensions.vscode-marketplace-release; [
    # Add released extensions here
  ];

  openVsxExtensionsRelease = with extensions.open-vsx-release; [
    # Add released extensions here
  ];
  # custom-extensions = import ./extensions.nix {
  #   inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;
  # };
in {
  config = mkIf config.programs.vscode.enable {
    programs.vscode = {
      mutableExtensionsDir = true;
      enableExtensionUpdateCheck = true;
      enableUpdateCheck = true;
      extensions =
        # with inputs.nix-vscode-marketplace.packages.${pkgs.system}.vscode;
        with extensions.open-vsx;
        # with inputs.nix-vscode-marketplace.packages.${pkgs.system}.open-vsx;
        with extensions.vscode-marketplace;
        with pkgs.vscode-extensions; [
          golang.go # Go language support
          kahole.magit # Magit - Git support

          (pkgs.callPackage ./theme.nix {} osConfig.modules.themes.colors)

          dhall.dhall-lang
          hashicorp.terraform
          bungcip.better-toml
          llvm-vs-code-extensions.vscode-clangd
          stkb.rewrap
          meraymond.idris-vscode
          ocamllabs.ocaml-platform
          bierner.markdown-mermaid
          # 2gua.rainbow-brackets
          vlanguage.vscode-vlang # support for Vlang
          # vue.vscode-typescript-vue-plugin # Vue
          # vue.volar # language server for Vue
          # ms-vscode.vscode-typescript-next # TypeScript
          ms-toolsai.jupyter # Jupyter - Jupyter notebook support
          decaycs.decay # Decay color scheme
          adolfdaniel.vscode-chromium-vector-icons # Chromium Vector Icons
          arrterian.nix-env-selector # Nix environment selector
          bbenoist.nix # Nix language support
          catppuccin.catppuccin-vsc # Catppuccin Macchiato color scheme
          christian-kohler.path-intellisense # Path Intellisense - autocompletion for file paths
          dbaeumer.vscode-eslint # ESLint - JavaScript linting
          eamodio.gitlens # GitLens - For enhanced Git integration
          esbenp.prettier-vscode # Prettier - Code formatter
          formulahendry.code-runner # Code Runner - run code snippet or code file for multiple languages
          ibm.output-colorizer # Output Colorizer - colorize the output in the debug console
          kamadorueda.alejandra # Alejandra formatter for nix
          ms-azuretools.vscode-docker # Docker - Docker support
          ms-python.python # Python - Python language support
          ms-python.vscode-pylance # Pylance - Python language server
          ms-vscode-remote.remote-ssh # Remote - SSH - SSH support
          ms-vscode.cpptools # C/C++ - C/C++ language support
          naumovs.color-highlight # Color Highlight - highlight web colors in your editor
          ms-python.black-formatter # Black - Python code formatter
          svelte.svelte-vscode # Svelte - Svelte language support
          ms-vsliveshare.vsliveshare # Live Share - Real-time collaborative development
          oderwat.indent-rainbow # Indent Rainbow - colorize indentation in front of your text
          pkief.material-icon-theme # Material Icon Theme - Material Design icons
          shardulm94.trailing-spaces # Trailing Spaces - highlight trailing spaces and delete them in a flash
          sumneko.lua # Lua - Lua language support
          timonwong.shellcheck # ShellCheck - Shell script linting
          usernamehw.errorlens # Error Lens - display diagnostics inline
          xaver.clang-format # Clang-Format - C/C++ code formatter
          # yzhang.markdown-all-in-one # Markdown All in One - Markdown language support
          james-yu.latex-workshop # LaTeX Workshop - LaTeX language support
          redhat.vscode-yaml # YAML - YAML language support
          irongeek.vscode-env # .env - .env file support
          github.vscode-pull-request-github # GitHub Pull Requests - GitHub pull request support
          github.codespaces # GitHub Codespaces - GitHub Codespaces support
          astro-build.astro-vscode # Astro - Astro language support
          wakatime.vscode-wakatime # WakaTime - WakaTime support
          gpoore.codebraid-preview # Preview Pandoc Markdown in VS Code, and execute code blocks and inline code with Codebraid
        ];
      # extensions =
      #   vscodeMarketplaceExtensions
      #   ++ openVsxExtensions
      #   ++ vscodeMarketplaceExtensionsRelease
      #   ++ openVsxExtensionsRelease
      #   ++ [
      #     pkgs.vscode-extensions."aaron-bond".better-comments # Better Comments
      #     pkgs.vscode-extensions."2gua".rainbow-brackets # Rainbow Brackets
      #   ]
      #   ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      #     {
      #       name = "copilot-nightly";
      #       publisher = "github";
      #       version = "1.67.7949";
      #       sha256 = "sha256-ZtUqQeWjXmTz49DUeYkuqSTdVHRC8OfgWv8fuhlHDVc=";
      #     }
      #   ];
      userSettings = {
        "update.mode" = "none";
        "[nix]"."editor.tabSize" = 2;
        "workbench.colorTheme" = "Balsoft's generated theme";
        "terminal.integrated.profiles.linux".bash.path = "/run/current-system/sw/bin/bash";
        "terminal.integrated.defaultProfile.linux" = "bash";
        "editor.fontFamily" = "IBM Plex Mono";
        "nix.formatterPath" = "nixfmt";
        "git.autofetch" = true;
        "redhat.telemetry.enabled" = false;
        "security.workspace.trust.untrustedFiles" = "open";
        "window.menuBarVisibility" = "toggle";
        "vim.useSystemClipboard" = true;
        "haskell.manageHLS" = "PATH";
        "extensions.autoCheckUpdates" = false;
        "extensions.autoUpdate" = false;
        # "workbench.iconTheme" = "material-icon-theme";
        # "workbench.colorTheme" = "Catppuccin Macchiato";
        # "explorer.compactFolders" = false; # disable compact mode
        # "update.showReleaseNotes" = false; # disable update release notes
        # "catppuccin.accentColor" = "mauve";
        # "editor.fontFamily" = "JetBrainsMono Nerd Font, Material Design Icons, 'monospace', monospace";
        # "editor.inlayHints.enabled" = "off";
        # "git.openRepositoryInParentFolders" = "always";
        # "editor.lineNumbers" = "relative";
        # "breadcrumbs.filePath" = "off";
        # "workbench.layoutControl.enabled" = false;
        # "editor.lightbulb.enabled" = "off";
        # "notebook.breadcrumbs.showCodeCells" = false;
        # "workbench.editor.enablePreview" = false;
        # "editor.scrollbar.verticalScrollbarSize" = 6;
        # "editor.fontSize" = 16;
        # "editor.fontLigatures" = true;
        # "workbench.fontAliasing" = "antialiased";
        # "files.trimTrailingWhitespace" = true;
        # "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font Mono";
        # "window.titleBarStyle" = "custom";
        # "terminal.integrated.automationShell.linux" = "nix-shell";
        # "terminal.integrated.defaultProfile.linux" = "zsh";
        # "terminal.integrated.cursorBlinking" = true;
        # "terminal.integrated.enableVisualBell" = false;
        # "editor.formatOnPaste" = true;
        # "editor.formatOnSave" = true;
        # "editor.formatOnType" = false;
        # "editor.minimap.enabled" = false;
        # "editor.minimap.renderCharacters" = false;
        # "editor.overviewRulerBorder" = false;
        # "editor.renderLineHighlight" = "all";
        # "editor.inlineSuggest.enabled" = true;
        # "editor.smoothScrolling" = true;
        # "editor.suggestSelection" = "first";
        # "editor.guides.indentation" = true;
        # "editor.guides.bracketPairs" = true;
        # "editor.bracketPairColorization.enabled" = true;
        # "window.nativeTabs" = true;
        # "window.restoreWindows" = "all";
        # "window.menuBarVisibility" = "toggle";
        # "workbench.panel.defaultLocation" = "right";
        # "workbench.editor.tabCloseButton" = "left";
        # "workbench.startupEditor" = "none";
        # "workbench.list.smoothScrolling" = true;
        # "security.workspace.trust.enabled" = false;

        # "terminal.integrated.tabs.enabled" = true;
        # "editor.scrollbar.horizontalScrollbarSize" = 0;
        # "git.enableSmartCommit" = true;
        # "git.confirmSync" = false;
        # "explorer.confirmDelete" = false;
        # "redhat.telemetry.enabled" = false;
        # "extensions.experimental.affinity" = {
        #   "asvetliakov.vscode-neovim" = 1;
        # };
        # "flake8.severity" = {
        #   "E" = "Information";
        #   "F" = "Hint";
        #   "W" = "Error";
        # };
        # "window.titleSeparator" = " | ";
        # "terminal.integrated.enableMultiLinePasteWarning" = false;
        # "explorer.openEditors.visible" = 1;
        # # "editor.cursorBlinking" = "phase";
        # "terminal.integrated.tabs.separator" = " | ";
        # "git.autofetch" = true;
        # "explorer.confirmDragAndDrop" = false;
        # "explorer.autoReveal" = false;
        # "errorLens.gutterIconsEnabled" = true;
        # "errorLens.gutterIconSize" = "115%";
        # "errorLens.messageBackgroundMode" = "message";
        # "errorLens.enabledDiagnosticLevels" = [
        #   "error"
        #   "warning"
        #   "info"
        #   "hint"
        # ];
        # "window.title" = "!Neovim";

        # "python.linting.flake8Args" = [
        #   "--extend-ignore=E501"
        # ];

        # "[python]" = {
        #   # use black vs code extension to format python code
        #   "editor.defaultFormatter" = "ms-python.black-formatter";
        #   "editor.formatOnSave" = true;
        # };

        # "[nix]" = {
        #   "editor.defaultFormatter" = "kamadorueda.alejandra";
        #   "editor.formatOnPaste" = true;
        #   "editor.formatOnSave" = true;
        #   "editor.formatOnType" = false;
        # };
        # "alejandra.program" = "alejandra";

        # "python.linting.flake8CategorySeverity.F" = "Warning";
        # "vscode-neovim.highlightGroups.highlights" = {
        #   "IncSearch" = {
        #     "backgroundColor" = "theme.editor.findMatchBackground";
        #     "borderColor" = "theme.editor.findMatchBorder";
        #   };
        #   "Search" = {
        #     "backgroundColor" = "theme.editor.findMatchHighlightBackground";
        #     "borderColor" = "theme.editor.findMatchHighlightBorder";
        #   };
        #   "Visual" = {
        #     "backgroundColor" = "theme.editor.selectionBackground";
        #   };
        # };
        # "breadcrumbs.enabled" = true;
        # "github.copilot.enable" = {
        #   "markdown" = true;
        #   "plaintext" = true;
        # };
      };
      keybindings = [
        {
          key = "ctrl+c";
          command = "editor.action.clipboardCopyAction";
          when = "textInputFocus";
        }
        # Run any selected code in jupyter
        {
          key = "shift+enter";
          command = "jupyter.execSelectionInteractive";
          when = "editorTextFocus && isWorkspaceTrusted && jupyter.ownsSelection && !findInputFocussed && !notebookEditorFocused && !replaceInputFocussed && editorLangId == 'python'";
        }
      ];
    };
  };
}