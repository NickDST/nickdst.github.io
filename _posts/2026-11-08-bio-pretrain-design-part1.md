---
layout: distill
title: "Designing observational transcriptomic pretraining objectives for cellular perturbation prediction (Part 1)"
description: ""
date: 2026-11-08
permalink: /blog/2026/bio-pretrain-design-part1/
tags: [single-cell, representation-learning, perturbation-prediction]
featured: false
related_posts: false
giscus_comments: false
bibliography: papers.bib
thumbnail: assets/img/posts/ember-part1/blog2.png
authors:
  - name: Nicholas Ho
    url: https://nickdst.github.io/
    affiliations:
      name: Carnegie Mellon University
      url: https://www.cmu.edu/
toc:
  - name: What does it look like to pretrain on single cell data?
  - name: What are we actually learning with reconstruction?
    subsections:
      - name: The effect of pretraining data
  - name: How could this be useful for perturbation prediction?
  - name: So is reconstruction all we need?
  - name: Next up
    subsections:
      - name: Limitations
  - name: References
_styles: |
  d-article .ember-highlight { background: #fff0d9; color: inherit; padding: 0.06em 0.12em; -webkit-box-decoration-break: clone; box-decoration-break: clone; }
  d-article .ember-references { font-size: 15.5px; line-height: 1.55; padding-left: 1.4rem; }
  d-article .ember-references li { scroll-margin-top: 5rem; margin-bottom: 0.75rem; }
  d-article strong, d-article b { font-weight: 700; }
  d-article hr.ember-intro-divider { grid-column: text; width: 100%; height: 0; margin: 0.5rem 0 48px; padding: 0; border: 0; border-bottom: 1px solid var(--global-divider-color); }
  d-article hr.ember-intro-divider + h2 { margin-top: 0; }
  d-title h1 { font-size: clamp(2rem, 3.4vw, 3rem); line-height: 1.16; }
  d-article { font-size: 17px; line-height: 1.6; font-weight: 300; }
  d-article > p, d-article details p { margin: 0 0 1em; font-size: inherit; line-height: inherit; }
  d-article h2 { scroll-margin-top: 5rem; font-size: 1.75rem; line-height: 1.3; font-weight: 600; margin: 1.8rem 0 0.7rem; padding-bottom: 0.5rem; }
  d-article h2 em { font-style: normal; }
  d-article h3 { scroll-margin-top: 5rem; font-size: 1.2rem; line-height: 1.4; font-weight: 600; margin: 1.25rem 0 0.5rem; }
  d-article .ember-finding { grid-column: text; font-size: 16px; line-height: 1.55; margin: 0.25rem 0 1rem; padding: 0.5rem 0.75rem; border-left: 2px solid var(--global-theme-color); background: var(--global-code-bg-color); }
  d-article .ember-finding p { margin: 0; font-size: inherit; line-height: inherit; }
  d-article d-contents nav a { font-weight: 500; }
  d-article d-contents nav h3 { font-size: 1rem; margin: 0 0 0.8rem; }
  @media (min-width: 1025px) {
    d-article d-contents { grid-row: 1 / span 12; }
  }
  @media (max-width: 600px) {
    d-article { font-size: 16px; line-height: 1.6; }
    d-article h2 { font-size: 1.5rem; }
  }
  d-title > p:empty { display: none; }
  d-article .ember-note { color: var(--global-text-color); grid-column: text; align-self: start; margin: 0 0 1rem; padding: 0.65rem 0.85rem; border-left: 4px solid var(--global-theme-color); background: var(--global-code-bg-color); font-size: 15.5px; line-height: 1.5; font-style: normal; }
  d-article .ember-question { grid-column: text; color: var(--global-text-color); border-left: 4px solid var(--global-theme-color); padding: 1rem 1.5rem; margin: 0.5rem 0 1.5rem; font-size: 19px; line-height: 1.55; font-weight: 300; font-style: normal; }
  d-article .ember-question strong { font-weight: 600; }
  d-article .ember-figure { grid-column: text; width: 100%; max-width: 100%; margin: 0.5rem 0 1.25rem; }
  d-article h2 + .ember-figure, d-article h3 + .ember-figure { margin-top: 0; }
  d-article .ember-figure > a { display: block; border: 0; }
  d-article .ember-figure img { display: block; width: 100%; height: auto; background: white; }
  d-article .ember-figure figcaption { margin: 0.75rem auto 0; max-width: 740px; font-size: 0.9rem; line-height: 1.5; color: var(--global-text-color); }
  d-article details { background: transparent; border: 1px solid var(--global-divider-color); padding: 0.65rem 0.8rem; margin: 0 0 1.4rem; border-radius: 3px; font-size: 0.95em; }
  d-article summary { cursor: pointer; font-weight: 500; }
  d-article a:focus-visible, d-article summary:focus-visible { outline: 2px solid var(--global-theme-color); outline-offset: 3px; }
---

<aside class="ember-note">This blog is based on a few of our findings in <strong>EMBER</strong> that I thought were interesting. There is a lot more in the paper so please check that out!</aside>

[Read the paper](https://doi.org/10.64898/2026.10.28.762655) · [Code](https://github.com/ma-compbio-lab/EMBER/) · [Video explainer](https://x.com/eigenNick/status/2117336472852553806)

The success of text LLMs largely stemmed from how downstream performance could be predictably scaled with compute and data, known as the scaling laws ([1](#ref-1 "Training Compute-Optimal Large Language Models"),[2](#ref-2 "Scaling Laws for Neural Language Models")). It remains an open question on how to find similar scaling behaviors in other domains, such as biological data.

One particular task of interest is *perturbation prediction*, predictions of how a cell responds to an external perturbation, such as a gene knockout or chemical application ([3](#ref-3 "Virtual Cell Challenge: Toward a Turing test for the virtual cell"),[4](#ref-4 "A world model of the virtual cell")).

Due to the limited amount of available public perturbation data\* we focus on asking how to design pretraining objectives for observational transcriptomics data (scRNA-seq) to improve downstream performance.

<aside class="ember-question"><strong>Question:</strong> How can we design pretraining objectives for observational transcriptomic data that yield predictable improvements in downstream perturbation-response prediction?</aside>

<p><mark class="ember-highlight">In <a href="https://doi.org/10.64898/2026.10.28.762655">EMBER</a>, we found that the <strong>gene representation level</strong> was a strong interface for transferring representations from pretrained transcriptomics models to downstream tasks.</mark></p>

Here, we'll talk about some pretraining insights we found with gene representations and how to design better gene representations.

<hr class="ember-intro-divider">

## What does it look like to *pretrain* on single cell data? {#what-does-it-look-like-to-pretrain-on-single-cell-data}

<figure class="ember-figure" id="figure-1">
  <a href="{{ '/assets/img/posts/ember-part1/blog1.png' | relative_url }}" target="_blank" rel="noopener" aria-label="Open Figure 1 at full resolution">
    <img src="{{ '/assets/img/posts/ember-part1/blog1.png' | relative_url }}" width="3450" height="1652" alt="EMBER samples 1,280 genes, masks half their expression values, and trains contextualized gene embeddings with cell subgraph contrastive learning and masked expression reconstruction." loading="lazy" decoding="async">
  </a>
  <figcaption><strong>Figure 1.</strong> EMBER pretraining. Each cell contributes 1,024 expressed and 256 non-expressed genes. The transformer produces contextualized gene embeddings used by two training objectives. This post focuses on masked expression reconstruction. <a href="{{ '/assets/img/posts/ember-part1/blog1.png' | relative_url }}" target="_blank" rel="noopener">View full size</a>.</figcaption>
</figure>

For **EMBER**, we chose to sample 1280 genes per cell, where 1024 genes are sampled from expressed genes and 256 are sampled from non-expressed genes. Then, we mask the gene expression of 50% of our 1280 sampled genes. After passing this sequence of 1280 gene tokens into a transformer, the output tokens are the *contextualized gene embeddings*, where we then apply two training objectives, masked expression reconstruction and cell subgraph contrastive learning (CSCL).

{% details Why sample genes rather than use the full transcriptome? %}
Single-cell data is a tabular datatype that contains counts for usually 20K or more genes. One challenge of single-cell data is that it is incredibly sparse, usually 90% of measured genes have no expression.

It is arguable that maybe training on the full 20K transcriptome may capture more information, and we did that before with [AIDO.Cell](https://www.biorxiv.org/content/10.1101/2024.11.28.625303v1), but applying the attention mechanism over all 20K genes made the computational trade-offs quite large.

Single cell appears relatively low rank, so just taking the 1024 expressed genes as input works quite well for capturing an estimate of cell state.
{% enddetails %}

We intentionally chose to focus on **pretraining objectives**, as we felt that was the biggest opportunity for scalable improvement.

For this blog post we will focus specifically on the effect of the second loss, **masked expression reconstruction**, and save CSCL for another day.

## What are we *actually* learning (with reconstruction)? {#what-are-we-actually-learning-with-reconstruction}

Intuitively, reconstruction should organize gene embeddings in the best way to support… reconstruction (insightful, I know right?). Specifically, we hypothesized that genes that are “more difficult to reconstruct” may be geometrically separated from genes with much more predictable expression patterns.

So what would that mean? Aside from genes that were highly expressed, **we hypothesized that a gene that is regulated by many other genes may be more difficult to reconstruct.**

We measured this with Perturb-seq data, we measured a gene's *perturbation responsiveness* as measuring how many perturbations regulate a readout gene. We calculated this for 4 immortalized cell lines with perturb-seq data available (Replogle-Nadig dataset) trained on cells that have different lineages from the cell lines.

<div class="ember-finding" markdown="1">
We found that genes that were **more perturbation responsive (genes regulated by many other genes)**, tended to lie **further away from the centroid** of gene embeddings in that cell (adjusting for expression magnitude, variance, and tokenization sampling).
</div>

<figure class="ember-figure" id="figure-2">
  <a href="{{ '/assets/img/posts/ember-part1/blog2.png' | relative_url }}" target="_blank" rel="noopener" aria-label="Open Figure 2 at full resolution">
    <img src="{{ '/assets/img/posts/ember-part1/blog2.png' | relative_url }}" width="3450" height="1131" alt="Perturbation responsiveness and distance from the gene-embedding centroid, with higher correlations for matched cell-line embeddings than unmatched cell lines." loading="lazy" decoding="async">
  </a>
  <figcaption><strong>Figure 2.</strong> Left: perturbation responsiveness counts how many perturbations affect a readout gene. Center: more responsive genes tend to lie farther from the gene-embedding centroid. Right: correlations are stronger for embeddings from the matched cell line than for unmatched cell lines. <a href="{{ '/assets/img/posts/ember-part1/blog2.png' | relative_url }}" target="_blank" rel="noopener">View full size</a>.</figcaption>
</figure>

### The effect of pretraining data

This behavior appears to be dependent on the pretraining dataset composition as well. We chose 100 cell types that had a different lineage to the 4 immortalized cell lines, kept the number of cells fixed at 176K cells, and increased the number of cell types available in pretraining. We found there to be a monotonic relationship between the number of cell types available in pretraining, and the amount the embedding space recapitulated *perturbation responsiveness*.

<figure class="ember-figure" id="figure-3">
  <a href="{{ '/assets/img/posts/ember-part1/blog3.png' | relative_url }}" target="_blank" rel="noopener" aria-label="Open Figure 3 at full resolution">
    <img src="{{ '/assets/img/posts/ember-part1/blog3.png' | relative_url }}" width="3450" height="1652" alt="Correlation between gene-embedding distance from the centroid and perturbation responsiveness increases as pretraining diversity grows from 1 to 100 cell types." loading="lazy" decoding="async">
  </a>
  <figcaption><strong>Figure 3.</strong> With the number of pretraining cells held fixed, the correlation between distance from the gene-embedding centroid and perturbation responsiveness increases with cell-type diversity. <a href="{{ '/assets/img/posts/ember-part1/blog3.png' | relative_url }}" target="_blank" rel="noopener">View full size</a>.</figcaption>
</figure>

## How could this be *useful* for perturbation prediction? {#how-could-this-be-useful-for-perturbation-prediction}

Genes that inherently organize by *perturbation responsiveness* can actually be a useful prior. Here is a simple toy example:

For a given gene knockout, **can a logistic regression classifier distinguish differentially expressed genes (DE genes) from those that are unchanged?**

We tracked logistic regression accuracy over many perturbations, and also calculated Spearman correlation over many perturbations while the reconstruction-only version of EMBER trained. We found that linear regression performance tracked closely with how well the model recapitulated perturbation responsiveness.

<figure class="ember-figure" id="figure-4">
  <a href="{{ '/assets/img/posts/ember-part1/blog4.png' | relative_url }}" target="_blank" rel="noopener" aria-label="Open Figure 4 at full resolution">
    <img src="{{ '/assets/img/posts/ember-part1/blog4.png' | relative_url }}" width="3450" height="1843" alt="Readout-gene classification and responsiveness correlation improve over pretraining; a histogram shows separation of differentially expressed genes for NUP54 knockdown in Jurkat." loading="lazy" decoding="async">
  </a>
  <figcaption><strong>Figure 4.</strong> Left: held-out readout-gene classification and correlation with perturbation responsiveness improve during pretraining. Right: NUP54 knockdown in Jurkat, with five-fold cross-validation balanced accuracy of 0.80. The histogram shows signed distances from the logistic-regression decision plane. <a href="{{ '/assets/img/posts/ember-part1/blog4.png' | relative_url }}" target="_blank" rel="noopener">View full size</a>.</figcaption>
</figure>

As a specific case study, we can look at NUP54 knockdown in Jurkat, and see that the logistic regression hyperplane appears to separate the DE genes from the non-DE genes in this dataset.

{% details Details on the logistic regression %}
We fit logistic regression to the normalized gene embeddings, $\hat{v} = v / \lVert v \rVert_2$, rather than the raw embeddings $v$, to predict whether a readout gene is differentially expressed under a given perturbation. It is the distance from the centroid that correlated with perturbation responsiveness. As a result, to set up a hyperplane to easier separate everything within a distance from the centroid, it would be easier to put the points on a sphere (just by renormalizing each gene by its norm). Hence the linear regression is actually on $v / \lVert v \rVert$ instead of just $v$.

We added a simple baseline where the model just took in expression magnitude and variance, to ensure that the gene embedding space was providing something more than just expression levels.

We use five-fold cross-validation over readout genes: each model is trained on four folds and evaluated on the remaining fold. We repeat this evaluation across over 500 different sampled perturbations.

For the NUP54 histogram, we pool the held-out results across all five folds. Each gene appears in the test set exactly once, and its plotted signed distance comes from the logistic-regression decision plane fitted without that gene.
{% enddetails %}

## So is reconstruction *all we need?* {#so-is-reconstruction-all-we-need}

In our paper, **we found reconstruction alone to not be sufficient.** Although reconstruction alone captures perturbation responsiveness, the gene embeddings do not organize by known gene ontology groupings (Figure 5). We also found that models trained with reconstruction alone do not perform well when holding out *perturbations*.

<figure class="ember-figure" id="figure-5">
  <a href="{{ '/assets/img/posts/ember-part1/blog5.png' | relative_url }}" target="_blank" rel="noopener" aria-label="Open Figure 5 at full resolution">
    <img src="{{ '/assets/img/posts/ember-part1/blog5.png' | relative_url }}" width="3450" height="1652" alt="Gene Ontology and cell-type clustering measured by adjusted Rand index (ARI), comparing EMBER, its CSCL-only and reconstruction-only variants, and other representations." loading="lazy" decoding="async">
  </a>
  <figcaption><strong>Figure 5.</strong> Left: gene-embedding clustering by Gene Ontology across models. Right: cell-type clustering for lineage markers, transcription factors, and housekeeping genes. Both panels report adjusted Rand index (ARI). NMI and more baselines can be found in the full paper. <a href="{{ '/assets/img/posts/ember-part1/blog5.png' | relative_url }}" target="_blank" rel="noopener">View full size</a>.</figcaption>
</figure>

We hypothesize that gene embeddings encoding molecular function is important for generalizing perturbations. Interestingly, our reconstruction model performed similarly to that of many existing scFMs that were also trained on only reconstruction-based objectives, suggesting that models trained on only reconstruction may learn similar patterns.

## Next up {#next-up}

In short, we found that when trained with expression reconstruction, **contextualized gene representations** appear to organize in the latent space that is beneficial for downstream perturbation tasks. This pattern appears to scale with higher cell-type diversity in the pretraining corpus.

In part 2, we will further examine the cell subgraph contrastive learning training objective, which drives context-specific molecular function, but also works synergistically with reconstruction for better gene representations.

### Limitations

Some key limitations are that these evaluations are on perturb-seq on immortalized cell lines, which may not generalize to other biological contexts.

Secondly, these experiments only go up to 100 cell types that are distinct from the 4 immortalized cell lines. It would be better to scale this analysis to 1000 or more cell types, but cell lines based on well studied cell types, such as Jurkat (T-cells) limit the number of other distinct cell types we could use in this analysis.

Lastly, I think there is a strong interplay between cell-type, donors, and experimental batch effects. We tried to minimize the number of donors and experimental batches in curating the pretraining datasets for this analysis, and did not investigate the isolated effects of these additional factors.

## References

<ol class="ember-references">
  <li id="ref-1">Hoffmann, J., et al. (2022). <a href="https://arxiv.org/abs/2203.15556">Training Compute-Optimal Large Language Models</a>. arXiv:2203.15556.</li>
  <li id="ref-2">Kaplan, J., et al. (2020). <a href="https://arxiv.org/abs/2001.08361">Scaling Laws for Neural Language Models</a>. arXiv:2001.08361.</li>
  <li id="ref-3">Roohani, Y. H., et al. (2025). <a href="https://www.cell.com/cell/fulltext/S0092-8674%2825%2900675-0">Virtual Cell Challenge: Toward a Turing test for the virtual cell</a>. <em>Cell</em>, 188(13), 3370–3374.</li>
  <li id="ref-4">Xing, E. P., and Song, L. (2026). <a href="https://www.cell.com/cell/fulltext/S0092-8674%2826%2901015-9">A world model of the virtual cell</a>. <em>Cell</em>, 189(19), 5831–5844.</li>
</ol>

<script defer src="{{ "/assets/js/ember-blog.js" | relative_url }}"></script>
