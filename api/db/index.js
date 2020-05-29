const promise = require('bluebird')
const pgPromise = require('pg-promise')
const dbConfig = require('./db-config.json')
const { FishableWaters } = require('./repos')

const initOptions = {
  promiseLib: promise,

  extend(obj, dc) {
    obj.fishableWaters = new FishableWaters(obj, pgp)
  }
}

const pgp = pgPromise(initOptions)
const db = pgp(dbConfig)

module.exports = { db, pgp }