# Run from anywhere after install:  cpy examples/smoke.cpy
# Or:  cpy /path/to/cpypi/examples/smoke.cpy
import cpypi

html = """<html><head><title>T</title></head>
<body><h1 class="x">Hi</h1><a href="/a">A</a></body></html>"""

doc = cpypi.parse(html, url="https://ex.com/")
assert doc.title == "T"
assert doc.select_one("h1.x").text.strip() == "Hi"
assert len(doc.select("a[href]")) == 1
print("ok", cpypi.__version__)
