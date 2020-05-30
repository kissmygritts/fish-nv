<template>
  <l-marker :lat-lng="latLng" :color="color">
    <l-tooltip><slot>tooltip content</slot></l-tooltip>
  </l-marker>
</template>

<script>
export default {
  name: 'MarkerWithTooltip',

  props: {
    latLng: {
      type: Array,
      require: true,
      default () {
        return [0, 0]
      }
    },
    color: {
      type: String,
      default: '#6958d0'
    }
  }
}
</script>

<style>

</style>
