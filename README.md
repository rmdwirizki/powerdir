# Powerdir

[Work In Progress] Directory based navigation for markdown reader application.

## How to run

- Run `npm install`
- Generate `tree.json` by running `node index.js`
- Serve `index.html` as static content (ex: `localhost`)

## How to dev

- Run `npm run watch` (without serving)
- Run `npm run dev` (with serve at `localhost:8080`)

## How to build

- Run `npm run build`
- Run `npm run build-es5` to support es5

## How to analyze bundle (with webpack-bundle-analyzer) 

- Run `npm run stats`
- Run `npm run stats-es5` to support es5

## Available properties to meta.json and .md (markdown header) files

- **id**, to create a static slug for url
- **title**, as a filename or foldername alias
- **order**, represented an order sequence of file and folder
- **description**, file or folder description

## Webpack Optimization Tasks List

- [x] Minify HTML, CSS, JS
- [x] Assets Hashing
- [x] ES5 + Polyfill to Support Edge and IE11
- [x] Gzip compression
- [x] Use ESM as long as possible to leverage Tree Shaking Ability
- [x] Component based CSS
- [ ] Service Worker
- [ ] Server-side Rendering
- [ ] Implement purgecss-webpack-plugin to reduce `bulma` size
