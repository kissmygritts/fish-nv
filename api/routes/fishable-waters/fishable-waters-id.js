const { getFishableWatersById } = require('../../controllers/fishable-waters.js')

// declare schema
const response = {
  200: {
    type: 'object',
    properties: {
      id: { type: 'string' },
      water_name: { type: 'string' },
      label: { type: 'string' },
      region: { type: 'string' },
      county: { type: 'string' },
      species: {
        type: 'array',
        items: { type: 'string' }
      },
      geojson: {
        type: 'object',
        properties: {
          type: { type: 'string' }
        },
        additionalProperties: true
      }
    }
  }
}

const schema = {
  response
}

// export route config
module.exports = {
  schema,
  handler: getFishableWatersById
}
