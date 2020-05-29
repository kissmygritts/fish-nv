const { QueryFile } = require('pg-promise')
const path = require('path')

module.exports = {
  fishableWaters: {
    getAll: sql('fishable-waters/get-all.sql'),
    getById: sql('fishable-waters/get-by-id.sql')
  }
}

function sql(file) {
  const fullPath = path.join(__dirname, file)

  const qf = new QueryFile(fullPath, {
    minify: true
  })

  if (qf.error) {
    console.error(qf.error)
  }

  return qf
}