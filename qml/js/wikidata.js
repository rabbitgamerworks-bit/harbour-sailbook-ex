.pragma library

// Account-free search for Facebook pages and profiles.
//
// Facebook itself only lets logged-in users search. Wikidata, however,
// records the Facebook username (property P2013) of many organisations and
// public people, together with a description, picture, website, etc.
// One SPARQL request to the public Wikidata Query Service finds entities
// that match the query AND have a Facebook page. No account, no scraping,
// no user-agent tricks. Data: Wikidata (CC0), pictures: Wikimedia Commons.
//
// This file is plain JS (no Qt APIs) so it can be unit-tested with node.

var ENDPOINT = "https://query.wikidata.org/sparql";
var USER_AGENT = "Sailbook/13 (Sailfish OS; https://github.com/rabbitgamerworks-bit/harbour-sailbook-ex)";
var FILTERS = ["all", "profile", "page"];
var THUMB_WIDTH = 250;   // Commons only serves standard thumbnail widths

function _sparqlString(text) {
    return '"' + String(text).replace(/\\/g, "\\\\").replace(/"/g, '\\"')
                             .replace(/[\r\n\t]+/g, " ") + '"';
}

function buildQuery(query, filter, limit, language) {
    return _query(String(query).trim() + " haswbstatement:P2013", filter, limit, language);
}

function _query(srsearch, filter, limit, language) {
    var lang = language && /^[a-z-]+$/.test(language) ? language + ",en" : "en";
    var max = Math.max(1, Math.min(50, Math.round(Number(limit) || 1)));
    // Ask for more than needed: some hits get filtered out below.
    var fetch = Math.min(50, max * 2);
    var humanFilter = filter === "profile" ? "FILTER(?human)" : filter === "page" ? "FILTER(!?human)" : "";
    return [
        "SELECT ?item ?itemLabel ?itemDescription ?fb ?img ?logo ?web ?inception ?typeLabel ?placeLabel ?human ?ord WHERE {",
        "  SERVICE wikibase:mwapi {",
        '    bd:serviceParam wikibase:api "Search"; wikibase:endpoint "www.wikidata.org";',
        "                    mwapi:srsearch " + _sparqlString(srsearch) + "; mwapi:srlimit \"" + fetch + "\".",
        "    ?item wikibase:apiOutputItem mwapi:title. ?ord wikibase:apiOrdinal true.",
        "  }",
        "  ?item wdt:P2013 ?fb.",
        "  OPTIONAL { ?item wdt:P18 ?img. } OPTIONAL { ?item wdt:P154 ?logo. } OPTIONAL { ?item wdt:P856 ?web. }",
        "  OPTIONAL { ?item wdt:P571 ?inception. } OPTIONAL { ?item wdt:P31 ?type. } OPTIONAL { ?item wdt:P131 ?place. }",
        "  BIND(EXISTS { ?item wdt:P31 wd:Q5 } AS ?human)",
        "  " + humanFilter,
        '  SERVICE wikibase:label { bd:serviceParam wikibase:language "' + lang + '". }',
        "} ORDER BY ?ord"
    ].join("\n");
}

function buildUrl(query, filter, limit, language) {
    return ENDPOINT + "?format=json&query=" + encodeURIComponent(buildQuery(query, filter, limit, language));
}

// ---------------------------------------------------------------------------
// Facebook links -> Facebook page address (username) -> Wikidata.
//
// The only thing Sailbook ever reads from facebook.com is the address of the
// page a pasted link belongs to. For a direct page link it is in the link
// itself (no request at all). Only share links (facebook.com/share/...,
// fb.me, fb.watch...) need ONE request without login and without cookies,
// and from the answer only the public page address and name are used.
// ---------------------------------------------------------------------------

var FB_HOST = /^(https?:\/\/)?([a-z0-9-]+\.)*(facebook\.com|fb\.com|fb\.me|fb\.watch)(\/|$)/i;
// First path parts that are not page addresses.
var FB_NOT_A_PAGE = ["share", "sharer", "sharer.php", "story.php", "permalink.php", "photo", "photo.php",
    "photos", "video.php", "videos", "watch", "reel", "reels", "groups", "events", "login", "login.php",
    "l.php", "home.php", "search", "hashtag", "messages", "notifications", "marketplace", "gaming",
    "stories", "dialog", "plugins", "help", "policies", "privacy", "settings", "friends", "bookmarks"];

function isFacebookLink(text) {
    return FB_HOST.test(String(text || "").trim());
}

// Page address from a Facebook URL, or "" when the link has to be resolved.
function facebookUsername(url) {
    var t = String(url || "").trim();
    if (!/^https?:\/\//i.test(t)) t = "https://" + t;
    var m = /^https?:\/\/([^\/?#]+)([^?#]*)(\?[^#]*)?/i.exec(t);
    if (!m || !FB_HOST.test(m[1] + "/")) return "";
    if (/(^|\.)(fb\.me|fb\.watch)$/i.test(m[1])) return "";
    var parts = m[2].split("/").filter(function (x) { return x.length > 0 });
    var query = m[3] || "";
    if (parts.length === 0) return "";
    var first = decodeURIComponent(parts[0]);
    if (first === "profile.php") {
        var id = /[?&]id=(\d+)/.exec(query);
        return id ? id[1] : "";
    }
    if (first === "people" && parts.length >= 3 && /^\d+$/.test(parts[2])) return parts[2];
    if (first === "pages" && parts.length >= 3 && /^\d+$/.test(parts[parts.length - 1])) return parts[parts.length - 1];
    if (FB_NOT_A_PAGE.indexOf(first.toLowerCase()) >= 0) return "";
    return /^[A-Za-z0-9.\-]{2,80}$/.test(first) ? first : "";
}

function _decodeEntities(text) {
    return String(text)
        .replace(/&#x([0-9a-f]+);/gi, function (m, h) { return String.fromCodePoint ? String.fromCodePoint(parseInt(h, 16)) : String.fromCharCode(parseInt(h, 16)) })
        .replace(/&#(\d+);/g, function (m, d) { return String.fromCodePoint ? String.fromCodePoint(parseInt(d, 10)) : String.fromCharCode(parseInt(d, 10)) })
        .replace(/&quot;/g, '"').replace(/&apos;/g, "'").replace(/&#039;/g, "'")
        .replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&amp;/g, "&");
}

function _meta(html, property) {
    var re = new RegExp('<meta[^>]+property="' + property + '"[^>]+content="([^"]*)"', "i");
    var m = re.exec(html);
    return m ? _decodeEntities(m[1]) : "";
}

// Reads only the page address and the page name from a public Facebook page.
function parseFacebookPage(html) {
    var url = _meta(html, "og:url");
    var title = _meta(html, "og:title").replace(/\s+\|.*$/, "").trim();
    return { username: facebookUsername(url), title: title };
}

// Wikidata entities whose Facebook address (P2013) is exactly `username`.
function buildLookupUrl(username, language) {
    return ENDPOINT + "?format=json&query=" + encodeURIComponent(
        _query("haswbstatement:P2013=" + String(username).replace(/[^A-Za-z0-9.\-]/g, ""), "all", 5, language));
}

// Wikidata entries that match a page name but have no Facebook address yet:
// the place where the address could be added.
function buildCandidatesUrl(name, language) {
    var lang = language && /^[a-z-]+$/.test(language) ? language : "en";
    var clean = String(name).replace(/["\u201c\u201d\u201e\u00ab\u00bb]/g, "").replace(/\s+/g, " ").trim();
    var q = [
        "SELECT ?item ?itemLabel ?itemDescription ?ord WHERE {",
        "  SERVICE wikibase:mwapi {",
        '    bd:serviceParam wikibase:api "EntitySearch"; wikibase:endpoint "www.wikidata.org";',
        "                    mwapi:search " + _sparqlString(clean) + '; mwapi:language "' + lang + '".',
        "    ?item wikibase:apiOutputItem mwapi:item. ?ord wikibase:apiOrdinal true.",
        "  }",
        "  FILTER NOT EXISTS { ?item wdt:P2013 ?fb }",
        '  SERVICE wikibase:label { bd:serviceParam wikibase:language "' + lang + ',en". }',
        "} ORDER BY ?ord LIMIT 3"
    ].join("\n");
    return ENDPOINT + "?format=json&query=" + encodeURIComponent(q);
}

function parseCandidates(json) {
    var data = typeof json === "string" ? JSON.parse(json) : json;
    var rows = (data && data.results && data.results.bindings) || [];
    return rows.map(function (b) {
        var id = _v(b, "item").replace(/^.*\//, "");
        return { id: id, label: _v(b, "itemLabel") || id, description: _v(b, "itemDescription"),
                 url: "https://www.wikidata.org/wiki/" + id };
    });
}

// Sailbook never links to Meta services (no login screens, no tracking).
function _isMeta(url) {
    return /^https?:\/\/([^\/]*\.)?(facebook\.com|fb\.com|fb\.me|messenger\.com|instagram\.com|threads\.net|meta\.com|whatsapp\.com)(\/|$)/i.test(String(url));
}

// True when the search text is a link to a Meta service (e.g. a pasted
// facebook.com/share/... link). Sailbook never opens those.
function isMetaLink(text) {
    var t = String(text || "").trim();
    if (!/^https?:\/\//i.test(t)) t = "https://" + t;
    return _isMeta(t);
}

function _v(binding, key) {
    return binding[key] ? String(binding[key].value) : "";
}

// Commons file name from a Special:FilePath URL.
function fileName(filePathUrl) {
    var m = /Special:FilePath\/(.+)$/.exec(String(filePathUrl || ""));
    return m ? decodeURIComponent(m[1]).replace(/ /g, "_") : "";
}

// Direct thumbnail URL (no redirect, Qt 5.6 images don't follow redirects).
// md5 is a function returning the hex MD5 of a UTF-8 string (Qt.md5 in QML).
function thumbUrl(filePathUrl, md5) {
    var name = fileName(filePathUrl);
    if (!name || typeof md5 !== "function") return "";
    var h = md5(name);
    var enc = encodeURIComponent(name);
    var thumb = THUMB_WIDTH + "px-" + enc + (/\.(svg|tiff?|pdf)$/i.test(name) ? ".png" : "");
    return "https://upload.wikimedia.org/wikipedia/commons/thumb/" + h.charAt(0) + "/" + h.substr(0, 2) + "/" + enc + "/" + thumb;
}

// Turns the SPARQL JSON into a de-duplicated list of results, in search order.
function parse(json, md5, limit) {
    var data = typeof json === "string" ? JSON.parse(json) : json;
    var rows = (data && data.results && data.results.bindings) || [];
    var byId = {}, out = [];
    for (var i = 0; i < rows.length; i++) {
        var b = rows[i];
        var id = _v(b, "item").replace(/^.*\//, "");
        if (!id) continue;
        var r = byId[id];
        if (!r) {
            var human = _v(b, "human") === "true";
            var year = /^(-?\d+)-/.exec(_v(b, "inception"));
            r = byId[id] = {
                type: human ? "profile" : "page",
                id: id,
                name: _v(b, "itemLabel") || id,
                description: _v(b, "itemDescription"),
                facebook: _v(b, "fb"),
                website: _isMeta(_v(b, "web")) ? "" : _v(b, "web"),
                founded: year ? String(Number(year[1])) : "",
                category: "",
                place: _v(b, "placeLabel"),
                picture: thumbUrl(_v(b, "logo") || _v(b, "img"), md5),
                cover: thumbUrl(_v(b, "img"), md5),
                wikidataUrl: "https://www.wikidata.org/wiki/" + id
            };
            out.push(r);
        }
        // Keep the first readable type label (skip raw Q-ids).
        var t = _v(b, "typeLabel");
        if (!r.category && t && !/^Q\d+$/.test(t)) r.category = t;
    }
    var max = Math.max(1, Math.round(Number(limit) || out.length || 1));
    return out.slice(0, max);
}

function subtitle(r) {
    var parts = [];
    if (r.category) parts.push(r.category.charAt(0).toUpperCase() + r.category.slice(1));
    if (r.place) parts.push(r.place);
    return parts.join(" · ");
}

function initials(name) {
    var parts = String(name || "").split(/\s+/).filter(function (w) { return /^[\wÀ-ɏ]/.test(w) });
    if (parts.length === 0) return "?";
    return (parts[0].charAt(0) + (parts.length > 1 ? parts[1].charAt(0) : "")).toUpperCase();
}
