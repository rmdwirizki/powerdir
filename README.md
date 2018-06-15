# Powerdir

[Work In Progress] Directory based navigation for markdown reader application.

## How to run

- Run `npm install`
- Generate `tree.json` by running `node index.js`
- Open `index.html`

## How to dev

- Run `npm run watch`

## Available properties to meta.json and .md (markdown header) files

- **id**, to create a static slug for url
- **title**, as a filename or foldername alias
- **order**, represented an order sequence of file and folder
- **description**, file or folder description

## Temporary Notes

- [x] Set default id by generating UUID from stats.ino (LINUX) or dirpath (WINDOWS)
- [ ] Find alternative identifier for WINDOWS
- [ ] Create node for generating id/slug by dirname and filename