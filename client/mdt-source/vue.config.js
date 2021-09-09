const path = require("path");
module.exports = {
  transpileDependencies: [
    'vuetify'
  ],
  filenameHashing: false,
  productionSourceMap: false,
  publicPath: './',
  outputDir: path.resolve(__dirname, "../html"),
  //assetsDir: "../../static/SPA"
}
