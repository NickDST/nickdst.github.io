---
layout: distill
title: Research post starter
description: An unpublished working template for a research walkthrough.
date: 2026-10-26
tags: [machine-learning, computational-biology]
featured: false
giscus_comments: false
bibliography: papers.bib
authors:
  - name: Nicholas Ho
    url: https://nickdst.github.io/
    affiliations:
      name: Carnegie Mellon University
toc:
  - name: The question
  - name: The method
  - name: The evidence
  - name: What it means
---

This is an unpublished writing scaffold in `_drafts/`. Replace the instructional prose before publishing. It appears locally only when Jekyll runs with `--drafts`.

## The question

Start with a concrete question, explain why it matters, and state the main finding in a few sentences. Give the reader enough intuition to follow the technical sections.

Introduce related work where it helps the explanation. For example, this citation points to your existing AIDO.Cell paper.<d-cite key="ho2024aidocell"></d-cite>

## The method

Describe the mechanism before introducing notation. Inline math works like $z=f_\theta(x)$. Put longer equations on their own lines:

$$
\mathcal{L}(\theta) = \frac{1}{N}\sum_{i=1}^{N} \ell(f_\theta(x_i), y_i).
$$

Explain what every symbol means and what the objective encourages. This equation is an illustrative template, not a claim about a specific paper.

```python
def mean_loss(losses):
    return sum(losses) / len(losses)
```

{% details Optional technical detail %}
Use a collapsible note for derivations or implementation details that readers can skip without losing the main argument.
{% enddetails %}

## The evidence

Place each figure next to the claim it supports. Give its caption enough context to understand the axes, comparison, and takeaway.

{% include figure.liquid path="assets/pics/aidocell.png" class="img-fluid rounded" alt="Existing AIDO.Cell project illustration" caption="An existing project image used to demonstrate figure formatting. Replace it with the figure for your post." %}

A small table can be written directly in Markdown:

| Question | Evidence to include |
| :--- | :--- |
| Does the approach work? | Main result and a relevant baseline |
| Which choice matters? | A controlled ablation |
| Where does it fail? | A limitation or counterexample |

For an interactive figure, embed a separate HTML file:

<iframe src="{{ '/assets/html/blog-starter/decay.html' | relative_url }}" title="Illustrative exponential decay with an adjustable rate" width="100%" height="360" loading="lazy" style="border:0;border-radius:8px;"></iframe>

*Illustrative exponential decay, not experimental data. Move the slider to change the rate.*

## What it means

Connect the evidence back to the initial question. Separate observations from hypotheses, discuss limitations, and finish with the next question worth investigating.<d-footnote>Use footnotes for useful context that would interrupt the main text.</d-footnote>
