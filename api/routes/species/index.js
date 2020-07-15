const {
  schema: getAllSchema,
  handler: getAllHandler
} = require('./species.js')
const {
  schema: getByIdSchema,
  handler: getByIdHandler
} = require('./species-id.js')
const {
  schema: getFishEntriesSchema,
  handler: getFishEntriesHandler
} = require('./fish-entries.js')

module.exports = function (fastify, opts, next) {
  // route registration
  fastify.get('/species', { schema: getAllSchema }, getAllHandler)
  fastify.get('/species/:id', { schema: getByIdSchema}, getByIdHandler)
  fastify.get('/species/:id/fish-entries', { schema: getFishEntriesSchema}, getFishEntriesHandler)

  next()
}
