const { db, sql, pgp } = require('../db')

async function getFishableWaters (request, reply) {
  const { query } = request
  const res = null

  if (hasQueryString(query)) {
    const qf = sql.fishableWaters.search
    const where = pgp.as.format('WHERE water_name ilike \'%$<water_name:value>%\'', query)
    return db.manyOrNone(qf, { where })
  }

  return db.fishableWaters.getAll()
}

async function getFishableWatersById (request, reply) {
  const { id } = request.params
  console.log(id)
  return db.fishableWaters.getById({ id })
}

module.exports = {
  getFishableWaters,
  getFishableWatersById
}

function hasQueryString (query) {
  return Object.keys(query).length > 0
}