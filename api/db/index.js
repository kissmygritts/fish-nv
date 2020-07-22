const promise = require('bluebird')
const pgPromise = require('pg-promise')
const dbConfig = require('./db-config.json')
const sql = require('./sql')
const {
  FishableWaters,
  FishEntries,
  Spatial,
  Species
} = require('./repos')

const conn = process.env.DBURI || dbConfig
const initOptions = {
  promiseLib: promise,

  extend(obj, dc) {
    obj.fishableWaters = new FishableWaters(obj, pgp)
    obj.fishEntries = new FishEntries(obj, pgp)
    obj.spatial = new Spatial(obj, pgp)
    obj.species = new Species(obj, pgp)
  }
}

const pgp = pgPromise(initOptions)
const db = pgp(conn)

module.exports = { db, pgp, sql }
