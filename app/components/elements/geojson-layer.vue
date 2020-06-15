<template>
  <l-geo-json :geojson="geojson" :options="options" />
</template>

<script>
export default {
  name: 'GeoJsonLayer',

  props: {
    enableTooltip: {
      type: Boolean,
      required: true,
      default: true
    },
    geojson: {
      type: Object,
      required: true,
      default () { return null }
    }
  },

  computed: {
    options () {
      return {
        onEachFeature: this.onEachFeature
      }
    },

    onEachFeature () {
      if (!this.enableTooltip) {
        return () => {}
      }

      return (feature, layer) => {
        layer.bindTooltip(
          feature.properties.water_name,
          {
            permanent: false,
            sticky: true
          }
        )
      }
    }
  }
}
</script>

<style>
</style>
