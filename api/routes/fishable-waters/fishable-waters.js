const { getFishableWaters } = require('../../controllers/fishable-waters.js')

// declare schema
const querystring = {
  type: 'object',
  properties: {
    s: {
      type: 'string',
      description: 'A search term or phrase for full text search of fishable waters'
    }
  }
}

// format response output
const fishableWaterOutput = {
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
    coordinates: {
      type: 'array',
      items: { type: 'number' }
    }
  }
}

const response = {
  200: {
    type: 'array',
    items: fishableWaterOutput
  }
}

const schema = {
  querystring,
  response
}

// build export
module.exports = {
  schema,
  handler: getFishableWaters
}
