# 站点工程在 docusaurus/，文档在仓库根 docs/；在仓库根执行 make 即可。

.DEFAULT_GOAL := help

SITE := docusaurus
NP   := npm --prefix $(SITE)

.PHONY: help install ci start build serve deploy clear typecheck swizzle write-translations write-heading-ids

help:
	@echo "在仓库根目录执行，命令转发到 $(SITE)/ ："
	@echo "  make install   # 安装依赖（开发）"
	@echo "  make ci        # npm ci（CI / 干净安装）"
	@echo "  make start     # 本地开发"
	@echo "  make build     # 生产构建 -> $(SITE)/build/"
	@echo "  make serve     # 本地预览 build 产物"
	@echo "  make deploy    # 部署（需已配置 GitHub Pages 等）"
	@echo "  make clear     # 清理 $(SITE)/.docusaurus 等缓存"
	@echo "  make typecheck # TypeScript 检查"

install:
	$(NP) install

ci:
	$(NP) ci

start build serve deploy clear typecheck swizzle write-translations write-heading-ids:
	$(NP) run $@
