.pragma library

// Sailbook — search-only wrapper around m.facebook.com.
// Everything here is plain JS so it can be unit-tested outside of Sailfish OS.

var BASE_URL = "https://m.facebook.com";
var SEARCH_URL = BASE_URL + "/search/";

// Paths that lead to a feed / endless stream of content.
// They are never shown: the app jumps back to search instead.
var BLOCKED_PATHS = [
    /^\/?$/,                    // m.facebook.com/ (news feed)
    /^\/home\.php/,
    /^\/stories/,
    /^\/watch/,
    /^\/reel/,
    /^\/reels/,
    /^\/marketplace/,
    /^\/gaming/,
    /^\/feeds?\//
];

function _parse(url) {
    var m = /^(https?):\/\/([^\/?#]+)([^?#]*)(\?[^#]*)?/.exec(String(url));
    if (!m) return null;
    return { scheme: m[1], host: m[2].toLowerCase(), path: m[3] || "/", query: m[4] || "" };
}

function isFacebookHost(host) {
    return host === "facebook.com" || /\.facebook\.com$/.test(host);
}

// true when the url is a feed-like page that must not be displayed
function isBlocked(url) {
    var u = _parse(url);
    if (!u || !isFacebookHost(u.host)) return false;
    for (var i = 0; i < BLOCKED_PATHS.length; i++) {
        if (BLOCKED_PATHS[i].test(u.path)) return true;
    }
    return false;
}

function searchUrl(query) {
    var q = String(query || "").trim();
    if (q.length === 0) return SEARCH_URL;
    return BASE_URL + "/search/top/?q=" + encodeURIComponent(q);
}

// JavaScript injected into every loaded page: caps how far the page
// can be scrolled, so search results can't turn into an endless feed.
// screens: allowed scroll depth expressed in viewport heights.
function scrollLimitScript(screens) {
    var n = Math.max(1, Math.round(Number(screens) || 3));
    return "(function(){" +
        "var screens=" + n + ";" +
        "function max(){return Math.max(0,Math.round(window.innerHeight*screens));}" +
        "function clamp(){var m=max();if(window.scrollY>m){window.scrollTo(window.scrollX,m);}}" +
        "if(window.__sailbookScroll){window.__sailbookScroll.screens=screens;clamp();return;}" +
        "window.__sailbookScroll={screens:screens};" +
        "window.addEventListener('scroll',function(){screens=window.__sailbookScroll.screens;clamp();},{passive:true});" +
        "window.addEventListener('resize',clamp,{passive:true});" +
        "clamp();" +
        "})();";
}
