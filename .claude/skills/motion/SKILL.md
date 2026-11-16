---
name: motion
description: Add, plan or review motion for a website, mockup or promo video using the LiftPage motion standard. Use this whenever a request involves animation, motion visuals, hero loops, scroll reveals, video backgrounds, reels, promo clips or Higgsfield, even when the user only says "make it move" or "add some life to it".
---

# Motion

Motion on a small-business site has one job: help a visitor understand the page faster, or make a before-and-after obvious. It never gets to slow the page down, because speed is what LiftPage sells. Pick the lightest tool that does the job.

## Pick the tool

| What's needed | Use | Why |
|---|---|---|
| Movement inside a page: reveals, a hero loop, hover and press states | Code in the page. CSS for simple things, the `motion` library in React projects. | Sharp at any size, a few KB, easy to switch off for people who ask for less motion. |
| A video that shows a real interface or readable text: a before-and-after reel, a walkthrough | The Motion Reel skill, which renders video from code. | AI video smears small text and invents interface details. Code keeps every pixel of a screenshot exact. |
| Footage that can't be drawn: coastline, atmosphere, a slow push on a photo | Higgsfield. | Looks like real camera work. Keep text and interfaces out of it. |

If two would work, choose the one higher in the table.

## Motion inside a page

There are two levels. Ask which one applies if it isn't obvious.

**Gentle (client mockups and client sites).** Reveal on scroll and nothing else: content below the first screen fades up once as it enters view. No looping animation, parallax, marquee or autoplay video. An owner judging a mockup on their phone should notice their business, not the effects. The concept kit in the pitch skill already does this, so don't add a second system on top of it.

**Full (LiftPage's own site).** A looping hero piece, a headline that builds word by word, a draggable before-and-after, a marquee, animated step connectors. LiftPage's site is the showcase, so it can do more, inside the same limits below.

Limits that apply to both:

- **Reduced motion.** Under `prefers-reduced-motion: reduce`, show the finished state. No loops, parallax or marquee. Check this in a browser, don't assume it.
- **Only animate `transform` and `opacity`.** Anything else makes the page re-lay out on every frame, which stutters on cheap phones.
- **Pause what's off screen.** Loops run only while visible.
- **No layout shift.** Reserve the space for anything that animates in.
- **The first screen stays fast.** Motion must not delay the headline or the main button from showing.
- **Phone first.** Check at 390 px wide: no sideways scrolling, nothing clipped.

## Video on a page

A hero video is the easiest way to make a fast site slow, so it has a budget:

- 6 seconds or less, no sound track, around 1 MB and never over 2 MB.
- `autoplay muted loop playsinline`, with a poster image so something shows before the video loads.
- Under reduced motion, show the poster and don't play.
- Don't load it on the first screen of a phone unless it is the whole point of the page.

Compress any clip with this skill's `scripts/web-video.sh <clip> [output folder]`. It writes `hero.mp4`, `hero.webm` and `poster.jpg`, prints their sizes, and says when the MP4 is over budget.

```html
<video autoplay muted loop playsinline preload="metadata" poster="poster.jpg" width="1280" height="720">
  <source src="hero.webm" type="video/webm">
  <source src="hero.mp4" type="video/mp4">
</video>
```

Add this after it so visitors who ask for reduced motion get the still image:

```html
<script>
if (matchMedia('(prefers-reduced-motion: reduce)').matches) {
  document.querySelectorAll('video[autoplay]').forEach(v => { v.removeAttribute('autoplay'); v.pause(); });
}
</script>
```

## Footage with Higgsfield

The Higgsfield connector can look things up but can't start a generation. So the work splits in three:

1. **Claude writes the shot.** Check the credit balance and say what it is. Look up the current models and their settings with the connector instead of trusting memory, since the list changes. Then give a brief the user can paste: model, aspect ratio (16:9 for a hero, 9:16 for Instagram or TikTok), length, resolution, sound off, and the prompt.
2. **The user runs it in Higgsfield.**
3. **Claude finishes it.** Find the clip in the generation history, download it, run `scripts/web-video.sh`, and place it using the markup above.

Writing the prompt:

- One subject and one slow camera move. "Slow aerial drift along the coast at golden hour" works. Three things happening at once doesn't.
- Say what to leave out: no people, no text, no logos, no signs. AI video garbles lettering.
- For a loop, ask for steady motion with no cuts, then trim to a stretch where the first and last frames look alike.
- To animate a real photo, use it as the start image and ask for a small move (a slow push in, steam rising). Small moves hold up. Big ones warp.

**Honesty rule for client work.** For a real business, only animate that business's own photos. Never use generated footage that passes for their food, shop or staff. Mark it with a "to confirm" tag and list it in the "What changed?" panel like any other unverified item. The pitch skill's rule against inventing facts about a business covers pictures too. LiftPage's own marketing can use generic scenery, as long as nothing implies a real client.

## Reels with Motion Reel

Use it for before-and-after reels and anything else that shows a site or a screenshot.

- **Inputs:** the before screenshots from the audit (1280x800 and 390x844) and the mockup screenshots. Real captures only.
- **Length and shape:** 10 to 20 seconds. 9:16 for Instagram and TikTok, 16:9 for the site or a deck, 1:1 if asked.
- **Cloud sessions have no graphics card.** Keep reels 2-D there. 3-D scenes fall back to software rendering and take far longer.
- **Privacy.** A reel about a real business is as private as its mockup. Send it to that owner and don't post it unless they say yes.

## Before you finish

- Reduced motion checked in a browser, not assumed.
- Checked at 390 px wide.
- Video file sizes stated, and under budget.
- For client work: every moving image is the client's own, and anything unverified is tagged.
- Say where the files are and what the user needs to do next.
