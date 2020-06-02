<template>
  <client-only>
    <l-map ref="map" @ready="setMapBounds()">
      <l-tile-layer :url="url" />
      <l-geo-json ref="geojson" :geojson="geojson" />
    </l-map>
  </client-only>
</template>

<script>
export default {
  name: 'GeoJsonMap',
  props: {
    geojson: {
      type: Object,
      default () {
        return null
      }
    }
  },

  data () {
    return {
      url: 'https://{s}.tile.osm.org/{z}/{x}/{y}.png'
    }
  },

  methods: {
    setMapBounds () {
      this.$refs.map.setBounds(this.$refs.geojson.getBounds())
    }
  }
}
</script>
