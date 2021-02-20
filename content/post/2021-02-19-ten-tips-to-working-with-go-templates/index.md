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
toc: yes
---

{{< table_of_contents >}}

# Introduction

`hugo` templates are based on the `go` language, but are derived from the go template library.  It is simple and relies on only basic logic.
`go` templates are html documents whose variables and functions are accessible via `{{-}}`.

Templates are usually bound to a data structure which is then used to populate the fields within the template.  (An old fashioned mail label merge comes to mind, back when we sent mail).  The code `{{ .FieldName }}` denotes the placeholder that the data will replace.

## Variable

```go
// predefined variable
{{ .Title }}
// custom variable
{{ $address }}

```

## Function

```go
// general syntax
// {{ FUNCTION ARG1 ARG2 .. }}
{{ add 1 2 }}
```

## Dot Notation

```go
// Access Page Parameter "bar" defined in page front matter.
{{ .Params.bar }}
```

## Set Custom Variable

```go
{{ $address := "123 Main St." }}
{{ $address }}
```

# Basic Functions

```go
{{add 1 2}}
// yield "3"
```

```go
{{ lt 1 2 }}
<!-- prints true (i.e., since 1 is less than 2) -->
```

# Incorporation

Templates in `hugo` are always in the `/layouts` folder.

## Includes

```go

```

## Partials

**Don't forget the ".".**

```go
//syntax {{ partial "<PATH>/<PARTIAL>.<EXTENSION>" . }}
{{ partial "header.html" . }}
```