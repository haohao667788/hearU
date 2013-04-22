//
//Template.hello.greeting = function () {
//  return "Welcome to hearU.";
//};
//
//Template.hello.events({
//  'click input' : function () {
//    // template data, if any, is available in 'this'
//    if (typeof console !== 'undefined')
//      console.log("You pressed the button");
//  }
//});
window.addEventListener("load", init);
function init(){
  KISSY.use("dom, node, anim, event, widget/horidrag, widget/sslog", function(S, DOM, Node, Anim, Event, HoriDrag, SSlog){
    var $ = KISSY.all;
    $('body').addClass("EntryList");


    // 初始化 UI
    new HoriDrag("#Main", {
      binds: [
        null,
        null,
        null,
        {
          moveEl: [], // 如果不为空，则只移动这里的元素
          maxDistance: DOM.viewportWidth(),
          validDistance: DOM.viewportWidth() / 2,  // 一般是 maxDistance/2
          passCallback: function(){
            $('#Main')[0].style.webkitTransform = "";
            $('body').addClass(".Menu");
          },
          failCallback: null

        }
      ]
    });
//    document.getElementById('Main').addEventListener("touchmove", function(){
//      SSlog("touchmove");
//    })

  })

}
