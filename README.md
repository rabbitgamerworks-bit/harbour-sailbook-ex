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
- **Classic Sailbook look, rendered natively in Silica**: Facebook-style white content,
  the blue Sailbook menu bar with the original icons, the original themes
  (Facebook, Night, Ambience) and the original cover artwork. No web page, no WebView.
- **No feed.** The news feed button shows an empty page; content only appears when you search.
- **Removed as addictive**: news feed, messages, notifications and all unread counters
  (menu bar and cover). Groups are gone too (not searchable without an account).
- **Limited scrolling.** Results stop after a configurable number of screens
  (Settings, default 3 screens = 18 results).
- **No Facebook account needed.** Facebook only lets logged-in users search, so Sailbook
  finds pages and people through their public Facebook usernames on
  [Wikidata](https://www.wikidata.org/wiki/Property:P2013) (one SPARQL query, CC0 data,
  pictures from Wikimedia Commons). This covers organisations and public figures
  (e.g. universities, cities, media), not private profiles. No scraping, no browser
  user-agent spoofing: requests identify themselves as Sailbook.
- English and Polish UI.

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
