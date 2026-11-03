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
