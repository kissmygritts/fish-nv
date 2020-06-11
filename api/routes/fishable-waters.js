const { getFishableWaters, getFishableWatersById } = require('../controllers/fishable-waters')

// declare routes
const routes = [
  // GET /fishable-waters
  {
    method: 'GET',
    url: '/fishable-waters',
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