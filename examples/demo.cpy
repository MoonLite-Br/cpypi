import cpypi

html = """
<html><head><title>Hi</title></head>
<body>
  <h1 class="title">Hello</h1>
  <p>Visit <a href="/docs">docs</a>.</p>
  <ul>
    <li class="item">one</li>
    <li class="item">two</li>
  </ul>
</body></html>
"""

doc = cpypi.parse(html, url="https://example.com/")
print("title:", doc.title)
print("h1:", doc.select_one("h1.title").text)
for a in doc.select("a[href]"):
    print("link:", a["href"], "->", a.text)
for li in doc.find_all("li", class_="item"):
    print("item:", li.text)
