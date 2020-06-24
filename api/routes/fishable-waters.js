const { getFishableWaters, getFishableWatersById } = require('../controllers/fishable-waters.js')

// declare routes
const routes = [
  // GET /fishable-waters
  {
    method: 'GET',
    url: '/fishable-waters',
    schema: {querystring: {
        's': {
          type: 'string',
          description: 'A search term or phrase for full text search of the fishable waters table'
        }
      }
    },
    handler: getFishableWaters
  },
  // GET /fishable-waters/:id
  {
    method: 'GET',
    url: '/fishable-waters/:id',
    handler: getFishableWatersById
  }
]

// export routes as a plugin for fastify-autoload
module.exports = function (fastify, opts, next) {
  routes.forEach((route) => {
    fastify.route(route)
  })

  next()
} 