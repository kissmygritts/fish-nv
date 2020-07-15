const { db } = require('../../db')

// declare schema
const response = {
  200: {
    type: 'array',
    items: {
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
}

const schema = {
  response
}

// handler
async function getSpecies () {
  return db.species.getAll()
}

module.exports = {
  schema,
  handler: getSpecies
}
