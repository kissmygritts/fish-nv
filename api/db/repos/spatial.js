const sql = require('../sql').spatial

class SpatialRepository {
  constructor(db, pgp) {
    this.db = db
    this.pgp = pgp
  }

  async getGeoJSON({ table, columns }) {
    // format columns
    const columnNames = [ 'geom', ...columns ]
      .map(this.pgp.as.name)
      .join(', ')
    
      const query = this.pgp.as.format(sql.getGeoJSON, {
      table,
      columns: columnNames
    })
    console.log(JSON.stringify({ query }))
    
    return this.db.oneOrNone(sql.getGeoJSON, {
      table,
      columns: columnNames
    })
  }

  async getGeobuf () {
    const res = await this.db.any(sql.getGeobuf)
    return res[0].st_asgeobuf
  }
}

module.exports = SpatialRepository
