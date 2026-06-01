# dao-quant local tdx2db install

本目录是 dao-quant fork 专用的本地辅助目录，刻意放在 `dao_quant_local/` 下，避免修改上游已有文件，也降低未来同步 `jing2uo/tdx2db` 时的文件名冲突概率。

## 安装到当前用户

在 `third_party/tdx2db` 目录执行：

```bash
./dao_quant_local/dao_quant_install_tdx2db.sh
```

默认会调用 tdx2db 原有 `make user-install`，编译当前 checkout，并把二进制安装到：

```text
~/.local/bin/tdx2db
```

如果 `~/.local/bin` 不在 `PATH`，可以把下面内容加入 shell 配置：

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## 指定安装目录

```bash
./dao_quant_local/dao_quant_install_tdx2db.sh --dir /usr/local/bin
```

安装到系统目录可能需要写权限。脚本本身不自动调用 `sudo`；如需系统安装，请自行用具备权限的 shell 运行。

## 依赖

脚本会检查以下命令：

- `go`
- `make`
- `curl`
- `unrar`

这些依赖与 tdx2db 当前 `makefile` 的构建流程一致。构建时会下载通达信 `datatool.rar` 并提取 `datatool`，随后编译 `tdx2db`。

## 验证

安装完成后脚本默认执行：

```bash
~/.local/bin/tdx2db -h
```

如果只想安装、不做验证：

```bash
./dao_quant_local/dao_quant_install_tdx2db.sh --skip-check
```
