/* Show the feed-button in the statusbar From http://vimperator.org/trac/ticket/17 */
(function(){
    var feedPanel = document.createElement("statusbarpanel");
    feedPanel.setAttribute("id", "feed-panel-clone");
    feedPanel.appendChild(document.getElementById("feed-button"));
    feedPanel.firstChild.setAttribute("style", "padding: 0; max-height: 16px;");
    document.getElementById("status-bar")
            .insertBefore(feedPanel, document.getElementById("abp-status"));
})();
