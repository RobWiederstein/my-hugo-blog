---
title: Ten Tips to Working with Go Templates
author: Rob Wiederstein
date: '2021-02-19'
slug: ten-tips-to-working-with-go-templates
categories:
  - go
  - hugo
tags: []
draft: false
toc: true
---

# Introduction

`hugo` templates are based on the `go` language, but are derived from the go template library.  It is simple and relies on only basic logic.
`go` templates are html documents whose variables and functions are accessible via `{{-}}`.

## Variable

```{go}
# predefined variable
{{ .Title }}
# custom variable
{{ $address }}

```

## Function

```{go}
# general syntax
# {{ FUNCTION ARG1 ARG2 .. }}
{{ add 1 2 }}
```

## Dot Notation

```{go}
# Access Page Parameter "bar"" defined in page front matter.
{{ .Params.bar }}
```

## Set Custom Variable

```{go}

{{ $address := "123 Main St." }}
{{ $address }}

```

## Basic Functions

```go

#Hello

```

