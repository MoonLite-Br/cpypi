# cpypi

**Super-beta** HTML toolkit for [cpy](https://github.com/MoonLite-Br/Cpy): forgiving parser, small DOM, CSS selectors, URL helpers.

API is intentionally close to a thin BeautifulSoup / `html.parser` style — pure `.cpy`, no C extensions.

> Status: **0.1.0-beta**. Expect rough edges. Issues and patches welcome.

## Install

Needs [cpy](https://github.com/MoonLite-Br/Cpy) on your `PATH`.

```bash
git clone https://github.com/MoonLite-Br/cpypi.git
cd cpypi
./install.sh
# new shells: source ~/.bashrc   (or the export line install.sh prints)
```

Manual alternative:

```bash
export CPY_PATH="/path/to/cpypi:$CPY_PATH"
```

(`install.sh` copies the package under `~/.local/share/cpypi` or `$PREFIX/share/cpypi` on Termux and appends `CPY_PATH` to your shell rc.)

## Quick start

```python
import cpypi

doc = cpypi.parse(html, url="https://example.com")
print(doc.title)
print(doc.select_one("h1.title").text)
for a in doc.select("a[href^='http']"):
    print(a["href"], a.get_text(strip=True))
```

```bash
cpy examples/demo.cpy
```

## Layout

```
cpypi/
  __init__.cpy    # public API
  core.cpy        # parse(), Document, Element, …
  selector.cpy    # CSS select / select_one / matches
  entities.cpy    # unescape / escape
  url.cpy         # urljoin, quote, urlsplit, …
  extract.cpy     # links, images, tables, form fields
install.sh
examples/demo.cpy
```

## License

MIT (same spirit as cpy). Package is experimental software — use at your own risk.
