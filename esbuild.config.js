const esbuild = require('esbuild')
const watch = process.argv.includes('--watch')
const {sassPlugin} = require('esbuild-sass-plugin')

const config = {
  entryPoints: ["./app/javascript/application.js"],
  outdir: "./app/assets/builds",
  bundle: true,
  allowOverwrite: true,
  plugins: [sassPlugin({
    loadPaths: ['./node_modules']
  })],
  sourcemap: true,
  publicPath: 'assets',
  loader: {
    '.woff': 'file',
    '.woff2': 'file',
  },
}

if (watch) {
  esbuild.context(config).then((context) => {
    context.watch()
  })
} else {
  esbuild.build(config)
}
