{ 
  config,
  pkgs,
  home-manager,
  ... 
}: 

{

  # if use vscode in wayland, uncomment this line
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.vscode = {
    enable = true;
    userSettings = {
      "editor.renderWhitespace" = "all";
      "editor.rulers" = [ 80 120 ];
      "telemetry.enableTelemetry" = false;
      "telemetry.enableCrashReporter" = false;
      "files.exclude" = { "**/node_modules/**" = true; };
      "editor.formatOnSave" = false;
      "breadcrumbs.enabled" = true;
      "editor.useTabStops" = false;
      "editor.lineHeight" = 20;
      "workbench.fontAliasing" = "antialiased";
      "files.trimTrailingWhitespace" = true;
      "editor.minimap.enabled" = false;
      "workbench.editor.enablePreview" = false;
    };
  };

}
