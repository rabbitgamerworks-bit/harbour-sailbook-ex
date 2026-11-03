.pragma library

// The three classic Sailbook themes, colours taken from the original
// sailbook-theme-*.css files and util.js:
//   0 = Ambience, 1 = Facebook (default, as in the store screenshots), 2 = Night.
// `ambience` is Silica's Theme object (used by theme 0).

function palette(index, ambience) {
    if (index === 2) return {
        bar: "#191919", barHighlight: "#292929", page: "#191919", card: "#333333",
        text: "#ffffff", secondary: "#aaaaaa", link: "#5890ff", separator: "#444444",
        field: "#333333", fieldText: "#ffffff"
    };
    if (index === 0) return {
        bar: ambience.secondaryHighlightColor, barHighlight: ambience.highlightBackgroundColor,
        page: "transparent", card: "transparent",
        text: ambience.primaryColor, secondary: ambience.secondaryColor, link: ambience.highlightColor,
        separator: ambience.rgba(ambience.primaryColor, 0.2),
        field: ambience.rgba(ambience.primaryColor, 0.15), fieldText: ambience.primaryColor
    };
    return {
        bar: "#3b5998", barHighlight: "#6778c9", page: "#e9ebee", card: "#ffffff",
        text: "#1d2129", secondary: "#90949c", link: "#365899", separator: "#dddfe2",
        field: "#ffffff", fieldText: "#1d2129"
    };
}
