/*

FREESTYLE MENUS v1.0 RC (c) 2001-2009 Angus Turnbull, http://www.twinhelix.com
Altering this notice or redistributing this file is prohibited.

*/

var isDOM=document.getElementById?1:0,isIE=document.all?1:0,isNS4=navigator.appName=='Netscape'&&!isDOM?1:0,isOp=self.opera?1:0,isDyn=isDOM||isIE||isNS4;function getRef(i,p){p=!p?document:p.navigator?p.document:p;return isIE?p.all[i]:isDOM?(p.getElementById?p:p.ownerDocument).getElementById(i):isNS4?p.layers[i]:null};function getSty(i,p){var r=getRef(i,p);return r?isNS4?r:r.style:null};if(!self.LayerObj)var LayerObj=new Function('i','p','this.ref=getRef(i,p);this.sty=getSty(i,p);return this');function getLyr(i,p){return new LayerObj(i,p)};function LyrFn(n,f){LayerObj.prototype[n]=new Function('var a=arguments,p=a[0],px=isNS4||isOp?0:"px";with(this){'+f+'}')};LyrFn('x','if(!isNaN(p))sty.left=p+px;else return parseInt(sty.left)');LyrFn('y','if(!isNaN(p))sty.top=p+px;else return parseInt(sty.top)');if(typeof addEvent!='function'){var addEvent=function(o,t,f,l){var d='addEventListener',n='on'+t;if(o[d]&&!l)return o[d](t,f,false);if(!o._evts)o._evts={};if(!o._evts[t]){o._evts[t]={};if(o[n])addEvent(o,t,o[n],l);o[n]=new Function('e','var r=true,o=this,a=o._evts["'+t+'"],i;for(i in a){o._f=a[i];if(o._f._i)r=o._f(e||window.event)!=false&&r}o._f=null;return r')}if(!f._i)f._i=addEvent._i++;o._evts[t][f._i]=f;if(t!='unload')addEvent(window,'unload',function(){removeEvent(o,t,f,l)})};addEvent._i=1;var removeEvent=function(o,t,f,l){var d='removeEventListener';if(o[d]&&!l)return o[d](t,f,false);if(o._evts&&o._evts[t]&&f._i)delete o._evts[t][f._i]}}var addReadyEvent=function(f){var a=addReadyEvent,n=null;addEvent(a,'ready',f);if(!a.r){a.r=function(){clearInterval(t);if(a.r)a.onready();a.r=null};addEvent(document,'DOMContentLoaded',a.r);addEvent(window,'load',a.r);var t=setInterval(function(){if(/complete|loaded/.test(document.readyState)){if(!n)a.r();else try{n.doScroll('left');n=null;a.r()}catch(e){}}},50)}};function FSMenu(myName,nested,cssProp,cssVis,cssHid){this.myName=myName;this.nested=nested;this.cssProp=cssProp;this.cssVis=cssVis;this.cssHid=cssHid;this.cssLitClass='highlighted';this.menus=nested?{}:{root:new FSMenuNode('root',true,this)};this.menuToShow=[];this.mtsTimer=null;this.showDelay=0;this.switchDelay=125;this.hideDelay=500;this.showOnClick=0;this.hideOnClick=true;this.animInSpeed=0.2;this.animOutSpeed=0.2;this.animations=[]};FSMenu.prototype.show=function(mN){with(this){menuToShow.length=arguments.length;for(var i=0;i<arguments.length;i++)menuToShow[i]=arguments[i];clearTimeout(mtsTimer);if(!nested)mtsTimer=setTimeout(myName+'.menus.root.over()',10)}};FSMenu.prototype.hide=function(mN){with(this){clearTimeout(mtsTimer);if(menus[mN])menus[mN].out()}};FSMenu.prototype.hideAll=function(){with(this){for(var m in menus)if(menus[m].visible&&!menus[m].isRoot)menus[m].hide(true)}};function FSMenuNode(id,isRoot,obj){this.id=id;this.isRoot=isRoot;this.obj=obj;this.lyr=this.child=this.par=this.timer=this.visible=null;this.args=[];var node=this;this.over=function(evt){with(node)with(obj){if(isNS4&&evt&&lyr.ref)lyr.ref.routeEvent(evt);clearTimeout(timer);clearTimeout(mtsTimer);if(!isRoot&&!visible)node.show();if(menuToShow.length){var a=menuToShow,m=a[0];if(!menus[m]||!menus[m].lyr.ref)menus[m]=new FSMenuNode(m,false,obj);var c=menus[m];if(c==node){menuToShow.length=0;return}clearTimeout(c.timer);if(c!=child&&c.lyr.ref){c.args.length=a.length;for(var i=0;i<a.length;i++)c.args[i]=a[i];var delay=child?switchDelay:showDelay;c.timer=setTimeout('with('+myName+'){menus["'+c.id+'"].par=menus["'+node.id+'"];menus["'+c.id+'"].show()}',delay?delay:1)}menuToShow.length=0}if(!nested&&par)par.over()}};this.out=function(evt){with(node)with(obj){if(isNS4&&evt&&lyr&&lyr.ref)lyr.ref.routeEvent(evt);clearTimeout(timer);if(!isRoot&&hideDelay>=0){timer=setTimeout(myName+'.menus["'+id+'"].hide()',hideDelay);if(!nested&&par)par.out()}}};if(id!='root')with(this)with(lyr=getLyr(id))if(ref){if(isNS4)ref.captureEvents(Event.MOUSEOVER|Event.MOUSEOUT);addEvent(ref,'mouseover',this.over);addEvent(ref,'mouseout',this.out);if(obj.nested){addEvent(ref,'focus',this.over,1);addEvent(ref,'click',this.over);addEvent(ref,'blur',this.out,1)}}};FSMenuNode.prototype.show=function(forced){with(this)with(obj){if(!lyr||!lyr.ref)return;if(par){if(par.child&&par.child!=this)par.child.hide();par.child=this}var offR=args[1],offX=args[2],offY=args[3],lX=0,lY=0,doX=''+offX!='undefined',doY=''+offY!='undefined';if(self.page&&offR&&(doX||doY)){with(page.elmPos(offR,par.lyr?par.lyr.ref:0))lX=x,lY=y;if(doX)lyr.x(lX+eval(offX));if(doY)lyr.y(lY+eval(offY))}if(offR)lightParent(offR,1);visible=1;if(obj.onshow)obj.onshow(id);lyr.ref.parentNode.style.zIndex='2';setVis(1,forced)}};FSMenuNode.prototype.hide=function(forced){with(this)with(obj){if(!lyr||!lyr.ref||!visible)return;if(isNS4&&self.isMouseIn&&isMouseIn(lyr.ref))return show();if(args[1])lightParent(args[1],0);if(child)child.hide();if(par&&par.child==this)par.child=null;if(lyr){visible=0;if(obj.onhide)obj.onhide(id);lyr.ref.parentNode.style.zIndex='1';setVis(0,forced)}}};FSMenuNode.prototype.lightParent=function(elm,lit){with(this)with(obj){if(!cssLitClass||isNS4)return;if(lit)elm.className+=(elm.className?' ':'')+cssLitClass;else elm.className=elm.className.replace(new RegExp('(\\s*'+cssLitClass+')+$'),'')}};FSMenuNode.prototype.setVis=function(sh,forced){with(this)with(obj){if(lyr.forced&&!forced)return;lyr.forced=forced;lyr.timer=lyr.timer||0;lyr.counter=lyr.counter||0;with(lyr){clearTimeout(timer);var speed=sh?animInSpeed:animOutSpeed;if(!counter)sty[cssProp]=sh?cssVis:cssHid;if(isDOM&&(speed<1))for(var a=0;a<animations.length;a++)animations[a](ref,counter,sh);if(isDOM&&(sh?counter<1:counter>0))timer=setTimeout(myName+'.menus["'+id+'"].setVis('+sh+','+(forced||0)+')',50);else lyr.forced=false;counter=counter+speed*(sh?1:-1);if(counter<0.001)counter=0;if(counter>0.999)counter=1}}};FSMenu.animSwipeDown=function(ref,counter,show){var elm=ref.firstChild.style?ref.firstChild:ref.firstChild.nextSibling,isOldIE=/MSIE\s(5|6|7)\./.test(navigator.userAgent);if(!elm)return;if(show&&(counter==0)){if(!elm._fsm_marg)elm._fsm_marg={'top':elm.style.marginTop};ref._fsm_height=ref.offsetHeight}if(counter==1||(counter<0.01&&!show)){ref.style.overflow='visible';elm.style.marginTop=elm._fsm_marg.top;if(isOldIE)ref.style.height=''}else{var cP=Math.pow(Math.sin(Math.PI*counter/2),0.75);ref.style.overflow='hidden';if(isOldIE)ref.style.height=(ref._fsm_height*cP)+'px';else elm.style.marginTop=(0-ref._fsm_height*(1-cP))+'px'}};FSMenu.animFade=function(ref,counter,show){if(typeof ref.filters=='unknown')return;var f=ref.filters,done=(show?counter==1:counter<0.01),a=/MSIE\s(4|5)/.test(navigator.userAgent)?'alpha':'DXImageTransform.Microsoft.Alpha';if(f){if(!done&&ref.style.filter.indexOf(a)==-1)ref.style.filter+=' '+(a=='alpha'?a:'progid:'+a)+'(opacity='+(counter*100)+')';else if(f.length&&f[a]){if(done)f[a].enabled=false;else{f[a].opacity=(counter*100);f[a].enabled=true}}}else ref.style.opacity=ref.style.MozOpacity=counter*0.999};FSMenu.animClipDown=function(ref,counter,show){var cP=Math.pow(Math.sin(Math.PI*counter/2),0.75);ref.style.clip=(counter==1?((window.opera||navigator.userAgent.indexOf('KHTML')>-1)?'':'rect(auto,auto,auto,auto)'):'rect(0,'+ref.offsetWidth+'px,'+(ref.offsetHeight*cP)+'px,0px)')};FSMenu.prototype.activateMenu=function(id,subInd){with(this){if(!isDOM||!document.documentElement)return;var fsmFB=getRef('fsmenu-fallback');if(fsmFB){fsmFB.rel='alternate stylesheet';fsmFB.disabled=true}var a,ul,li,parUL,mRoot=getRef(id),nodes;if(!FSMenu._count)FSMenu._count=1;var evtProp=navigator.userAgent.indexOf('Safari')>-1||isOp?'safRtnVal':'returnValue';var lists=mRoot.getElementsByTagName('ul');for(var i=0;i<lists.length;i++){li=ul=lists[i];while(li){if(li.nodeName.toLowerCase()=='li')break;li=li.parentNode}if(!li)continue;parUL=li;while(parUL){if(parUL.nodeName.toLowerCase()=='ul')break;parUL=parUL.parentNode}a=li.getElementsByTagName('a');if(!a)continue;a=a.item(0);var menuID;if(ul.id)menuID=ul.id;else{menuID=myName+'-id-'+FSMenu._count++;ul.setAttribute('id',menuID)}if(menus[menuID]&&menus[menuID].lyr.ref==ul)continue;menus[menuID]=new FSMenuNode(menuID,false,this);var rootItem=(li.parentNode==mRoot)?1:0;var eShow=new Function('with('+myName+'){var m=menus["'+menuID+'"],pM=menus["'+parUL.id+'"];if(!showOnClick||(showOnClick==1&&!'+rootItem+')||((showOnClick<=2)&&((pM&&pM.child)||(m&&m.visible))))show("'+menuID+'",this)}');var eHide=new Function('e','if(e.'+evtProp+'!=false)'+myName+'.hide("'+menuID+'")');addEvent(a,'mouseover',eShow);addEvent(a,'mouseout',eHide);addEvent(a,'focus',eShow);addEvent(a,'blur',eHide);addEvent(a,'click',new Function('e','var s='+myName+'.showOnClick,m='+myName+'.menus["'+menuID+'"];if(!((s==1&&'+rootItem+')||s>=2))return;'+myName+'[m&&m.visible?"hide":"show"]("'+menuID+'",this);if(e.cancelable&&e.preventDefault)e.preventDefault();e.'+evtProp+'=false;return false'));if(subInd)a.insertBefore(subInd.cloneNode(true),a.firstChild)}var aNodes=mRoot.getElementsByTagName('a');for(var i=0;i<aNodes.length;i++){addEvent(aNodes[i],'focus',new Function('e','var node=this.parentNode;while(node){if(node.onfocus)node.onfocus(e);node=node.parentNode}'));addEvent(aNodes[i],'blur',new Function('e','var node=this.parentNode;while(node){if(node.onblur)node.onblur(e);node=node.parentNode}'))}if(hideOnClick)addEvent(mRoot,'click',new Function('e','if(e.'+evtProp+'!=false)'+myName+'.hideAll()'));menus[id]=new FSMenuNode(id,true,this)}};var page={win:self,minW:0,minH:0,MS:isIE&&!isOp,db:document.compatMode&&document.compatMode.indexOf('CSS')>-1?'documentElement':'body'};page.elmPos=function(e,p){var x=0,y=0,w=p?p:this.win;e=e?(e.substr?(isNS4?w.document.anchors[e]:getRef(e,w)):e):p;if(isNS4){if(e&&(e!=p)){x=e.x;y=e.y};if(p){x+=p.pageX;y+=p.pageY}}if(e&&this.MS&&navigator.platform.indexOf('Mac')>-1&&e.tagName=='A'){e.onfocus=new Function('with(event){self.tmpX=clientX-offsetX;self.tmpY=clientY-offsetY}');e.focus();x=tmpX;y=tmpY;e.blur()}else while(e){x+=e.offsetLeft;y+=e.offsetTop;e=e.offsetParent}return{x:x,y:y}};if(isNS4){var fsmMouseX,fsmMouseY,fsmOR=self.onresize,nsWinW=innerWidth,nsWinH=innerHeight;document.fsmMM=document.onmousemove;self.onresize=function(){if(fsmOR)fsmOR();if(nsWinW!=innerWidth||nsWinH!=innerHeight)location.reload()};document.captureEvents(Event.MOUSEMOVE);document.onmousemove=function(e){fsmMouseX=e.pageX;fsmMouseY=e.pageY;return document.fsmMM?document.fsmMM(e):document.routeEvent(e)};function isMouseIn(sty){with(sty)return((fsmMouseX>left)&&(fsmMouseX<left+clip.width)&&(fsmMouseY>top)&&(fsmMouseY<top+clip.height))}}


// For each menu you create, you must create a matching "FSMenu" JavaScript object to represent
// it and manage its behaviour. You don't have to edit this script at all if you don't want to;
// these comments are just here for completeness. Also, feel free to paste this script into the
// external .JS file to make including it in your pages easier!

// Here's a menu object to control the above list of menu data:
var listMenu = new FSMenu('listMenu', true, 'display', 'block', 'none');

// The parameters of the FSMenu object are:
//  1) Its own name in quotes.
//  2) Whether this is a nested list menu or not (in this case, true means yes).
//  3) The CSS property name to change when menus are shown and hidden.
//  4) The visible value of that CSS property.
//  5) The hidden value of that CSS property.
//
// Next, here's some optional settings for delays and highlighting:
//  * showDelay is the time (in milliseconds) to display a new child menu.
//    Remember that 1000 milliseconds = 1 second.
//  * switchDelay is the time to switch from one child menu to another child menu.
//    Set this higher and point at 2 neighbouring items to see what it does.
//  * hideDelay is the time it takes for a menu to hide after mouseout.
//    Set this to a negative number to disable hiding entirely.
//  * cssLitClass is the CSS classname applied to parent items of active menus.
//  * showOnClick will, suprisingly, set the menus to show on click. Pick one of 4 values:
//     0 = All levels show on mouseover.
//     1 = Menu activates on click of first level, then shows on mouseover.
//     2 = All levels activate on click, then shows on mouseover.
//     3 = All levels show on click only (no mouseover at all).
//  * hideOnClick hides all visible menus when one is clicked (defaults to true).
//  * animInSpeed and animOutSpeed set the animation speed. Set to a number
//    between 0 and 1 where higher = faster. Setting both to 1 disables animation.

//listMenu.showDelay = 0;
//listMenu.switchDelay = 125;
//listMenu.hideDelay = 500;
//listMenu.cssLitClass = 'highlighted';
//listMenu.showOnClick = 0;
//listMenu.hideOnClick = true;
//listMenu.animInSpeed = 0.2;
//listMenu.animOutSpeed = 0.2;


// Now the fun part... animation! This script supports animation plugins you
// can add to each menu object you create. I have provided 3 to get you started.
// To enable animation, add one or more functions to the menuObject.animations
// array; available animations are:
//  * FSMenu.animSwipeDown is a "swipe" animation that sweeps the menu down.
//  * FSMenu.animFade is an alpha fading animation using tranparency.
//  * FSMenu.animClipDown is a "blind" animation similar to 'Swipe'.
// They are listed inside the "fsmenu.js" file for you to modify and extend :).

// I'm applying two at once to listMenu. Delete this to disable!
listMenu.animations[listMenu.animations.length] = FSMenu.animFade;
listMenu.animations[listMenu.animations.length] = FSMenu.animSwipeDown;
//listMenu.animations[listMenu.animations.length] = FSMenu.animClipDown;


// Finally, on page load you have to activate the menu by calling its 'activateMenu()' method.
// I've provided an "addEvent" method that lets you easily run page events across browsers.
// You pass the activateMenu() function two parameters:
//  (1) The ID of the outermost <ul> list tag containing your menu data.
//  (2) A node containing your submenu popout arrow indicator.
// If none of that made sense, just cut and paste this next bit for each menu you create.

var arrow = null;
if (document.createElement && document.documentElement)
{
 arrow = document.createElement('span');
 arrow.appendChild(document.createTextNode('>'));
 // Feel free to replace the above two lines with these for a small arrow image...
 //arrow = document.createElement('img');
 //arrow.src = 'arrow.gif';
 //arrow.style.borderWidth = '0';
 arrow.className = 'subind';
}
addReadyEvent(new Function('listMenu.activateMenu("listMenuRoot", arrow)'));

