(window.webpackJsonp=window.webpackJsonp||[]).push([[2],{2:function(t){t.exports.Store={tree:null,node:null,boxes:[],scroller:{width:0},docs:{root:"data-example/",path:"data-example/imba-docs/"}}},22:function(t,e,n){var o=n(0),r=n(4).Connect;o.extendTag("element",function(t){t.prototype.asset=function(t){return void 0===t&&(t=""),window.location.pathname.replace(/[^\/]*$/,"")+"dist/static/images/"+t},t.prototype.setText=function(t){if(t!=this._tree_){var e=null===t||!1===t?"":t,n=this._text_||this._dom;void 0==n.outerHTML?r.timeout(0,function(){return n.textContent=e}):n.textContent=e,this._text_||(this._text_=this._dom.firstChild),this._tree_=t}return this}})},25:function(t,e,n){"use strict";n.r(e),n.d(e,"Frontmatter",function(){return r});var o=n(9);n.n(o);const r=function(t){const{head:e,body:n}=o(t.replace(/\r?/g,""));return{head:e,body:n}}},29:function(t,e,n){"use strict";function o(){var t="Width",e="Height",n="Top",o="Left",r="scroll",i="client",u="EventListener",s="length",c=Math.round,a={};!function(){var f,d,p,h,l,v=document.getElementsByClassName("sync"+r);for(l in a)if(a.hasOwnProperty(l))for(f=0;f<a[l][s];f++)a[l][f]["remove"+u](r,a[l][f].syn,0);for(f=0;f<v[s];)if(h=d=0,l=(p=v[f++]).getAttribute("name")){for(p=p[r+"er"]||p;d<(a[l]=a[l]||[])[s];)h|=a[l][d++]==p;h||a[l].push(p),p.eX=p.eY=0,function(f,d){f["add"+u](r,f.syn=function(){var u,p=a[d],h=f[r+o],l=f[r+n],v=h/(f[r+t]-f[i+t]),_=l/(f[r+e]-f[i+e]),m=h!=f.eX,y=l!=f.eY,w=0;for(f.eX=h,f.eY=l;w<p[s];)(u=p[w++])!=f&&(m&&c(u[r+o]-(h=u.eX=c(v*(u[r+t]-u[i+t]))))&&(u[r+o]=h),y&&c(u[r+n]-(l=u.eY=c(_*(u[r+e]-u[i+e]))))&&(u[r+n]=l))},0)}(p,l)}}()}n.r(e),n.d(e,"SyncScroll",function(){return o})},3:function(t,e){function n(){this._node=document.createTextNode("")}n.prototype.__eventFuncs={default:{},name:"eventFuncs"},n.prototype.eventFuncs=function(){return this._eventFuncs},n.prototype.setEventFuncs=function(t){return this._eventFuncs=t,this},n.prototype._eventFuncs={},n.prototype.node=function(){return this._node},n.prototype.setNode=function(t){return this._node=t,this},n.prototype.on=function(t,e){return this._node.addEventListener(t,e),this._eventFuncs[t]=e},n.prototype.once=function(t,e){if(!this._eventFuncs[t])return this._node.addEventListener(t,e),this._eventFuncs[t]=e},n.prototype.off=function(t){var e;return this._node.removeEventListener(t,this._eventFuncs[t]),e=this._eventFuncs[t],delete this._eventFuncs[t],e},n.prototype.trigger=function(t,e){if(t){const n=new CustomEvent(t,{detail:e});return this._node.dispatchEvent(n)}};var n=e.EventDispatcher=new n},32:function(t,e,n){"use strict";function o(t){function e(e){if(!function(e,n=!1){if(e!=t)for(;!n&&e.parentNode&&e!=t&&e!=document.body;)e.clientHeight<e.scrollHeight&&(n=!0),e=e.parentNode;return n}(e.target)){(e=window.event||e).preventDefault();const n=Math.max(-1,Math.min(1,e.wheelDelta||-e.detail));t.scrollLeft-=40*n}}t&&(t.addEventListener?(t.addEventListener("mousewheel",e,!1),t.addEventListener("DOMMouseScroll",e,!1)):t.attachEvent("onmousewheel",e))}n.r(e),n.d(e,"HorizontalScroll",function(){return o})},35:function(t,e,n){"use strict";n.r(e),n.d(e,"Marked",function(){return r});var o=n(10);n.n(o);const r=o},4:function(t,e){function n(){}n.prototype.__prefix={default:window.location.pathname,name:"prefix"},n.prototype.prefix=function(){return this._prefix},n.prototype.setPrefix=function(t){return this._prefix=t,this},n.prototype._prefix=window.location.pathname,n.prototype.timeout=function(t,e,n){return void 0===t&&(t=100),void 0===e&&(e=null),void 0===n&&(n=null),new Promise(function(o){return window.setTimeout(function(){if(e&&e(),n||o(),n)return o(n)},t)})},n.prototype.async=function(t){return this.timeout(0,t)},n.prototype.fetchData=async function(t,e){void 0===e&&(e=!1);const n=await window.fetch(this.prefix()+t);return e?n.json():n.text()};var n=e.Connect=new n}}]);