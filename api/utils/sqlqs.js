// parse filter params
const safeText = text => text.replace(/'/g, "''")

const wrapText = text => `'` + text + `'`

const formatValue = value => {
  return isNaN(value) ? wrapText(safeText(value)) : Number(value)
}

// this function is doing more than one thing, think about simplifying it
const formatArray = values => {
  if (values instanceof Array) {
    return '(' + values.map(formatValue).join() + ')'
  }
  return values === undefined ? '' : formatValue(values)
}

const hasOperator = value => value.includes('.')

const hasMany = value => value.includes(',')

const getCriteria = criteria => {
  let c = hasOperator(criteria) ? criteria.split('.')[1] : criteria
  return hasMany(c) ? c.split(',') : c
}

const getOperator = criteria => {
  return hasOperator(criteria) ? operators[criteria.split('.')[0]] : hasMany(criteria) ? 'IN' : '='
}

const operators = {
  eq: '=',
  gte: '>=',
  gt: '>',
  lte: '<=',
  lt: '<',
  neq: '!=',
  in: 'IN',
  ilike: 'ilike',
  like: 'like'
}

const parse = query => {
  return Object.keys(query).map(m => ({
    column: m,
    operator: getOperator(query[m]),
    criteria: getCriteria(query[m])
  }))
}

const sqlize = parsed => {
  return parsed
    .map(m => `${m.column} ${m.operator} ${formatArray(m.criteria)}`)
    .join(' and ')
}

const where = query => sqlize(parse(query))

// parse order params
function splitOrderString(str) {
  const split = str.split('.')
  return {
    field: split[1],
    type: split[0]
  }
}

function parseOrderString(str) {
  return str.includes('.')
    ? splitOrderString(str)
    : { field: str, type: 'asc' }
}

function parseOrder(order) {
  return order
    ? Array.isArray(order)
      ? order.map(parseOrderString)
      : [parseOrderString(order)]
    : []
}

module.exports = {
  parse,
  sqlize,
  where,
  parseOrder
}
