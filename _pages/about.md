---
layout: "about"
title: "about"
permalink: "/"
subtitle: "Computational Biology PhD · Carnegie Mellon University School of Computer Science"
profile: false
selected_papers: false
social: true
announcements: {"enabled": false}
latest_posts: {"enabled": false, "scrollable": false, "limit": 3}
---


<div id="bio" class="home-bio">
  <div class="home-intro">
    <div class="home-intro-copy">
      <p>Hello! I'm Nicholas, a Computational Biology PhD student at Carnegie Mellon University, advised by
        <a href="https://www.cs.cmu.edu/~jianma/">Professor Jian Ma</a> and
        <a href="https://www.cs.cmu.edu/~epxing/">Professor Eric Xing</a>.
      </p>
      <p>My research is supported by the <strong>NSF Graduate Research Fellowship (GRFP)</strong>. I previously interned at <a href="https://genbio.ai/">GenBio.AI</a>.</p>
      <p class="research-statement"><strong>I develop biological foundation models and study how their representations uncover new insights and improve counterfactual predictions.</strong></p>
      <ul class="research-experience">
        <li><span class="research-tag tag-perturbation">Cell Perturbation</span> — Performed a
          <a href="https://www.biorxiv.org/content/10.64898/2026.02.18.706454v2">comprehensive evaluation of perturbation response prediction</a>, training and benchmarking diffusion, flow matching, Schr&ouml;dinger bridge, and GNN models for <strong>unseen chemical and genetic perturbations</strong>.
        </li>
        <li><span class="research-tag tag-cell">Single Cell</span> — Led
          <a href="https://www.biorxiv.org/content/10.1101/2024.11.28.625303v1">AIDO.Cell</a>, a <strong>600M-parameter</strong> whole-transcriptome model, and designed
          <a href="https://www.biorxiv.org/content/10.1101/2025.11.09.687403v3">HEIMDALL</a> to study how <strong>tokenizer design</strong> affects transfer learning in single-cell foundation models.
        </li>
        <li><span class="research-tag tag-dna">DNA</span> — Pretrained
          <a href="https://www.biorxiv.org/content/10.1101/2024.12.01.625444v1">AIDO.DNA</a>, a <strong>7B-parameter</strong> genome foundation model trained to learn evolutionary representations for cis-regulatory sequence-to-function prediction.
        </li>
        <li><span class="research-tag tag-tissue">Spatial Transcriptomics</span> — Co-authored
          <a href="https://www.biorxiv.org/content/10.1101/2025.07.04.663102v1">AIDO.Tissue</a>, a spatial transcriptomics foundation model that learns tissue-level context through <strong>spatial cell-guided pretraining</strong>.
        </li>
      </ul>
    </div>
    <div class="home-portrait">
      {% include figure.liquid loading="eager" path="assets/img/profile_pic.jpeg" class="img-fluid rounded" alt="Nicholas Ho playing with a yoyo on a rooftop" cache_bust=true %}
      <p class="portrait-contact"><a href="mailto:nzh@cs.cmu.edu">nzh [AT] cs.cmu.edu</a></p>
    </div>
  </div>

  <p class="research-contact">Feel free to reach out—I'm always happy to discuss interesting problems.</p>
  <p>In my spare time I enjoy <a href="https://www.youtube.com/shorts/61IQGUaxTgQ">yoyoing</a>.</p>
</div>

<script src="{{ '/assets/js/legacy-links.js' | relative_url }}" defer></script>


<section class="home-section" aria-labelledby="latest-posts-heading">
<h2 id="latest-posts-heading">Latest Posts</h2>
<p>Soon!</p>
</section>

<section class="home-section" aria-labelledby="publications-heading">
<h2 id="publications-heading"><a href="{{ '/publications/' | relative_url }}" style="color:inherit;">Publications</a></h2>
{% include selected_papers.liquid %}
</section>
