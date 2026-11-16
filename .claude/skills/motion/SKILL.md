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
- When the footage doesn't loop cleanly, a good default is to play it once when it scrolls into view and let it rest on its last frame. That avoids a visible loop seam, and as long as the clip runs five seconds or less it also avoids the need for a pause control.
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

Claude makes the clip itself. The Higgsfield connector can generate video directly, so there is no step where the user runs it by hand. A session may also show an older Higgsfield connector that can only look things up. Use the one that has a generate tool.

Every generation spends the user's credits, so the order matters:

1. **Check the balance.** Look up the credit balance first and tell the user what it is.
2. **Look up the models.** Get the current video models and their settings from the connector instead of trusting memory. The list and the costs change.
3. **Price the clip before making it.** Settle the aspect ratio (16:9 for a hero, 9:16 for Instagram or TikTok), the length and the resolution. Then use the generate tool's cost preview option, which returns the cost without making anything, and tell the user what it is. Never generate without knowing the cost, and never retry a generation blindly, because each one spends credits. If the default model costs more than the balance, price cheaper models, then say which one was picked and why.
4. **Turn sound off unless sound is wanted.** A hero video plays muted anyway. On at least one model, turning sound off cut the cost in half, so make sure the cost in step 3 was taken with sound off.
5. **Generate one clip.** Wait for it to finish, then download it. If it seems to fail or time out, check the generation history before trying again, because it may have gone through.
6. **Check the result frame by frame before using it.** Pull the frames out as still images and look through them. AI video often adds made-up brand marks or lettering even when the prompt says not to, and it may move the camera when asked to hold it still. Crop or trim stray lettering out, or use a different take. A new take is a new generation, so price it first.
7. **Compress and place it.** Run `scripts/web-video.sh` on the clip, then place it with the markup under "Video on a page".

Some plans include an "unlimited" allowance for certain models. Using it has to be the user's explicit choice. If the connector asks whether to use it, pass the question to the user and wait for the answer.

This is how it worked on 2026-11-16. If the connector has changed since, the tool names may differ, but the order still holds: know the balance and the cost before anything is generated.

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
