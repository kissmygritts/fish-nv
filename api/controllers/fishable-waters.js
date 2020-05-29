const { db } = require('../db')

async function getFishableWaters () {
  return db.fishableWaters.getAll()
}

module.exports = {
  getFishableWaters
}
