const fastify = require('fastify')({ logger: true })
const routes = require('./routes/fishable-waters')

// register fastify middleware
fastify.register(require('fastify-cors'), {
  origin: '*'
})

// register routes
routes.forEach((route) => {
  fastify.route(route)
})

const start = async () => {
  try {
    await fastify.listen({ port: 8000, host: '0.0.0.0' })
    fastify.log.info(`server listening on ${fastify.server.address().port}`)
  } catch (err) {
    fastify.log.error(err)
    process.exit(1)
  }
}

start()