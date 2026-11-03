.pragma library

// The three classic Sailbook themes: 0 = Ambience, 1 = Facebook, 2 = Night.
// `ambience` holds Silica's Theme colours for theme 0.

function bar(index, ambience) {
    return [ambience.highlightDimmerColor, "#3b5998", "#191919"][index] || ambience.highlightDimmerColor;
}

function barHighlight(index, ambience) {
    return [ambience.highlightBackgroundColor, "#6778c9", "#292929"][index] || ambience.highlightBackgroundColor;
}

function icon(index, ambience) {
    return [ambience.primaryColor, "#f7f7f7", "#aaaaaa"][index] || ambience.primaryColor;
}
