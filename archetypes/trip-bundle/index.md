---
title:  "{{ replace .Name "-" " " | title }}"
author: "Rob Wiederstein"
date: "2021-03-01"
draft: false
slug: []
resources:
- src: gallery/*.jpg
  name: gallery-:counter
  title: gallery-title-:counter
---

# Day 1

Visit a museum.

{{< gallery folder="gallery" title="Purple Flowers" >}}
