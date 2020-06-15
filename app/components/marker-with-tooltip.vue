<template>
  <l-marker :lat-lng="latLng" :color="color" @click="clicker(fishableWaterId)">
    <l-tooltip><slot>tooltip content</slot></l-tooltip>
  </l-marker>
</template>

<script>
export default {
  name: 'MarkerWithTooltip',

  props: {
    fishableWaterId: {
      type: String,
      require: true,
      default: ''
    },
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
  },

  methods: {
    clicker (fishableWaterId) {
      this.$router.push({
        path: `/fishable-waters/${fishableWaterId}`
      })
    }
  }
}
</script>

<style>

</style>
