const sql = require('../sql').fishableWaters

class FishableWatersRepository {
  constructor(db, pgp) {
    this.db = db
    this.pgp = pgp
  }

  async getAll() {
    return this.db.any(sql.getAll)
  }

  async getById(id) {
    return this.db.one(sql.getById, id)
  }
}

module.exports = FishableWatersRepository
