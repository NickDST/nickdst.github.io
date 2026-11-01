# Nicholas Ho’s website

Personal academic website at **https://nickdst.github.io**, built with [al-folio](https://github.com/alshedivat/al-folio) v1 and Jekyll. The al-folio layouts, styling, and Distill runtime are installed as versioned gems; there is no separate frontend build.

## Run locally

Requirements: Ruby 3.3, Bundler, and Node.js 22 or newer (used for JavaScript minification).

```sh
bundle config set --local path vendor/bundle
bundle install
LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 bundle exec jekyll serve
```

Open http://127.0.0.1:4000. Stop the server with Ctrl-C. Restart it after changing `_config.yml`.

To preview unpublished drafts:

```sh
LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 bundle exec jekyll serve --drafts --destination _site-drafts
```

The working example is at `/blog/2026/research-post-starter/`. Drafts are excluded from normal builds. Files in `_drafts` are still visible in a public GitHub repository; use an untracked file or a private repository for confidential writing.

## Edit content

| Content | File |
| --- | --- |
| Bio and homepage | `_pages/about.md` |
| Name, URL, site-wide options | `_config.yml` |
| Contact and social links | `_data/socials.yml` |
| Publications | `_bibliography/papers.bib` |
| Projects | `_projects/*.md` |
| CV | `_data/cv.yml` |
| Yo-yo page | `_pages/yoyo.md` |
| Blog index | `_pages/blog.md` |
| Published posts | `_posts/YYYY-MM-DD-slug.md` |
| Unpublished Distill template | `_drafts/research-post-starter.md` |

See [the writing guide](docs/WRITING.md) for equations, citations, figures, interactive embeds, and publishing a first post. See [migration notes](docs/MIGRATION.md) for preserved material and template provenance.

## Build and verify

```sh
LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 bundle exec jekyll build
bundle exec ruby scripts/verify_site.rb _site
LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 bundle exec jekyll build --drafts --destination _site-drafts
bundle exec ruby scripts/verify_site.rb _site-drafts --drafts
```

The verifier checks migrated content against the archived source, local page and asset links, excluded directories, and draft isolation. It also checks Distill markup when testing drafts.

## Deploy

The existing `master` branch remains the publishing branch. `.github/workflows/jekyll-gh-pages.yml` builds with Bundler, checks the result, and deploys the production `_site` artifact to GitHub Pages. Pull requests build and validate without deploying.

In GitHub repository **Settings → Pages**, use **GitHub Actions** as the source. Push reviewed changes to `master` to publish. This migration does not require a new repository, a new domain, or the upstream template’s `gh-pages` deployment approach.

## Theme upgrades

The current starter snapshot is recorded in `docs/MIGRATION.md`. Plugin versions are explicitly pinned in `Gemfile`; transitive dependencies and the minifier’s Git revision are pinned in `Gemfile.lock` for macOS and Linux. Update plugin pins deliberately and rebuild both production and drafts before deploying.

The core plugin supplies the site layouts and styling. Bootstrap compatibility is disabled. The local `assets/css/main.scss` entrypoint loads `_sass/_custom.scss` for the orange accent palette. Its upstream version is tracked in `.al-folio-overrides.yml`; no layout overrides are used.
