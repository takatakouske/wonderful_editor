const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)

environment.loaders.append('fonts', {
  test: /\.(woff2?|eot|ttf|otf|svg)$/i,
  use: [
    {
      loader: 'file-loader',
      options: {
        name: '[name]-[hash].[ext]',
        outputPath: 'fonts/',
        publicPath: '/packs/fonts/'
      }
    }
  ]
})

module.exports = environment
