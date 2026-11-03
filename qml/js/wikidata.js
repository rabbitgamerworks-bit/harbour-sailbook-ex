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
    var lang = language && /^[a-z-]+$/.test(language) ? language + ",en" : "en";
    var max = Math.max(1, Math.min(50, Math.round(Number(limit) || 1)));
    // Ask for more than needed: some hits get filtered out below.
    var fetch = Math.min(50, max * 2);
    var humanFilter = filter === "profile" ? "FILTER(?human)" : filter === "page" ? "FILTER(!?human)" : "";
    return [
        "SELECT ?item ?itemLabel ?itemDescription ?fb ?img ?logo ?web ?inception ?typeLabel ?placeLabel ?human ?ord WHERE {",
        "  SERVICE wikibase:mwapi {",
        '    bd:serviceParam wikibase:api "Search"; wikibase:endpoint "www.wikidata.org";',
        "                    mwapi:srsearch " + _sparqlString(String(query).trim() + " haswbstatement:P2013") + "; mwapi:srlimit \"" + fetch + "\".",
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

// Sailbook never links to Meta services (no login screens, no tracking).
function _isMeta(url) {
    return /^https?:\/\/([^\/]*\.)?(facebook\.com|fb\.com|fb\.me|messenger\.com|instagram\.com|threads\.net|meta\.com|whatsapp\.com)(\/|$)/i.test(String(url));
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
