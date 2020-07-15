const sql = require('../sql').species

class SpeciesRepository {
  constructor(db, pgp) {
    this.db = db
    this.pgp = pgp
  }

  async getAll () {
    return this.db.manyOrNone(sql.getAll)
  }

  async getById ({ id }) {
    return this.db.oneOrNone(sql.getById, { id })
  }

  async getWaterBodies ({ id }) {
    return this.db.one(sql.getWaterBodies, { id })
  }
}

module.exports = SpeciesRepository
