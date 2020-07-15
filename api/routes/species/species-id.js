const { db } = require('../../db')

// declare schema
const params = {
  type: 'object',
  properties: {
    table: {
      type: 'string',
      description: 'ID of the fish species'
    }
  }
}

const response = {
  200: {
    type: 'object',
    properties: {
      id: { type: 'string' },
      species: { type: 'string' },
      abbr: { type: 'string' },
      scientific_name: { type: 'string' },
      min_trophy_weight: { type: 'number' },
      description: { type: 'string' },
      other_names: { type: 'string' }
    }
  }
}

const schema = {
  params,
  response
}

// handler
async function getSpeciesById ({ params }) {
  return db.species.getById({ id: params.id })
}

module.exports = {
  schema,
  handler: getSpeciesById
}
