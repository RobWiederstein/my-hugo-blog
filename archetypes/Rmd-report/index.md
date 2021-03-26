---
title:
author:
date:
slug:
# tags/categories example: ["A Tag", "Another Tag"]`
categories:
tags:
layout: layouts/post/single
draft: no
# bib style and .bib in content/post. packages.bib within content/post/my-post
bibliography: [packages.bib, ../blog.bib]
# style bib via https://citationstyles.org
csl: ../ieee-with-url.csl
#link inline reference to bib
link-citations: true
#include packages even if not referenced
nocite: |
  @R-base, @R-blogdown, @R-tidyverse
# image path for social media
header:
   image:
   alt:
   caption: 
repo:
summary:  By default, Hugo automatically takes the first 70 words of your content as its summary and stores it into the `.Summary` page variable for use in your templates. You may customize the summary length by setting `summaryLength` in your site configuration *or* you can set it in the front matter.
---


```{r load-packages, include = F}
## Load frequently used packages for blog posts
packages <- c(
      'devtools', #for session info
      'ggthemes', #for plots
      'blogdown'
)
lapply(packages, function(x) {
  if (!requireNamespace(x)) install.packages(x)
  library(x, character.only = TRUE)
})
```

```{r set-chunk-options, include = F}
## Do not break chunk line
## Do not use spaces or periods "." or underscores "_"
## set options for knitr
knitr::opts_chunk$set(
  comment = '',
  fig.width = 6,
  fig.asp = .8,
  fig.align="center",
  message=F,
  error=F,
  warning=F,
  tidy=T,
  comment='',
  cache=T,
  dev='svg',
  echo=F
)
```

```{r set-ggplot-theme-defaults, include = F}
#from ggthemes
library(ggplot2); theme_set(ggthemes::theme_fivethirtyeight())
```

```{r define-color-palette, include = F, eval = T}
# color blind friendly palette from http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/
cbPalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7", "#000000")
```

```{r write-package-bib, echo = F}
# write packages used to bib in current directory
knitr::write_bib(.packages(), "./packages.bib")
```

# [R image](#image)


```{r plot-mtcars, echo=F, fig.cap = "A plot with 538 layout theme and color blind palette."}
data(mtcars)
mtcars$cyl <- factor(mtcars$cyl)
p <- ggplot(mtcars, aes(mpg, hp, group = cyl, colour = cyl))
p <- p + scale_color_manual(values = cbPalette)
p <- p + geom_point(size = 2)
p <- p + ggtitle("mtcars")
p
```

# [Overview](#overview)

(Describe the problem.)

# [Background](#background)

(Who else has worked on this problem?  What did they find?)

# [Data and model](#data)

(What data did you use, where did you get it?)

# [Results](#results)

# [Conclusion](#conclusion)

# [Acknowledgements](#acknowledge)

This blog post was made possible thanks to:

# [References](#reference)

<div id="refs"></div>

# [Disclaimer](#disclaimer)

The views, analysis and conclusions presented within this paper represent the author’s alone and not of any other person, organization or government entity. While I have made every reasonable effort to ensure that the information in this article was correct, it will nonetheless contain errors, inaccuracies and inconsistencies. It is a working paper subject to revision without notice as additional information becomes available. Any liability is disclaimed as to any party for any loss, damage, or disruption caused by errors or omissions, whether such errors or omissions result from negligence, accident, or any other cause. The author(s) received no financial support for the research, authorship, and/or publication of this article.

# [Reproducibility](#reproduce)

```{r reproducibility, echo = FALSE}
# system & package info
options(width = 120)
session_info()
```
