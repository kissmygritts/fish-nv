const sql = require('../sql').spatial

class SpatialRepository {
  constructor(db, pgp) {
    this.db = db
    this.pgp = pgp
  }

  async getGeojson(params) {
    console.log(params)
    return params
  }
}

module.exports = SpatialRepository