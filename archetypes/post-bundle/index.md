---
title:
author:
date:
draft: false
# tags/categories example: ["A Tag", "Another Tag"]`
tags:
categories:
#   Markdown linking is allowed, e.g. `caption: "[Image credit](http://example.org)"`.
# image path for social media
image:
#10 words or less
caption:
#default summary length in HUGO is 100 words
summary:
---

```{r load-packages, include = F}
## Load frequently used packages for blog posts
library('devtools') # for session_info()
```
## Post content

Typical location to start editing since the bibliography chunk is hidden. Make sure that you selected `R Markdown (.Rmd)` as the _format_ option of the post when using the `New Post` `r CRANpkg('blogdown')` addin.

## R image


```{r 'plot', echo = TRUE, fig.width = 6, fig.height = 6, eval = FALSE}
## This imaged will be saved in the /post/*_files/ directory
## Use echo = FALSE if you want to hide the code for making the plot
plot(1:10, 10:1)
```
## Custom image

The easiest option is to use the `r CRANpkg('blogdown')` _Insert Image_ RStudio addin to add an external image.


## Acknowledgements


## References


## Reproducibility

```{r reproducibility, echo = FALSE}
## Reproducibility info
options(width = 120)
session_info()
```
