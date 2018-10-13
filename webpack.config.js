const webpack = require('webpack')

const CleanWebpackPlugin = require('clean-webpack-plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const BabelPlugin = require('babel-webpack-plugin')
const MinifyPlugin = require('babel-minify-webpack-plugin')
const CompressionPlugin = require('compression-webpack-plugin');
const WebpackMd5Hash = require('webpack-md5-hash')

const zopfli = require('@gfx/zopfli');

const getWebpackPlugins = function(plugins) {
	let activePlugins = []

	for (let index = 0; index < plugins.length; index++) {
		if (plugins[index].exclude) { 
			continue
		}
		else { 
			activePlugins.push(plugins[index].plugin) 
		}
	}
	return activePlugins
}

module.exports = (env, argv) => {
	const isDev = argv.mode !== 'production'
	const isES5 = (argv.es5) ? true : false
	const buildPath = 'dist/build/' + ((isDev) ? 'dev' : ((isES5) ? 'prod-es5' : 'prod'))

	return {
		entry: isDev ? [
			'./src/app.imba', './src/styles/main.scss'
		] : Object.assign(isES5 ? {
			'polyfill': [
				'./node_modules/babel-polyfill/browser.js', 
				'./node_modules/whatwg-fetch/fetch.js',
				'./node_modules/custom-event-polyfill/polyfill.js'
			]
		} : {}, {
			'main': './src/app.imba', 
			'style-loader': './src/styles/main.scss'
		}),
		output: {
			path: __dirname + '/' + buildPath, 
			filename: '[name].[chunkhash].js'
		},
		optimization: isDev ? {} : {
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
						'css-loader', 'postcss-loader', 'sass-loader'
					]
				},
				{
					test: /\.(ttf|otf|eot|svg|woff(2)?)(\?[a-z0-9]+)?$/,
					use: [{ 
						loader: 'file-loader',
						options: {
							name: 'fonts/[name].[ext]',
							publicPath: isDev ? (buildPath + '/') : './'
						}
					}]
				}
			]
		},
		plugins: getWebpackPlugins([
			{ plugin: new CleanWebpackPlugin([
				buildPath + '/*.js', 
				buildPath + '/*.css', 
				buildPath + '/*.gz'
			], { watch: isDev }) },
			{ exclude: isDev, plugin: new MiniCssExtractPlugin({ filename: 'main.[contenthash].css' }) },
			{ plugin: new HtmlWebpackPlugin({
				template: './www/template.index.html',
				filename: (isES5) ? '../../../index.es5.html' : '../../../index.html',
				minify: {
					removeAttributeQuotes: true,
					collapseWhitespace: true,
					html5: true,
					minifyCSS: true,
					removeComments: true,
					removeEmptyAttributes: true
				}
			}) },
			{ exclude: !isES5, plugin: new BabelPlugin({
				test: /\.js$/,
				// https://gist.github.com/newyankeecodeshop/79f3e1348a09583faf62ed55b58d09d9#server-side
				presets: [['env', { 
					targets: { 
						'chrome'  : '49',
						'firefox' : '45',
						'safari'  :  '8',
						'ie'      : '11', 
						'edge'    : '14',
					} 
				}]],
			}) },
			{ exclude: isDev, plugin: new MinifyPlugin({}, { test: /\.js($|\?)/i }) },
			{ plugin: new webpack.DefinePlugin({ 
				BUILD_PATH: buildPath,
				ES5: isES5,
				PRODUCTION: !isDev
			}) },
			{ exclude: isDev, plugin: new CompressionPlugin({
				compressionOptions: { 
					numiterations: 15 
				},
				algorithm(input, compressionOptions, callback) {
					return zopfli.gzip(
						input, compressionOptions, callback
					);
				}
			}) },
			{ plugin: new WebpackMd5Hash() }
		]),
	}
}