const { db } = require('../db')

async function getFishableWaters () {
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
