const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const { VueLoaderPlugin } = require('vue-loader');


module.exports = (env, options) => {
  const NODE_ENV = env.NODE_ENV;
  const production = env.production;
  const jsSourceMap = NODE_ENV === "local" ? true : false;
  const devtool = NODE_ENV === "local" ? 'source-maps' : 'eval';
  console.info("env", env);
  console.info('NODE_ENV: ', NODE_ENV);
  console.info('Production: ', production);
  console.info("jsSourceMap", jsSourceMap);
  console.info("devtool", devtool);

  return {
    devtool: devtool,
    optimization: {
      minimizer: [
        new UglifyJsPlugin({ 
            cache: true, 
            parallel: true, 
            sourceMap: jsSourceMap,
        }),
        new OptimizeCSSAssetsPlugin({})
      ]
    },
    entry: {
        './js/app.js': ['./js/app.js'].concat(glob.sync('./vendor/**/*.js'))
    },
    output: {
      filename: 'app.js',
      path: path.resolve(__dirname, '../priv/static/js')
    },
    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader'
          }
        },
        {
          test: /\.css$/,
          use: [MiniCssExtractPlugin.loader, 'css-loader']
        },
        {
          test: /\.scss$/,
          use: [
              "style-loader", // creates style nodes from JS strings
              MiniCssExtractPlugin.loader, // extracts CSS into separate files
              "css-loader", // translates CSS into CommonJS
              "sass-loader", // compiles Sass to CSS, using Node Sass by default,
          ]
        },
        {
          test: /\.vue$/,
          use: 'vue-loader'
        },
      ]
    },
    plugins: [
      new MiniCssExtractPlugin({ filename: '../css/app.css' }),
      new CopyWebpackPlugin([{ from: 'static/', to: '../' }]),
      new VueLoaderPlugin(),
    ]
  }
};