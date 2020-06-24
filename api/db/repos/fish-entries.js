const sql = require('../sql').fishEntries
const { sqlize } = require('../../utils/sqlqs.js')

class FishEntriesRepository {
  constructor(db, pgp) {
    this.db = db,
    this.pgp = pgp
  }

  async getAll({filters, order, pagination }) {
    const pgp = this.pgp

    // parameterize query
    // 1. filters: simply equals right now
    const filtersSql = Object.keys(filters).length > 0 ? `where ${sqlize(filters)}` : ''

    // 2. order: write order clause
    const orderSql = stringifyOrder(order, pgp)

    // 3. pagination: limit & offset
    const paginationSql = pgp.as.format('limit $<limit> offset $<offset>', pagination)
    
    // 4. format sql together
    const records = await this.db.manyOrNone(sql.getAll, {
      where: filtersSql,
      order: orderSql,
      pagination: paginationSql
    })
    const totalRecords = await this.db.one(sql.count, { where: filtersSql })

    return {
      data: records,
      totalRecords: Number(totalRecords.count)
    }
  }
}

module.exports = FishEntriesRepository

function stringifyOrder (order, pgp) {
  console.log(JSON.stringify({ order }))
  if (order && order.length > 0) {
    const str = order
        .map(m => pgp.as.format('$<field:name> $<type:raw>', m))
        .join(', ')
    return `order by ${str}`
  } else {
    return ''
  }
}