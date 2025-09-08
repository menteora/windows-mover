# make_icons.py
# Cross-platform icon generator for Window Mover
# PNG: rounded-caps corners   | ICO: square-caps corners
# Requires: Pillow  (pip install pillow)

from PIL import Image, ImageDraw
import argparse
import sys

def parse_color(s: str):
    s = s.strip()
    if s.lower() == "transparent":
        return (0, 0, 0, 0)
    if s.startswith("#"):
        s = s[1:]
    if len(s) == 6:
        r = int(s[0:2], 16); g = int(s[2:4], 16); b = int(s[4:6], 16)
        return (r, g, b, 255)
    if len(s) == 8:
        r = int(s[0:2], 16); g = int(s[2:4], 16); b = int(s[4:6], 16); a = int(s[6:8], 16)
        return (r, g, b, a)
    raise ValueError("Color must be hex like #000000 or #000000FF, or 'transparent'")

def draw_round_line(draw, p1, p2, width, color):
    # Simula cap arrotondato anche su piattaforme senza linecap round
    draw.line([p1, p2], fill=color, width=width)
    r = width/2
    for (x,y) in [p1, p2]:
        draw.ellipse([x-r, y-r, x+r, y+r], fill=color)

def icon_png(sz, fg, bg=None):
    """PNG con angoli arrotondati."""
    img = Image.new("RGBA", (sz, sz), (0,0,0,0) if bg is None else bg)
    draw = ImageDraw.Draw(img)
    pad = max(2, int(sz*0.10))
    seg = int(sz*0.28)
    thickness = max(2, int(sz*0.08))
    # corners (rounded caps)
    draw_round_line(draw, (pad, pad), (pad+seg, pad), thickness, fg)         # TL h
    draw_round_line(draw, (pad, pad), (pad, pad+seg), thickness, fg)         # TL v
    draw_round_line(draw, (sz-pad, pad), (sz-pad-seg, pad), thickness, fg)   # TR h
    draw_round_line(draw, (sz-pad, pad), (sz-pad, pad+seg), thickness, fg)   # TR v
    draw_round_line(draw, (pad, sz-pad), (pad+seg, sz-pad), thickness, fg)   # BL h
    draw_round_line(draw, (pad, sz-pad), (pad, sz-pad-seg), thickness, fg)   # BL v
    draw_round_line(draw, (sz-pad, sz-pad), (sz-pad-seg, sz-pad), thickness, fg) # BR h
    draw_round_line(draw, (sz-pad, sz-pad), (sz-pad, sz-pad-seg), thickness, fg) # BR v
    # arrows
    arrow_w = int(sz*0.12); arrow_h = int(sz*0.24)
    cx = int(sz*0.33); cy = sz//2
    draw.polygon([(cx+arrow_w, cy-arrow_h//2),
                  (cx+arrow_w, cy+arrow_h//2),
                  (cx-arrow_w, cy)], fill=fg)
    cx2 = int(sz*0.67); cy2 = sz//2
    draw.polygon([(cx2-arrow_w, cy2-arrow_h//2),
                  (cx2-arrow_w, cy2+arrow_h//2),
                  (cx2+arrow_w, cy2)], fill=fg)
    return img

def icon_ico_layer(sz, fg, bg=None):
    """ICO semplificata (no rounded caps)."""
    img = Image.new("RGBA", (sz, sz), (0,0,0,0) if bg is None else bg)
    draw = ImageDraw.Draw(img)
    pad = max(1, int(sz*0.10))
    seg = int(sz*0.28)
    thickness = max(1, int(sz*0.08))
    # corners (square caps)
    # TL
    draw.rectangle([pad, pad, pad+seg, pad+thickness], fill=fg)       # h
    draw.rectangle([pad, pad, pad+thickness, pad+seg], fill=fg)       # v
    # TR
    draw.rectangle([sz-pad-seg, pad, sz-pad, pad+thickness], fill=fg)
    draw.rectangle([sz-pad-thickness, pad, sz-pad, pad+seg], fill=fg)
    # BL
    draw.rectangle([pad, sz-pad-thickness, pad+seg, sz-pad], fill=fg)
    draw.rectangle([pad, sz-pad-seg, pad+thickness, sz-pad], fill=fg)
    # BR
    draw.rectangle([sz-pad-seg, sz-pad-thickness, sz-pad, sz-pad], fill=fg)
    draw.rectangle([sz-pad-thickness, sz-pad-seg, sz-pad, sz-pad], fill=fg)
    # arrows
    arrow_w = int(sz*0.12); arrow_h = int(sz*0.24)
    cx = int(sz*0.33); cy = sz//2
    draw.polygon([(cx+arrow_w, cy-arrow_h//2),
                  (cx+arrow_w, cy+arrow_h//2),
                  (cx-arrow_w, cy)], fill=fg)
    cx2 = int(sz*0.67); cy2 = sz//2
    draw.polygon([(cx2-arrow_w, cy2-arrow_h//2),
                  (cx2-arrow_w, cy2+arrow_h//2),
                  (cx2+arrow_w, cy2)], fill=fg)
    return img

def main():
    ap = argparse.ArgumentParser(description="Generate PNG & ICO icons for Window Mover")
    ap.add_argument("--png", default="window-mover-256.png", help="PNG output path (default: window-mover-256.png)")
    ap.add_argument("--ico", default="window-mover.ico", help="ICO output path (default: window-mover.ico)")
    ap.add_argument("--size", type=int, default=256, help="PNG size in px (default: 256)")
    ap.add_argument("--fg", default="#000000", help="Foreground color (hex or 'transparent'). Default: #000000")
    ap.add_argument("--bg", default="transparent", help="Background color (hex or 'transparent'). Default: transparent")
    args = ap.parse_args()

    fg = parse_color(args.fg)
    bg = None if args.bg.lower() == "transparent" else parse_color(args.bg)

    # PNG (rounded caps)
    png_img = icon_png(args.size, fg, bg)
    png_img.save(args.png, format="PNG")

    # ICO (square caps), multi-size layers
    sizes = [16, 24, 32, 48, 64, 128, 256]
    layers = [icon_ico_layer(s, fg, bg) for s in sizes]
    layers[0].save(args.ico, sizes=[(s, s) for s in sizes], format="ICO")

    print(f"Done:\n - PNG: {args.png}\n - ICO:  {args.ico}")

if __name__ == "__main__":
    sys.exit(main())
