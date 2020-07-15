const { db } = require('../../db')

/*
SCHEMA AND LOGIC FOR: /species/:id/water-bodies
*/

// declare schema
const params = {
  type: 'object',
  properties: {
    id: {
      type: 'string',
      description: 'ID of a fish species'
    }
  }
}

const response = {
  200: {
    type: 'object',
    properties: {
      type: { type: 'string' }
    },
    additionalProperties: true
  }
}

const schema = {
  params
}

// define route handler
async function getWaterBodies({ params }, reply) {
  return db.species.getWaterBodies({ id: params.id })
}

module.exports = {
  schema,
  handler: getWaterBodies
}
