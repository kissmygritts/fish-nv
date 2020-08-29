const path = require('path')
const fastify = require('fastify')({ logger: true })
const autoload = require('fastify-autoload')
const routes = require('./routes/fishable-waters')

// fastify cors
fastify.register(require('fastify-cors'), {
  origin: '*'
})

// compression
fastify.register(require('fastify-compress'), {
  customTypes: /^text\/|\+json$|\+text$|\+xml|x-protobuf$/,
  encodings: ['gzip', 'deflate']
})


// register routes
fastify.register(autoload, {
  dir: path.join(__dirname, 'routes')
})

// server startup function
const start = async () => {
  try {
    // from the docs, listen on 0.0.0.0 when deploying to containers, etc.
    await fastify.listen({
      port: process.env.PORT || 8000,
      host: process.env.HOST || '0.0.0.0'
    })
  } catch (err) {
    fastify.log.error(err)
    process.exit(1)
  }
}

start()