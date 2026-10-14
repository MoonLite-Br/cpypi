# cpypi/extract.cpy - pull links, images, tables, form fields from a subtree.
from .url import urljoin


def links(root, base=None):
    """List of {"href", "text", "title", "rel"} for every <a href=...> under root."""
    if base is None and hasattr(root, "base_url"):
        try:
            base = root.base_url()
        except Exception:
            base = getattr(root, "url", None)
    out = []
    for a in root.find_all("a", href=True):
        href = a.attrs.get("href", "")
        if base:
            href = urljoin(base, href)
        out.append({
            "href": href,
            "text": " ".join(a.get_text().split()),
            "title": a.attrs.get("title"),
            "rel": a.attrs.get("rel"),
        })
    return out


def images(root, base=None):
    """List of {"src", "alt", "title"} for every <img> under root."""
    if base is None and hasattr(root, "base_url"):
        try:
            base = root.base_url()
        except Exception:
            base = getattr(root, "url", None)
    out = []
    for img in root.find_all("img"):
        src = img.attrs.get("src") or img.attrs.get("data-src") or ""
        if base and src:
            src = urljoin(base, src)
        out.append({
            "src": src,
            "alt": img.attrs.get("alt"),
            "title": img.attrs.get("title"),
        })
    return out


def table_rows(table, strip=True):
    """Rows of a <table> as lists of cell text."""
    rows = []
    for tr in table.find_all("tr"):
        cells = []
        for cell in tr.children:
            if not getattr(cell, "is_element", False):
                continue
            if cell.tag not in ("td", "th"):
                continue
            t = cell.get_text(sep=" ", strip=strip)
            if strip:
                t = " ".join(t.split())
            cells.append(t)
        if cells:
            rows.append(cells)
    return rows


def table_dicts(table):
    """First row = headers; remaining rows -> list of dicts."""
    rows = table_rows(table, strip=True)
    if not rows:
        return []
    headers = rows[0]
    out = []
    for row in rows[1:]:
        d = {}
        for i in range(len(headers)):
            key = headers[i] if i < len(headers) else ("col" + str(i))
            d[key] = row[i] if i < len(row) else ""
        out.append(d)
    return out


def form_fields(form):
    """Dict of name -> value for controls inside a <form> (or any subtree)."""
    out = {}
    for tag in ("input", "textarea", "select", "button"):
        for el in form.find_all(tag):
            name = el.attrs.get("name")
            if not name:
                continue
            if tag == "input":
                typ = (el.attrs.get("type") or "text").lower()
                if typ in ("submit", "button", "image", "reset", "file"):
                    continue
                if typ in ("checkbox", "radio"):
                    if "checked" not in el.attrs:
                        continue
                    out[name] = el.attrs.get("value", "on")
                else:
                    out[name] = el.attrs.get("value", "")
            elif tag == "textarea":
                out[name] = el.get_text()
            elif tag == "select":
                selected = None
                first = None
                for opt in el.find_all("option"):
                    if first is None:
                        first = opt.attrs.get("value", opt.get_text())
                    if "selected" in opt.attrs:
                        selected = opt.attrs.get("value", opt.get_text())
                        break
                out[name] = selected if selected is not None else (first or "")
            elif tag == "button":
                if (el.attrs.get("type") or "submit").lower() == "submit":
                    out[name] = el.attrs.get("value", el.get_text())
    return out
