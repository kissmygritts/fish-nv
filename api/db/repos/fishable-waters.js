const sql = require('../sql').fishableWaters

class FishableWatersRepository {
  constructor(db, pgp) {
    this.db = db
    this.pgp = pgp
  }

  async getAll() {
    return this.db.any(sql.getAll)
  }
}

module.exports = FishableWatersRepository
