const CleanWebpackPlugin = require('clean-webpack-plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const BabelPlugin = require('babel-webpack-plugin')
const MinifyPlugin = require('babel-minify-webpack-plugin')
const WebpackMd5Hash = require('webpack-md5-hash')

module.exports = (env, argv) => {
	const isDev = argv.mode !== 'production'
	return {
		entry: {
			'main': './src/client.imba', 
			'style-loader': './src/styles/main.scss'
		},
		output: {
			path: __dirname + '/dist', 
			filename: '[name].[chunkhash].js'
		},
		optimization: {
			splitChunks: {
				chunks: 'all', 
				cacheGroups: {
					utilities: {
						test: /[\\/]src[\\/](global|lib)[\\/]/,
						minSize: 0
					}
				}
			}
		},
		resolve: {
			extensions: ['.imba', '.js', '.json']
		},
		module: {
			rules: [
				{
					test: /\.imba$/,
					use: [{ loader: 'imba/loader' }]
				},
				{
					test: /\.scss$/,
					use: [
						isDev ? 'style-loader' : MiniCssExtractPlugin.loader,
						'css-loader', 
						'postcss-loader', 
						'sass-loader'
					]
				},
				{
					test: /\.(ttf|otf|eot|svg|woff(2)?)(\?[a-z0-9]+)?$/,
					use: [{ 
						loader: 'file-loader',
						options: {
							name: 'fonts/[name].[ext]',
							publicPath: isDev ? 'dist/' : './'
						}
					}]
				}
			]
		},
		plugins: [
			new CleanWebpackPlugin(['dist/*.js', 'dist/*.css'], { watch: isDev }),
			new MiniCssExtractPlugin({ filename: 'main.[contenthash].css' }),
			new HtmlWebpackPlugin({
				template: './www/template.index.html',
				filename: '../index.html'
			}),
			new BabelPlugin({
				test: /\.js$/,
				presets: ['es2015'],
				plugins: ['transform-async-to-generator'],
			}),
			new MinifyPlugin({}, { test: /\.js($|\?)/i }),
			new WebpackMd5Hash()
		]
	}
}