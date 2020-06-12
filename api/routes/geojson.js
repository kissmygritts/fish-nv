const as = require('pg-promise/lib/formatting').as
const { db, sql } = require('../db')

const schema = {
  description: 'Return table as GeoJSON',
  params: {
    table: {
      type: 'string',
      description: 'The name of the table of view'
    }
  },
  querystring: {
    columns: {
      type: 'string',
      description: 'Columns to return as GeoJSON properties.'
    }
  }
}

async function geojsonHandler (req, reply) {
  console.log(req)

  const q = {
    ...req.params,
    columns: req.query.columns
      ? `, ${as.name(req.query.columns)}`
      :''
  }

  console.log(as.format(sql.spatial.getGeoJson, q))
  return db.oneOrNone(sql.spatial.getGeoJson, q)
}

module.exports = function(fastify, opt, next) {
  fastify.get('/geojson/:table', { schema: schema }, geojsonHandler)
  next()
}