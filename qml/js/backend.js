.pragma library

// Search backend for Sailbook.
//
// The app only ever *searches*: there is no feed function here on purpose.
//
// Right now the only provider is a MOCK that generates clearly fictional
// sample results, so the native UI can be shown without a Facebook account.
// Result objects follow the shapes of facebook-gql-scraper's models
// (Profile / Post / Group), so a real provider can be plugged in later
// behind the same `search()` call.

var FILTERS = ["all", "profile", "post", "group"];

var _first = ["Alex", "Bea", "Chris", "Dana", "Eli", "Finn", "Gina", "Hugo", "Iris", "Jules"];
var _last = ["Example", "Sample", "Mockup", "Placeholder", "Demo"];
var _cities = ["Kraków", "Gdańsk", "Poznań", "Wrocław", "Helsinki", "Tampere", "Turku"];
var _posts = [
    "Looking for good cycling routes nearby. Any tips?",
    "Club meeting on Thursday at 18:00, newcomers welcome.",
    "Selling my old Sailfish OS phone, works perfectly.",
    "Photos from yesterday's concert are in the group album.",
    "Does anyone know a good bike mechanic in the centre?"
];

// Small deterministic PRNG so the same query always gives the same results.
function _rng(seed) {
    var s = seed >>> 0;
    return function () {
        s = (s * 1664525 + 1013904223) >>> 0;
        return s / 4294967296;
    };
}

function _hash(text) {
    var h = 2166136261;
    for (var i = 0; i < text.length; i++) {
        h ^= text.charCodeAt(i);
        h = (h * 16777619) >>> 0;
    }
    return h;
}

function _pick(r, list) {
    return list[Math.floor(r() * list.length)];
}

function _count(r, max) {
    var n = Math.floor(r() * max);
    return n >= 1000 ? (n / 1000).toFixed(1) + "K" : String(n);
}

function _make(type, q, i, r) {
    var id = "mock-" + type + "-" + i;
    if (type === "profile") {
        var name = _pick(r, _first) + " " + _pick(r, _last);
        return {
            type: "profile", id: id, name: name,
            subtitle: _pick(r, _cities) + " · " + _count(r, 5000) + " followers",
            text: "Sample profile matching \u201c" + q + "\u201d.",
            isVerified: r() < 0.15
        };
    }
    if (type === "group") {
        return {
            type: "group", id: id,
            name: q.charAt(0).toUpperCase() + q.slice(1) + " – " + _pick(r, _cities),
            subtitle: (r() < 0.5 ? "Public group" : "Private group") + " · " + _count(r, 20000) + " members",
            text: "Sample group about \u201c" + q + "\u201d.",
            isVerified: false
        };
    }
    return {
        type: "post", id: id,
        name: _pick(r, _first) + " " + _pick(r, _last),
        subtitle: (1 + Math.floor(r() * 23)) + "h ago · " + _count(r, 900) + " reactions",
        text: "#" + q.replace(/\s+/g, "") + " " + _pick(r, _posts),
        isVerified: false
    };
}

// Returns at most `limit` results for `query`. Empty query -> no results
// (there is no default content / feed).
function search(query, filter, limit) {
    var q = String(query || "").trim();
    if (q.length === 0) return [];
    if (FILTERS.indexOf(filter) < 0) filter = "all";
    var max = Math.max(1, Math.round(Number(limit) || 1));
    var r = _rng(_hash(q.toLowerCase() + "|" + filter));
    var types = filter === "all" ? ["profile", "group", "post"] : [filter];
    // The mock pretends there are always more results than the limit allows,
    // so the "limit reached" end of the list is visible.
    var available = max + 5;
    var out = [];
    for (var i = 0; i < available && out.length < max; i++) {
        out.push(_make(types[i % types.length], q, i, r));
    }
    return out;
}

function initials(name) {
    // Only words that start with a letter or digit (skips "–" and the like).
    var parts = String(name || "").split(/\s+/).filter(function (w) { return /^[\w\u00C0-\u024F]/.test(w) });
    if (parts.length === 0) return "?";
    return (parts[0].charAt(0) + (parts.length > 1 ? parts[1].charAt(0) : "")).toUpperCase();
}
