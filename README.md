<h1 align="center">
  <br>
  <img src="icons/256x256/harbour-sailbook.png" width="256px" alt="Sailbook">
  <br>
  Sailbook
  <br>
  <sub>Ożywione przez Claude</sub>
</h1>

Sailbook is a **search-only** Facebook client for Sailfish OS, in the classic Sailbook look.
*Ożywione przez Claude* (revived by Claude).

## What it is
This fork keeps the **original Sailbook app** (its menu bar, loading screen, pulldown
menu, settings dialog, about/translators pages, cover and themes, restored from
[DylanVanAssche/harbour-sailbook](https://github.com/DylanVanAssche/harbour-sailbook))
and changes what it shows:

- **No account, no login, ever.** There is nothing to log into and nothing that could
  get an account banned. Sailbook only talks to facebook.com to read the page address
  behind a pasted share link (see below). Pages and people are found through their public Facebook usernames on
  [Wikidata](https://www.wikidata.org/wiki/Property:P2013) (one SPARQL query, CC0 data,
  pictures from Wikimedia Commons). This covers organisations and public figures
  (universities, cities, media...), not private profiles or posts.
- **No news feed.** The feed button shows an empty page; content only appears when you search.
- **Pasted Facebook links.** A direct page link (facebook.com/name) already contains
  the page address, so Sailbook looks it up on Wikidata without contacting Facebook.
  A share link (facebook.com/share/..., fb.me, fb.watch) needs one request to
  facebook.com, without login and without cookies (Sailbook never stores or sends
  cookies for Meta domains); only the public page address and name are read.
  If the page has no Facebook address on Wikidata yet, Sailbook suggests the
  Wikidata entry where it can be added (property P2013).
- **Removed**: messenger, notifications, events, groups, the Facebook settings button,
  logout, the video player and all unread counters (menu bar and cover).
- **Limited scrolling.** Results stop after a configurable number of screens
  (Settings > Limits, default 3 screens = 18 results).
- **Original look, without the web page.** Default theme is "Facebook" (blue bar,
  as in the original store screenshots), the original start-up screen is back, and
  the content is drawn natively to look like the Facebook mobile site the original
  showed inside (white cards, round pictures; dark with the night theme).
  Requests identify themselves honestly as Sailbook (no user-agent spoofing).
- Polish translation added; the original translations are kept.

## Build
With the Sailfish SDK (or the `coderus/sailfishos-platform-sdk` Docker image):

```
# Jolla Phone (2026) and other aarch64 devices
mb2 -t SailfishOS-5.2.0.15-aarch64 build
# Emulator
mb2 -t SailfishOS-5.2.0.15-i486 build
```

Built against Sailfish OS 5.2 (Sailjail permission `Internet`). Tested in the Sailfish OS 5.1 emulator; not yet tested on real hardware.

## License
GNU General Public License v3.0. Based on the original Sailbook by Dylan Van Assche and contributors.
