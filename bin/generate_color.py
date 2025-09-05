import argparse

import numpy as np

def hex_to_rgb(h: str):
    h = h.lstrip('#')
    return np.array(tuple(int(h[i:i+2], 16) for i in (0, 2, 4)))

def rgb_to_hex(rgb):
    return "#{:02x}{:02x}{:02x}".format(*rgb)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("init")
    parser.add_argument("end")
    parser.add_argument("bins", type=int)
    args = parser.parse_args()

    init_color = hex_to_rgb(args.init)
    end_color = hex_to_rgb(args.end)
    color_gap = end_color - init_color

    color_gap_unit = color_gap / args.bins
    color_tuples = list(
        tuple(map(int, init_color + i*color_gap_unit))
        for i in range(args.bins)
    )
    for color_tuple in color_tuples:
        print(rgb_to_hex(color_tuple))

