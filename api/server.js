const path = require('path')
const fastify = require('fastify')({ logger: true })
const autoload = require('fastify-autoload')
const routes = require('./routes/fishable-waters')

// register fastify middleware
fastify.register(require('fastify-cors'), {
  origin: '*'
})

// register routes
fastify.register(autoload, {
  dir: path.join(__dirname, 'routes')
})

// server startup function
const start = async () => {
  try {
    // from the docs, listen on 0.0.0.0 when deploying to containers, etc.
    await fastify.listen({ port: 8000, host: '0.0.0.0' })
    fastify.log.info(`server listening on ${fastify.server.address().port}`)
  } catch (err) {
    fastify.log.error(err)
    process.exit(1)
  }
}

start()