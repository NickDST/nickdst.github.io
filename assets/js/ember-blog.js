window.addEventListener("load", function () {
  document.querySelectorAll("d-byline h3").forEach(function (heading) {
    if (heading.textContent.trim() === "Published") {
      heading.textContent = "Posted";
    }
  });

  // Hide unused appendix and related-post sections without hiding actual content.
  document.querySelectorAll(".post.distill > d-appendix, .post.distill > d-article:last-child").forEach(function (section) {
    if (!section.innerText.trim() && !section.querySelector("iframe, img, video, audio, input, button")) {
      section.style.display = "none";
    }
  });
});
