for svg in *.svg; do
  pngfile=$(basename $svg .svg).png
  inkscape -o $pngfile $svg
  echo $pngfile
done
