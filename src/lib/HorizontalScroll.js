export function HorizontalScroll(el) {
  if (!el) return;

  function hasScrolledContent(target, hasScroll=false) {
    if (target != el) {
      while (!hasScroll && target.parentNode) {
        if (target == el || target == document.body) break;
        if (target.clientHeight < target.scrollHeight) {
          hasScroll = true;
        }
        target = target.parentNode;
      }
    }
    return hasScroll;
  }

  function scrollHorizontally(e) {
    if (hasScrolledContent(e.target)) return;
    e = window.event || e;
    e.preventDefault();
    const delta = Math.max(-1, Math.min(1, (e.wheelDelta || -e.detail)));
    el.scrollLeft -= (delta * 40);
  }
  
  if (el.addEventListener) {
    el.addEventListener('mousewheel', scrollHorizontally, false);
    el.addEventListener('DOMMouseScroll', scrollHorizontally, false);
  } 
  else {
    el.attachEvent('onmousewheel', scrollHorizontally);
  }
}
