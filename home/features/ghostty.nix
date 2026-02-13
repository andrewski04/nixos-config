{ ... }:

{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      cursor-style = "block";
      shell-integration-features = true;
    };
  };
}
