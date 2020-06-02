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
    await fastify.listen(3030)
    fastify.log.info(`server listening on ${fastify.server.address().port}`)
  } catch (err) {
    fastify.log.error(err)
    process.exit(1)
  }
}

start()