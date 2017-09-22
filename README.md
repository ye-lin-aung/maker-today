## Setup Site

Based on install instructions [available here](https://themes.gohugo.io/hugo-universal-theme)

### Install Hugo

```bash
$ brew install hugo
```

Check hugo version

```bash
$ hugo version
```

### Create a New Site

```bash
## Create the base hugo site
$ hugo new site maker-today

## init the repo
$ cd maker-today
$ git init
```

### Install Universal Theme

```bash
## Set the theme as a git submodule
$ git submodule add https://github.com/devcows/hugo-universal-theme themes/hugo-universal-theme

## Add the theme to the config.toml file
$ echo 'theme = "hugo-universal-theme"' >> config.toml
```

### Add Content

Now you can add content yourself, or use the example available in the [exampleSite](themes/hugo-universal-theme/exampleSite) folder

## Run Site (Dev)

```bash
$ hugo server -D
```

## Generate Static Site (Prod)

```bash
$ hugo
```
