---
title: HUGO Site Variables
author: Rob Wiederstein
date: '2021-02-19'
slug: hugo-site-variables
categories:
  - hugo
  - go
tags: []
---

Hello World!


<p>{{ .Site.Title }}</p>

{{< highlight go >}} A bunch of code here {{< /highlight >}}


{{ $_hugo_config := `{ "version": 1 }` }}

{{< gist spf13 7896402 >}}

{{< param slug >}}

{{< tweet 1316806201888378880 >}}
