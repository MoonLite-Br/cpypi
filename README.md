# cpypi

**Super-beta** HTML toolkit for [cpy](https://github.com/MoonLite-Br/Cpy): parser, DOM, CSS selectors.

> **0.1.0-beta** — expect rough edges.

## Install

```bash
git clone https://github.com/MoonLite-Br/cpypi.git
cd cpypi
./install.sh
```

Copy-paste the `export CPY_PATH=...` line it prints (needed once in the current terminal).  
New terminals pick it up from `~/.bashrc` / `~/.zshrc` after that.

Or in one step from the repo folder:

```bash
source ./env.sh
```

Check:

```bash
cpy -c 'import cpypi; print(cpypi.__version__)'
```

**Do not** name your own file `cpypi.cpy` — cpy will import that file instead of this package.

## Quick start

```python
import cpypi

doc = cpypi.parse(html, url="https://example.com")
print(doc.title)
for a in doc.select("a[href]"):
    print(a["href"], a.text)
```

```bash
cpy examples/demo.cpy
```

## Layout

```
cpypi/           package (import cpypi)
install.sh       writes CPY_PATH into your shell rc + prints export line
env.sh           source ./env.sh  → sets CPY_PATH for this shell
examples/
```

## License

MIT
