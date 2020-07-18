const { db } = require('../../db')
const { parseOrder } = require('../../utils/sqlqs.js')
/* 
schema and logic for route:
/species/:id/fish-entries

This logic is almost exactly the same as in routes/fishable-waters/fish-entries
there is probably a better way to abstract this logic? The easiest,
method might be to extract the handler and add it to a "handlers" file?
*/

// declare schema
// define params
const params = {
  type: 'object',
  properties: {
    id: { type: 'string' }
  }
}

// define querystring
const querystring = {
  type: 'object',
  properties: {
    page: { type: 'integer' },
    per_page: { type: 'integer' },
    order: { type: ['string', 'array'] }
  }
}

// define response
const fishEntryResponse = {
  type: 'object',
  properties: {
    id: { type: 'string' },
    species_id: { type: 'string' },
    species: { type: 'string' },
    water_id: { type: 'string' },
    water_name: { type: 'string' },
    date_caught: { type: 'string' },
    pounds: { type: 'integer' },
    ounces: { type: 'integer' },
    fish_weight: { type: 'integer' },
    fish_length: { type: 'number' },
    angler_name: { type: 'string' },
    angler_state: { type: 'string' },
    trophy_classification: { type: 'string' }
  }
}

const response = {
  200: {
    type: 'object',
    properties: {
      totalRecords: { type: 'integer' },
      data: {
        type: 'array',
        items: fishEntryResponse
      }
    }
  }
}

const schema = {
  params,
  querystring,
  response
}

// define route handler
async function getFishEntries({ query, params }, reply) {
  // format pagination params
  const limit = query.per_page || 25
  const offset = query.page ? (query.page - 1) * limit : 0

  // construct params object for repo/services
  // manually constructing the filter b/c fish_id is 
  // in the params instead of the query
  const queryParams = {
    filters: [{
      column: 'species_id',
      operator: '=',
      criteria: params.id
    }],
    order: parseOrder(query.order),
    pagination: { limit, offset }
  }

  return db.fishEntries.getAll(queryParams)
}

module.exports = {
  schema,
  handler: getFishEntries
}