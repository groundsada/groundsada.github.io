/* groundsada — gentle parallax: layers drift at different speeds on scroll */
(function () {
  const layers = document.querySelectorAll("[data-parallax]");
  if (!layers.length) return;
  let ticking = false;
  function onScroll() {
    if (ticking) return;
    ticking = true;
    requestAnimationFrame(() => {
      const y = window.scrollY;
      layers.forEach((l) => {
        const speed = parseFloat(l.getAttribute("data-parallax")) || 0.2;
        l.style.transform = "translate3d(0," + y * speed + "px,0)";
      });
      ticking = false;
    });
  }
  window.addEventListener("scroll", onScroll, { passive: true });
  onScroll();
})();
