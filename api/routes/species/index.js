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
const {
  schema: getWaterBodiesSchema,
  handler: getWaterBodiesHandler
} = require('./water-bodies.js')

module.exports = function (fastify, opts, next) {
  // route registration
  fastify.get('/species', { schema: getAllSchema }, getAllHandler)
  fastify.get('/species/:id', { schema: getByIdSchema}, getByIdHandler)
  fastify.get('/species/:id/fish-entries', { schema: getFishEntriesSchema}, getFishEntriesHandler)
  fastify.get('/species/:id/water-bodies', { schema: getWaterBodiesSchema }, getWaterBodiesHandler)

  next()
}

module.exports.prefixOverride = ''
