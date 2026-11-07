# omnigraffle-pdf
使用LaTeX对OmniGraffle文档排版，以便于最佳的打印效果
参考:
- https://support.omnigroup.com/documentation/omnigraffle/mac/7.19/en/print/

## 文档来源
macOS 本机 OmniGraffle.app 自带的帮助文档（单页 HTML）:

`/Applications/OmniGraffle.app/Contents/Resources/Base.lproj/OmniGraffle Help/index.html`

## 目录结构
- `main.tex`          — 主文件（ctexbook + subfiles）
- `art-book.sty`      — 版式宏包
- `intro/`            — 前言/Introduction（frontmatter，含版权页）
- `basics/`           — Part I: OmniGraffle Basics（第 1–4 章）
- `in-depth/`         — Part II: OmniGraffle In-Depth（第 5–14 章）
- `reference/`        — Part III: Reference（第 15–18 章）
- `dbg/`              — 调试样例
- `res/`              — 帮助文档 art/ 目录的图片资源镜像
- `tools/convert.py`  — HTML → LaTeX 转换脚本


## 构建
```sh
make        # 生成 main.pdf（latexmk -xelatex）
make view   # 构建并预览
make clean  # 清理
```
