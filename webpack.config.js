const HtmlWebpackPlugin = require('html-webpack-plugin')
const ExtractTextPlugin = require('extract-text-webpack-plugin')

module.exports = {
	module: {
		rules: [
			{
				test: /\.imba$/,
				loader: 'imba/loader',
			},
			{
				test: /\.(s*)css$/,
        use: ExtractTextPlugin.extract({
					fallback: 'style-loader',
          use: ['css-loader', 'sass-loader']
        })
      },
			{
				test: /\.(ttf|otf|eot|svg|woff(2)?)(\?[a-z0-9]+)?$/,
				loader: 'file-loader?name=fonts/[name].[ext]'
			}
		]
	},
	resolve: {
		extensions: ['.imba', '.js', '.json']
	},
	entry: ['./src/client.imba', './src/styles/main.scss'],
	output: {  
		path: __dirname + '/dist', 
		filename: 'bundle.js'
	},
	plugins: [
		new ExtractTextPlugin('style.css'),
    new HtmlWebpackPlugin({ 
			hash: true,
			template: './www/template.index.html',
			filename: '../index.html'
		})
	]
}