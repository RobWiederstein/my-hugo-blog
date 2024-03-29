---
title: Primer on Working with Go Templates
author: Rob Wiederstein
date: '2021-02-19'
slug: primer-on-working-with-go-templates
categories:
  - go
  - hugo
tags: []
draft: no
toc: yes
header:
   image: feature.jpg
   alt: go logo
   caption: Go is the templating language behind HUGO. 
summary:  Knowing a little bit about the go templating language will help you understand the syntax of layout templates in HUGO.
repo: https://raw.githubusercontent.com/RobWiederstein/purple-bananas/main/content/post/2021-02-19-ten-tips-to-working-with-go-templates/index.md
---

{{< table_of_contents >}}

# Introduction

`hugo` templates are based on the `go` language, but are derived from the go template library.  It is simple and relies on only basic logic.
`go` templates are html documents whose variables and functions are accessible via `{{-}}`. For purposes of the blog, the templates are contained in the `layout` folder.


## Curly Brackets

Templates are usually bound to a data structure which is then used to populate the fields within the template.  (An old fashioned mail label merge comes to mind, back when we sent mail).  The code `{{ .FieldName }}` denotes the placeholder that the data will replace.

## Capital Letters

A name is only exported if it begins with a capital letter. For example, `fmt.Println(math.Pi)` must have the capital "P" or it will not export 3.14. This is the case when working with templates as well.

## Commenting

```go
{{/* a comment */}}
```

## Dot Notation

You are never going to understand `go` without understanding the `{{ . }}` first. It's about the scoping rules in `go` and it allows you to abbreviate how you cite a variable depending on the context.  Great article [here](https://regisphilibert.com/blog/2018/02/hugo-the-scope-the-context-and-the-dot/).

```go
// Access Page Parameter "bar" defined in page front matter.
{{ .Params.bar }}
```
## Dollar Notation

Another important symbol is `$`.  The root context of a template file is stored in `$` so the variable can be referenced no matter the depth of the loop or function.

## Assignments

Variables are assigned values or declared through the use of `:=`.
```go
{{ $city := "A string" }}
```

# Variable

Global, pages, parameters, configured or set.

```go
// predefined variable
{{ .Title }}
// root variable
{{ $address }}
// declared value
{{ $city:= "Dallas"}}
```

# Arrays

## Arrays  (slice)

An array, known as a slice in `go`, is declared as follows:

```go
{{ $names := slice "Alex" "Bob" "Christy"}}
```

## Associative arrays (maps)

Associative arrays are called "maps".

```go
{{ $starwars := dict "firstname" "Darth" "lastname" "Vader" "birthplace" "Tatooine" }}
```

## Subsetting or Indexing

```go
{{ index $names 3 }}
// Christy
{{ index $starwars "birthplace"}}
//Tatooine
```

# Functions

## Basic

```go
{{add 1 2}}
<!-- yields "3" -->
```

```go
{{ lt 1 2 }}
<!-- prints true (i.e., since 1 is less than 2) -->
```

```go
{{ eq 1 1}}
<!--prints true since "eq" means "equals"
```

## `range`

Iterates over a map, array, or slice. Go and Hugo templates make heavy use of `range` to iterate over a map, array or slice.

## `where`

Filters an array to only the elements containing a matching value for a given field.

```go
{{ range where .Pages "Section" "foo" }}
  {{ .Content }}
{{ end }}
```

## `delim`

Loops through any array, slice, or map and returns a string of all the values separated by a delimiter.

```go
<p>Tags: {{ delimit .Params.tags ", " }}</p>
```

# Incorporation

Templates in `hugo` are always in the `/layouts` folder.

## Partials

A partial is by definition only part of a template.  It must have a context for it to be relevant.  In other words, **Don't forget the "{{ . }}"**.

```go
//syntax {{ partial "<PATH>/<PARTIAL>.<EXTENSION>" . }}
{{ partial "header.html" . }}
```

# Lists

`_index.md` adds front matter and content to list templates. You can keep one _index.md for your homepage and one in each of your content sections, taxonomies, and taxonomy terms.

# Lookup Order for templates

Hugo searches for the layout to use for a given page in a well defined order, starting from the most specific.

-   kind
-   declared in frontmatter: `layout:  "single"`
-   type in frontmatter: `type:  "post"`

# `_index.md`

It has a special role in Hugo. It allows you to add front matter and content to your list templates.
