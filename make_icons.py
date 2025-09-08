# make_icons.py
# Generates both:
#  - ICO: 1px corners (square caps), big arrows separated by 1px
#  - PNG: simple style like provided image (square caps, uniform thickness)
# Cross-platform (Windows/Linux/macOS). Requires: Pillow (pip install pillow)

from PIL import Image, ImageDraw
import argparse
import sys

def parse_color(s: str):
    s = s.strip()
    if s.lower() == "transparent":
        return (0, 0, 0, 0)
    if s.startswith("#"): s = s[1:]
    if len(s) == 6:
        r = int(s[0:2], 16); g = int(s[2:4], 16); b = int(s[4:6], 16)
        return (r, g, b, 255)
    if len(s) == 8:
        r = int(s[0:2], 16); g = int(s[2:4], 16); b = int(s[4:6], 16); a = int(s[6:8], 16)
        return (r, g, b, a)
    raise ValueError("Color must be hex like #000000 or #000000FF, or 'transparent'")

# ---------- PNG (simple, like uploaded image) ----------
def png_simple(sz, fg, bg=None, pad_ratio=0.10, seg_ratio=0.28, thickness=None):
    """Square-caps corners (no rounded), uniform thickness; no text."""
    img = Image.new("RGBA", (sz, sz), (0,0,0,0) if bg is None else bg)
    d = ImageDraw.Draw(img)

    pad = max(1, int(sz * pad_ratio))
    seg = int(sz * seg_ratio)
    t   = max(1, thickness if thickness is not None else int(sz * 0.08))

    # corners (square caps via rectangles)
    # Top-left
    d.rectangle([pad, pad, pad+seg, pad+t], fill=fg)       # horizontal
    d.rectangle([pad, pad, pad+t,   pad+seg], fill=fg)     # vertical
    # Top-right
    d.rectangle([sz-pad-seg, pad, sz-pad, pad+t], fill=fg)
    d.rectangle([sz-pad-t,   pad, sz-pad, pad+seg], fill=fg)
    # Bottom-left
    d.rectangle([pad, sz-pad-t, pad+seg, sz-pad], fill=fg)
    d.rectangle([pad, sz-pad-seg, pad+t, sz-pad], fill=fg)
    # Bottom-right
    d.rectangle([sz-pad-seg, sz-pad-t, sz-pad, sz-pad], fill=fg)
    d.rectangle([sz-pad-t,   sz-pad-seg, sz-pad, sz-pad], fill=fg)

    # No arrows in the PNG according to the sample you sent
    return img

# ---------- ICO (1px corners + bigger arrows separated by 1px) ----------
def ico_layer(sz, fg, bg=None, pad_ratio=0.10, seg_ratio=0.28, gap=1):
    img = Image.new("RGBA", (sz, sz), (0,0,0,0) if bg is None else bg)
    d = ImageDraw.Draw(img)

    pad = max(1, int(sz * pad_ratio))
    seg = int(sz * seg_ratio)
    t   = 1  # 1px stroke for ICO corners

    # corners square 1px
    d.rectangle([pad, pad, pad+seg, pad+t], fill=fg)
    d.rectangle([pad, pad, pad+t,   pad+seg], fill=fg)
    d.rectangle([sz-pad-seg, pad, sz-pad, pad+t], fill=fg)
    d.rectangle([sz-pad-t,   pad, sz-pad, pad+seg], fill=fg)
    d.rectangle([pad, sz-pad-t, pad+seg, sz-pad], fill=fg)
    d.rectangle([pad, sz-pad-seg, pad+t, sz-pad], fill=fg)
    d.rectangle([sz-pad-seg, sz-pad-t, sz-pad, sz-pad], fill=fg)
    d.rectangle([sz-pad-t,   sz-pad-seg, sz-pad, sz-pad], fill=fg)

    # bigger arrows with 1px separation
    aw = int(sz * 0.16)
    ah = int(sz * 0.34)

    cx1 = int(sz * 0.32) - gap; cy = sz // 2
    d.polygon([(cx1+aw, cy-ah//2), (cx1+aw, cy+ah//2), (cx1-aw, cy)], fill=fg)

    cx2 = int(sz * 0.68) + gap
    d.polygon([(cx2-aw, cy-ah//2), (cx2-aw, cy+ah//2), (cx2+aw, cy)], fill=fg)

    return img

def main():
    ap = argparse.ArgumentParser(description="Generate Window Mover icons (PNG simple + ICO with arrows)")
    ap.add_argument("--png", default="window-mover-256.png", help="PNG output (default: window-mover-256.png)")
    ap.add_argument("--ico", default="window-mover.ico", help="ICO output (default: window-mover.ico)")
    ap.add_argument("--size", type=int, default=256, help="PNG size (default: 256)")
    ap.add_argument("--fg", default="#000000", help="Foreground color (hex or 'transparent'). Default: #000000")
    ap.add_argument("--bg", default="transparent", help="Background color (hex or 'transparent'). Default: transparent")
    ap.add_argument("--png-thickness", type=int, default=None, help="PNG corner thickness in px (default: ~8% of size)")
    args = ap.parse_args()

    fg = parse_color(args.fg)
    bg = None if args.bg.lower() == "transparent" else parse_color(args.bg)

    # PNG simple (like the provided sample image)
    png_img = png_simple(args.size, fg, bg, thickness=args.png_thickness)
    png_img.save(args.png, format="PNG")

    # ICO multi-size (with arrows)
    sizes = [16, 24, 32, 48, 64, 128, 256]
    layers = [ico_layer(s, fg, bg) for s in sizes]
    layers[0].save(args.ico, sizes=[(s, s) for s in sizes], format="ICO")

    print(f"Done:\n - PNG: {args.png}\n - ICO:  {args.ico}")

if __name__ == "__main__":
    sys.exit(main())
