<template>
  <l-map
    ref="map"
    :center="center"
    :zoom="zoom"
    @ready="ready"
  >
    <l-tile-layer :url="url" />
    <l-geo-json
      v-if="hasGeoJson"
      ref="geojson"
      :geojson="geojson"
      :options="options"
    />
  </l-map>
</template>

<script>
/* eslint-disable */
export default {
  name: 'FishableWatersMap',

  props: {
    geojson: {
      type: Object,
      required: false,
      default () { return {} }
    }
  },

  data () {
    return {
      url: 'https://{s}.tile.osm.org/{z}/{x}/{y}.png',
      center: [38.64954285997146, -116.77592011899117],
      zoom: 6
    }
  },

  computed: {
    hasGeoJson () {
      return Object.keys(this.geojson).length > 0
    },

    onEachFeature () {
      return (feature, layer) => {
        layer.bindTooltip(
          feature.properties.water_name,
          {
            permanent: false,
            sticky: true
          }
        )
      }
    },

    options () {
      return {
        onEachFeature: this.onEachFeature
      }
    }
  },

  methods: {
    ready () {
      console.log('im fucking ready!!!!!!!!!!!!!!')
      this.$emit('ready')
    }
  }
}
</script>

<style>
#map {
  height: 100vh;
}
</style>
