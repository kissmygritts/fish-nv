const {
  schema: getAllSchema,
  handler: getAllHandler
} = require('./fishable-waters.js')
const {
  schema: getByIdSchema,
  handler: getByIdHandler
} = require('./fishable-waters-id.js')

module.exports = function (fastify, opts, next) {
  // Route registration
  fastify.get('/fishable-waters', { schema: getAllSchema }, getAllHandler)
  fastify.get('/fishable-waters/:id', { schema: getByIdSchema }, getByIdHandler)

  next()
}
