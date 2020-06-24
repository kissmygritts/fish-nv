const { db, sql, pgp } = require('../db')

async function getFishableWaters (request, reply) {
  const { query } = request

  if (hasQueryString(query)) {
    return db.fishableWaters.search(query)
  }

  return db.fishableWaters.getAll()
}

async function getFishableWatersById (request, reply) {
  const { id } = request.params
  return db.fishableWaters.getById({ id })
}

module.exports = {
  getFishableWaters,
  getFishableWatersById
}

function hasQueryString (query) {
  return Object.keys(query).length > 0
}