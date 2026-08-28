#!/usr/bin/env python3
"""Turn a standalone page in this repo into a publishable Artifact body.

The pages here are complete HTML documents. The Artifact tool wraps whatever
it is given in its own <!doctype>/<html>/<head>/<body>, so the document
wrapper has to come off first or the page ends up nested inside itself.

    python3 scripts/build-artifact.py movienight.html
    python3 scripts/build-artifact.py vision-k7x9q2.html --banner "Vision build"

Output goes to build/<name>.artifact.html. The <title> and <style> are kept,
the <meta> tags are dropped (they do nothing outside a real <head>), and the
body content is passed through untouched.

build/ is generated. Edit the source page, never the output.
"""

import argparse
import html
import pathlib
import re
import sys

REPO = pathlib.Path(__file__).resolve().parent.parent
OUT_DIR = REPO / "build"

BANNER_CSS = """
.artifact-banner{background:#111;color:#fff;font:600 13px/1.45 -apple-system,BlinkMacSystemFont,"Segoe UI",Helvetica,Arial,sans-serif;padding:10px 16px;text-align:center;letter-spacing:.01em}
"""


def section(source: str, tag: str) -> str:
    """Return the inner content of the first <tag>...</tag> pair."""
    match = re.search(
        rf"<{tag}\b[^>]*>(.*?)</{tag}>", source, re.DOTALL | re.IGNORECASE
    )
    if not match:
        sys.exit(f"error: no <{tag}> found, is this a complete HTML document?")
    return match.group(1)


def build(source: str, banner: str | None) -> str:
    head = section(source, "head")
    body = section(source, "body")

    # <meta> only means anything inside a real <head>, and the Artifact wrapper
    # supplies its own. Everything else in the head (title, style) is kept.
    head = re.sub(r"<meta\b[^>]*>\s*", "", head, flags=re.IGNORECASE)

    parts = [head.strip()]
    if banner:
        parts.append(f"<style>{BANNER_CSS.strip()}</style>")
        parts.append(f'<div class="artifact-banner">{html.escape(banner)}</div>')
    parts.append(body.strip())
    return "\n".join(parts) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("page", help="path to a source .html page in this repo")
    parser.add_argument(
        "--banner",
        help="optional line pinned above the page, for framing a preview",
    )
    args = parser.parse_args()

    src = pathlib.Path(args.page)
    if not src.is_file():
        sys.exit(f"error: {src} not found")

    OUT_DIR.mkdir(exist_ok=True)
    out = OUT_DIR / f"{src.stem}.artifact.html"
    out.write_text(build(src.read_text(encoding="utf-8"), args.banner), encoding="utf-8")

    print(f"{src}  ->  {out.relative_to(REPO)}  ({out.stat().st_size:,} bytes)")


if __name__ == "__main__":
    main()
