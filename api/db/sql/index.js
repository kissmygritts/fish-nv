const { QueryFile } = require('pg-promise')
const path = require('path')

module.exports = {
  fishableWaters: {
    getAll: sql('fishable-waters/get-all.sql'),
    getById: sql('fishable-waters/get-by-id.sql'),
    search: sql('fishable-waters/search.sql'),
    waterRecords: sql('fishable-waters/water-records.sql')
  },
  fishEntries: {
    getAll: sql('fish-entries/get-all.sql'),
    count: sql('fish-entries/count.sql')
  },
  spatial: {
    getGeobuf: sql('spatial/geobuf.sql'),
    getGeoJSON: sql('spatial/geojson.sql')
  },
  species: {
    getAll: sql('species/get-all.sql'),
    getById: sql('species/get-by-id.sql'),
    getWaterBodies: sql('species/water-bodies.sql')
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