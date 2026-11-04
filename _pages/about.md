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
        <a class="advisor-link" href="https://www.cs.cmu.edu/~jianma/">Professor Jian Ma</a> and
        <a class="advisor-link" href="https://www.cs.cmu.edu/~epxing/">Professor Eric Xing</a>.
        My research is supported by the NSF Graduate Research Fellowship. I previously interned at <a href="https://genbio.ai/">GenBio.AI</a>.
      </p>
      <p class="research-statement"><strong>I develop biological foundation models and study how their representations uncover new insights and improve counterfactual predictions.</strong></p>
      <p>Here are some highlights:</p>
      <ul class="research-projects">
        <li>
          <a class="research-project-name" href="https://doi.org/10.64898/2026.10.28.762655">EMBER</a> —
          <span>Gene-centric foundation model for <strong>contextualized gene representations</strong> that support multigene perturbation prediction.</span>
          <a href="https://x.com/eigenNick/status/2117336472852553806">Video Explainer</a>
        </li>
        <li>
          <a class="research-project-name" href="https://www.biorxiv.org/content/10.64898/2026.02.18.706454v2">Cell Perturbation Benchmarking</a> —
          <span>Evaluated and trained diffusion, flow matching, Schr&ouml;dinger bridge, and graph neural network models.</span>
        </li>
        <li>
          <a class="research-project-name" href="https://www.biorxiv.org/content/10.1101/2024.11.28.625303v1">AIDO.Cell</a> —
          <span>Led a team for <strong>600M-parameter single-cell foundation model</strong> for pretraining with minimal priors.</span>
        </li>
        <li>
          <a class="research-project-name" href="https://www.biorxiv.org/content/10.1101/2024.12.01.625444v1">AIDO.DNA</a> —
          <span>In charge of pretraining <strong>7B-parameter genome foundation model</strong> for variant effect prediction and sequence generation.</span>
        </li>
        <li>
          <a class="research-project-name" href="https://www.biorxiv.org/content/10.1101/2025.11.09.687403v3">HEIMDALL</a> —
          <span>Examined how <strong>tokenizer design affects transfer learning</strong> in single-cell pretrained models.</span>
        </li>
      </ul>
    </div>
    <div class="home-portrait">
      {% include figure.liquid loading="eager" path="assets/img/profile_pic.jpeg" class="img-fluid rounded" alt="Nicholas Ho playing with a yoyo on a rooftop" cache_bust=true %}
      <p class="portrait-contact"><a href="mailto:nzh@cs.cmu.edu">nzh [AT] cs.cmu.edu</a></p>
    </div>
  </div>

  <p class="research-contact">I got some <a href="https://www.biorxiv.org/content/10.1101/2025.07.04.663102v1">spatial transcriptomics</a> and <a href="https://www.biorxiv.org/content/10.1101/2022.10.04.510845v1">biophysics</a> experience too. Feel free to reach out — I'm always happy to chat!</p>
  <p>In my spare time I enjoy <a href="https://www.youtube.com/shorts/61IQGUaxTgQ">yoyoing</a>.</p>
</div>

<script src="{{ '/assets/js/legacy-links.js' | relative_url }}" defer></script>


<section class="home-section" aria-labelledby="latest-posts-heading">
<h2 id="latest-posts-heading">Latest Posts</h2>
<p>Soon!</p>
</section>

<section class="home-section" aria-labelledby="publications-heading">
<h2 id="publications-heading"><a href="{{ '/publications/' | relative_url }}" style="color:inherit;">Publications &amp; Preprints</a></h2>
{% include selected_papers.liquid %}
</section>
