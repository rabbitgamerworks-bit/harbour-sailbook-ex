<h1 align="center">
  <br>
  <img src="icons/256x256/harbour-sailbook.png" width="256px" alt="Sailbook">
  <br>
  Sailbook
  <br>
</h1>

Sailbook is a **search-only** wrapper around `m.facebook.com` for Sailfish OS.

## What it is
- Loads the full, real `m.facebook.com` page in the modern Gecko based `Sailfish.WebView`
  (no QtWebKit, **no user-agent spoofing**: the engine's own user agent is sent).
- **No feed.** The only interface left is search: a native search field on top of the page.
  Feed-like pages (`/`, `/home.php`, stories, watch, reels, marketplace, gaming) are never
  shown — the app jumps back to search.
- **Limited scrolling.** Every page can only be scrolled a configurable number of screens
  (Settings, default 3), so results can't turn into an endless stream.
- No accounts / logout UI, no notification scraping, no injected themes.

## Build
With the Sailfish SDK (or the `coderus/sailfishos-platform-sdk` Docker image):

```
mb2 -t SailfishOS-5.2.0.15-aarch64 build
```

Requires Sailfish OS 4.4+ (`sailfish-components-webview-qt5`, Sailjail `Internet;WebView`).

## License
GNU General Public License v3.0. Based on the original Sailbook by Dylan Van Assche and contributors.
