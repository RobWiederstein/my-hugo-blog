---
title: HUGO Variables
author: Rob Wiederstein
date: '2021-02-19'
slug: hugo-variables
categories:
  - hugo
  - go
tags: []
---

`hugo` has three kinds of variables:  (1) resident or "built-in" global variables, (2) defined global variables in the `config` file and (3) page variables.

# Site Variables List

To see the configuration settings for `hugo` run:

```
hugo config
```


# `.Site.Params` Variable




<p>{{ .Site.Title }}</p>

{{< highlight go >}} A bunch of code here {{< /highlight >}}


{{ $_hugo_config := `{ "version": 1 }` }}

{{< gist spf13 7896402 >}}

{{< param slug >}}

{{< tweet 1316806201888378880 >}}

{{ .Title | markdownify }}
