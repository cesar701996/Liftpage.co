# LiftPage

Tooling for working on liftpage.co with Claude Code.

## What's here

- `.claude/skills/motion/` is the `/motion` skill. It holds the motion standard for sites, mockups and promo clips, plus `scripts/web-video.sh`, which turns a clip into a small hero video, a WebM copy and a poster image.
- `.claude/settings.json` stops Claude from sending, replying to or forwarding email through Gmail in sessions on this repository. Drafts still work. A person reviews and sends every email.

## What isn't here yet

The site's code. It lives in Lovable for now.

## Using it

Start a Claude Code session on this repository and both pieces load on their own. Type `/motion` to use the skill.
