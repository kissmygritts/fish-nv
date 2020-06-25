const { db } = require('../db')

// declare schema
const params = {
  id: { type: 'string' }
}

const waterRecordSchema = {
  type: 'object',
  properties: {
    id: { type: 'string' },
    water_id: { type: 'string' },
    species: { type: 'string' },
    fish_weight: { type: 'integer' },
    pounds: { type: 'integer' },
    ounces: { type: 'integer' }
  }
}

const response = {
  200: {
    type: 'array',
    items: waterRecordSchema
  }
}

const schema = { 
  params,
  response
}

// route logic
async function getWaterRecords (request, reply) {
  const { id } = request.params

  return db.fishableWaters.getWaterRecords({ id })
}

// register route
module.exports = function (fastify, opt, next) {
  fastify.get('/fishable-waters/:id/water-records', { schema }, getWaterRecords)
  next()
}
