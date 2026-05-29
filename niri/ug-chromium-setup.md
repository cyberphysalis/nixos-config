
[ungoogle-chromium 项目](https://github.com/ungoogled-software/ungoogled-chromium)去除了 chromium 中的 google 服务, 旨在加强隐私和安全性。

[chromium-web-store 项目](https://github.com/NeverDecaf/chromium-web-store) 使 ungoogled-chromium 支持直接安装, 更新 chrome web store 中的插件（插件生态是 chrome 的重要部分，既要又要的折中办法。）

要在 ungoogled-chromium 中安装 chromium-web-store 需要设置 `chrome://flags/#extension-mime-request-handling` 为 `Always prompt for install` 或者在 ungoogled-chromium 启动时添加参数 `--extension-mime-request-handling=always-prompt-for-install`.


在 home-manager 中管理 chromium 时，安装 extensions 需要额外设置
https://discourse.nixos.org/t/home-manager-ungoogled-chromium-with-extensions/15214/7

related issues
- https://github.com/nix-community/home-manager/issues/2585
- https://github.com/nix-community/home-manager/issues/2261

install extension at startup
https://gitlab.com/engmark/root/-/merge_requests/892/diffs?commit_id=e511897c53fbe5ec9303e4b9f22d1084ae00c8bf#diff-content-1cfc72dcc3f6d99ed7693711ceff8cc2159f27df

install for nixos module 
https://gist.github.com/MaximilianGaedig/acbce27522c997e9666bd93cef77492d

patch home-manager
https://github.com/copilot/c/67ff743e-336b-40ba-8244-356f28c974f1

