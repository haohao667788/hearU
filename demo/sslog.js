KISSY.add('widget/sslog', function(S, UA, DOM) {
  var SSlog;
  SSlog = function() {
    if (location.href.indexOf("?ks-debug") === -1) {
      return function() {};
    }
    if ((typeof console === "undefined" || console === null) || UA.mobile) {
      this.el = DOM.create("<div id='SS_log'><p></p></div>");
      DOM.css(this.el, {
        position: 'absolute',
        top: 10,
        left: 10,
        width: 160,
        height: "90%",
        'z-index': 99999,
        'overflow-y': 'scroll',
        opacity: 0.5,
        background: '#000',
        color: '#fff',
        'font-size': '10px',
        'line-height': '12px'
      });
      DOM.append(this.el, 'body');
      this.log = function() {
        var txt;
        txt = DOM.create('<p></p>');
        txt.innerHTML = [].slice.call(arguments).join(', ');
        return DOM.prepend(txt, '#SS_log');
      };
      window.console = {};
      window.console.log = this.log;
      return this.log;
    } else {
      return function() {
        return console.log([].slice.call(arguments).join(' '));
      };
    }
  };
  return SSlog();
}, {
  requires: ['ua', 'dom']
});