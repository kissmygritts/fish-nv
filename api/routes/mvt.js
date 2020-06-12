const { db } = require('../db')

/*
From: @tobinbradley: tobinbradley/dirt-simple-postgis-http-api
https://github.com/tobinbradley/dirt-simple-postgis-http-api/blob/master/routes/mvt.js
*/
// route query
const sql = (params, query) => {
  return `
    WITH mvtgeom as (
      SELECT
        ST_AsMVTGeom (
          ST_Transform(${query.geom_column}, 3857),
          ST_TileEnvelope(${params.z}, ${params.x}, ${params.y})
        ) as geom
        ${query.columns ? `, ${query.columns}` : ''}
        ${query.id_column ? `, ${query.id_column}` : ''}
      FROM
        ${params.table},
        (SELECT ST_SRID(${query.geom_column}) AS srid FROM ${
    params.table
    } LIMIT 1) a
      WHERE
        ST_Intersects(
          geom,
          ST_Transform(
            ST_TileEnvelope(${params.z}, ${params.x}, ${params.y}),
            srid
          )
        )

        -- Optional Filter
        ${query.filter ? ` AND ${query.filter}` : ''}
    )
    SELECT ST_AsMVT(mvtgeom.*, '${params.table}', 4096, 'geom' ${
    query.id_column ? `, '${query.id_column}'` : ''
    }) AS mvt from mvtgeom;
  `
}

// route schema
const schema = {
  description:
    'Return table as Mapbox Vector Tile (MVT). The layer name returned is the name of the table.',
  tags: ['feature'],
  summary: 'return MVT',
  params: {
    table: {
      type: 'string',
      description: 'The name of the table or view.'
    },
    z: {
      type: 'integer',
      description: 'Z value of ZXY tile.'
    },
    x: {
      type: 'integer',
      description: 'X value of ZXY tile.'
    },
    y: {
      type: 'integer',
      description: 'Y value of ZXY tile.'
    }
  },
  querystring: {
    geom_column: {
      type: 'string',
      description: 'Optional geometry column of the table. The default is geom.',
      default: 'geom'
    },
    columns: {
      type: 'string',
      description:
        'Optional columns to return with MVT. The default is no columns.'
    },
    id_column: {
      type: 'string',
      description:
        'Optional id column name to be used with Mapbox GL Feature State. This column must be an integer a string cast as an integer.'
    },
    filter: {
      type: 'string',
      description: 'Optional filter parameters for a SQL WHERE statement.'
    }
  }
}

async function handleMVT (req, reply) {
  const q = sql(req.params, req.query)
  console.log(q)
  
  const res = await db.any(q)
  console.log(res)

  reply
    .header('Content-Type', 'application/x-protobuf')
    .send(res[0].mvt)
}

// create route
module.exports = function (fastify, opts, next) {
  fastify.route({
    method: 'GET',
    url: '/mvt/:table/:z/:x/:y',
    schema: schema,
    handler: handleMVT
  })
  next()
}
