function addWidget(){

  KISSY.add("widget/horidrag", function(S, Node, Event, UA, SSlog){
    var $ = KISSY.all;
    var defaultConfig = {
      distance: 6,
      angle: Math.PI/6,
      binds: [
        null,
        null,
        null,
        null,
        {
          moveEl: [], // 如果不为空，则只移动这里的元素
          maxDistance: 99999,
          validDistance: null,  // 一般是 maxDistance/2
          passCallback: null
        }
        // 最后一个只是例子，其实完全没用处，顺序按 up, right, down, left
      ]

    }

    function Matrix(transform, distance, hori) {
      if(UA.webkit)
        return (new WebKitCSSMatrix(transform)).translate(distance * hori, distance * (1 - hori));
//      if(UA.firefox) return new MozCSSMatrix(transform);
//      if(UA.firefox) return new MozCSSMatrix(transform);
//      if(UA.firefox) return new MozCSSMatrix(transform);
    }

    function movement(self, startPoint, lastPoint, endPoint) {
      var items = self.config.binds,
          key   = self.key;
      var rawDistance = self.distance =
        key % 2 === 0 ? endPoint[1] - startPoint[1] : endPoint[0] - startPoint[0];
      var distance = key % 2 === 0 ? endPoint[1] - lastPoint[1] : endPoint[0] - lastPoint[0];
      if(!items[key] || items[key].maxDistance < Math.abs(rawDistance)) return;
      var els = items[key].moveEl;
      els.forEach(function(el){
        el = $(el)[0];
        var currentTransform = el.style.webkitTransform
//        || el.style.mozTransform
//        || el.style.msTransform
//        || el.style.oTransform
//        || el.style.transform;
        el.style.webkitTransform
//        = el.style.mozTransform
//        = el.style.msTransform
//        = el.style.oTransform
//        = el.style.transform
          = Matrix(currentTransform, distance, key % 2);
      })
    }

    function getMatrix(el) {
      return $(el).css("-webkit-transform") || $(el).css("-o-transform") || $(el).css("transform");
    }


    function HoriDrag(el, config) {
      var self = this;
      self.el = el;
      self.config = config;
      self.init()
    }

    var o = {
      init: function(){
        var self = this;
        self.el = $(self.el);
        self.config = S.merge(defaultConfig, self.config);
        self.tanAngel = Math.tan(self.config.angle);
        self.config.binds.forEach(function(item){
          if(item){
            if(!item.moveEl.join('')) item.moveEl = [self.el]
          }
        })

        self.bindEvents();
      },
      bindEvents: function(){
        var self = this;
        self.el.on("touchstart", function(ev){
          ev.preventDefault();
          ev = ev.originalEvent;
          self.touchStart = true;
          self.isSendStart = false;
          self.eventType = null;
          self.key = null;
          self.startPoint = [ev.touches[0].pageX, ev.touches[0].pageY];
          self.lastPoint = self.startPoint.slice();
          self.originalMatrix = getMatrix(self.el);
          $('body').addClass("hroidrag-dragging");
        });
        self.el.on("touchmove", function(e){
          if(!self.touchStart) return;
          var ev = e.originalEvent;
          var point = [ev.touches[0].pageX, ev.touches[0].pageY];
          var oPoint = self.startPoint;
          var angleDelta = Math.abs((oPoint[1] - point[1]) / (point[0] - oPoint[0])); // 这是水平方向的
          var distance = [oPoint[0] - point[0], oPoint[1] - point[1]];
          var maxDistance = Math.max(Math.abs(distance[0]), Math.abs(distance[1]));
          if(!self.isSendStart && angleDelta > self.tanAngel && 1 / angleDelta > self.tanAngel) {
            self.touchStart = false;
            return;
          }
          else if(!self.eventType && maxDistance >= self.config.distance) {
            if(angleDelta <= self.tanAngel) {    //水平
              self.eventType = distance[0] > 0 ? "dragRight" : "dragLeft";
            }
            else if(1 / angleDelta <= self.tanAngel) {
              self.eventType = distance[1] > 0 ? "dragUp" : "dragDown";
            }
            else {
              self.eventType = null
            }
            self.key =
              self.eventType == "dragUp" ? 0 :
                self.eventType == "dragRight" ? 1 :
                  self.eventType == "dragDown" ? 2 :
                    self.eventType == "dragLeft" ? 3 : null;
          }
          SSlog(self.eventType);
          if(self.eventType){
            if(!self.isSendStart) {
              self.el.fire(self.eventType + "Start", S.mix(e, {self: self}));
              self.isSendStart = true;
            }
            self.el.fire(self.eventType, S.mix(e, {self: self}));
            if(!e.isDefaultPrevented()){
              movement(self, oPoint, self.lastPoint, point);
            }
          }

          self.lastPoint = point.slice();
        });
        self.el.on("touchend", function(e){
          $('body').removeClass("hroidrag-dragging");
          if(self.touchStart && self.isSendStart) {
            self.el.fire(self.eventType + "End", S.mix(e, {self: self}));
//            var point = [e.originalEvent.touches[0].clientX, e.originalEvent.touches[0].clientY];
            var obj = self.config.binds[self.key];
            if(Math.abs(self.distance) >= obj.validDistance) {
              if(obj.passCallback) {
                obj.passCallback.call(e.target, S.mix(e, {self: self}))
              }
            }
            else {
              // 复原
              movement(self, self.startPoint, self.lastPoint, self.startPoint);
            }
          }
          self.touchStart = false;
          self.isSendStart = false;
        })
      }
    }

    S.augment(HoriDrag, S.EventTarget, o);
    return HoriDrag;
  },
    { requires: ["node", "event", "ua", "widget/sslog"] }
  )

}

window.addEventListener('load', addWidget);