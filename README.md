# Powerdir

[Work In Progress] Directory based navigation for markdown reader application.

## How to run

- Clone this repo on a localhost (server) environment `git clone https://github.com/rmdwirizki/powerdir.git`
- Go to the directory
- Run `npm install`
- Generate `tree.json` by running `node index.js`
- Open `index.html`

## How to dev

- Run `npm run watch`

## How to build

- Run `npm run build`

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