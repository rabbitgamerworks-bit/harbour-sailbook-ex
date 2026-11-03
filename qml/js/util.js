function getHighlightBackgroundColor(index) {
    switch(index) {
    case 0:
        return Theme.secondaryHighlightColor;
    case 1:
        return "#6778c9";
    case 2:
        return "#292929";
    }
}

function getBackgroundColor(index) {
    switch(index) {
    case 0:
        return Theme.secondaryHighlightColor;
    case 1:
        return "#3b5998";
    case 2:
        return "#191919";
    }
}

function getHighlightColor(index) {
    switch(index) {
    case 0:
        return Theme.highlightColor;
    case 1:
        return "#6778c9";
    case 2:
        return "#696969";
    }
}

function getPrimaryColor(index) {
    switch(index) {
    case 0:
        return Theme.primaryColor;
    case 1:
        return "#f7f7f7";
    case 2:
        return "#AAAAAA";
    }
}

function getMenubarItems() { // Count how many elements we have in our menu bar
    // Messages, notifications, events, groups and the Facebook settings
    // button are gone in this fork (no account, nothing addictive).
    var numberOfItems = (settings.placeBack==1 && fbWebview.canGoBack) + settings.showFeed + settings.showFriends + settings.showSearch + settings.showLikedPages;
    return Math.max(1, numberOfItems);
}

// Colours of the page content. The original Sailbook showed the Facebook
// mobile site inside; with the Ambience and Facebook themes it stayed white,
// the night theme (sailbook-theme-night.css) made it dark.
function getPagePalette(index) {
    if (index == 2) {
        return { page: "#191919", card: "#191919", text: "#ffffff", secondary: "#AAAAAA",
                 link: "#5890ff", separator: "#444444", field: "#333333" };
    }
    return { page: "#e9ebee", card: "#ffffff", text: "#1d2129", secondary: "#90949c",
             link: "#365899", separator: "#dddfe2", field: "#f5f6f7" };
}
