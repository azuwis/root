/* Flashblock plugin.
 *
 * @author  Kris Maglione
 * @version .5
 */

if ("noscriptOverlay" in window)
    noscriptOverlay.safeAllow("chrome-data:", true, false);

options.add(["flashblock", "fb"],
    "Enable blocking of flash animations",
    "boolean", true,
    { setter: reload });
options.add(["fbwhitelist", "fbw"],
    "Sites which may run flash animations without prompting",
    "stringlist", "",
    { setter: reload });
commands.add(["flashplay"],
    "Play all flash animations on the current page",
    function () { content.postMessage("flashblockPlay", "*") },
    { argCount: "0" });
commands.add(["flashstop"],
    "Stop all flash animations on the current page",
    function () { content.postMessage("flashblockStop", "*") },
    { argCount: "0" });
var enabled = options.get("fb");
var whitelist = options.get("fbw");
function reload(value) {
    for (let [,t] in tabs.browsers)
        t.contentWindow.postMessage("flashblockReload", "*");
    return util.Array.uniq(String.toLowerCase(value).split(",").filter(function (f) f)).join(",");
}

function matchHost(host, base) {
    let idx = host.lastIndexOf(base);
    return idx > -1 && idx + base.length == host.length && (idx == 0 || host[idx-1] == ".");
}
function removeHost(host) {
    let oldval = whitelist.value;
    whitelist.setValues(whitelist.values.filter(function (h) !matchHost(host, h)));
    return whitelist.value != oldval;
}
function checkLoadFlash(e) {
    let host = e.target.domain.toLowerCase();
    if(!enabled.value || whitelist.value.split(",").some(function (h) matchHost(host, h)))
        e.preventDefault();
    e.stopPropagation();
}

mappings.add([modes.NORMAL], ["e"],
    "Add the current site to the flash whitelist",
    function () { whitelist.op("+", content.location.hostname) });
mappings.add([modes.NORMAL], ["E"],
    "Toggle the current site in the flash whitelist",
    function () {
        let host = content.location.hostname.toLowerCase();
        if (!removeHost(host))
            whitelist.op("+", host);
    });

if (!liberator.plugins.checkLoadFlash)
    window.addEventListener("flashblockCheckLoad", function (e) liberator.plugins.checkLoadFlash(e), true, true);
liberator.plugins.checkLoadFlash = checkLoadFlash;

XML.ignoreWhitespace = true;
XML.prettyPrinting = false;
var data = {
    bindings: "chrome-data:text/xml," + encodeURIComponent('<?xml version="1.0"?>' +
      <e4x>
        <bindings
           xmlns="http://www.mozilla.org/xbl"
           xmlns:xbl="http://www.mozilla.org/xbl"
           xmlns:html="http://www.w3.org/1999/xhtml">
        
          <binding id="flash">
            <implementation>
              <constructor>
                  <![CDATA[
                  function myObj(obj) {
                      return {
                          __noSuchMethod__: function(id, args) {
                              this[id] = Components.lookupMethod(obj, id);
                              return this[id].apply(obj, args);
                          }
                      }
                  };
                  var myDocument = myObj(document);
                  var myWindow = myObj(window);
                  function copyAttribs(to, from) {
                      Array.forEach(from.attributes, function(attrib) {
                          to.setAttribute(attrib.name, attrib.value);
                      });
                  }
                  function Placeholder(embed) {
                      var self = this;
                      this.embed = embed;

                      this.div = myDocument.createElement('pseudoembed');
                      this.div.addEventListener("click", function() { self.showEmbed(true) }, true);
                  }
                  Placeholder.prototype = {
                      showEmbed: function(clicked) {
                          this.embed.clicked = clicked;
                          if (this.embed.parentNode)
                                  return;
                          copyAttribs(this.embed, this.div);
                          this.div.parentNode.replaceChild(this.embed, this.div);
                      },
                      hideEmbed: function() {
                          var self = this;
                          let embed = this.embed;
                          let parent = embed.parentNode;
                          if (!parent)
                              return;

                          this.div.setAttribute("embedtype", embed.flashblockType);
                          copyAttribs(this.div, this.embed);

                          ['width', 'height'].forEach(function(dimen) {
                             if(embed[dimen])
                                 self.div.style[dimen] = /%$/.test(embed[dimen]) ?
                                          embed[dimen] :
                                          parseInt(embed[dimen]) + "px";
                          });

                          let style = window.getComputedStyle(parent, "");
                          if (style.getPropertyValue("text-align") == "center") {
                              this.div.style.marginRight = "auto";
                              this.div.style.marginLeft = "auto";
                          }
                
                          parent.replaceChild(this.div, this.embed);
                      }
                }

                var parent = this.parentNode
                var self = this;
                this.setAttribute("flashblock", true);
                if (this.placeholder || parent.placeholder)
                    return;
                this.placeholder = new Placeholder(self);

                function checkReplace(e) {
                    if (!e || e.data == "flashblockReload") {
                        if (self.clicked)
                            return;
                        let event = myDocument.createEvent("UIEvents");
                        event.initEvent("flashblockCheckLoad", true, true);
                        myDocument.dispatchEvent(event);
                        if (event.getPreventDefault())
                            self.placeholder.showEmbed();
                        else
                            self.placeholder.hideEmbed();
                      }
                      else if (e.data == "flashblockPlay")
                          self.placeholder.showEmbed(true);
                      else if (e.data == "flashblockStop")
                          self.placeholder.hideEmbed();
                }
                checkReplace();
                myWindow.addEventListener("message", checkReplace, false);

                if(this.src == this.ownerDocument.location)
                    window.location = 'chrome-data:application/xhtml+xml,' + encodeURIComponent('<?xml version="1.0" encoding="UTF-8"?>' +
                                      '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">' +
                        <html xmlns="http://www.w3.org/1999/xhtml">
                            <head><title></title></head>
                            <body>{new XML(parent.innerHTML)}</body>
                        </html>);
                ]]>
              </constructor>
            </implementation>
          </binding>
        </bindings>
      </e4x>.*.toXMLString()),
    flash: <![CDATA[data:image/png;base64,
        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
    ]]>,
};

var CSS = <![CDATA[ /* <css> */
    /*
     * Flash Click to View by Ted Mielczarek (luser_mozilla@perilith.com)
     * Original code by Jesse Ruderman (jruderman@hmc.edu)
     * taken from http://www.squarefree.com/userstyles/xbl.html
     *
     * Change XBL binding for <object> tags, click to view flash
     */

    pseudoembed {
            display: inline-block;
            min-width: 32px !important;
            min-height: 32px !important;
            border: 1px solid #dfdfdf;
            cursor: pointer;
            overflow: hidden;
            -moz-box-sizing: border-box;
            background: url("{flash}") no-repeat center;
    }
/*
    pseudoembed:hover {
            background-image: url("{flash}");
    }
*/
    pseudoembed[embedtype=director]:hover {
            background-image: url("chrome://flashblock/content/director.png");
    }
    pseudoembed[embedtype=director]:hover {
            background-image: url("chrome://flashblock/content/authorware.png");
    }

    /*
     * Flash identifiers.
     */
    object[classid*=":D27CDB6E-AE6D-11cf-96B8-444553540000"],
    object[codebase*="swflash.cab"],
    object[data*=".swf"],
    embed[type="application/x-shockwave-flash"],
    embed[src*=".swf"],
    object[type="application/x-shockwave-flash"],
    object[src*=".swf"] {
            -moz-binding: url("{bindings}") !important;
    }
    /* TODO: Could do better. */
    /*
     * NoScript is incredibly annoying. The binding can't execute JS on
     * untrusted sites.
     */
    object[classid*=":D27CDB6E-AE6D-11cf-96B8-444553540000"]:not([flashblock]),
    object[codebase*="swflash.cab"]:not([flashblock]),
    object[data*=".swf"]:not([flashblock]),
    embed[type="application/x-shockwave-flash"]:not([flashblock]),
    embed[src*=".swf"]:not([flashblock]),
    object[type="application/x-shockwave-flash"]:not([flashblock]),
    object[src*=".swf"]:not([flashblock]) {
        /* display: none !important; */
    }

    /*
     * Java identifiers.
     */
    applet,
    object[classid*=":8AD9C840-044E-11D1-B3E9-00805F499D93"],
    object[classid^="clsid:CAFEEFAC-"],
    object[classid^="java:"],
    object[type="application/x-java-applet"],
    embed[classid*=":8AD9C840-044E-11D1-B3E9-00805F499D93"],
    embed[classid^="clsid:CAFEEFAC-"],
    embed[classid^="java:"],
    embed[type="application/x-java-applet"]
    { /* TODO: Make this work. */
         -moz-binding: none !important;
    }
]]>.toString().replace(/\{(\w+)\}/g, function($0, $1) String(data[$1]).replace(/\s+/g, ""));

storage.styles.addSheet(true, "flashblock", "*", CSS);
delete data;
delete CSS;

