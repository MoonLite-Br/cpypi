# cpypi

**Super-beta** HTML toolkit for [cpy](https://github.com/MoonLite-Br/Cpy).

## Install

```bash
git clone https://github.com/MoonLite-Br/cpypi.git
cd cpypi
source ./install.sh
cpy -c 'import cpypi; print(cpypi.__version__)'
```

`source ./install.sh` sets `CPY_PATH` **now** and writes it into `~/.bashrc` for next time.

Already in the folder?

```bash
source ./install.sh
```

Quick one-shot (no rc file):

```bash
source ./env.sh
```

**Important:** do not name your script `cpypi.cpy` — that name hides the package.

## Use

```python
import cpypi
doc = cpypi.parse(html, url="https://example.com")
print(doc.title)
print(doc.select_one("h1").text)
```

```bash
cpy examples/demo.cpy
cpy examples/smoke.cpy
```

## License

MIT · **0.1.0-beta**
