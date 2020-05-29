const { getFishableWaters } = require('../controllers/fishable-waters')

const routes = [
  {
    method: 'GET',
    url: '/fishable-waters',
    handler: getFishableWaters
  }
]
// alternative route declaration
// async function routes (fastify, options) {
//   fastify.get('/', async (request, reply) => {
//     return db.fishableWaters.getAll()
//   })
// }

module.exports = routes
