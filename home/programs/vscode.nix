{
  config,
  pkgs,
  home-manager,
  nix-vscode-extensions,
  ...
}:

{

  # if use vscode in wayland, uncomment this line
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.vscode = {
    enable = true;
    userSettings = {
      "editor.renderWhitespace" = "all";
      "editor.rulers" = [ 120 ];
      "telemetry.enableTelemetry" = false;
      "telemetry.enableCrashReporter" = false;
      "files.exclude" = { "**/node_modules/**" = true; };
      "editor.formatOnSave" = true;
      "breadcrumbs.enabled" = true;
      "editor.lineHeight" = 20;
      "workbench.fontAliasing" = "antialiased";
      "files.trimTrailingWhitespace" = true;
      "editor.minimap.enabled" = false;
      "workbench.editor.enablePreview" = false;
    };
    package =
      let
        config.packageOverrides = pkgs: {
          vscode = pkgs.vscode.override {
            vscodeExtensions = with nix-vscode-extensions.extensions; [
              espressif.esp-idf-extension
              GitHub.copilot
              jnoortheen.nix-ide
              ms-azuretools.vscode-docker
              ms-python.isort
              ms-python.python
              ms-python.vscode-pylance
              ms-toolsai.jupyter
              ms-toolsai.jupyter-keymap
              ms-toolsai.jupyter-renderers
              ms-toolsai.vscode-jupyter-cell-tags
              ms-toolsai.vscode-jupyter-slideshow
              ms-vscode-remote.remote-containers
              ms-vscode-remote.remote-ssh
              ms-vscode-remote.remote-ssh-edit
              ms-vscode-remote.vscode-remote-extensionpack
              ms-vscode.cmake-tools
              ms-vscode.cpptools
              ms-vscode.cpptools-extension-pack
              ms-vscode.cpptools-themes
              ms-vscode.remote-explorer
              ms-vscode.remote-server
              pinage404.nix-extension-pack
              platformio.platformio-ide
            ];
          };
        };
      in
        pkgs.vscode;
  };

}
