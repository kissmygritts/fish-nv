const sql = require('../sql').fishableWaters

class FishableWatersRepository {
  constructor(db, pgp) {
    this.db = db
    this.pgp = pgp
  }

  async getAll() {
    return this.db.manyOrNone(sql.getAll)
  }

  async getById(id) {
    return this.db.oneOrNone(sql.getById, id)
  }

  async search({ s }) {
    const frmt = this.pgp.as.format(sql.search, { s })
    console.log(JSON.stringify({
      s,
      frmt
    }))

    return this.db.manyOrNone(frmt)
  }

  async getWaterRecords ({ id }) {
    return this.db.manyOrNone(sql.waterRecords, { id })
  }
}

module.exports = FishableWatersRepository
