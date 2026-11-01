# Migration to al-folio

## Source and provenance

- Existing repository: `NickDST/nickdst.github.io`, retaining its Git history and `origin` remote.
- Upstream starter: `alshedivat/al-folio` at `929fbf71c5a45b13e9b5a20dfa425ce9e9de7935`.
- Core runtime: `al_folio_core` 1.0.15; Distill: `al_folio_distill` 1.0.3; CV: `al_folio_cv` 1.0.2. See `Gemfile` for all pins.
- The upstream MIT license is retained in `LICENSE`.

## Content mapping

| Original | New |
| --- | --- |
| `index.html` bio | `_pages/about.md` |
| `_data/main_info.yaml` | `_config.yml`, `_data/socials.yml`, homepage profile |
| 8 entries in `_data/publications.yaml` | `_bibliography/papers.bib` |
| 17 entries in `_data/projects.yaml` | `_projects/*.md` and `/projects/` |
| 9 entries in `_data/experience.yaml` | `_data/cv.yml` and `/cv/` |
| Homepage hobby section | `/yoyo/` |
| Existing images | Original `assets/` paths retained; profile also copied into `assets/img/` |

The initial migration preserved author order, equal-contribution markers, venues (with years separated into their BibTeX field), project descriptions, paper/code links, and experience descriptions. The old bio’s time-sensitive “third year” wording was shortened to “PhD student”. Dates already encoded in source venues or paper identifiers supplied publication years. The molecular-dynamics paper is listed as 2022 and CyanoPATH as 2021.

Subsequent user-directed edits added NSF GRFP funding and the GenBio.AI internship, revised the bio and profile photo, and updated HEIMDALL to Cell Systems (2026), AIDO.Tissue to the ICML 2025 GenBio Workshop, and perturbation evaluation links to v2. The verifier explicitly maps that superseded v1 URL to v2 while preserving the original archive. CV and blog navigation are temporarily hidden; their URLs still work. Latest Posts currently displays an unlinked “Soon!” placeholder.

The old homepage used a double-dagger legend although the author lists used asterisks; the migrated legend consistently uses asterisks.

`/index.html#bio` still points to the bio. A small script redirects the old `#publications`, `#projects`, `#resume`, and `#hobbies` fragments to their new pages. Existing asset paths remain available.

## Preserved legacy material

`_archive/legacy/` contains the previous homepage, config, data, layouts, includes, project files, README, and deployment helpers. It is excluded from Jekyll output. The nine old `_projects` pages were examples belonging to the previous template author; they are archived rather than presented as Nicholas’s work. Their old project-page URLs are not retained. The old `_website_2014/` and `libs/` trees remain on disk but are excluded from the build.

The original Google Analytics setting belonged to the old template. It has not been copied into the active configuration; analytics remains unconfigured.

## Blog and deployment

The production blog begins empty, with an unpublished Distill starter under `_drafts/`. The starter demonstrates actual rendering of author metadata, math, code, citations, figures, footnotes, a collapsible aside, and an interactive HTML embed. It is not published as Nicholas’s research.

GitHub Actions now runs a full Bundler build because al-folio uses plugins unavailable in the restricted GitHub Pages Jekyll builder. The deployment keeps the existing Actions-based Pages mechanism and `master` branch. The workflow is prepared locally; it has not been pushed or run on GitHub as part of this migration.

## Validation

- Production build: 24 HTML pages verified, with all eight publications, seventeen projects, and nine experience entries accounted for.
- Draft build: 28 HTML pages verified, including Distill author metadata, math loader, citations, bibliography, and iframe markup.
- Local page/asset links and draft exclusion from production/RSS passed.
- Initial al-folio upgrade audit: zero blocking or non-blocking findings. The later stylesheet override is recorded in `.al-folio-overrides.yml`.
- Browser checks: desktop light/dark homepage, 390px mobile homepage/article/CV, mobile navigation, project images, publication filtering, legacy publication fragment redirect, rendered math/citation, and interactive slider response.
- GitHub Actions deployment has not been run; changes are local and uncommitted.

## Accent customization

The orange palette lives in `_sass/_custom.scss`, loaded after the core theme by a local `assets/css/main.scss` override. `.al-folio-overrides.yml` records the upstream source so theme upgrades can flag changes. Light backgrounds use a deeper orange for readable links; dark backgrounds use light orange. Text selection uses a soft peach highlight.
