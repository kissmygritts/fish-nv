const as = require('pg-promise/lib/formatting').as
const { db, sql } = require('../db')

// declare route schema
const params = {
  type: 'object',
  properties: {
    table: {
      type: 'string',
      description: 'The name of the table to return as GeoJSON'
    }
  }
}

const querystring = {
  type: 'object',
  properties: {
    columns: {
      type: 'string',
      description: 'Columns to return as properties for the GeoJSON'
    }
  }
}

const response = {
  200: {
    type: 'object',
    properties: {
      type: { type: 'string' }
    },
    // additional props aren't validated by fastify
    // TODO: add additional props: features, geometry, coordinates...
    additionalProperties: true
  }
}

const schema = {
  description: 'Return table as GeoJSON',
  params,
  querystring,
  response
}

// route logic (business logic?)
async function geojsonHandler ({ params, query }, reply) {
  // format columns as an array
  const columns = query.columns
    ? query.columns.split(',')
    : []
  
  const queryParams = {
    table: params.table,
    columns
  }

  return db.spatial.getGeoJSON(queryParams)
}

module.exports = function(fastify, opt, next) {
  fastify.get('/geojson/:table', { schema: schema }, geojsonHandler)
  next()
}
