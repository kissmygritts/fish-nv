const pick = (o, props) => {
  return Object.assign(
    {},
    ...props.map(prop => ({ [prop]: o[prop] }))
  )
}

const pickDefined = (o, props) => {
  return Object.assign(
    {},
    ...props.map(prop => {
      if (o[prop]) {
        return { [prop]: o[prop] }
      }
    })
  )
}

module.exports = {
  pick,
  pickDefined
}
