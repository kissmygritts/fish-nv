const { db } = require('../db')
const sql = require('../db/sql').geojson

const schema = {
  description: 'Return table as GeoJSON',
  params: {
    table: {
      type: 'string',
      description: 'The name of the table of view'
    }
  }
}

async function geojsonHandler (req, reply) {
  return db.oneOrNone(sql.getGeoJson)
}

module.exports = function(fastify, opt, next) {
  fastify.get('/geojson/:table', { schema: schema }, geojsonHandler)
  next()
}