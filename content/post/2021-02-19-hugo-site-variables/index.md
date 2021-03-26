---
title: HUGO Variables
author: Rob Wiederstein
date: '2021-02-19'
slug: hugo-variables
categories:
  - hugo
  - go
tags: []
draft: no
header:
   image: hugo-logo.jpg
   alt: hugo logo
   caption: Hugo is the static web site generator paired with blogdown.
summary: Inspecting a hugo website will reveal templates dependent on variables.  You have to have an understanding of what variables are available and under what circumstances.  Careful reading of hugo documentation is helpful, but here are a few tips.
repo: https://raw.githubusercontent.com/RobWiederstein/purple-bananas/main/content/post/2021-02-19-hugo-site-variables/index.md
---

`hugo` has lots of different kinds of variables but we'll focus on just three here:  (1) "built-in" site variables, (2) defined global variables in the `config` file and (3) page variables.

# Site Variables List

Site-level variables are built into hugo's "core" and are defined in the configuration file.  Any variable that begins with `.Site` is a site-level variable. Common examples include:`Site.Author`, `.Site.BaseURL`, and `.Site.Title`.  To see the configuration settings for `hugo` run the following code in the terminal:

```
hugo config
```
Reference to a site variable might look like
`<p>{{ .Site.Title }}</p>`.

# `.Site.Params` Variable

The `.Site.Params` variable is a container that holds all of the values from the `params` section of your configuration file.  For example, `www.robwiederstein.org` holds the parameters:

```
params:
  author: Rob Wiederstein
  MathJaxCDN: //cdnjs.cloudflare.com/ajax/libs
  MathJaxVersion: 2.7.5
  description: A website about data, analysis, and public policy.
  favicon: favicon.ico
```
Reference to the above author would look like `{{ .Site.Params.author }}` and return "Rob Wiederstein".

# Page Variables

Page-level variables are either (1) defined in a **content** files front matter, (2) derived from the content's file location, or (3) extracted from the content body itself.

Here's some code that is the front matter of an `.Rmd` post.

```
#example front matter
title: Lost Cargo in Wisconsin Shipwrecks
author: Rob Wiederstein
date: '2021-03-20'
slug: lost-cargo-in-wisconsin-shipwrecks
categories:
  - R
tags:
  - wordcloud
```
Page-level variables are only accessible in lower case like `.Params.tags`.

# Conclusion

Variables are the building blocks for templates.  Understanding what's available and how to define a variable means you can use it to render webpages.  Hugo's documentation on variables can be found [here](https://gohugo.io/categories/variables-and-params).
