---
title:
author:
date:
layout: layouts/post/single
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
x <- c(
      'devtools', #for session info
      'ggthemes'
)
lapply(x, library, character.only = T)
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

## R image


```{r plot-mtcars, echo=F, fig.cap = "A plot with 538 layout theme and color blind palette."}
data(mtcars)
mtcars$cyl <- factor(mtcars$cyl)
p <- ggplot(mtcars, aes(mpg, hp, group = cyl, colour = cyl))
p <- p + scale_color_manual(values = cbPalette)
p <- p + geom_point(size = 2)
p <- p + ggtitle("mtcars")
p
```

## Custom image

The easiest option is to use the  _Insert Image_ RStudio addin to add an external image.

## Overview

(Describe the problem.)

## Background

(Who else has worked on this problem?  What did they find?)

## Data and model

(What data did you use, where did you get it?)

## Results

## Conclusion

## Acknowledgements

(Get bibliographic stuff from "archetype hill".)

## References

## Disclaimer

The views, analysis and conclusions presented within this paper represent the author’s alone and not of any other person, organization or government entity. While I have made every reasonable effort to ensure that the information in this article was correct, it will nonetheless contain errors, inaccuracies and inconsistencies. It is a working paper subject to revision without notice as additional information becomes available. Any liability is disclaimd as to any party for any loss, damage, or disruption caused by errors or omissions, whether such errors or omissions result from negligence, accident, or any other cause. The author(s) received no financial support for the research, authorship, and/or publication of this article.

## Reproducibility

```{r reproducibility, echo = FALSE}
## Reproducibility info
options(width = 120)
session_info()
```
