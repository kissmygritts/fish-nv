/* eslint-disable */
<template>
  <client-only>
    <l-map ref="map" :center="center" :zoom="zoom" @ready="setMapBounds()">
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
      url: 'https://{s}.tile.osm.org/{z}/{x}/{y}.png',
      center: [38.64954285997146, -116.77592011899117],
      zoom: 6
    }
  },

  methods: {
    setMapBounds () {
      this.$refs.map.setBounds(this.$refs.geojson.getBounds())
    }
  }
}
</script>
