// example of schema and serialization

const schema = {
  method: 'GET',
  url: '/',
  // response serialization with fastify/fast-json-stringify
  response: {
    200: {
      type: 'object',
      properties: {
        msg: { type: 'string' },
        info: {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              msgType: { type: 'string' },
              msg: { type: 'string' }
            }
          }
        }
      }
    }
  }
}

async function baseHandler (req, reply) {
  return {
    msg: 'Hello from the api',
    info: [{
      msgType: 'good',
      msg: 'this is a good message'
    }, {
      msgType: 'bad',
      msg: 'this is a bad message'
    }]
  }
}

module.exports = function (fastify, opts, next) {
  fastify.get('/', { schema: schema }, baseHandler)

  next()
}