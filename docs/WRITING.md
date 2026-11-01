# Writing research posts

## Start a draft

Copy `_drafts/research-post-starter.md` to `_drafts/your-slug.md`. Edit its title, description, date, tags, authors, bibliography, and table of contents. Keep the original starter for reference. Preview with:

```sh
LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 bundle exec jekyll serve --drafts --destination _site-drafts
```

Ordinary notes can use `layout: post`. Research walkthroughs can use `layout: distill`, which provides an author byline, contents, citations, footnotes, and a bibliography.

## Structure a research walkthrough

1. State the question and the central finding.
2. Explain the intuition, then the mechanism and equations.
3. Discuss consequential design choices and alternatives.
4. Put each result beside its supporting figure, baseline, or ablation.
5. Separate observations from possible explanations.
6. Discuss limitations and the next research question.

Use section headings that exactly match the names in the `toc` metadata. For a series, link to the previous and next posts in the body. The layout handles presentation; the article and each interactive figure remain separately editable.

## Equations and code

Use `$z=f_\theta(x)$` for inline math and a separate `$$ ... $$` block for display equations. Fenced code blocks accept a language, such as `python`, for syntax highlighting.

## Citations and notes

Put references in `_bibliography/your-post.bib` and set `bibliography: your-post.bib` in the post header. The starter uses the existing `papers.bib` so its example citation works immediately.

```html
<d-cite key="ho2024aidocell"></d-cite>
<d-footnote>Additional context for interested readers.</d-footnote>
```

For optional longer explanations:

```liquid
{% details Derivation %}
Your derivation, Markdown, and equations go here.
{% enddetails %}
```

## Figures

Store images in `assets/img/posts/your-slug/`. Use al-folio’s figure include:

```liquid
{% include figure.liquid
   path="assets/img/posts/your-slug/result.png"
   class="img-fluid rounded"
   alt="Describe the result shown by the figure"
   caption="Explain the comparison, axes, and takeaway." %}
```

ImageMagick generation is disabled so publishing has no system image-tool dependency. Ordinary images, captions, zoom, and responsive CSS still work.

## Interactive figures

Save self-contained HTML/CSS/JavaScript in `assets/html/your-slug/` and embed it:

```html
<iframe
  src="{{ '/assets/html/your-slug/figure.html' | relative_url }}"
  title="A clear description of the interactive figure"
  width="100%"
  height="420"
  loading="lazy"
  style="border:0;">
</iframe>
```

A working, dependency-free example lives in `assets/html/blog-starter/decay.html`. Replace it with your actual data and controls. Check on a narrow screen, give controls accessible labels, and describe the main takeaway in prose so the explanation also works without interaction.

Charts can also opt into the bundled chart plugin using the al-folio front matter, such as `chart: { chartjs: true }`. Use the upstream documentation for each library’s content syntax.

## Publish

When the article is ready:

1. Copy the finished draft into `_posts/YYYY-MM-DD-your-slug.md` and remove its old draft copy.
2. Set the header’s `date` to the publication date. Future dates stay hidden in ordinary builds until that date.
3. Remove instructional prose and unused examples. Check every citation and figure caption.
4. For the first post, set `nav: true` in `_pages/blog.md`. In `_pages/about.md`, replace the `<p>Soon!</p>` placeholder with `{% include latest_posts.liquid limit=true %}` to show the post list.
5. Run a normal production build and the link checks described in the README.
6. Commit and push the reviewed changes to `master`.

The URL is `/blog/YYYY/your-slug/`. The blog index, archives, search index, and RSS feed update from published posts; the homepage list does too once restored in step 4. Comments remain off until you intentionally configure a provider.
