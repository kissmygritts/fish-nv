const { getFishableWaters, getFishableWatersById } = require('../controllers/fishable-waters')

const routes = [
  {
    method: 'GET',
    url: '/fishable-waters',
    handler: getFishableWaters
  }, {
    method: 'GET',
    url: '/fishable-waters/:id',
    handler: getFishableWatersById
  }
]
// alternative route declaration
// async function routes (fastify, options) {
//   fastify.get('/', async (request, reply) => {
//     return db.fishableWaters.getAll()
//   })
// }

module.exports = routes
