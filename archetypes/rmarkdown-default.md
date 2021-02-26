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
library(ggplot2); theme_set(ggthemes::theme_fivethirtyeight())
```
## R image


```{r plot-mtcars, echo=F}
data(mtcars)
mtcars$cyl <- factor(mtcars$cyl)
p <- ggplot(mtcars, aes(mpg, hp, group = cyl, colour = cyl))
p <- p + geom_point(size = 2)
p <- p + ggtitle("mtcars")
p

```
## Custom image

The easiest option is to use the  _Insert Image_ RStudio addin to add an external image.


## Acknowledgements


## References


## Reproducibility

```{r reproducibility, echo = FALSE}
## Reproducibility info
options(width = 120)
session_info()
```
