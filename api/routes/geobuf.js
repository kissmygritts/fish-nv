const { db } = require('../db')

const schema = {}

async function geobufHandler (request, reply) {
  reply.header('Content-Type', 'application/x-protobuf')
  return db.spatial.getGeobuf()
}

module.exports = function(fastify, opt, next) {
  fastify.get('/geobuf', {}, geobufHandler)
  next()
}
