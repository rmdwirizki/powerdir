module.exports = {
  plugins: [
    require('cssnano')({ 
      autoprefixer: { 
        browsers: ['IE 6','Chrome 9', 'Firefox 14'],
        add: true
      } 
    }),
    require('css-mqpacker')()
  ]
}