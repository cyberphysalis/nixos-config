self: super: {
  # 将我们的包添加到 nixpkgs 集合中
  claude-code-router = super.buildNpmPackage rec {
    pname = "claude-code-router";
    version = "1.0.32";

    src = super.fetchurl {
      url = "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-${version}.tgz";
      sha256 = "sha256-H1OB7nT58yMMqYVOWbSK/j8tj0dbGAA2hIgOLi/+jNw=";
    };

    npmDepsHash = "sha256-Z7JMvVZ8eNjRNQ8xKJlrF/oPu7nHDqaoU68bAexnrxU=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';
  #dontNpmInstall = true;  # 不执行 npm install
  dontNpmBuild = true;       # 不执行 npm build

  meta = with super.lib; {
      description = "A CLI tool to route code to different Claude models based on file size";
      homepage = "https://github.com/dazebind/claude-code-router";
      license = licenses.mit;
    };
  };
}
