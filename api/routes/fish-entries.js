const { db } = require('../db')
const { parse } = require('../utils/sqlqs.js')
const { pickDefined } = require('../utils/pick.js')

// declare route schema
// define the querystring schema
const querystring = {
  type: 'object',
  properties: {
    water_id: { type: 'string' },
    angler_name: { type: 'string' },
    // species: { type: 'string' },
    page: { type: 'integer' },
    per_page: { type: 'integer' },
    order: { type: ['string', 'array'] }
  }
}

const schema = {
  querystring
}

async function getFishEntries (request, reply) {
  const { query } = request
  query.water_id = request.params.id
  
  console.log(JSON.stringify({ query }))

  // parse query into parts
  // 1. query parameters
  const filters = pickDefined(query, ['water_id', 'angler_name'])
  
  // const where = Object.keys(filters).length > 0 ? parse(filters) : []

  // 2. pagination
  const limit = query.per_page || 25
  const offset = query.page ? (query.page - 1) * limit : 0
  const pagination = { limit, offset }
  
  // 3. order
  const order = parseOrder(query.order)
  
  const params = {
    filters: parse(filters),
    order,
    pagination
  }
  
  console.log(JSON.stringify({ params }))
  return db.fishEntries.getAll(params)
  // return params
}

// register routes
module.exports = function (fastify, opt, next) {
  fastify.get('/fishable-waters/:id/fish-entries', { schema }, getFishEntries)
  next()
}

// functions to parse order portion of querystring
function splitOrderString (str) {
  const split = str.split('.')
  return {
    field: split[1],
    type: split[0]
  }
}

function parseOrderString (str) {
  return str.includes('.')
    ? splitOrderString(str)
    : { field: str, type: 'asc' }
}

function parseOrder (order) {
  return order
    ? Array.isArray(order)
      ? order.map(parseOrderString)
        : [ parseOrderString(order) ]
      : []
}