#!/usr/bin/env bash
# Compress a video clip for use on a web page.
#
# Usage: web-video.sh <input clip> [output folder] [max width] [max seconds]
#   output folder  default: ./web-video
#   max width      default: 1280 (a smaller clip is never scaled up)
#   max seconds    default: 6
#
# Writes hero.mp4 (H.264), hero.webm (VP9) and poster.jpg, all without sound.
# The frame rate is capped at 30 per second and never raised: a faster clip
# comes down to 30, a slower one keeps its own rate.
# Exit codes: 0 ok, 3 the MP4 is over the 2 MB cap, 1 anything else.
set -euo pipefail

in="${1:-}"
out="${2:-web-video}"
maxw="${3:-1280}"
secs="${4:-6}"
target_kb=1024
cap_kb=2048

if [ -z "$in" ] || [ ! -f "$in" ]; then
  echo "Usage: $(basename "$0") <input clip> [output folder] [max width] [max seconds]" >&2
  exit 1
fi
for tool in ffmpeg ffprobe; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "$tool is not installed." >&2
    exit 1
  fi
done
mkdir -p "$out"

size_filter="scale='min($maxw,iw)':-2:flags=lanczos"

# Frame rate: cap at 30 a second, but never raise a slower clip. Forcing 30 on
# a 24 fps clip repeats one frame in five, and slow camera moves stutter.
rate_filter="fps='min(source_fps,30)'"
if ! ffmpeg -hide_banner -loglevel quiet -f lavfi -i "color=size=16x16:rate=24" \
     -frames:v 1 -vf "$rate_filter" -f null - </dev/null; then
  # ffmpeg older than 5.0 can't work that out inside the filter. Read the
  # clip's rate here instead and hand the filter a plain number.
  src_rate="$(ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate \
    -of default=nw=1:nk=1 "$in" 2>/dev/null | head -n 1 | tr -cd '0-9/')" || true
  rate_filter="fps=$(awk -v r="$src_rate" 'BEGIN {
    n = split(r, p, "/")
    if (n == 2 && p[1] > 0 && p[2] > 0 && p[1] / p[2] <= 30) print r; else print 30
  }')"
fi

encoders="$(ffmpeg -hide_banner -encoders 2>/dev/null || true)"
has_encoder() { printf '%s\n' "$encoders" | grep -q " $1 "; }

if has_encoder libx264; then
  ffmpeg -hide_banner -loglevel error -y -i "$in" -t "$secs" -an \
    -vf "$size_filter,$rate_filter" -c:v libx264 -preset slow -crf 27 \
    -pix_fmt yuv420p -movflags +faststart "$out/hero.mp4"
else
  echo "This ffmpeg has no H.264 encoder, so hero.mp4 was skipped." >&2
fi

if has_encoder libvpx-vp9; then
  ffmpeg -hide_banner -loglevel error -y -i "$in" -t "$secs" -an \
    -vf "$size_filter,$rate_filter" -c:v libvpx-vp9 -b:v 0 -crf 38 \
    -row-mt 1 -deadline good -cpu-used 2 "$out/hero.webm"
else
  echo "This ffmpeg has no VP9 encoder, so hero.webm was skipped." >&2
fi

ffmpeg -hide_banner -loglevel error -y -i "$in" -frames:v 1 \
  -vf "$size_filter" -q:v 4 "$out/poster.jpg"

size_kb() {
  if [ -f "$1" ]; then
    echo $(( ($(wc -c < "$1") + 1023) / 1024 ))
  else
    echo 0
  fi
}

echo "Wrote to $out/:"
for f in hero.mp4 hero.webm poster.jpg; do
  if [ -f "$out/$f" ]; then
    printf '  %-11s %5s KB\n' "$f" "$(size_kb "$out/$f")"
  fi
done

if [ -f "$out/hero.mp4" ]; then
  dims="$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$out/hero.mp4" || true)"
  length="$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$out/hero.mp4" || true)"
  echo "  ${dims:-unknown size}, ${length%.*}s, no sound"
  mp4_kb="$(size_kb "$out/hero.mp4")"
  if [ "$mp4_kb" -gt "$cap_kb" ]; then
    echo "hero.mp4 is over the 2 MB cap. Shorten the clip, lower the width (third argument), or use calmer footage."
    exit 3
  elif [ "$mp4_kb" -gt "$target_kb" ]; then
    echo "hero.mp4 is over the 1 MB target but under the 2 MB cap. Fine on desktop. Consider a shorter clip for phones."
  else
    echo "hero.mp4 is within the 1 MB target."
  fi
fi
