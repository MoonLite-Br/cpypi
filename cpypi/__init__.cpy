# cpypi — HTML parse + CSS select for cpy (super-beta)
#
#   import cpypi
#   doc = cpypi.parse(html, url="https://example.com")
#   print(doc.title)
#   for a in doc.select("a[href]"):
#       print(a["href"], a.text)

from .core import (
    parse, Document, Element, Text, Comment, Doctype, Node,
    VOID, BLOCK,
)
from .entities import unescape, escape
from .url import (
    urlsplit, urljoin, urlunsplit, quote, unquote, quote_plus, unquote_plus,
    urlencode, parse_qsl, parse_qs, urldefrag, SplitResult,
)
from .selector import select, select_one, matches, compile_selector, SelectorError
from .extract import links, images, table_rows, table_dicts, form_fields

__version__ = "0.1.0-beta"
__all__ = [
    "parse", "Document", "Element", "Text", "Comment", "Doctype", "Node",
    "unescape", "escape",
    "urlsplit", "urljoin", "quote", "unquote", "urlencode", "parse_qsl",
    "select", "select_one", "matches", "compile_selector", "SelectorError",
    "links", "images", "table_rows", "table_dicts", "form_fields",
    "__version__",
]
