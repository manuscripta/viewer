(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){

'use strict';

(function() {

var global = this
  , addEventListener = 'addEventListener'
  , removeEventListener = 'removeEventListener'
  , getBoundingClientRect = 'getBoundingClientRect'
  , isIE8 = global.attachEvent && !global[addEventListener]
  , document = global.document

  , calc = (function () {
        var el
          , prefixes = ["", "-webkit-", "-moz-", "-o-"]

        for (var i = 0; i < prefixes.length; i++) {
            el = document.createElement('div')
            el.style.cssText = "width:" + prefixes[i] + "calc(9px)"

            if (el.style.length) {
                return prefixes[i] + "calc"
            }
        }
    })()
  , elementOrSelector = function (el) {
        if (typeof el === 'string' || el instanceof String) {
            return document.querySelector(el)
        } else {
            return el
        }
    }

  , Split = function (ids, options) {
    var dimension
      , i
      , clientDimension
      , clientAxis
      , position
      , gutterClass
      , paddingA
      , paddingB
      , pairs = []

    // Set defaults

    options = typeof options !== 'undefined' ?  options : {}

    if (typeof options.gutterSize === 'undefined') options.gutterSize = 10
    if (typeof options.minSize === 'undefined') options.minSize = 100
    if (typeof options.snapOffset === 'undefined') options.snapOffset = 30
    if (typeof options.direction === 'undefined') options.direction = 'horizontal'

    if (options.direction == 'horizontal') {
        dimension = 'width'
        clientDimension = 'clientWidth'
        clientAxis = 'clientX'
        position = 'left'
        gutterClass = 'gutter gutter-horizontal'
        paddingA = 'paddingLeft'
        paddingB = 'paddingRight'
        if (!options.cursor) options.cursor = 'ew-resize'
    } else if (options.direction == 'vertical') {
        dimension = 'height'
        clientDimension = 'clientHeight'
        clientAxis = 'clientY'
        position = 'top'
        gutterClass = 'gutter gutter-vertical'
        paddingA = 'paddingTop'
        paddingB = 'paddingBottom'
        if (!options.cursor) options.cursor = 'ns-resize'
    }

    // Event listeners for drag events, bound to a pair object.
    // Calculate the pair's position and size when dragging starts.
    // Prevent selection on start and re-enable it when done.

    var startDragging = function (e) {
            var self = this
              , a = self.a
              , b = self.b

            if (!self.dragging && options.onDragStart) {
                options.onDragStart()
            }

            e.preventDefault()

            self.dragging = true
            self.move = drag.bind(self)
            self.stop = stopDragging.bind(self)

            global[addEventListener]('mouseup', self.stop)
            global[addEventListener]('touchend', self.stop)
            global[addEventListener]('touchcancel', self.stop)

            self.parent[addEventListener]('mousemove', self.move)
            self.parent[addEventListener]('touchmove', self.move)

            a[addEventListener]('selectstart', preventSelection)
            a[addEventListener]('dragstart', preventSelection)
            b[addEventListener]('selectstart', preventSelection)
            b[addEventListener]('dragstart', preventSelection)

            a.style.userSelect = 'none'
            a.style.webkitUserSelect = 'none'
            a.style.MozUserSelect = 'none'
            a.style.pointerEvents = 'none'

            b.style.userSelect = 'none'
            b.style.webkitUserSelect = 'none'
            b.style.MozUserSelect = 'none'
            b.style.pointerEvents = 'none'

            self.gutter.style.cursor = options.cursor
            self.parent.style.cursor = options.cursor

            calculateSizes.call(self)
        }
      , stopDragging = function () {
            var self = this
              , a = self.a
              , b = self.b

            if (self.dragging && options.onDragEnd) {
                options.onDragEnd()
            }

            self.dragging = false

            global[removeEventListener]('mouseup', self.stop)
            global[removeEventListener]('touchend', self.stop)
            global[removeEventListener]('touchcancel', self.stop)

            self.parent[removeEventListener]('mousemove', self.move)
            self.parent[removeEventListener]('touchmove', self.move)

            delete self.stop
            delete self.move

            a[removeEventListener]('selectstart', preventSelection)
            a[removeEventListener]('dragstart', preventSelection)
            b[removeEventListener]('selectstart', preventSelection)
            b[removeEventListener]('dragstart', preventSelection)

            a.style.userSelect = ''
            a.style.webkitUserSelect = ''
            a.style.MozUserSelect = ''
            a.style.pointerEvents = ''

            b.style.userSelect = ''
            b.style.webkitUserSelect = ''
            b.style.MozUserSelect = ''
            b.style.pointerEvents = ''

            self.gutter.style.cursor = ''
            self.parent.style.cursor = ''
        }
      , drag = function (e) {
            var offset

            if (!this.dragging) return

            // Get the relative position of the event from the first side of the
            // pair.

            if ('touches' in e) {
                offset = e.touches[0][clientAxis] - this.start
            } else {
                offset = e[clientAxis] - this.start
            }

            // If within snapOffset of min or max, set offset to min or max

            if (offset <=  this.aMin + options.snapOffset) {
                offset = this.aMin
            } else if (offset >= this.size - this.bMin - options.snapOffset) {
                offset = this.size - this.bMin
            }

            adjust.call(this, offset)

            if (options.onDrag) {
                options.onDrag()
            }
        }
      , calculateSizes = function () {
            // Calculate the pairs size, and percentage of the parent size
            var computedStyle = global.getComputedStyle(this.parent)
              , parentSize = this.parent[clientDimension] - parseFloat(computedStyle[paddingA]) - parseFloat(computedStyle[paddingB])

            this.size = this.a[getBoundingClientRect]()[dimension] + this.b[getBoundingClientRect]()[dimension] + this.aGutterSize + this.bGutterSize
            this.percentage = Math.min(this.size / parentSize * 100, 100)
            this.start = this.a[getBoundingClientRect]()[position]
        }
      , adjust = function (offset) {
            // A size is the same as offset. B size is total size - A size.
            // Both sizes are calculated from the initial parent percentage.

            this.a.style[dimension] = calc + '(' + (offset / this.size * this.percentage) + '% - ' + this.aGutterSize + 'px)'
            this.b.style[dimension] = calc + '(' + (this.percentage - (offset / this.size * this.percentage)) + '% - ' + this.bGutterSize + 'px)'
        }
      , fitMin = function () {
            var self = this
              , a = self.a
              , b = self.b

            if (a[getBoundingClientRect]()[dimension] < self.aMin) {
                a.style[dimension] = (self.aMin - self.aGutterSize) + 'px'
                b.style[dimension] = (self.size - self.aMin - self.aGutterSize) + 'px'
            } else if (b[getBoundingClientRect]()[dimension] < self.bMin) {
                a.style[dimension] = (self.size - self.bMin - self.bGutterSize) + 'px'
                b.style[dimension] = (self.bMin - self.bGutterSize) + 'px'
            }
        }
      , fitMinReverse = function () {
            var self = this
              , a = self.a
              , b = self.b

            if (b[getBoundingClientRect]()[dimension] < self.bMin) {
                a.style[dimension] = (self.size - self.bMin - self.bGutterSize) + 'px'
                b.style[dimension] = (self.bMin - self.bGutterSize) + 'px'
            } else if (a[getBoundingClientRect]()[dimension] < self.aMin) {
                a.style[dimension] = (self.aMin - self.aGutterSize) + 'px'
                b.style[dimension] = (self.size - self.aMin - self.aGutterSize) + 'px'
            }
        }
      , balancePairs = function (pairs) {
            for (var i = 0; i < pairs.length; i++) {
                calculateSizes.call(pairs[i])
                fitMin.call(pairs[i])
            }

            for (i = pairs.length - 1; i >= 0; i--) {
                calculateSizes.call(pairs[i])
                fitMinReverse.call(pairs[i])
            }
        }
      , preventSelection = function () { return false }
      , parent = elementOrSelector(ids[0]).parentNode

    if (!options.sizes) {
        var percent = 100 / ids.length

        options.sizes = []

        for (i = 0; i < ids.length; i++) {
            options.sizes.push(percent)
        }
    }

    if (!Array.isArray(options.minSize)) {
        var minSizes = []

        for (i = 0; i < ids.length; i++) {
            minSizes.push(options.minSize)
        }

        options.minSize = minSizes
    }

    for (i = 0; i < ids.length; i++) {
        var el = elementOrSelector(ids[i])
          , isFirst = (i == 1)
          , isLast = (i == ids.length - 1)
          , size
          , gutterSize = options.gutterSize
          , pair

        if (i > 0) {
            pair = {
                a: elementOrSelector(ids[i - 1]),
                b: el,
                aMin: options.minSize[i - 1],
                bMin: options.minSize[i],
                dragging: false,
                parent: parent,
                isFirst: isFirst,
                isLast: isLast,
                direction: options.direction
            }

            // For first and last pairs, first and last gutter width is half.

            pair.aGutterSize = options.gutterSize
            pair.bGutterSize = options.gutterSize

            if (isFirst) {
                pair.aGutterSize = options.gutterSize / 2
            }

            if (isLast) {
                pair.bGutterSize = options.gutterSize / 2
            }
        }

        // IE9 and above
        if (!isIE8) {
            if (i > 0) {
                var gutter = document.createElement('div')

                gutter.className = gutterClass
                gutter.style[dimension] = options.gutterSize + 'px'

                gutter[addEventListener]('mousedown', startDragging.bind(pair))
                gutter[addEventListener]('touchstart', startDragging.bind(pair))

                parent.insertBefore(gutter, el)

                pair.gutter = gutter
            }

            if (i === 0 || i == ids.length - 1) {
                gutterSize = options.gutterSize / 2
            }

            if (typeof options.sizes[i] === 'string' || options.sizes[i] instanceof String) {
                size = options.sizes[i]
            } else {
                size = calc + '(' + options.sizes[i] + '% - ' + gutterSize + 'px)'
            }

        // IE8 and below
        } else {
            if (typeof options.sizes[i] === 'string' || options.sizes[i] instanceof String) {
                size = options.sizes[i]
            } else {
                size = options.sizes[i] + '%'
            }
        }

        el.style[dimension] = size

        if (i > 0) {
            pairs.push(pair)
        }
    }

    balancePairs(pairs)
}

if (typeof exports !== 'undefined') {
    if (typeof module !== 'undefined' && module.exports) {
        exports = module.exports = Split
    }
    exports.Split = Split
} else {
    global.Split = Split
}

}).call(window);

},{}],2:[function(require,module,exports){
'use strict';

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _$;

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

/* global $ */

var React = require('react');
var ReactDOM = require('react-dom');

var ReactTabs = require('react-tabs');
var Tabs = ReactTabs.Tabs,
    TabList = ReactTabs.TabList,
    Tab = ReactTabs.Tab,
    TabPanel = ReactTabs.TabPanel;

var Autocomplete = require('react-autocomplete');

var Split = require('split.js');

var personsData = null;
var placesData = null;
var schemaData = {};

var loadData = (_$ = $).when.apply(_$, [$.get('modules/get_persons.xql', function (data) {
    personsData = $(data.documentElement).children().get();
}), $.get('modules/get_places.xql', function (data) {
    placesData = $(data.documentElement).children().get();
})].concat(_toConsumableArray(['institution', 'repository', 'publisher', 'xmllang'].map(function (type) {
    return $.get('modules/get_schemadata.xql?type=' + type, function (data) {
        schemaData[type] = $(data.documentElement).children().get();
    });
}))));

/** Get the text of the child text nodes of the given element **/
function getImmediateText(element) {
    return $(element).contents().filter(function () {
        return this.nodeType === Node.TEXT_NODE;
    }).text().replace(/^\s*|\s*$/g, '').replace(/\s+/g, ' ');
}

function htmlEscape(str) {
    return str.replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/'/g, '&#39;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

function htmlUnescape(str) {
    return str.replace(/&quot;/g, '"').replace(/&#39;/g, "'").replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&amp;/g, '&');
}

function getAdjacentChildNodeGroups(root, pred) {
    var group = null,
        groups = [];
    for (var i = 0; i < root.childNodes.length; i++) {
        if (pred(root.childNodes[i])) {
            if (group === null) group = groups[groups.length] = [];
            group.push(root.childNodes[i]);
        } else group = null;
    }
    return groups;
}

/** Currently only supports single range selection. **/
function insertDummyTextNodesAndSelect(sel, root) {
    var a,
        o,
        range,
        dummy,
        dummyTextNodes = [];
    if (sel.rangeCount > 0) {
        range = sel.getRangeAt(0);
        // start/anchor position
        a = range.startContainer;
        o = range.startOffset;
        if ($.contains(root, a) && a.nodeType === Node.ELEMENT_NODE) {
            dummy = document.createTextNode('\0'); // some web browsers fail the selection if dummy node is an empty text node, so use a non empty un-displayable stiring string instead.
            dummyTextNodes.push(dummy);
            a.insertBefore(dummy, a.childNodes[o] || null);
            range.setStart(dummy, 0);
        }
        // end/focus position
        a = range.endContainer;
        o = range.endOffset;
        if ($.contains(root, a) && a.nodeType === Node.ELEMENT_NODE) {
            dummy = document.createTextNode('\0');
            dummyTextNodes.push(dummy);
            a.insertBefore(dummy, a.childNodes[o] || null);
            range.setEnd(dummy, 0);
        }
        sel.removeAllRanges();
        sel.addRange(range);
    }
    return dummyTextNodes;
}
/** Save the current selected ranges within the `root` element. So that the selection can be restored even after some tree modification.
 * It does this inserting dummy text nodes that are kept as references.
 * Note: restoreSelection may throw an error if any text nodes that were present in root when saveSelection was called are missing from the document.
**/
function saveSelection(root) {
    var r,
        i,
        sel = root.ownerDocument.getSelection(),
        result = {
        dummyNodes: insertDummyTextNodesAndSelect(sel, root),
        root: root,
        ranges: []
    };
    for (i = 0; i < sel.rangeCount; i++) {
        r = sel.getRangeAt(i);
        result.ranges.push({
            a: r.startContainer,
            ao: r.startOffset,
            b: r.endContainer,
            bo: r.endOffset
        });
    }
    return result;
}

function restoreSelection(saved) {
    var r,
        i,
        doc = saved.root.ownerDocument,
        sel = doc.getSelection();
    sel.removeAllRanges();
    for (i = 0; i < saved.ranges.length; i++) {
        r = doc.createRange();
        r.setStart(saved.ranges[i].a, saved.ranges[i].ao);
        r.setEnd(saved.ranges[i].b, saved.ranges[i].bo);
        sel.addRange(r);
    }
    $(saved.dummyNodes).remove();
}

/**
  Remove from Element `elem` all attributes fulfilling function `pred`.
  pred is called as such: pred(attrName, attrValue).
**/
function removeAttributes(elem, pred) {
    var attrs = elem.attributes;
    var attrsToRemove = [];
    for (var i = 0; i < attrs.length; i++) {
        if (pred(attrs[i].name, attrs[i].value)) {
            attrsToRemove.push(attrs[i].name);
        }
    }
    attrsToRemove.forEach(function (attr) {
        return elem.removeAttribute(attr);
    });
}

/**
* Using the given form data array (as returned by jquery's .serializeArray()).
* Create in the given xml document the structure described in the form array data.
* Make sure that the paths in `formArray` describe the full path including document root.
* Example usage:
* 
* formArray = [
*   {name: 'root/subelem/#text', value: 'a text node'},
*   {name: 'root/subelem/@attr', value: 'an attribute on subelem'},
*   {name: 'root/subelem#1/x', value: 'creates another element in root with the name "subelem" that contains an "x" element. This "value" string is ignored.'},
*   {name: 'root/subelem#1/y/@a', value:'true'}, 
*   {name: 'root/subelem#1/y/@b', value:''}, // empty attributes are NOT serialized to XML 
*   {name: 'root/subelem#anyidentifier/x'}, 
* ]
* 
* Will result in the following doc:
<root>
    <subelem attr='an attribute on subelem'>a text node<subelem>
    <subelem>
        <x/>
        <y a='true'/>
    </subelem>
    <subelem>
        <x/>
    </subelem>
</root>
**/
function formArrayToXml(formArray, doc) {
    var partsRe = /@?[\w-#:]+/g;
    formArray.forEach(function (formItem) {
        var parts = formItem.name.match(partsRe),
            lastPart = $(doc);
        if (parts.length > 0 && parts[0] !== doc.documentElement.nodeName) {
            throw "Invalid first part of " + formItem.name + " is " + parts[0] + ", expected " + doc.documentElement.nodeName;
        }
        for (var i = 0; i < parts.length; i++) {
            if (parts[i].charAt(0) === '@') {
                if (i !== parts.length - 1 || lastPart[0].nodeType !== Node.ELEMENT_NODE) throw "Misplaced attribute " + parts[i] + " at index " + i + " in document structure " + formItem.name;
                // Skip empty attributes...
                if (formItem.value !== '') {
                    lastPart.attr(parts[i].substring(1), formItem.value);
                }
                return;
            }
            if (parts[i] === '#text') {
                if (i !== parts.length - 1) throw "Misplaced #text in " + formItem.name;
                lastPart.append(formItem.value);
                return;
            }

            var splitted = parts[i].split('#');
            var tags = splitted.splice(1).join(' ');
            var name = splitted[0];

            var next = lastPart.children(name + (tags ? '[__tags="' + tags + '"]' : ''));
            if (next.length === 0) {
                next = $('<' + name + (tags ? ' __tags="' + tags + '"' : '') + '/>', lastPart).appendTo(lastPart);
            }
            lastPart = next;
        }
    });
    $(doc).find('[__tags]').removeAttr('__tags');
    return doc;
}

/* Sort array in place and remove duplicate items */
function sortedAndDistinct(array, comparator) {
    array.sort(comparator);
    for (var i = 1; i < array.length; i++) {
        if (array[i] === array[i - 1]) {
            array.splice(i, 1);
            i -= 1;
        }
    }
    return array;
}

function filterOnWords(string, filterString) {
    if (filterString === '') return true;
    var i = string.toLowerCase().indexOf(filterString.toLowerCase());
    return i === 0 || string.charAt(i - 1) == ' ';
}

function getData(elementPath, data) {
    var d = getDataArr(elementPath, data);
    return d.length >= 2 ? d : d[0];
}

function getDataArr(elementPath, data) {
    return $(elementPath.replace(/\//g, '>'), data).get();
}

function camelCaseToDashed(name) {
    return name.replace('-', '--').replace(/[A-Z]/g, function (m) {
        return '-' + m.toLowerCase();
    });
}

function dashedToCamelCase(name) {
    return name.replace(/-([a-z])/g, function (m, c) {
        return c.toUpperCase();
    }).replace('--', '-');
}

function nextId() {
    return nextId.counter++;
}
nextId.counter = 0;

function renderDataNodesAsInputElements(name, nodes) {
    return nodes.map(function (n, i) {
        if (n.nodeType === Node.ELEMENT_NODE) {
            var elemNameRoot = name + '/' + n.nodeName + '#' + i;
            var attrInputs = $(n.attributes).map(function (i, attr) {
                return React.createElement('input', { type: 'hidden', name: elemNameRoot + '/@' + attr.name, value: attr.value, key: nextId() });
            }).get();
            var contentsInputs = renderDataNodesAsInputElements(elemNameRoot, $(n).contents().get());
            if (contentsInputs.length > 0 || attrInputs.length > 0) return attrInputs.concat(contentsInputs);else return React.createElement('input', { type: 'hidden', name: elemNameRoot, key: nextId(), value: '' });
        } else if (n.nodeType === Node.TEXT_NODE) {
            return React.createElement('input', { type: 'hidden', name: name + '/#text', value: n.nodeValue, key: nextId() });
        } else {
            console.warn("Discarding data node of unsupported type=" + n.nodeType + ": " + n);
        }
    });
}
/* Visitor return false to stop recursing. */
function depthFirst(n, visitor) {
    if (n === null || n === undefined) return true;
    if (depthFirst(n.firstChild, visitor) === false) return false;
    if (visitor(n) === false) return false;
    return depthFirst(n.nextSibling, visitor);
}

function getNodesInRange(range) {
    var a = range.startContainer;
    var b = range.endContainer;

    if (a === b) return [a];

    var foundStart = false,
        foundEnd = false;

    var nodes = [];

    depthFirst(range.commonAncestorContainer.firstChild, function (n) {
        if (n === a) foundStart = true;
        if (n === b) foundEnd = true;
        if (foundStart) nodes.push(n);
        return !foundEnd;
    });

    if (!foundStart) throw "Did not find startNode!";
    if (!foundEnd) throw "Did not find endNode!";

    return nodes;
}

var Test = React.createClass({
    displayName: 'Test',
    render: function render() {
        return React.createElement(
            'span',
            null,
            'Hello from react!'
        );
    }
});

var ContextMenu = React.createClass({
    displayName: 'ContextMenu',

    propTypes: {
        x: React.PropTypes.number.isRequired,
        y: React.PropTypes.number.isRequired,
        items: React.PropTypes.array.isRequired
    },

    onItemClick: function onItemClick(i, item, e) {
        item.action(i, item);
        e.preventDefault();
        e.stopPropagation();
        this.unmount();
    },
    unmount: function unmount() {
        ReactDOM.unmountComponentAtNode(ReactDOM.findDOMNode(this).parentNode);
    },
    componentDidMount: function componentDidMount() {
        var _this = this;

        $(document).on('mousedown.manuscripta.editor.ContextMenu', function (e) {
            if (e.target === _this.refs.menu || $.contains(_this.refs.menu, e.target)) {
                return;
            } else {
                e.preventDefault();
                _this.unmount();
            }
        });
    },
    componentWillUnmount: function componentWillUnmount() {
        $(document).off('mousedown.manuscripta.editor.ContextMenu');
    },
    render: function render() {
        var _this2 = this;

        var style = { position: 'absolute', top: this.props.y, left: this.props.x };
        return React.createElement(
            'div',
            { ref: 'menu', className: 'editor-context-menu', style: style },
            this.props.items.map(function (item, i) {
                return item.type === 'div' ? React.createElement('hr', { key: i }) : React.createElement(
                    'div',
                    { className: 'editor-context-menu-item',
                        key: item.label,
                        onMouseDown: function onMouseDown(e) {
                            e.preventDefault();e.stopPropagation();
                        },
                        onMouseUp: _this2.onItemClick.bind(_this2, i, item) },
                    item.label
                );
            })
        );
    }
});

/**
* 
* If multiParagraph is true, this component creates separate inputs for each html paragraph (whose tag name is defined by topLevelElement) in the text area.
* If multiParagraph is false, this component creates one input element containing each html paragraph in the text area.
* The name of the elemet input(s) is defined by prop.name, such as {this.props.name + "#<paragraph-number>"}.
**/
var MyTextArea = React.createClass({
    displayName: 'MyTextArea',


    editorElements: void 0, // created in makeEditorElements, where when run, components have been declared so they can be referenced. 
    elementsByName: {},

    // Allowed sub elements. If an element name is not in this map, that element is not allowed to have any sub elements.
    editorElemTree: {
        foreign: ["ex", "unclear", "lb"],
        note: ["bibl", "date", "foreign", "hi", "idno", "list", "locus", "locusGrp", "orgName", "p", "persName", "placeName", "quote", "ref", "term"],
        quote: ["foreign", "ex", "hi", "lb", "sic", "supplied", "unclear"],
        term: ["material"]
    },

    propTypes: {
        data: React.PropTypes.oneOfType([React.PropTypes.instanceOf(Element), React.PropTypes.arrayOf(React.PropTypes.instanceOf(Element))]),
        name: React.PropTypes.string,
        multiParagraph: React.PropTypes.bool,
        topLevelElement: React.PropTypes.string, // the HTML element that is used as the top level element in the editor.
        topElems: React.PropTypes.arrayOf(React.PropTypes.string) },

    getDefaultProps: function getDefaultProps() {
        return {
            multiParagraph: true,
            topLevelElement: 'p',
            topElems: ["bibl", "date", "foreign", "idno", "locus", "note", "origDate", "origPlace", "orgName", "persName", "placeName", "quote"]
        };
    },
    getInitialState: function getInitialState() {
        return {
            //dataNodes: $(this.props.data).get().map( dataNode => $(dataNode).contents().get() ),
        };
    },
    makeEditorElements: function makeEditorElements() {
        this.editorElements = [
        //{label: 'Bibliographic citation', name: 'bibl', component: Bibl},
        { label: 'Date', name: 'date', component: DateElem }, { label: 'Expansion', name: 'ex', component: Ex }, { label: 'Foreign', name: 'foreign', component: Foreign }, { label: 'Idno', name: 'idno', component: Idno }, { label: 'Locus', name: 'locus', component: Locus },
        //{label: 'Locus Group', name: 'locusGrp', component: LocusGrp},
        { label: 'Note', name: 'note', component: Note },
        //{label: 'Number', name: 'num', component: Num},
        { label: 'Origin Date', name: 'origDate', component: OrigDate },
        //{label: 'Origin Place', name: 'origPlace', component: OrigPlace},
        //{label: 'Organization name', name: 'orgName', component: OrgName},
        { label: 'Person', name: 'persName', component: PersName }, { label: 'Place', name: 'placeName', component: PlaceName }, { label: 'Term', name: 'term', component: Term }, { label: 'Unclear', name: 'unclear', component: Unclear }];
        var _iteratorNormalCompletion = true;
        var _didIteratorError = false;
        var _iteratorError = undefined;

        try {
            for (var _iterator = this.editorElements[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
                var elm = _step.value;

                if (elm.name) {
                    this.elementsByName[elm.name] = elm;
                }
            }
        } catch (err) {
            _didIteratorError = true;
            _iteratorError = err;
        } finally {
            try {
                if (!_iteratorNormalCompletion && _iterator.return) {
                    _iterator.return();
                }
            } finally {
                if (_didIteratorError) {
                    throw _iteratorError;
                }
            }
        }
    },
    getSpanDataText: function getSpanDataText(data) {
        return $(data).text();
    },
    getDataForSpan: function getDataForSpan(span) {
        return this.editorDataToXml([span])[0];
    },
    setDataForSpan: function setDataForSpan(span, data) {
        // Update the span element's attributes and innerHTML instead of replacing the element, so references to the span are kept.
        var newSpan = $(this.renderDataNodesAsHtml([data]))[0];
        /* Update attributes. */
        removeAttributes(span, function (attr) {
            return attr.match(/^data-attr-/) && !newSpan.hasAttribute(attr);
        });
        var newAttrs = newSpan.attributes;
        for (var i = 0; i < newAttrs.length; i++) {
            span.setAttribute(newAttrs[i].name, newAttrs[i].value);
        }

        /* This clause is here so that clicking subelements wont break when we replace all the contents of a parent element.
         * It should be ok as elements that contains sub elements should not have the editor change any of its subelements, only attributes of the parent span.
         */
        if ($(span).has('span[data-elemName]')[0]) {
            if (span.innerHTML !== newSpan.innerHTML) {
                console.warn("Not applying new innerHTML to data span!");
            }
            return;
        } else {
            /* Update inner html */
            span.innerHTML = newSpan.innerHTML;
        }
    },
    applySpanEditorData: function applySpanEditorData() {
        var span = this.state.editingSpan;
        var formArray = $('*', this.refs.spanEditor).serializeArray();
        if (formArray.length === 0) {
            console.log("Not applying null editor data for " + span.getAttribute('data-elemName') + "! (editor not implemented?)");
            return;
        }
        var data = formArrayToXml(formArray, $.parseXML('<' + this.getDataForSpan(span).nodeName + '/>')).documentElement;
        // update the span element with the editor data
        this.setDataForSpan(span, data);
        console.log('applied ', data, ' to ', span);
    },
    startEditingSpan: function startEditingSpan(span) {
        if (this.state.editingSpan) {
            if (this.state.editingSpan === span) return;else this.stopEditingSpan();
        }

        $(span).addClass('selected');

        this.setState({
            editingSpan: span
        });
    },
    stopEditingSpan: function stopEditingSpan() {
        if (this.state.editingSpan) {
            $(this.state.editingSpan).removeClass('selected');
            this.applySpanEditorData();
            this.setState({ editingSpan: null });
        }
    },
    clearDataSpan: function clearDataSpan(span) {
        $(span).find('span[data-elemName]').addBack('span[data-elemName]').each(function () {
            if (this.firstChild !== null) $(this.firstChild).unwrap();else $(this).remove(); // data span is empty, just remove it.
        });
    },
    clearSelectionDataSpan: function clearSelectionDataSpan(elemNameToClear) {
        var sel = document.getSelection();
        var range = sel.getRangeAt(0);
        if (sel.isCollapsed) {
            //clearDataSpan();
        } else {

            var nodesInSelection = $(getNodesInRange(range));
            var elementNodesInSelection = nodesInSelection.map(function (i, n) {
                if (n.nodeType === Node.TEXT_NODE) return n.parentNode;else if (n.nodeType === Node.ELEMENT_NODE) return n;
            });
            $.unique(elementNodesInSelection);
            var spansToClear = elementNodesInSelection.filter('span[data-elemName=' + elemNameToClear + ']');
            if (spansToClear.length > 0) console.info("Clearing elements" + elemNameToClear + " from selection.");else console.warn("Clearing elements" + elemNameToClear + " from selection failed: no matching elements!" + elementNodesInSelection.html());

            this.clearDataSpan(spansToClear);
        }
    },
    formatContents: function formatContents(editorElement) {
        var topLevelElement = this.props.topLevelElement;
        var allowedSubLevel = 'span[data-elemName], br';

        if (!window.getSelection) console.warn("window.getSelection not supported. Please update your web browser.");
        //console.log('selection before', window.getSelection(), window.getSelection().toString());
        var selSave = saveSelection(editorElement);

        // remove any unwanted attributes on all descendants.
        $(editorElement).find('*').each(function (i, e) {
            removeAttributes(e, function (attr) {
                return !(attr.match(/^data-/) || attr === 'class' || attr === 'contenteditable');
            });
        });

        /* all contents have to be contained in top level elements (like paragraphs). */
        var nodesToWrap = getAdjacentChildNodeGroups(editorElement, function (n) {
            return !$(n).is(topLevelElement);
        });
        //console.log('Child nodes to to wrap ', nodesToWrap);
        $.each(nodesToWrap, function (i, elems) {
            // try to put in the preceding top level element, otherwise wrap elems in a new top level element.
            /*if (elems[0].previousSibling) {
                if (!(elems[0].previousSibling.nodeType === Node.ELEMENT_NODE
                      && $(elems[0].previousSibling).is(topLevelElement))) {
                    console.error("assertion error, unexpected previousSibling node ", elems[0].previousSibling);
                }
                $(elems[0].previousSibling).append(elems);
            } else*/
            $(elems).wrapAll(document.createElement(topLevelElement));
        });

        var children = $(editorElement).children(topLevelElement);
        var toRemove = $('*', editorElement).not(allowedSubLevel).not(children);
        //console.log('Elements to remove ', toRemove);
        toRemove.each(function () {
            if (this.firstChild) $(this.firstChild).unwrap();else $(this).remove();
        });

        restoreSelection(selSave);
        //console.log('selection after ', sel, sel.toString());
    },


    /*
         Event handlers
     
    */

    onDocumentClick: function onDocumentClick(evt) {
        // If applicable, stop editing currently selected span and apply any changes.
        if (this.state.editingSpan && this.state.editingSpan !== evt.target && this.refs.spanEditor !== evt.target && !$.contains(this.refs.spanEditor, evt.target)) {
            this.stopEditingSpan();
        }
    },
    onSpanEditorFocusOut: function onSpanEditorFocusOut(evt) {
        if (this.ignoreSpanEditorBlur) {
            this.ignoreSpanEditorBlur = false;
            return;
        }
        this.applySpanEditorData();
    },
    onSpanEditorMouseDown: function onSpanEditorMouseDown(evt) {
        if ($(evt.target).closest('.autocomplete-menu')[0]) {
            this.ignoreSpanEditorBlur = true;
        } else {
            this.ignoreSpanEditorBlur = false;
        }
    },
    onEditorInput: function onEditorInput(evt) {
        this.formatContents(this.refs.input);
        if (this.state.editingSpan) {
            // force update so that span editor get updated.
            this.forceUpdate();
        }
    },
    onEditorFocusOut: function onEditorFocusOut(evt) {
        // Force update so the hidden inputs gets updated to reflect any changes in editor.
        this.forceUpdate();
    },
    onContextMenu: function onContextMenu(evt) {
        var _this3 = this;

        evt.preventDefault();
        var target = evt.toElement;
        var sel = window.getSelection();
        var range = sel.getRangeAt(0);

        var action = function action(i, item) {
            //console.log(i, item, target, sel); 
            var newSpan = document.createElement('SPAN');
            newSpan.setAttribute('data-elemName', item.elm.name);
            _this3.startEditingSpan(newSpan);
            // Start editing the newSpan before actually inserting it, so that the we dont overwrite the newly inserted span with the editor data.
            range.surroundContents(newSpan);
        };

        var menuItems = [];
        var allowedElems; // possible element types to be inserted.

        if (sel.isCollapsed) {
            if ($(target).is('span[data-elemName]')) {
                menuItems = [{ label: 'Clear ' + target.getAttribute('data-elemName'), action: this.clearDataSpan.bind(this, target) }];
            }

            allowedElems = $(target).is('span[data-elemName]') ? this.editorElemTree[target.getAttribute('data-elemName')] : this.props.topElems;
        } else {
            /* Get the nodes in selection */
            var nodesInSelection = $(getNodesInRange(range));
            var elementNodesInSelection = nodesInSelection.map(function (i, n) {
                if (n.nodeType === Node.TEXT_NODE) return n.parentNode;else if (n.nodeType === Node.ELEMENT_NODE) return n;
            });
            $.unique(elementNodesInSelection);

            /* Produce unique and sorted elemNames that can be cleared from selection. */
            var elemNames = [];
            $(elementNodesInSelection).filter('span[data-elemName]').each(function (i, e) {
                var name = e.getAttribute('data-elemName');
                if (elemNames.indexOf(name) === -1) elemNames.push(name);
            });
            elemNames.sort();

            /* Create `Clear` action menu items. */
            menuItems = elemNames.map(function (name) {
                return {
                    label: 'Clear ' + name,
                    action: _this3.clearSelectionDataSpan.bind(_this3, name)
                };
            });

            /* Any allowed elements to be inserted over the selection? */
            // None if multiple spans (including top element) are selected. Otherwise use the routine from the collapsed selection case.
            if (elementNodesInSelection.length <= 1) {
                allowedElems = $(target).is('span[data-elemName]') ? this.editorElemTree[target.getAttribute('data-elemName')] : this.props.topElems;
            }
        }

        if (allowedElems) {
            if (menuItems.length > 0) menuItems.push({ type: 'div' });
            this.editorElements.forEach(function (elm) {
                if (allowedElems.indexOf(elm.name) !== -1) menuItems.push({ label: elm.label, action: action, elm: elm });
            });
        }

        ReactDOM.render(React.createElement(ContextMenu, { x: evt.clientX, y: evt.clientY, items: menuItems }), this.refs.contextmenuholder);
    },


    /*
        Life cycle methods.
     */

    componentDidMount: function componentDidMount() {
        var _this4 = this;

        this.makeEditorElements();

        this.refs.input.innerHTML = this.getInitialContentHtml();
        this.formatContents(this.refs.input); // format the initial content

        // click events on data spans will open the span data editor.
        $(this.refs.input).on('click', 'span[data-elemName]', function (evt) {
            _this4.startEditingSpan(evt.target);
        });
        // click outside will close the span data editor
        document.addEventListener('click', this.onDocumentClick, true);

        // right click to open context menu.
        $(this.refs.input).on('contextmenu', this.onContextMenu);

        // apply the formatted content, and generate the input elements.
        this.forceUpdate();

        /*$(this.refs.input).popover({
            placement: 'auto bottom',
            selector: 'span[data-xmldata]',
            container: 'body',
            title: function(){
                return this1.getDataForSpan(this).documentElement.nodeName 
            },
            template: '<div class="popover" role="tooltip"><div class="arrow"/><h3 class="popover-title"/><div class="popover-content"/></div>',
        });
        $(this.refs.input).on('inserted.bs.popover, shown.bs.popover', function(evt) {
            ReactDOM.render(<Test />, $('.popover-content', document.getElementById(this.getAttribute('aria-describedby')))[0]);
        });
        $(this.refs.input).on('hidden.bs.popover', function(evt) {
            ReactDOM.unmountComponentAtNode($('.popover-content', document.getElementById(this.getAttribute('aria-describedby')))[0]);
        });*/
    },
    componentWillUnmount: function componentWillUnmount() {
        // Because the event listener is attached to the document node, we have to remove event handler when the component is unmounted.
        document.removeEventListener('click', this.onDocumentClick, true);
    },


    /*
        Rendering methods
     */

    renderDataNodesInputs: function renderDataNodesInputs() {
        var _this5 = this;

        var paragraphs = $(this.refs.input).children();
        if (this.props.multiParagraph) {
            return paragraphs.map(function (i, paragraph) {
                var name = _this5.props.name + '#' + i;
                var contents = $(paragraph).contents().get();
                var xmlContents = _this5.editorDataToXml(contents);
                return renderDataNodesAsInputElements(name, xmlContents);
            }).get();
        } else {
            var name = this.props.name;
            var contents = paragraphs.map(function (i, paragraph) {
                var separator;
                if (i < paragraphs.length - 1) {
                    if (_this5.props.topElems.indexOf('lb') !== -1) separator = paragraph.ownerDocument.createElement('lb');else separator = paragraph.ownerDocument.createTextNode('\n');
                }
                return $(paragraph).contents().add(separator).get();
            }).get();
            var xmlContents = this.editorDataToXml(contents);
            return renderDataNodesAsInputElements(name, xmlContents);
        }
    },
    getInitialContentHtml: function getInitialContentHtml() {
        var _this6 = this;

        return $(this.props.data).get().map(function (dataNode) {
            // TODO if not multiParagraph, separate paragraphs on line breaks?
            return '<' + _this6.props.topLevelElement + '>' + _this6.renderDataNodesAsHtml($(dataNode).contents().get()) + ('</' + _this6.props.topLevelElement + '>');
        }).join("\n");
    },
    renderDataNodesAsHtml: function renderDataNodesAsHtml(nodes) {
        var _this7 = this;

        return nodes.map(function (n) {
            if (n.nodeType === Node.ELEMENT_NODE) {
                if (n.nodeName == 'lb') return '<br>';

                var s = '<span data-elemName="' + n.nodeName + '"';
                var attrs = n.attributes;
                for (var i = 0; i < attrs.length; i++) {
                    var name = camelCaseToDashed(attrs[i].name);
                    var value = htmlEscape(attrs[i].value);
                    s += ' data-attr-' + name + '="' + value + '"';
                }
                if (n.nodeName === 'locus') {
                    s += ' contenteditable="false"';
                }
                var contentsHtml = _this7.renderDataNodesAsHtml($(n).contents().get());

                if (contentsHtml === '') {
                    contentsHtml = _this7.getContentForEmptyElement(n);
                    if (contentsHtml.length > 0) {
                        s += ' data-generated-content="' + contentsHtml + '"';
                    }
                }

                s += '>' + contentsHtml + '</span>';
                return s;
                //return n.outerHTML;
            } else if (n.nodeType === Node.TEXT_NODE) {
                return n.nodeValue;
            } else {
                console.warn("Discarding data node of unsupported type=" + n.nodeType + ": " + n);
            }
        }).join('');
    },
    getContentForEmptyElement: function getContentForEmptyElement(n) {
        var contentsHtml = '';
        var ref;
        if (n.nodeName === 'persName') {
            ref = n.getAttribute('ref');
            if (ref) {
                var persName = $(personsData).filter('person[xml\\:id="' + ref.replace(/^#/, '') + '"]').children('persName');
                contentsHtml = PersName.getPersNameValue(persName);
            }
        } else if (n.nodeName === 'placeName') {
            ref = n.getAttribute('ref');
            if (ref) {
                var placeName = $(placesData).filter('place[xml\\:id="' + ref.replace(/^#/, '') + '"]').children('placeName');
                contentsHtml = PlaceName.getValue(placeName);
            }
        } else if (n.nodeName === 'date') {
            if (n.hasAttribute('when')) contentsHtml = n.getAttribute('when');else if (n.hasAttribute('from')) contentsHtml = n.getAttribute('from') + '–' + n.getAttribute('to');else if (n.hasAttribute('notBefore')) contentsHtml = n.getAttribute('notBefore') + '–' + n.getAttribute('notAfter');
        }

        return contentsHtml;
    },
    getEditorData: function getEditorData() {
        var _this8 = this;

        return this.ref.input.childNodes.map(function (n) {
            if (!(n.nodeType === Node.ELEMENT_NODE && $(n).is(_this8.props.topLevelElement))) {
                throw "Error: at top level only expected element nodes of name " + _this8.props.topLevelElement + " but found " + n.nodeName + " " + n;
            }
            var contentData = _this8.editorDataToXml($(n).contents().get());
            return contentData;
        });
    },
    editorDataToXml: function editorDataToXml(nodes, doc) {
        var _this9 = this;

        if (!doc) doc = $.parseXML('<tmp/>');
        return nodes.map(function (n) {
            if (n.nodeType === Node.ELEMENT_NODE) {
                if (n.tagName === 'BR') return doc.createElement('lb');else if (n.tagName === 'SPAN') {
                    var elem = doc.createElement(n.getAttribute('data-elemName'));
                    var attrs = n.attributes;
                    for (var i = 0; i < attrs.length; i++) {
                        var matches = /^data-attr-(.*)$/.exec(attrs[i].name);
                        if (matches !== null && matches[1]) {
                            var name = dashedToCamelCase(matches[1]);
                            var value = htmlUnescape(attrs[i].value);
                            elem.setAttribute(name, value);
                        }
                    }
                    if ($(n).children().length === 0 && n.hasAttribute('data-generated-content') && $(n).attr('data-generated-content') == $(n).text()) {
                        return elem;
                    } else {
                        var childData = _this9.editorDataToXml($(n).contents().get(), doc);
                        $(elem).append(childData);
                        return elem;
                    }
                } else {
                    console.warn("Discarding unexpected data element " + n.tagName + ": " + n);
                }
            } else if (n.nodeType === Node.TEXT_NODE) {
                return doc.createTextNode(n.nodeValue);
            } else {
                console.warn("Discarding data node of unsupported type=" + n.nodeType + ": " + n);
            }
        });
    },
    render: function render() {
        if (this.state.editingSpan) {
            var data = this.getDataForSpan(this.state.editingSpan);
            var name = data.nodeName;
            var key = $(this.state.editingSpan).text(); // use a key so that if the editingSpan's text has been updated, force React to reinitialize the editor component.

            var editingComponent;
            var label;

            var element = this.elementsByName[name];
            if (element) {
                var extraProps = {};
                if (name === 'term') {
                    extraProps = {
                        showFreeText: false,
                        //showMaterial: true,
                        showSameAs: true,
                        showXmlLang: true,
                        showCert: true,
                        showRef: true,
                        showType: true
                    };
                } else if (name === 'note') {
                    extraProps = {
                        dataDoc: $(this.props.data)[0].ownerDocument
                    };
                }

                var props = $.extend({ key: key, data: data, name: name }, extraProps);

                editingComponent = React.createElement(element.component, props);
                label = element.label;
            }

            var spanDataEditor = React.createElement(
                'div',
                { ref: 'spanEditor', className: 'editor-textbox-data-span-editor', onBlur: this.onSpanEditorFocusOut, onMouseDown: this.onSpanEditorMouseDown },
                'Editing "' + (label || name) + '"',
                editingComponent || '<no editing element configured for "' + name + '">'
            );
        }

        var id = this.props.name;

        return React.createElement(
            'div',
            null,
            React.createElement('div', { ref: 'input', className: 'editor-textbox', role: 'textbox', contentEditable: 'true', onBlur: this.onEditorFocusOut, onInput: this.onEditorInput }),
            this.renderDataNodesInputs(),
            spanDataEditor,
            React.createElement('div', { ref: 'contextmenuholder' })
        );
    }
});

var Ex = React.createClass({
    displayName: 'Ex',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    render: function render() {
        return React.createElement(
            'div',
            { className: 'Ex' },
            React.createElement(
                'label',
                null,
                'Expanded text'
            ),
            React.createElement(Text, { name: this.props.name + '/#text', data: this.props.data }),
            React.createElement(XmlLang, { name: this.props.name, defaultValue: $(this.props.data).attr('xml:lang'), required: false }),
            React.createElement(Cert, { name: this.props.name, defaultValue: $(this.props.data).attr('cert') }),
            React.createElement(SameAs, { name: this.props.name, defaultValue: $(this.props.data).attr('sameAs') })
        );
    }
});

var Unclear = React.createClass({
    displayName: 'Unclear',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    getInitialState: function getInitialState() {
        var isRange = this.props.data.hasAttribute('atLeast') || this.props.data.hasAttribute('atMost');
        return {
            quantity: $(this.props.data).attr('quantity'),
            atLeast: $(this.props.data).attr('atLeast'),
            atMost: $(this.props.data).attr('atMost'),
            isRange: isRange
        };
    },
    onChangeQuantity: function onChangeQuantity(evt) {
        this.setState({
            quantity: evt.target.value
        });
    },
    onChangeAtLeast: function onChangeAtLeast(evt) {
        this.setState({
            atLeast: evt.target.value
        });
    },
    onChangeAtMost: function onChangeAtMost(evt) {
        this.setState({
            atMost: evt.target.value
        });
    },
    onRangeChanged: function onRangeChanged(evt) {
        this.setState({
            isRange: evt.target.checked
        });
    },
    render: function render() {
        return React.createElement(
            'div',
            { className: 'Unclear' },
            React.createElement(
                'label',
                null,
                'Reason',
                React.createElement(
                    'select',
                    { name: this.props.name + '/@reason', defaultValue: $(this.props.data).attr('reason') },
                    React.createElement(
                        'option',
                        { value: 'illegible' },
                        'Illegible'
                    )
                )
            ),
            React.createElement('br', null),
            React.createElement(
                'label',
                null,
                'Unit',
                React.createElement(
                    'select',
                    { name: this.props.name + '/@unit', defaultValue: $(this.props.data).attr('unit') },
                    React.createElement(
                        'option',
                        { value: 'chars' },
                        'Characters'
                    ),
                    React.createElement(
                        'option',
                        { value: 'lines' },
                        'Lines'
                    ),
                    React.createElement(
                        'option',
                        { value: 'mm' },
                        'Millimeters'
                    )
                )
            ),
            React.createElement('br', null),
            React.createElement(
                'label',
                null,
                'Quantity'
            ),
            !this.state.isRange && React.createElement('input', { type: 'text', name: this.props.name + '/@quantity', value: this.state.quantity, onChange: this.onChangeQuantity }),
            this.state.isRange && React.createElement(
                'label',
                null,
                'At least ',
                React.createElement('input', { type: 'text', name: this.props.name + '/@atLeast', value: this.state.atLeast, onChange: this.onChangeAtLeast })
            ),
            this.state.isRange && React.createElement(
                'label',
                null,
                'At most ',
                React.createElement('input', { type: 'text', name: this.props.name + '/@atMost', value: this.state.atMost, onChange: this.onChangeAtMost })
            ),
            React.createElement(
                'label',
                null,
                React.createElement('input', { type: 'checkbox', checked: this.state.isRange, onChange: this.onRangeChanged }),
                ' Range'
            )
        );
    }
});

var Foreign = React.createClass({
    displayName: 'Foreign',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    render: function render() {
        var childContents = renderDataNodesAsInputElements(this.props.name, $(this.props.data).contents().get());
        return React.createElement(
            'div',
            { className: 'Foreign' },
            React.createElement(XmlLang, { name: this.props.name, defaultValue: $(this.props.data).attr('xml:lang'), required: true }),
            React.createElement(SameAs, { name: this.props.name, defaultValue: $(this.props.data).attr('sameAs') }),
            childContents
        );
    }
});

var SameAs = React.createClass({
    displayName: 'SameAs',

    propTypes: {
        defaultValue: React.PropTypes.string,
        name: React.PropTypes.string
    },

    render: function render() {
        return React.createElement(
            'div',
            { className: 'SameAs' },
            React.createElement(
                'label',
                null,
                'Same as (optional)'
            ),
            React.createElement('input', { type: 'text', name: this.props.name + "/@sameAs" })
        );
    }
});

var Ref = React.createClass({
    displayName: 'Ref',

    propTypes: {
        defaultValue: React.PropTypes.string,
        name: React.PropTypes.string
    },

    render: function render() {
        return React.createElement(
            'div',
            { className: 'Ref' },
            React.createElement(
                'label',
                null,
                'Ref (optional)'
            ),
            React.createElement('input', { type: 'text', name: this.props.name + "/@ref", value: this.props.defaultValue })
        );
    }
});

var Cert = React.createClass({
    displayName: 'Cert',

    propTypes: {
        defaultValue: React.PropTypes.string,
        name: React.PropTypes.string
    },

    getInitialState: function getInitialState() {
        var numericValue = this.validate(this.props.defaultValue) ? this.props.defaultValue : '';
        return {
            selectedValue: ['high', 'low', 'medium', 'unknown'].indexOf(this.props.defaultValue) !== -1 ? this.props.defaultValue : numericValue !== '' ? 'numeric' : '',
            numericValue: numericValue
        };
    },
    validate: function validate(str) {
        return !Number.isNaN(Number(str));
    },
    onSelect: function onSelect(evt) {
        if (evt.target.value === 'divider') {
            return; // disallow change
        }

        this.setState({
            selectedValue: evt.target.value
        });
    },
    onChange: function onChange(evt) {
        this.setState({
            numericValue: evt.target.value
        });
    },
    render: function render() {
        return React.createElement(
            'div',
            { className: 'Cert' },
            React.createElement(
                'label',
                null,
                'Certainty (optional)'
            ),
            React.createElement(
                'select',
                { value: this.state.selectedValue, onChange: this.onSelect },
                React.createElement('option', { value: '' }),
                '/*',
                React.createElement(
                    'option',
                    { value: 'divider' },
                    '--------'
                ),
                '*/',
                React.createElement(
                    'option',
                    { value: 'high' },
                    'High'
                ),
                React.createElement(
                    'option',
                    { value: 'medium' },
                    'Medium'
                ),
                React.createElement(
                    'option',
                    { value: 'low' },
                    'Low'
                ),
                React.createElement(
                    'option',
                    { value: 'unknown' },
                    'Unknown'
                ),
                React.createElement(
                    'option',
                    { value: 'numeric' },
                    'Numeric value'
                )
            ),
            this.state.selectedValue === 'numeric' && React.createElement('input', { type: 'text', className: this.validate(this.state.numericValue) ? "" : "invalid", placeholder: 'Numeric value', onChange: this.onChange, value: this.numericValue }),
            this.state.selectedValue === 'numeric' && !this.validate(this.state.numericValue) && React.createElement(
                'span',
                { className: 'help-block text-danger' },
                'Invalid numeric value entered.'
            ),
            React.createElement('input', { type: 'hidden', name: this.props.name + '/@cert', value: this.state.selectedValue === 'numeric' ? this.state.numericValue : this.state.selectedValue })
        );
    }
});

var Note = React.createClass({
    displayName: 'Note',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        dataDoc: React.PropTypes.oneOfType([React.PropTypes.node, React.PropTypes.instanceOf(Document)]),
        name: React.PropTypes.string
    },

    render: function render() {
        var childContents = renderDataNodesAsInputElements(this.props.name, $(this.props.data).contents().get());
        return React.createElement(
            'div',
            { className: 'Note' },
            React.createElement(HandAttr, { name: this.props.name, defaultValue: $(this.props.data).attr('hand'), dataDoc: this.props.dataDoc || this.props.data.ownerDocument }),
            childContents
        );
    }
});

var HandAttr = React.createClass({
    displayName: 'HandAttr',

    statics: {
        handNumberPattern: /\d+$/,

        handIdSortFunc: function handIdSortFunc(s1, s2) {
            return Number(this.handNumberPattern.exec(s2)[0]) - Number(this.handNumberPattern.exec(s1)[0]);
        }
    },

    propTypes: {
        defaultValue: React.PropTypes.string,
        dataDoc: React.PropTypes.oneOfType([React.PropTypes.node, React.PropTypes.instanceOf(Document)]),
        name: React.PropTypes.string,
        options: React.PropTypes.arrayOf(React.PropTypes.string)
    },

    render: function render() {
        var options = $(this.props.dataDoc).find('handNote').map(function (i, e) {
            return $(e).attr('xml:id');
        }).get();
        options = sortedAndDistinct(options, this.handIdSortFunc);
        return React.createElement(
            'div',
            { className: 'HandAttr' },
            React.createElement(
                'label',
                null,
                'Hand',
                React.createElement(
                    'select',
                    { name: this.props.name + '/@hand', defaultValue: this.props.defaultValue },
                    options.map(function (handId) {
                        return React.createElement(
                            'option',
                            { key: handId, value: handId },
                            handId
                        );
                    })
                )
            ),
            !options && React.createElement(
                'span',
                { className: 'text-warning' },
                'No handNotes to reference found in document.'
            )
        );
    }
});

var XmlLang = React.createClass({
    displayName: 'XmlLang',

    propTypes: {
        defaultValue: React.PropTypes.string,
        name: React.PropTypes.string,
        options: React.PropTypes.arrayOf(React.PropTypes.string),
        required: React.PropTypes.bool
    },

    getInitialState: function getInitialState() {
        var _this10 = this;

        var languageOptions = schemaData['xmllang'].map(function (elem) {
            return { value: elem.getAttribute('value'), label: elem.getAttribute('name') };
        });
        if (this.props.options) {
            languageOptions = languageOptions.filter(function (opt) {
                return _this10.props.options.indexOf(opt.value) !== -1;
            });
        }
        return {
            options: languageOptions
        };
    },
    render: function render() {
        return React.createElement(
            'div',
            { className: 'XmlLang' },
            React.createElement(
                'label',
                null,
                'Language',
                React.createElement(Select, { name: this.props.name + '/@xml:lang', options: this.state.options, defaultValue: this.props.defaultValue, placeholder: this.props.required ? undefined : '' })
            )
        );
    }
});

var OneOrMore = React.createClass({
    displayName: 'OneOrMore',

    propTypes: {
        emptyPlaceholder: React.PropTypes.node,
        data: React.PropTypes.arrayOf(React.PropTypes.instanceOf(Element)),
        name: React.PropTypes.string,
        children: React.PropTypes.node,
        onChange: React.PropTypes.func
    },

    render: function render() {
        return React.createElement(ZeroOrMore, _extends({}, this.props, { atLeastOne: true }));
    }
});

var ZeroOrMore = React.createClass({
    displayName: 'ZeroOrMore',

    propTypes: {
        emptyPlaceholder: React.PropTypes.node,
        data: React.PropTypes.arrayOf(React.PropTypes.instanceOf(Element)),
        name: React.PropTypes.string,
        children: React.PropTypes.node,
        onChange: React.PropTypes.func,
        atLeastOne: React.PropTypes.bool
    },

    getDefaultProps: function getDefaultProps() {
        return {
            emptyPlaceholder: "(empty)",
            atLeastOne: false
        };
    },
    getInitialState: function getInitialState() {
        var items;
        if (this.props.data && this.props.data.length > 0) items = this.props.data.map(function (e) {
            return { key: nextId(), data: e };
        });else if (this.props.atLeastOne) items = [{ key: nextId(), data: undefined }];else items = [];

        return {
            items: items
        };
    },
    remove: function remove(index) {
        var newItems = this.state.items.slice();
        newItems.splice(index, 1);

        if (this.props.atLeastOne && newItems.length === 0) newItems = [{ key: nextId(), data: undefined }];

        if (this.props.onChange) {
            this.props.onChange(this.state.items, newItems);
        }
        this.setState({ items: newItems });
    },
    add: function add(index) {
        var item = { key: nextId(), data: undefined };
        var newItems = this.state.items.slice();
        newItems.splice(index, 0, item);
        if (this.props.onChange) {
            this.props.onChange(this.state.items, newItems);
        }
        this.setState({ items: newItems });
    },
    createElementFromItem: function createElementFromItem(item, itemIndex) {
        var typeChild = React.Children.toArray(this.props.children)[0];
        var elementClass = typeChild.type;
        var props = $.extend({}, typeChild.props, { data: item.data, name: this.props.name + '#' + 'zeroOrMore' + itemIndex });
        return React.createElement(elementClass, props);
    },
    render: function render() {
        var _this11 = this;

        return React.createElement(
            'div',
            { className: 'zeroOrMore' },
            this.state.items.length === 0 ? React.createElement(
                'div',
                { className: 'ZeroOrMore-item ZeroOrMore-item-placeholder' },
                this.props.emptyPlaceholder,
                React.createElement(
                    'div',
                    { className: 'ZeroOrMore-item-buttons' },
                    React.createElement('span', { onClick: this.add.bind(this, 0), className: 'n-or-more-add glyphicon glyphicon-plus' })
                )
            ) : this.state.items.map(function (item, i) {
                return React.createElement(
                    'div',
                    { className: 'ZeroOrMore-item', key: item.key },
                    React.createElement(
                        'div',
                        { className: 'ZeroOrMore-item-contents' },
                        _this11.createElementFromItem(item, i)
                    ),
                    React.createElement(
                        'div',
                        { className: 'ZeroOrMore-item-buttons' },
                        React.createElement('span', { onClick: _this11.add.bind(_this11, i + 1), className: 'n-or-more-add glyphicon glyphicon-plus' }),
                        React.createElement('span', { onClick: _this11.remove.bind(_this11, i), className: 'n-or-more-remove glyphicon glyphicon-minus' })
                    )
                );
            })
        );
    }
});

var PersName = React.createClass({
    displayName: 'PersName',

    _persItems: null,
    getPersItems: function getPersItems() {
        if (this._persItems === null) {
            if (!personsData) return [];

            this._persItems = personsData.map(function (person, i) {
                return {
                    id: $(person).attr('xml:id'),
                    displayName: PersName.getPersNameValue($('persName', person))
                };
            });
        }
        return this._persItems;
    },


    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string,
        showRef: React.PropTypes.bool,
        showRefWarning: React.PropTypes.bool,
        showFreeText: React.PropTypes.bool,
        autocompleteItems: React.PropTypes.array,

        cert: React.PropTypes.string,
        showCert: React.PropTypes.bool,
        showSameAs: React.PropTypes.bool,
        evidence: React.PropTypes.string,
        showEvidence: React.PropTypes.bool,
        role: React.PropTypes.string,
        showRole: React.PropTypes.bool
    },

    getDefaultProps: function getDefaultProps() {
        return {
            showRef: true,
            showRefWarning: true,
            showFreeText: false,

            showCert: false,
            showSameAs: false,
            showEvidence: false,
            showRole: false
        };
    },


    statics: {
        getPersNameValue: function getPersNameValue(persName) {
            return $.trim($(persName).text().replace(/\s+/g, ' '));
        }
    },

    getInitialState: function getInitialState() {
        var selectedId = $(this.props.data).attr('ref');
        return {
            selectedId: selectedId
        };
    },
    findPersById: function findPersById(id) {
        if (!id) return null;
        var persItems = this.getPersItems();
        for (var i = 0; i < persItems.length; i++) {
            if ('#' + persItems[i].id === id) {
                return persItems[i];
            }
        }
        return null;
    },


    /*sortItems(value, a, b) {
        // put items where match is in beginning of word first.
        var a = this.getItemValue(a).toLowerCase(),
            b = this.getItemValue(b).toLowerCase(),
            s = this.state.searchString.toLowerCase();
        var ai = a.indexOf(s),
            bi = b.indexOf(s);
        var aPrio = (ai === 0 || a.charAt(ai-1) === ' '),
            bPrio = (bi === 0 || b.charAt(bi-1) === ' ');
        if (aPrio && !bPrio) {
            return -1unknown;
        } else if (bPrio && !aPrio) {
            return 1;
        } else {
            return a.localeCompare(b);
        }
    },*/

    onSelect: function onSelect(value, item) {
        this.setState({
            selectedId: '#' + item.id
        });
    },
    onChange: function onChange(newValue) {
        this.setState({
            selectedId: null
        });
    },
    getItemValue: function getItemValue(item) {
        return item ? item.displayName : '';
    },


    /* // ??? 
    onTextBlur() {
        this.setState({
            textFocus: false
        });
    },
    
    onTextFocus() {
        this.setState({
            textFocus: true
        });
    },
    */

    render: function render() {
        var selectedId = this.state.selectedId;
        var selectedItem = this.findPersById(this.state.selectedId);
        var hasSelectedRefInProsopography = !!selectedItem;

        return React.createElement(
            'div',
            { className: 'PersName' },
            this.props.showFreeText && React.createElement(
                'div',
                null,
                React.createElement(
                    'label',
                    null,
                    'Free text'
                ),
                React.createElement('br', null),
                React.createElement(Text, { data: this.props.data, name: this.props.name + "/#text" })
            ),
            !this.props.showFreeText && React.createElement('input', { type: 'hidden', value: $(this.props.data).text(), name: this.props.name + "/#text" }),
            React.createElement(
                'div',
                null,
                React.createElement(
                    'label',
                    null,
                    'Reference'
                ),
                '\xA0\xA0',
                React.createElement(
                    'small',
                    { className: selectedId ? hasSelectedRefInProsopography ? "text-success" : "text-warning" : "text-error" },
                    'ID: ',
                    selectedId || "n/a",
                    ' '
                ),
                selectedId && !hasSelectedRefInProsopography && React.createElement(
                    'small',
                    { className: 'text-danger' },
                    "No person with selected ID " + selectedId + " found in prosopography."
                ),
                !selectedId && React.createElement(
                    'small',
                    { className: 'text-danger' },
                    "No reference selected."
                ),
                React.createElement('br', null),
                React.createElement(Text, { data: selectedItem, className: 'form-control', autocomplete: this.getPersItems(), getItemValue: this.getItemValue,
                    onSelect: this.onSelect, onChange: this.onChange, onBlur: this.onTextBlur, onFocus: this.onTextFocus, placeholder: "Search reference", defaultValue: PersName.getPersNameValue(this.props.data) })
            ),
            this.props.showRole && React.createElement(
                'label',
                null,
                'Role',
                React.createElement(Select, { name: this.props.name + '/@role', defaultValue: $(this.props.data).attr('role'), options: ['cataloguer', 'librarian', 'scribe'], placeholder: '' })
            ),
            !this.props.showRole && this.props.role !== undefined && React.createElement('input', { type: 'hidden', name: this.props.name + '/@role', value: this.props.role }),
            this.props.showEvidence && React.createElement(
                'label',
                null,
                'Evidence',
                React.createElement(Select, { name: this.props.name + '/@evidence', defaultValue: $(this.props.data).attr('evidence'), options: ['internal', 'external', 'conjecture'], placeholder: '' })
            ),
            !this.props.showEvidence && this.props.evidence != undefined && React.createElement('input', { type: 'hidden', name: this.props.name + '/@evidence', value: this.props.evidence }),
            this.props.showCert && React.createElement(Cert, { name: this.props.name, defaultValue: $(this.props.data).attr('cert') }),
            !this.props.showCert && this.props.cert !== undefined && React.createElement('input', { type: 'hidden', name: this.props.name + '/@cert', value: this.props.cert }),
            this.props.showSameAs && React.createElement(SameAs, { name: this.props.name, defaultValue: $(this.props.data).attr('sameAs') }),
            React.createElement('input', { type: 'hidden', name: this.props.name + '/@ref', value: this.state.selectedId || '' })
        );
    }
});

var RespStmt = React.createClass({
    displayName: 'RespStmt',

    respPersons: [{ id: 'BC', ref: 'BarCro', name: 'Barbara Crostini' }, { id: 'EN', ref: 'EvaNys', name: 'Eva Nyström' }, { id: 'PG', ref: 'PatGra', name: 'Patrik Granholm' }, { id: 'PA', ref: '', name: 'Patrik Åström' }],

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    getInitialState: function getInitialState() {
        //var personChoices = persData.filter(p =>
        //    this.respPersons.some(rp => $(p).attr('xml:id') === rp.ref)
        //);
        var id = this.props.data ? $(this.props.data).attr('xml:id') : '';
        return {
            id: id,
            cataloguer: this.props.data ? $('resp[key=cataloguer]', this.props.data).length > 0 : false,
            encoder: this.props.data ? $('resp[key=encoder]', this.props.data).length > 0 : false,
            selectedPerson: this.respPersons.filter(function (p) {
                return p.id === id;
            })[0] || void 0
        };
    },
    respChanged: function respChanged(evt) {
        var newSt = {};
        newSt[evt.target.value] = evt.target.checked;
        this.setState(newSt);
    },
    onPersNameChanged: function onPersNameChanged(value) {
        /*var ref = $(item).attr('ref');
        var id = null;
        for (var i = 0; i < this.respPersons.length; i++) {
            if( this.respPersons[i].ref === ref ) {
                id = this.respPersons[i].id;
                break;
            }
        }
        this.setState({id: id});*/
        this.setState({ id: '', selectedPerson: undefined });
    },
    onPersonSelect: function onPersonSelect(item) {
        this.setState({ id: item.id, selectedPerson: item });
    },
    render: function render() {
        var blockStyle = { display: 'inline-block' };

        var persNameElem = React.createElement(Text, {
            data: this.state.selectedPerson,
            name: this.props.name + '/persName/#text',
            autocomplete: this.respPersons,
            getItemValue: function getItemValue(x) {
                return x.name;
            },
            onChange: this.onPersNameChanged,
            onSelect: this.onPersonSelect
        });
        //<PersName disabled data={getData('persName', this.props.data)} name={this.props.name+'/persName'} onChange={this.onPersNameChanged}  />
        return React.createElement(
            'div',
            { className: 'respStmt' },
            React.createElement('input', { type: 'hidden', name: this.props.name + '/@xml:id', value: this.state.id || '' }),
            React.createElement(
                'div',
                { style: blockStyle },
                React.createElement(
                    'label',
                    null,
                    'Person name:'
                ),
                React.createElement(
                    'div',
                    null,
                    persNameElem
                )
            ),
            React.createElement(
                'div',
                { style: blockStyle },
                React.createElement(
                    'label',
                    null,
                    'Responsibilities:'
                ),
                React.createElement(
                    'div',
                    { className: 'form-check' },
                    React.createElement(
                        'label',
                        { className: 'form-check-inline' },
                        React.createElement('input', { type: 'checkbox', className: 'form-check-input', name: this.props.name + '/resp#c/@key', onChange: this.respChanged, value: 'cataloguer', checked: this.state.cataloguer }),
                        ' cataloguer'
                    ),
                    React.createElement(
                        'label',
                        { className: 'form-check-inline' },
                        React.createElement('input', { type: 'checkbox', className: 'form-check-input', name: this.props.name + '/resp#e/@key', onChange: this.respChanged, value: 'encoder', checked: this.state.encoder }),
                        ' encoder'
                    )
                )
            )
        );
    }
});

var Text = React.createClass({
    displayName: 'Text',

    propTypes: {
        data: React.PropTypes.object,
        name: React.PropTypes.string,
        autocomplete: React.PropTypes.array,
        getItemValue: React.PropTypes.func,
        onChange: React.PropTypes.func,
        onSelect: React.PropTypes.func,
        placeholder: React.PropTypes.string,
        className: React.PropTypes.string,
        defaultValue: React.PropTypes.string
    },

    getDefaultProps: function getDefaultProps() {
        return {
            autocomplete: [],
            getItemValue: function getItemValue(item) {
                return $(item).text();
            },
            onSelect: function onSelect(value, item) {},
            onChange: function onChange(value, item) {},

            placeholder: '',
            defaultValue: ''
        };
    },
    getInitialState: function getInitialState() {
        return {
            value: this.props.data ? this.props.getItemValue(this.props.data) : this.props.defaultValue
        };
    },
    isChanged: function isChanged() {
        return this.getInitialState().value !== this.state.value;
    },
    onChange: function onChange(evt) {
        this.props.onChange(evt.target.value);
        this.setState({ value: evt.target.value });
    },
    onSelect: function onSelect(value, item) {
        this.props.onSelect(value, item);
        this.setState({ value: value });
    },
    shouldItemRender: function shouldItemRender(item, value) {
        return filterOnWords(this.props.getItemValue(item), value);
    },
    renderItem: function renderItem(item, highlighted) {
        return React.createElement(
            'div',
            { className: highlighted ? 'item highlighted' : 'item' },
            this.props.getItemValue(item)
        );
    },
    renderMenu: function renderMenu(items, value, style) {
        //style.maxHeight = 'calc(100%-'+style.height+')';
        // relative to autocomplete menu wrapper (position: relative)
        var rect = this.refs.menuWrapper.getBoundingClientRect();
        var input = $('input', this.refs.menuWrapper);
        var offsetY = input.outerHeight();
        var offsetX = (input.outerWidth(true) - input.outerWidth(false)) / 2; // assumes equal left and right margin... 
        if (rect.bottom < $(window).innerHeight() / 3 * 2) {
            style.top = offsetY;
        } else {
            delete style.top;
            style.bottom = offsetY;
        }
        style.left = offsetX;
        return React.createElement('div', { className: 'autocomplete-menu', style: style, children: items });
    },
    render: function render() {
        var className = this.props.className ? this.props.className + " editor-text" : "editor-text";
        if (this.isChanged()) {
            className += " editor-isChanged";
        }
        if (this.props.autocomplete === null || this.props.autocomplete.length === 0) {
            return React.createElement('input', { type: 'text', name: this.props.name, className: className, value: this.state.value, onChange: this.onChange, placeholder: this.props.placeholder });
        } else {
            return React.createElement(
                'div',
                { ref: 'menuWrapper', style: { display: 'inline' } },
                React.createElement(Autocomplete, {
                    getItemValue: this.props.getItemValue,
                    items: this.props.autocomplete,
                    inputProps: { name: this.props.name, placeholder: this.props.placeholder, className: className },
                    onChange: this.onChange,
                    onSelect: this.onSelect,
                    renderItem: this.renderItem,
                    renderMenu: this.renderMenu,
                    shouldItemRender: this.shouldItemRender,
                    value: this.state.value,
                    wrapperStyle: { position: 'relative' }
                })
            );
        }
    }
});

var PlaceName = React.createClass({
    displayName: 'PlaceName',


    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string,
        showFreeText: React.PropTypes.bool
    },

    getDefaultProps: function getDefaultProps() {
        return {
            showFreeText: false
        };
    },
    getInitialState: function getInitialState() {
        return {
            selectedId: $(this.props.data).attr('ref')
        };
    },


    statics: {
        getValue: function getValue(place) {
            return place.nodeName === 'place' ? $('placeName', place).text() : $(place).text();
        }
    },

    findPlaceById: function findPlaceById(id) {
        if (!id) return null;
        var id2 = id.replace(/^#/, '');
        var place = $(placesData).filter('place[xml\\:id="' + id2 + '"]');
        return place.get(0);
    },
    getId: function getId(place) {
        return $(place).attr('xml:id');
    },
    onSelect: function onSelect(value, item) {
        this.setState({ selectedId: '#' + $(item).attr('xml:id') });
    },
    onChange: function onChange() {
        this.setState({ selectedId: null });
    },
    render: function render() {
        var selectedId = this.state.selectedId;
        var selectedItem = this.findPlaceById(selectedId);
        var isSelectedRefValid = !!selectedItem;
        return React.createElement(
            'div',
            { className: 'PlaceName' },
            this.props.showFreeText && React.createElement(
                'div',
                null,
                React.createElement(
                    'label',
                    null,
                    'Free text'
                ),
                React.createElement('br', null),
                React.createElement(Text, { data: this.props.data, name: this.props.name + "/#text" })
            ),
            !this.props.showFreeText && React.createElement('input', { type: 'hidden', value: $(this.props.data).text(), name: this.props.name + "/#text" }),
            React.createElement(
                'div',
                null,
                React.createElement(
                    'label',
                    null,
                    'Reference'
                ),
                '\xA0\xA0',
                React.createElement(
                    'small',
                    { className: selectedId ? isSelectedRefValid ? "text-success" : "text-warning" : "text-error" },
                    'ID: ',
                    selectedId || "n/a",
                    ' '
                ),
                selectedId && !isSelectedRefValid && React.createElement(
                    'small',
                    { className: 'text-danger' },
                    "No place with selected ID " + selectedId + " found."
                ),
                !selectedId && React.createElement(
                    'small',
                    { className: 'text-danger' },
                    "No reference selected."
                ),
                React.createElement('br', null),
                React.createElement(Text, { data: selectedItem, className: 'form-control', autocomplete: placesData, getItemValue: PlaceName.getValue,
                    onSelect: this.onSelect, onChange: this.onChange, onBlur: this.onTextBlur, onFocus: this.onTextFocus, placeholder: "Search reference", defaultValue: PlaceName.getValue(this.props.data) })
            ),
            React.createElement('input', { type: 'hidden', name: this.props.name + '/@ref', value: this.state.selectedId || '' })
        );
    }
});

var Country = React.createClass({
    displayName: 'Country',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    getValue: function getValue(place) {
        return $(place).text();
    },
    getAutoCompleteValues: function getAutoCompleteValues() {
        // The country element is NOT a "place", but we use placesData for autocomplete.
        return $('placeName[type="country"]', placesData).get();
    },
    render: function render() {
        return React.createElement(Text, { data: this.props.data, name: this.props.name + '/#text', autocomplete: this.getAutoCompleteValues(), getItemValue: this.getValue });
    }
});

var Settlement = React.createClass({
    displayName: 'Settlement',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    getValue: function getValue(place) {
        return $(place).text();
    },
    getAutoCompleteValues: function getAutoCompleteValues() {
        // The Settlement element is NOT a "place", but we use placesData for autocomplete.
        return $('placeName[type="settlement"]', placesData).get();
    },
    render: function render() {
        return React.createElement(Text, { data: this.props.data, name: this.props.name + '/#text', autocomplete: this.getAutoCompleteValues(), getItemValue: this.getValue });
    }
});

var Institution = React.createClass({
    displayName: 'Institution',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    getValue: function getValue(item) {
        return $(item).text();
    },
    render: function render() {
        return React.createElement(Text, { data: this.props.data, name: this.props.name + '/#text', autocomplete: schemaData['institution'], getItemValue: this.getValue });
    }
});

var Repository = React.createClass({
    displayName: 'Repository',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    getValue: function getValue(item) {
        return $(item).text();
    },
    render: function render() {
        return React.createElement(Text, { data: this.props.data, name: this.props.name + '/#text', autocomplete: schemaData['repository'], getItemValue: this.getValue });
    }
});

var AltIdentifier = React.createClass({
    displayName: 'AltIdentifier',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string,
        type: React.PropTypes.string
    },

    render: function render() {
        return React.createElement(Idno, { data: getData('idno', this.props.data), name: this.props.name + '/idno', type: this.props.type });
    }
});

var Idno = React.createClass({
    displayName: 'Idno',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string,
        type: React.PropTypes.string.isRequired
    },

    render: function render() {
        return React.createElement(
            'span',
            null,
            React.createElement(Text, { data: this.props.data, name: this.props.name + '/#text' }),
            React.createElement('input', { type: 'hidden', name: this.props.name + '/@type', value: this.props.type })
        );
    }
});

var MsName = React.createClass({
    displayName: 'MsName',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    render: function render() {
        return React.createElement(Text, { data: this.props.data, name: this.props.name + '/#text' });
    }
});

var Publisher = React.createClass({
    displayName: 'Publisher',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    render: function render() {
        var options = schemaData['publisher'].map(function (p) {
            return { value: p.innerHTML, label: p.innerHTML };
        });
        var defaultValue = $(this.props.data).text();
        return React.createElement(
            'label',
            null,
            'Publisher ',
            React.createElement(Select, { name: this.props.name + '/#text', options: options, defaultValue: defaultValue }),
            ' '
        );
    }
});

var Select = React.createClass({
    displayName: 'Select',

    propTypes: {
        name: React.PropTypes.string,
        options: React.PropTypes.array.isRequired,
        defaultValue: React.PropTypes.string,
        onChange: React.PropTypes.func,
        placeholder: React.PropTypes.string
    },

    render: function render() {
        return React.createElement(
            'select',
            { name: this.props.name, defaultValue: this.props.defaultValue, onChange: this.props.onChange },
            this.props.placeholder !== undefined && React.createElement(
                'option',
                { key: '__placeholder__', value: '' },
                this.props.placeholder
            ),
            this.props.options.map(function (item) {
                if (item.hasOwnProperty('value')) return React.createElement(
                    'option',
                    { key: item.value, value: item.value },
                    item.label
                );else return React.createElement(
                    'option',
                    { key: item, value: item },
                    item
                );
            })
        );
    }
});

var DateElem = React.createClass({
    displayName: 'DateElem',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string,
        showFreeText: React.PropTypes.bool,
        showInterval: React.PropTypes.bool
    },

    getDefaultProps: function getDefaultProps() {
        return {
            showFreeText: false,
            showInterval: true
        };
    },
    getInitialState: function getInitialState() {
        return {
            isInterval: this.props.showInterval && $(this.props.data).is('[from], [notBefore], [to], [notAfter]'),
            notBefore: $(this.props.data).is('[notBefore]'),
            notAfter: $(this.props.data).is('[notAfter]')
        };
    },
    render: function render() {
        var _this12 = this;

        var $data = $(this.props.data),
            when = $data.attr('when'),
            from = $data.attr('from') || $data.attr('notBefore'),
            to = $data.attr('to') || $data.attr('notAfter'),
            text = $data.text();
        return React.createElement(
            'div',
            { className: 'dateEditor' },
            this.props.showInterval ? React.createElement(
                'table',
                null,
                React.createElement(
                    'thead',
                    null,
                    React.createElement(
                        'tr',
                        null,
                        React.createElement(
                            'th',
                            null,
                            React.createElement(
                                'label',
                                null,
                                React.createElement('input', { type: 'radio', checked: !this.state.isInterval, onChange: function onChange(evt) {
                                        return _this12.setState({ isInterval: !evt.target.checked });
                                    }, value: 'date' }),
                                ' Date'
                            )
                        ),
                        React.createElement(
                            'th',
                            null,
                            ' or '
                        ),
                        React.createElement(
                            'th',
                            { colSpan: '2' },
                            React.createElement(
                                'label',
                                null,
                                React.createElement('input', { type: 'radio', checked: this.state.isInterval, onChange: function onChange(evt) {
                                        return _this12.setState({ isInterval: evt.target.checked });
                                    }, value: 'interval' }),
                                'Interval'
                            )
                        )
                    )
                ),
                React.createElement(
                    'tbody',
                    null,
                    React.createElement(
                        'tr',
                        null,
                        React.createElement(
                            'td',
                            null,
                            React.createElement('input', { type: 'text', size: '10', name: this.props.name + "/@when", disabled: this.state.isInterval, defaultValue: when })
                        ),
                        React.createElement('td', null),
                        React.createElement(
                            'td',
                            null,
                            React.createElement(
                                'select',
                                { type: 'select', onChange: function onChange(evt) {
                                        return _this12.setState({ notBefore: evt.target.value === 'notBefore' });
                                    }, disabled: !this.state.isInterval, value: this.state.notBefore ? 'notBefore' : 'from' },
                                React.createElement(
                                    'option',
                                    { value: 'from' },
                                    'From'
                                ),
                                React.createElement(
                                    'option',
                                    { value: 'notBefore' },
                                    'Not before'
                                )
                            ),
                            React.createElement('br', null),
                            React.createElement(
                                'select',
                                { type: 'select', onChange: function onChange(evt) {
                                        return _this12.setState({ notAfter: evt.target.value === 'notAfter' });
                                    }, disabled: !this.state.isInterval, value: this.state.notAfter ? 'notAfter' : 'to' },
                                React.createElement(
                                    'option',
                                    { value: 'to' },
                                    'To'
                                ),
                                React.createElement(
                                    'option',
                                    { value: 'notAfter' },
                                    'Not after'
                                )
                            )
                        ),
                        React.createElement(
                            'td',
                            null,
                            React.createElement('input', { type: 'text', size: '10', name: this.props.name + (this.state.notBefore ? "/@notBefore" : "/@from"), disabled: !this.state.isInterval, defaultValue: from }),
                            React.createElement('br', null),
                            React.createElement('input', { type: 'text', size: '10', name: this.props.name + (this.state.notAfter ? "/@notAfter" : "/@to"), disabled: !this.state.isInterval, defaultValue: to })
                        )
                    )
                )
            ) : React.createElement(
                'label',
                null,
                'Date ',
                React.createElement('input', { type: 'text', size: '10', name: this.props.name + "/@when", defaultValue: when })
            ),
            this.props.showFreeText && React.createElement(
                'label',
                null,
                'Free text: ',
                React.createElement('input', { type: 'text', name: this.props.name + "/#text", defaultValue: text })
            ),
            !this.props.showFreeText && React.createElement('input', { type: 'hidden', name: this.props.name + "/#text", value: text })
        );
    }
});

var OrigDate = React.createClass({
    displayName: 'OrigDate',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string,
        showFreeText: React.PropTypes.bool
    },

    getDefaultProps: function getDefaultProps() {
        return {
            showFreeText: false
        };
    },
    getInitialState: function getInitialState() {
        return {
            isInterval: $(this.props.data).is('[notBefore], [notAfter]'),
            when: $(this.props.data).attr('when') || '',
            notBefore: $(this.props.data).attr('notBefore') || '',
            notAfter: $(this.props.data).attr('notAfter') || '',
            text: $(this.props.data).text() || ''
        };
    },
    isIntervalChanged: function isIntervalChanged(evt) {
        this.setState({ isInterval: evt.target.value === 'interval' && evt.target.checked });
    },
    whenChanged: function whenChanged(evt) {
        this.setState({ when: evt.target.value });
    },
    notBeforeChanged: function notBeforeChanged(evt) {
        this.setState({ notBefore: evt.target.value });
    },
    notAfterChanged: function notAfterChanged(evt) {
        this.setState({ notAfter: evt.target.value });
    },
    textChanged: function textChanged(evt) {
        this.setState({ text: evt.target.value });
    },
    render: function render() {
        return React.createElement(
            'div',
            { className: 'origDateEditor' },
            React.createElement(
                'div',
                null,
                React.createElement(
                    'label',
                    null,
                    React.createElement('input', { type: 'radio', checked: !this.state.isInterval, onChange: this.isIntervalChanged, value: 'date' }),
                    ' Date'
                ),
                React.createElement(
                    'label',
                    null,
                    React.createElement('input', { type: 'radio', checked: this.state.isInterval, onChange: this.isIntervalChanged, value: 'interval' }),
                    ' Interval'
                )
            ),
            React.createElement(
                'div',
                null,
                this.state.isInterval ? React.createElement(
                    'label',
                    null,
                    'Not before ',
                    React.createElement('input', { type: 'text', size: '10', name: this.props.name + "/@notBefore", value: this.state.notBefore, onChange: this.notBeforeChanged })
                ) : React.createElement(
                    'label',
                    null,
                    'When ',
                    React.createElement('input', { type: 'text', size: '10', name: this.props.name + "/@when", value: this.state.when, onChange: this.whenChanged })
                ),
                this.state.isInterval && React.createElement(
                    'label',
                    null,
                    'Not after ',
                    React.createElement('input', { type: 'text', size: '10', name: this.props.name + "/@notAfter", value: this.state.notAfter, onChange: this.notAfterChanged })
                )
            ),
            this.props.showFreeText && React.createElement(
                'div',
                null,
                React.createElement(
                    'label',
                    null,
                    'Free text: ',
                    React.createElement('input', { type: 'text', name: this.props.name + "/#text", value: this.state.text, onChange: this.textChanged })
                )
            ),
            !this.props.showFreeText && React.createElement('input', { type: 'hidden', name: this.props.name + "/#text", value: this.state.text })
        );
    }
});

var termTypes = ['layout', 'proximity', 'script', 'wm_motif', 'wm_term'];
var Term = React.createClass({
    displayName: 'Term',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string,
        type: React.PropTypes.oneOf(termTypes),
        showFreeText: React.PropTypes.bool,
        // showMaterial: React.PropTypes.bool,
        showSameAs: React.PropTypes.bool,
        showXmlLang: React.PropTypes.bool,
        showCert: React.PropTypes.bool,
        showRef: React.PropTypes.bool,
        showType: React.PropTypes.bool
    },

    getDefaultProps: function getDefaultProps() {
        return {
            type: null,
            showFreeText: false,
            //showMaterial: false,
            showSameAs: false,
            showXmlLang: false,
            showCert: false,
            showRef: false,
            showType: false
        };
    },
    render: function render() {
        return React.createElement(
            'div',
            { className: 'Term' },
            this.props.showFreeText && React.createElement(
                'label',
                null,
                'Term',
                React.createElement('input', { type: 'text', name: this.props.name + '/#text', defaultValue: $(this.props.data).text() })
            ),
            !this.props.showFreeText && React.createElement('input', { type: 'hidden', value: $(this.props.data).text(), name: this.props.name + "/#text" }),
            this.props.type && React.createElement('input', { type: 'hidden', name: this.props.name + '/@type', value: this.props.type }),
            this.props.showType && React.createElement(
                'div',
                null,
                React.createElement(
                    'label',
                    null,
                    'Type'
                ),
                ' ',
                React.createElement(Select, { name: this.props.name + '/@type', options: termTypes, defaultValue: $(this.props.data).attr('type'), placeholder: '' })
            ),
            this.props.showXmlLang && React.createElement(XmlLang, { required: false, name: this.props.name, defaultValue: $(this.props.data).attr('xml:lang') }),
            this.props.showSameAs && React.createElement(SameAs, { name: this.props.name, defaultValue: $(this.props.data).attr('sameAs') }),
            this.props.showCert && React.createElement(Cert, { name: this.props.name, defaultValue: $(this.props.data).attr('cert') }),
            this.props.showRef && React.createElement(Ref, { name: this.props.name, defaultValue: $(this.props.data).attr('ref') })
        );
    }
});

var Locus = React.createClass({
    displayName: 'Locus',

    schemeTypes: ['folios', 'pages', 'other'],

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    render: function render() {
        return React.createElement(
            'div',
            { className: 'Locus' },
            React.createElement(
                'label',
                null,
                'From',
                React.createElement('input', { type: 'text', name: this.props.name + '/@from', defaultValue: $(this.props.data).attr('from') })
            ),
            React.createElement(
                'label',
                null,
                'To',
                React.createElement('input', { type: 'text', name: this.props.name + '/@to', defaultValue: $(this.props.data).attr('to') })
            ),
            React.createElement(
                'label',
                null,
                'Scheme',
                React.createElement(Select, { name: this.props.name + '/@scheme', defaultValue: $(this.props.data).attr('scheme'), options: this.schemeTypes })
            )
        );
    }
});

var Availability = React.createClass({
    displayName: 'Availability',

    statuses: ["free"],

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    render: function render() {
        return React.createElement(
            'div',
            null,
            React.createElement(
                'label',
                null,
                'Availability'
            ),
            React.createElement(Select, { name: this.props.name + '/@status', options: this.statuses, defaultValue: $(this.props.data).attr('status') }),
            React.createElement(Licence, { data: getData('licence', this.props.data), name: this.props.name + "/licence" })
        );
    }
});

var Licence = React.createClass({
    displayName: 'Licence',

    licences: [{ uri: "https://creativecommons.org/licenses/by/4.0/", label: "Creative Commons Attribution 4.0 International" }],

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    getInitialState: function getInitialState() {
        return {
            selected: $(this.props.data).text()
        };
    },
    render: function render() {
        var _this13 = this;

        var options = this.licences.map(function (l) {
            return { value: l.label, label: l.label };
        });
        var selectedLicence = $(this.licences).filter(function (i, l) {
            return l.label === _this13.state.selected;
        }).get(0);
        return React.createElement(
            'span',
            null,
            React.createElement(
                'label',
                null,
                'Licence'
            ),
            React.createElement(Select, { name: this.props.name + '/#text', options: options, defaultValue: this.state.selected, onChange: function onChange(evt, value) {
                    return _this13.setState({ selected: value });
                } }),
            React.createElement('input', { type: 'hidden', name: this.props.name + '/@target', value: selectedLicence ? selectedLicence.uri : undefined })
        );
    }
});

var Material = React.createClass({
    displayName: 'Material',

    materials: ['Western paper', 'Western paper without watermarks', 'Arabic paper', 'Parchment'],

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string,
        required: React.PropTypes.bool
    },

    render: function render() {
        return React.createElement(
            'div',
            { className: 'Material' },
            React.createElement(
                'label',
                null,
                'Material'
            ),
            React.createElement(Select, { name: this.props.name + '/#text', defaultValue: $(this.props.data).text(), options: this.materials, placeholder: this.props.required ? undefined : '' })
        );
    }
});

/*  Dimensions: only @quantity is supported, not @min/@max */
var Dimensions = React.createClass({
    displayName: 'Dimensions',

    dimensionTypes: ['binding', 'chain-lines', 'leaf', 'wm', 'written'],

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string,
        type: React.PropTypes.string,
        widthDisabled: React.PropTypes.bool,
        heightDisabled: React.PropTypes.bool,
        depthDisabled: React.PropTypes.bool
    },

    render: function render() {
        return React.createElement(
            'div',
            { className: 'Dimensions' },
            this.props.type ? React.createElement('input', { type: 'hidden', name: this.props.name + '/@type', value: this.props.type }) : React.createElement(Select, { name: this.props.name + '/@type', defaultValue: this.props.data.getAttribute('type'), options: this.dimenisonTypes }),
            !this.props.heightDisabled && React.createElement(
                'div',
                null,
                React.createElement(
                    'label',
                    null,
                    'Height ',
                    React.createElement('input', { type: 'text', name: this.props.name + '/height/@quantity', defaultValue: $('height', this.props.data).attr('quantity') })
                )
            ),
            !this.props.widthDisabled && React.createElement(
                'div',
                null,
                React.createElement(
                    'label',
                    null,
                    'Width ',
                    React.createElement('input', { type: 'text', name: this.props.name + '/width/@quantity', defaultValue: $('width', this.props.data).attr('quantity') })
                )
            ),
            !this.props.depthDisabled && React.createElement(
                'div',
                null,
                React.createElement(
                    'label',
                    null,
                    'Depth ',
                    React.createElement('input', { type: 'text', name: this.props.name + '/depth/@quantity', defaultValue: $('depth', this.props.data).attr('quantity') })
                )
            )
        );
    }
});

var LocusGrp = React.createClass({
    displayName: 'LocusGrp',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string,
        nameIdSuffix: React.PropTypes.string },

    getDefaultProps: function getDefaultProps() {
        return {
            nameIdSuffix: ''
        };
    },
    getInitialState: function getInitialState() {
        return {
            locusCount: $(this.props.data).children('locus').addBack('locus').get().length
        };
    },
    onChange: function onChange(oldItems, newItems) {
        this.setState({ locusCount: newItems.length });
    },
    render: function render() {
        var name;
        if (this.state.locusCount >= 2) {
            name = this.props.name + '/locusGrp' + this.props.nameIdSuffix + '/locus';
        } else {
            name = this.props.name + '/locus' + this.props.nameIdSuffix;
        }
        return React.createElement(
            ZeroOrMore,
            { data: $(this.props.data).children('locus').addBack('locus').get(), name: name, onChange: this.onChange },
            React.createElement(Locus, null)
        );
    }
});

var Watermark = React.createClass({
    displayName: 'Watermark',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    render: function render() {
        return React.createElement(
            'fieldset',
            null,
            React.createElement(
                'legend',
                null,
                'Watermark ',
                React.createElement(
                    'i',
                    null,
                    '(watermark)'
                )
            ),
            React.createElement(
                'label',
                null,
                'Number ',
                React.createElement('input', { type: 'text', defaultValue: $(this.props.data).attr('n'), name: this.props.name + "/@n", width: 5 })
            ),
            React.createElement(
                'fieldset',
                null,
                React.createElement(
                    'legend',
                    null,
                    'Locus ',
                    React.createElement(
                        'i',
                        null,
                        '(locus | locusGrp)'
                    )
                ),
                React.createElement(LocusGrp, { name: this.props.name, data: $(this.props.data).children('locus, locusGrp')[0] })
            ),
            React.createElement(
                'label',
                null,
                'Motif ',
                React.createElement(Term, { type: 'wm_motif', name: this.props.name + "/term", data: $(this.props.data).children('term')[0], showFreeText: true })
            )
        );
    }
});

var Support = React.createClass({
    displayName: 'Support',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    getInitialState: function getInitialState() {
        return {
            locusCount: $("support > p > locus, support > p > locusGrp > locus", this.props.data).get().length
        };
    },
    render: function render() {
        var p = $(this.props.data).children('p');
        if (p.length > 1) {
            // TODO support more than one p here?
            console.warn("More than one 'p' in 'support' is not supprted! (Keeping only the first one).");
            p = p.first();
        }
        return React.createElement(
            'fieldset',
            null,
            React.createElement(
                'legend',
                null,
                'Support ',
                React.createElement(
                    'i',
                    null,
                    '(support)'
                )
            ),
            React.createElement(
                'fieldset',
                null,
                React.createElement(
                    'legend',
                    null,
                    'Locus ',
                    React.createElement(
                        'i',
                        null,
                        '(locusGrp/locus)'
                    )
                ),
                React.createElement(LocusGrp, { data: p.children('locus, locusGrp')[0], name: this.props.name + '/p' })
            ),
            React.createElement(Material, { data: p.children('material')[0], name: this.props.name + '/p/material' }),
            React.createElement(
                'fieldset',
                null,
                React.createElement(
                    'legend',
                    null,
                    'Size of the flyleaves ',
                    React.createElement(
                        'i',
                        null,
                        '(dimensions@type="leaf")'
                    )
                ),
                React.createElement(Dimensions, { type: 'leaf', name: this.props.name + '/p/dimensions', data: p.children('dimensions[type="leaf"]')[0], depthDisabled: true })
            ),
            React.createElement(
                'div',
                { className: 'Folding' },
                React.createElement('input', { type: 'hidden', name: this.props.name + '/p/measure/@type', value: 'folding' }),
                React.createElement(
                    'label',
                    null,
                    'Folding',
                    React.createElement(Select, { name: this.props.name + '/p/measure/#text', options: ['Folio', 'Quarto', 'Octavo'], defaultValue: p.children('measure').text() })
                )
            ),
            React.createElement(
                'fieldset',
                null,
                React.createElement(
                    'legend',
                    null,
                    'Water marks'
                ),
                React.createElement(
                    ZeroOrMore,
                    { data: p.children('watermark').get(), name: this.props.name + '/p/watermark' },
                    React.createElement(Watermark, null)
                )
            ),
            React.createElement(
                'label',
                null,
                'Note'
            ),
            React.createElement('textarea', { className: 'form-control', name: this.props.name + '/p/#text', defaultValue: getImmediateText(p) })
        );
    }
});

var Extent = React.createClass({
    displayName: 'Extent',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    render: function render() {
        return React.createElement(
            'fieldset',
            null,
            React.createElement(
                'legend',
                null,
                'Extent ',
                React.createElement(
                    'i',
                    null,
                    '(extent)'
                )
            ),
            React.createElement(
                'label',
                null,
                'Left flyleaves'
            ),
            React.createElement(Text, { defaultValue: $('measure[type=left_flyleaves]', this.props.data).attr('quantity'), name: this.props.name + '/measure#1/@quantity' }),
            React.createElement('input', { type: 'hidden', name: this.props.name + '/measure#1/@type', value: 'left_flyleaves' }),
            React.createElement('br', null),
            React.createElement(
                'label',
                null,
                'Right flyleaves'
            ),
            React.createElement(Text, { defaultValue: $('measure[type=right_flyleaves]', this.props.data).attr('quantity'), name: this.props.name + '/measure#2/@quantity' }),
            React.createElement('input', { type: 'hidden', name: this.props.name + '/measure#2/@type', value: 'right_flyleaves' })
        );
    }
});

//var Foliation = React.createClass({
//    propTypes: {
//        data: React.PropTypes.instanceOf(Element),
//        name: React.PropTypes.string,
//    },
//
//    render() {
//        return(
//            <fieldset>
//                <legend>Foliation <i>(foliation)</i></legend>
//            </fieldset>
//        );
//    },
//
//});

var HandNote = React.createClass({
    displayName: 'HandNote',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    getInitialState: function getInitialState() {
        return {
            handId: $(this.props.data).attr('xml:id') || ''
        };
    },
    onHandIdChange: function onHandIdChange(evt) {
        var n = evt.target.value;
        this.setState({ handId: 'hand-' + n });
    },
    render: function render() {
        var match = /^hand-(\d+)$/.exec(this.state.handId);
        var handNumber = match !== null && match[1] ? match[1] : '';

        /* The child elements is handled a bit differnetly for the componenet for the element handNote.
           Because we want a locus/locusGrp and a persName, both optional, to be separate fields in the UI,
           but in the schema, the locus/locusGrp element is separately declared, but persName is just another optional element with the rest of the children in handNote, which are a variety (see description field)
           Further, locus, locusGrp and persName may also be found in the rest of the child elements.
           So if locus/grp and/or persName are first child(ren) in handNote, treat them as the Locus and Scribe in the editor UI, and the rest of the children are put in the Description field */
        var locus = $(this.props.data).children('locus:first-child, locusGrp:first-child').get(0);
        var scribe_persName = $(this.props.data).children('persName:first-child, locus:first-child + persName, locusGrp:first-child + persName').first().get(0);
        var desc = $(this.props.data).contents().not(locus).not(scribe_persName).clone().wrapAll('<root/>').parent().get(0);

        return React.createElement(
            'fieldset',
            null,
            React.createElement(
                'legend',
                null,
                'Hand ',
                React.createElement(
                    'i',
                    null,
                    '(handNote)'
                )
            ),
            React.createElement(
                'label',
                null,
                'Number ',
                React.createElement('input', { type: 'text', defaultValue: handNumber, width: 5, onChange: this.onHandIdChange })
            ),
            React.createElement('input', { type: 'hidden', name: this.props.name + "/@xml:id", value: this.state.handId }),
            React.createElement(
                'fieldset',
                null,
                React.createElement(
                    'legend',
                    null,
                    'Locus ',
                    React.createElement(
                        'i',
                        null,
                        '(locus | locusGrp)'
                    )
                ),
                React.createElement(LocusGrp, { name: this.props.name, data: locus, nameIdSuffix: "#locus" })
            ),
            React.createElement(
                'fieldset',
                null,
                React.createElement(
                    'legend',
                    null,
                    'Scribe'
                ),
                React.createElement(PersName, { data: scribe_persName, name: this.props.name + '/persName#scribe', showCert: true, showEvidence: true, showSameAs: true, showRole: true })
            ),
            React.createElement(
                'label',
                null,
                'Description'
            ),
            React.createElement(MyTextArea, { name: this.props.name, data: desc, multiParagraph: false, topElems: ['bibl', 'date', 'foreign', 'idno', 'locus', 'locusGrp', 'term', 'persName', 'quote'] })
        );
    }
});

var ObjectDesc = React.createClass({
    displayName: 'ObjectDesc',

    formTypes: ['codex', 'fragment', 'roll'],

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        name: React.PropTypes.string
    },

    render: function render() {
        return React.createElement(
            'fieldset',
            null,
            React.createElement(
                'legend',
                null,
                'Description of the Binding ',
                React.createElement(
                    'i',
                    null,
                    '(objectDesc)'
                )
            ),
            React.createElement(
                'div',
                null,
                React.createElement(
                    'label',
                    null,
                    'Physical form'
                ),
                React.createElement(Select, { defaultValue: $(this.props.data).attr('form'), name: this.props.name + '/@form', options: this.formTypes, placeholder: '' })
            ),
            React.createElement(
                'fieldset',
                null,
                React.createElement(
                    'legend',
                    null,
                    'Support of the flyleaves ',
                    React.createElement(
                        'i',
                        null,
                        '(supportDesc)'
                    )
                ),
                React.createElement(Support, { name: this.props.name + '/supportDesc/support', data: getData('supportDesc/support', this.props.data) }),
                React.createElement(Extent, { name: this.props.name + '/supportDesc/extent', data: getData('supportDesc/extent', this.props.data) }),
                React.createElement(
                    'label',
                    null,
                    'Foliation'
                ),
                React.createElement('br', null),
                React.createElement(MyTextArea, { name: this.props.name + '/supportDesc/foliation', data: getData('supportDesc/foliation', this.props.data), topElems: ['foreign', 'locus', 'locusGrp', 'num', 'persName', 'supplied', 'term'] })
            )
        );
    }
});

var HeaderForm = React.createClass({
    displayName: 'HeaderForm',

    propTypes: {
        data: React.PropTypes.instanceOf(Element)
    },

    render: function render() {
        return React.createElement(
            'div',
            { id: 'headerForm' },
            React.createElement(
                'fieldset',
                null,
                React.createElement(
                    'legend',
                    null,
                    'File description'
                ),
                React.createElement(
                    'label',
                    null,
                    'Title of description'
                ),
                React.createElement(Text, { className: 'form-control', data: getData("TEI/teiHeader/fileDesc/titleStmt/title", this.props.data), name: 'TEI/teiHeader/fileDesc/titleStmt/title/#text' }),
                React.createElement(
                    'fieldset',
                    null,
                    React.createElement(
                        'legend',
                        null,
                        'Statement of responsibility ',
                        React.createElement(
                            'i',
                            null,
                            '(respStmt)'
                        )
                    ),
                    React.createElement(
                        ZeroOrMore,
                        { emptyPlaceholder: '(empty)', data: getDataArr("TEI/teiHeader/fileDesc/titleStmt/respStmt", this.props.data), name: 'TEI/teiHeader/fileDesc/titleStmt/respStmt' },
                        React.createElement(RespStmt, null)
                    )
                ),
                React.createElement(
                    'fieldset',
                    null,
                    React.createElement(
                        'legend',
                        null,
                        React.createElement(
                            'i',
                            null,
                            'publicationStmt'
                        )
                    ),
                    React.createElement(Publisher, { data: getData("TEI/teiHeader/fileDesc/publicationStmt/publisher", this.props.data), name: 'TEI/teiHeader/fileDesc/publicationStmt/publisher' }),
                    React.createElement(DateElem, { data: getData("TEI/teiHeader/fileDesc/publicationStmt/date", this.props.data), showInterval: false, showFreeText: false, name: 'TEI/teiHeader/fileDesc/publicationStmt/date' }),
                    React.createElement(Availability, { data: getData("TEI/teiHeader/fileDesc/publicationStmt/availability", this.props.data), name: 'TEI/teiHeader/fileDesc/publicationStmt/availability' })
                ),
                React.createElement(
                    'fieldset',
                    null,
                    React.createElement(
                        'legend',
                        null,
                        'Manuscript identifier ',
                        React.createElement(
                            'i',
                            null,
                            '(msIdentifier)'
                        )
                    ),
                    React.createElement(
                        'div',
                        null,
                        React.createElement(
                            'label',
                            null,
                            'Country'
                        ),
                        React.createElement(Country, { data: getData("TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/country", this.props.data), name: "TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/country" })
                    ),
                    React.createElement(
                        'div',
                        null,
                        React.createElement(
                            'label',
                            null,
                            'Settlement'
                        ),
                        React.createElement(Settlement, { data: getData("TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/settlement", this.props.data), name: "TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/settlement" })
                    ),
                    React.createElement(
                        'div',
                        null,
                        React.createElement(
                            'label',
                            null,
                            'Institution'
                        ),
                        React.createElement(Institution, { data: getData("TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/institution", this.props.data), name: "TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/institution" })
                    ),
                    React.createElement(
                        'div',
                        null,
                        React.createElement(
                            'label',
                            null,
                            'Repository'
                        ),
                        React.createElement(Repository, { data: getData("TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/repository", this.props.data), name: "TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/repository" })
                    ),
                    React.createElement(
                        'div',
                        null,
                        React.createElement(
                            'label',
                            null,
                            'Shelfmark'
                        ),
                        React.createElement(Idno, { type: 'shelfmark', data: getData("TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/idno[type='shelfmark']", this.props.data), name: "TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/idno" })
                    ),
                    React.createElement(
                        'div',
                        null,
                        React.createElement(
                            'label',
                            null,
                            'Former Shelfmark'
                        ),
                        React.createElement(
                            ZeroOrMore,
                            { data: $(getDataArr("TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/altIdentifier", this.props.data)).has("idno[type='former_shelfmark']").get(), name: "TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/altIdentifier#former" },
                            React.createElement(AltIdentifier, { type: 'former_shelfmark' })
                        )
                    ),
                    React.createElement(
                        'div',
                        null,
                        React.createElement(
                            'label',
                            null,
                            'Other identifier'
                        ),
                        React.createElement(
                            ZeroOrMore,
                            { data: $(getDataArr("TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/altIdentifier", this.props.data)).has("idno[type='other']").get(), name: "TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/altIdentifier#other" },
                            React.createElement(AltIdentifier, { type: 'other' })
                        )
                    ),
                    React.createElement(
                        'div',
                        null,
                        React.createElement(
                            'label',
                            null,
                            'Alternative Name'
                        ),
                        React.createElement(
                            ZeroOrMore,
                            { data: getDataArr("TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/msName", this.props.data), name: "TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/msName" },
                            React.createElement(MsName, null)
                        )
                    )
                )
            )
        );
    }
});

var BindingForm = React.createClass({
    displayName: 'BindingForm',

    propTypes: {
        data: React.PropTypes.instanceOf(Element)
    },

    render: function render() {
        return React.createElement(
            'div',
            { className: 'bindingForm' },
            React.createElement(ObjectDesc, { data: getData("TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/objectDesc", this.props.data), name: "TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/objectDesc" }),
            React.createElement(
                'fieldset',
                null,
                React.createElement(
                    'legend',
                    null,
                    'Description of hands on the flyleaves ',
                    React.createElement(
                        'i',
                        null,
                        '(handDesc)'
                    )
                ),
                React.createElement(
                    OneOrMore,
                    { data: getData("TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/handDesc/handNote", this.props.data), name: "TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/handDesc/handNote" },
                    React.createElement(HandNote, null)
                )
            ),
            React.createElement(
                'fieldset',
                null,
                React.createElement(
                    'legend',
                    null,
                    'Contents on the flyleaves ',
                    React.createElement(
                        'i',
                        null,
                        '(additions)'
                    )
                ),
                React.createElement(MyTextArea, { data: getData("TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/additions/p", this.props.data), name: "TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/additions/p" })
            ),
            React.createElement(
                'fieldset',
                null,
                React.createElement(
                    'legend',
                    null,
                    'Binding Description',
                    React.createElement(
                        'i',
                        null,
                        '(bindingDesc)'
                    )
                ),
                React.createElement(MyTextArea, { data: getData("TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/bindingDesc/binding/p", this.props.data), name: "TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/bindingDesc/binding/p" })
            )
        );
    }
});

var ProvenanceForm = React.createClass({
    displayName: 'ProvenanceForm',

    /* The commented out elements are to point out the difference between the three. The differences are according to the schema. */
    allowedElemsAcquisition: [/*"bibl",*/"date", "foreign", "idno", "locus", /*"origDate", "origPlace",*/"orgName", "persName", "placeName", "quote"],
    allowedElemsProvenance: ["bibl", "date", "foreign", "idno", "locus", /*"origDate", "origPlace",*/"orgName", "persName", "placeName", "quote"],
    allowedElemsOrigin: ["bibl", "date", "foreign", "idno", "locus", "origDate", "origPlace", /*"orgName",*/"persName", /*"placeName",*/"quote"],

    propTypes: {
        data: React.PropTypes.instanceOf(Element)
    },

    render: function render() {
        return React.createElement(
            'div',
            { id: 'provenanceForm' },
            React.createElement(
                'div',
                null,
                React.createElement(
                    'h3',
                    null,
                    'Origin'
                ),
                React.createElement(MyTextArea, {
                    data: getData("TEI/teiHeader/fileDesc/sourceDesc/msDesc/history/origin", this.props.data),
                    name: "TEI/teiHeader/fileDesc/sourceDesc/msDesc/history/origin",
                    topElems: this.allowedElemsOrigin, multiParagraph: false })
            ),
            React.createElement(
                'div',
                null,
                React.createElement(
                    'h3',
                    null,
                    'Provenance'
                ),
                React.createElement(MyTextArea, {
                    data: getData("TEI/teiHeader/fileDesc/sourceDesc/msDesc/history/provenance", this.props.data),
                    name: "TEI/teiHeader/fileDesc/sourceDesc/msDesc/history/provenance",
                    topElems: this.allowedElemsProvenance, multiParagraph: true })
            ),
            React.createElement(
                'div',
                null,
                React.createElement(
                    'h3',
                    null,
                    'Acquisition'
                ),
                React.createElement(MyTextArea, {
                    data: getData("TEI/teiHeader/fileDesc/sourceDesc/msDesc/history/acquisition", this.props.data),
                    name: "TEI/teiHeader/fileDesc/sourceDesc/msDesc/history/acquisition",
                    topElems: this.allowedElemsAcquisition, multiParagraph: false })
            )
        );
    }
});

var BibliographyForm = React.createClass({
    displayName: 'BibliographyForm',

    propTypes: {
        data: React.PropTypes.instanceOf(Element)
    },

    render: function render() {
        return React.createElement('div', { id: 'bibliographyForm' });
    }
});

var EditorForm = React.createClass({
    displayName: 'EditorForm',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        fileId: React.PropTypes.string,
        onDataChange: React.PropTypes.func
    },

    getInitialState: function getInitialState() {
        var _this14 = this;

        var staticTabs = [{ label: 'Header', content: React.createElement(HeaderForm, { data: this.props.data }) }, { label: 'Binding', content: React.createElement(BindingForm, { data: this.props.data }) }, { label: 'Provenance', content: React.createElement(ProvenanceForm, { data: this.props.data }) }, { label: 'Bibliography', content: React.createElement(BibliographyForm, { data: this.props.data }) }];

        var extraTabs = [{ label: "Codiological unit" }];

        var initialSelectedIndex = -1;

        staticTabs.forEach(function (t, i) {
            if (_this14.normalizeTabLabel(t.label) === window.location.hash.substr(1)) {
                initialSelectedIndex = i;
                return false;
            }
        });
        if (initialSelectedIndex === -1) {
            extraTabs.forEach(function (t, i) {
                if (_this14.normalizeTabLabel(t.label) === window.location.hash.substr(1)) {
                    initialSelectedIndex = i + staticTabs.length;
                    return false;
                }
            });
        }
        if (initialSelectedIndex === -1) initialSelectedIndex = 0;

        return {
            selectedIndex: initialSelectedIndex,
            staticTabs: staticTabs,
            extraTabs: extraTabs
        };
    },
    normalizeTabLabel: function normalizeTabLabel(label) {
        return label.toLowerCase().replace(/ /g, '_');
    },
    applyChanges: function applyChanges() {
        var formArray = $(this.refs.form).serializeArray();
        var formDoc = this.props.data;
        var pathsToClear = [['TEI > teiHeader > fileDesc > titleStmt', 'TEI > teiHeader > fileDesc > publicationStmt', 'TEI > teiHeader > fileDesc > sourceDesc > msDesc > msIdentifier'], ['TEI > teiHeader > fileDesc > sourceDesc > msDesc > physDesc > objectDesc', 'TEI > teiHeader > fileDesc > sourceDesc > msDesc > physDesc > handDesc'], ['TEI > teiHeader > fileDesc > sourceDesc > msDesc > history'], []][this.state.selectedIndex];
        pathsToClear.forEach(function (path) {
            return $(formDoc).find(path).empty();
        });

        // insert new data into formDoc
        formArrayToXml(formArray, formDoc.ownerDocument);

        if (this.props.onDataChange) this.props.onDataChange(formDoc);

        return formDoc;
    },
    onSubmit: function onSubmit(evt) {
        try {
            var formDoc = this.applyChanges();
            $.ajax({
                url: "modules/editor.xql?id=" + this.props.fileId,
                method: 'POST',
                data: formDoc.outerHTML,
                contentType: 'application/xml',
                processData: false
            });
        } finally {
            evt.preventDefault();
        }
    },
    onSelect: function onSelect(index, last) {
        window.location.hash = this.normalizeTabLabel(this.state.staticTabs[index].label);
        this.applyChanges();
        this.setState({ selectedIndex: index });
    },
    render: function render() {
        var tabLabels = this.state.staticTabs.map(function (tab, i) {
            return React.createElement(
                Tab,
                { key: i },
                tab.label
            );
        });

        var extraTabLabels = this.state.extraTabs.map(function (tab, i) {
            return React.createElement(
                Tab,
                { key: tabLabels.length + i },
                tab.label
            );
        });

        tabLabels.concat(extraTabLabels);

        var tabContents = this.state.staticTabs.map(function (tab, i) {
            return React.createElement(
                TabPanel,
                { key: i },
                tab.content
            );
        });

        var extraTabContents = this.state.extraTabs.map(function (tab, i) {
            return React.createElement(
                TabPanel,
                { key: tabContents.length + i },
                tab.content
            );
        });

        tabContents.concat(extraTabContents);

        return React.createElement(
            'form',
            { ref: 'form', id: 'editorForm', action: '#', onSubmit: this.onSubmit },
            React.createElement(
                Tabs,
                { onSelect: this.onSelect, selectedIndex: this.state.selectedIndex },
                React.createElement(
                    TabList,
                    null,
                    tabLabels
                ),
                tabContents
            ),
            React.createElement(
                'button',
                { type: 'submit', className: 'btn' },
                'Apply'
            )
        );
    },
    addTab: function addTab() {}
});

var EditorPreview = React.createClass({
    displayName: 'EditorPreview',


    request: null,

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        fileId: React.PropTypes.string
    },

    getInitialState: function getInitialState() {
        return {
            previewContent: null,
            loading: false,
            error: false,
            selectedTabIndex: 1
        };
    },
    updatePreview: function updatePreview(newData) {
        var _this15 = this;

        if (this.request) this.request.abort();

        this.savedPreviewState = {
            openPanels: $('.collapse.in', this.refs.preview).map(function (i, e) {
                return '#' + e.getAttribute('id');
            }).get(),
            scrollTop: $(this.refs.preview).scrollTop()
        };

        var previewData = newData;

        if (previewData) {
            this.request = $.ajax({
                url: 'modules/editor2.xql?action=get-preview',
                method: 'POST',
                data: previewData.ownerDocument,
                processData: false,
                contentType: 'text/xml'
            }).done(function (response) {
                _this15.setState({
                    previewContent: response,
                    loading: false,
                    error: false
                });
            }).fail(function (o, textStatus, e) {
                _this15.setState({
                    previewContent: null,
                    loading: false,
                    error: textStatus + ": " + e.message
                });
            });

            this.setState({
                error: false,
                loading: true
            });
        } else {
            this.setState({
                previewContent: null,
                error: false,
                loading: false
            });
        }
    },
    componentWillReceiveProps: function componentWillReceiveProps(newProps) {
        this.updatePreview(newProps.data);
    },
    componentWillMount: function componentWillMount() {
        this.updatePreview(this.props.data);
    },
    componentDidUpdate: function componentDidUpdate() {
        if (this.state.selectedTabIndex === 0) {
            // restore scroll/collapse state
            if (this.savedPreviewState && !this.state.loading && !this.state.error) {
                $(this.savedPreviewState.openPanels.join(','), this.refs.preview).addClass('in'); // Resore the collapsed panels (bootstrap components). Use addClass instead of 'show' method to skip animations.
                $(this.refs.preview).scrollTop(this.savedPreviewState.scrollTop);
                this.savedPreviewState = null;
            }
        } else if (this.state.selectedTabIndex === 1) {
            $(this.refs.diva).diva({
                iipServerURL: "http://www.manuscripta.se/iipsrv/iipsrv.fcgi",
                objectData: "metadata/diva/" + this.props.fileId + ".json",
                imageDir: this.props.fileId,
                //      If using IIIF omit iipServerURL and imageDir and comment out the following line
                //      objectData: "iiif/" + shelfmark + "/manifest.json",
                viewerWidthPadding: 0,
                enableAutoWidth: false,
                enableAutoHeight: false,
                fixedHeightGrid: true,
                enableFilename: false,
                minZoomLevel: 0,
                zoomLevel: 2,
                pagesPerRow: 2,
                maxPagesPerRow: 10,
                verticallyOriented: true,
                inFullscreen: false,
                inGrid: false,
                enableLinkIcon: false,
                enableAutoTitle: false,
                enableDownload: true,
                blockMobileMove: false
            });
        }
    },
    onSelectTab: function onSelectTab(newIndex, oldIndex) {
        if (oldIndex === 1) {
            if ($(this.refs.diva).data('diva')) {
                $(this.refs.diva).data('diva').destroy();
            }
        }
        this.setState({ selectedTabIndex: newIndex });
    },
    render: function render() {
        return React.createElement(
            Tabs,
            { onSelect: this.onSelectTab, selectedIndex: this.state.selectedTabIndex },
            React.createElement(
                TabList,
                null,
                React.createElement(
                    Tab,
                    null,
                    'MsDesc Preview'
                ),
                React.createElement(
                    Tab,
                    null,
                    'Viewer'
                )
            ),
            React.createElement(
                TabPanel,
                null,
                this.state.error && "Error loading preview:" + this.state.error,
                this.state.loading && React.createElement(
                    'div',
                    { className: 'panel', style: { position: 'absolute' } },
                    React.createElement('span', { className: 'glyphicon glyphicon-refresh spinner' }),
                    ' Loading preview...'
                ),
                this.state.previewContent && React.createElement('div', { id: 'editor-preview', ref: 'preview', dangerouslySetInnerHTML: { __html: this.state.previewContent.documentElement.outerHTML } })
            ),
            React.createElement(
                TabPanel,
                null,
                React.createElement('div', { ref: 'diva', id: 'diva-outer' })
            )
        );
    }
});

var EditorPanes = React.createClass({
    displayName: 'EditorPanes',

    propTypes: {
        data: React.PropTypes.instanceOf(Element),
        fileId: React.PropTypes.string
    },

    getInitialState: function getInitialState() {
        return {
            data: this.props.data
        };
    },
    componentDidMount: function componentDidMount() {
        Split(['#editor-form-pane', '#editor-preview-pane'], {
            sizes: [50, 50],
            minSize: 0
        });
    },
    onDataChange: function onDataChange(data) {
        this.setState({ data: data });
    },
    render: function render() {
        return React.createElement(
            'div',
            { id: 'editorPanes', className: 'flex' },
            React.createElement(
                'div',
                { id: 'editor-form-pane', className: 'split-horizontal' },
                React.createElement(EditorForm, { fileId: this.props.fileId, data: this.state.data, onDataChange: this.onDataChange })
            ),
            React.createElement(
                'div',
                { id: 'editor-preview-pane', className: 'split-horizontal' },
                React.createElement(EditorPreview, { fileId: this.props.fileId, data: this.state.data })
            )
        );
    }
});

var Editor = React.createClass({
    displayName: 'Editor',
    getInitialState: function getInitialState() {
        return {
            fileId: "100021",
            msFileLoaded: false,
            dataLoaded: false,
            loadError: null,
            saved: false,
            dataDoc: null
        };
    },
    componentWillMount: function componentWillMount() {
        var _this16 = this;

        this.request = $.get('modules/get_msDesc.xql?id=' + this.state.fileId, function (data) {
            _this16.setState({
                dataDoc: data,
                msFileLoaded: true
            });
        });
        loadData.done(function () {
            return _this16.setState({ dataLoaded: true });
        }).fail(function (obj, textStatus, error) {
            return _this16.setState({ loadError: textStatus + ": " + error });
        });

        document.title = 'Editing ' + this.state.fileId;
    },
    componentWillUnmount: function componentWillUnmount() {
        this.request.abort();
    },
    render: function render() {
        if (this.state.loadError !== null) {
            return React.createElement(
                'div',
                null,
                this.state.loadError
            );
        }
        if (!this.state.dataLoaded) {
            return React.createElement(
                'h3',
                null,
                'Loading data ...'
            );
        }
        if (!this.state.msFileLoaded) {
            return React.createElement(
                'h3',
                null,
                'Loading manuscript: ',
                this.state.fileId,
                ' ...'
            );
        }
        return React.createElement(
            'div',
            { id: 'editor' },
            React.createElement(EditorPanes, { fileId: this.state.fileId, data: this.state.dataDoc.documentElement })
        );
    },
    addTab: function addTab() {}
});

ReactDOM.render(React.createElement(Editor, null), document.getElementById('content'));

},{"react":"react","react-autocomplete":"react-autocomplete","react-dom":"react-dom","react-tabs":"react-tabs","split.js":1}]},{},[2]);
