<h1 align="center">
  <br>
  <img src="icons/256x256/harbour-sailbook.png" width="256px" alt="Sailbook">
  <br>
  Sailbook
  <br>
</h1>

Sailbook is a **native, search-only** Facebook client UI for Sailfish OS.

## What it is
- **Native Silica UI**, no web page and no WebView. The classic Sailbook menu bar,
  icons and themes (Ambience, Facebook, Night) are back.
- **No feed.** The only interface is search: profiles, posts and groups, with the
  bottom bar used as search filters. With an empty search there is nothing to scroll.
- **Limited scrolling.** Search results stop after a configurable number of screens
  (Settings, default 3 screens = 18 results), so they never become an endless stream.
- No accounts / logout UI, no user-agent spoofing, no notification scraping.

## Status: mockup
This version shows **clearly fictional sample data** (`qml/js/backend.js`) and is not
connected to Facebook. Every way of searching Facebook (including
[facebook-gql-scraper](https://github.com/XD-MHLOO/facebook-gql-scraper)) needs a
logged-in Facebook session. The result objects already follow that scraper's
Profile / Post / Group models, so a real backend can be plugged in behind
`Backend.search(query, filter, limit)` later.

## Build
With the Sailfish SDK (or the `coderus/sailfishos-platform-sdk` Docker image):

```
mb2 -t SailfishOS-5.2.0.15-aarch64 build
```

Requires Sailfish OS 4.4+ (Sailjail permission `Internet`).

## License
GNU General Public License v3.0. Based on the original Sailbook by Dylan Van Assche and contributors.
