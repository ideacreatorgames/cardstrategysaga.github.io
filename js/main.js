/**
 * FAQ 手风琴：点击问题展开/收起答案
 */
(function () {
  document.querySelectorAll(".faq-item").forEach(function (item) {
    var btn = item.querySelector(".faq-q");
    if (!btn) return;
    btn.addEventListener("click", function () {
      var open = item.classList.contains("is-open");
      document.querySelectorAll(".faq-item.is-open").forEach(function (el) {
        el.classList.remove("is-open");
      });
      if (!open) item.classList.add("is-open");
    });
  });
})();
