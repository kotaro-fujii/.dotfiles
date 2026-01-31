#!/bin/env python
from operator import add
from itertools import batched, accumulate
import sys
import argparse
import xml.etree.ElementTree as ET

def parse_length(value):
    if value.endswith('pt'):
        return float(value[:-2])
    if value.endswith('px'):
        return float(value[:-2])
    else:
        return float(value)


def get_svg_size(svg_root):
    width = svg_root.get('width')
    height = svg_root.get('height')
    return (parse_length(width), parse_length(height))


def main():
    # 名前空間処理
    ET.register_namespace('', 'http://www.w3.org/2000/svg')
    ns = {'svg': 'http://www.w3.org/2000/svg'}

    parser = argparse.ArgumentParser()
    parser.add_argument("-o", "--out_path")
    parser.add_argument("-n", "--n_columns", type=int, default=2)
    parser.add_argument("svg_files", nargs="+")
    args = parser.parse_args()

    svg_files = args.svg_files
    trees = [ET.parse(svg_file) for svg_file in svg_files]
    roots = [tree.getroot() for tree in trees]
    #sizes = [get_svg_size(root) for root in roots]

    rowed_svgs = list(batched(roots, args.n_columns))
    row_widths = [sum(get_svg_size(svg_root)[0] for svg_root in svg_roots) for svg_roots in rowed_svgs]
    max_heights = [max(get_svg_size(svg_root)[1] for svg_root in svg_roots) for svg_roots in rowed_svgs]
    heights_to_move = list(accumulate(max_heights, add, initial=0))

    # 新しいルートsvgを作成
    new_svg = ET.Element('{http://www.w3.org/2000/svg}svg', {
        'width': f'{max(row_widths)}',
        'height': f'{sum(max_heights)}',
        'xmlns': 'http://www.w3.org/2000/svg',
    })

    for svg_roots, height_to_move in zip(rowed_svgs, heights_to_move):
        widths = [get_svg_size(svg_root)[0] for svg_root in svg_roots]
        widths_to_move = accumulate(widths, add, initial=0)
        for svg_root, width_to_move in zip(svg_roots, widths_to_move):
            g = ET.SubElement(new_svg, "g", {"transform": f"translate({width_to_move}, {height_to_move})"})
            g.extend(list(svg_root))

    # 出力
    new_tree = ET.ElementTree(new_svg)
    new_tree.write(args.out_path, encoding="utf-8", xml_declaration=True)
    print(args.out_path)


if __name__ == '__main__':
    main()

