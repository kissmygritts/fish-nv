<template>
  <l-geo-json ref="geojson" :geojson="geojson" :options="options" :visible="visible" />
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
    filterIds: {
      type: Array,
      required: false,
      default () { return [] }
    },
    geojson: {
      type: Object,
      required: true,
      default () { return null }
    },
    visible: {
      type: Boolean,
      required: true,
      default: true
    }
  },

  computed: {
    options () {
      return {
        onEachFeature: this.onEachFeature,
        filter: this.filter
      }
    },

    filter () {
      return (feature) => {
        if (this.filterIds.length === 0) {
          /* eslint-disable-next-line */
          return true
        }
        /* eslint-disable-next-line */
        return this.filterIds.includes[feature.properties.id]
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

        // add event
        layer.on('click', (e) => {
          this.$emit('click:feature', { ...feature.properties })
        })
      }
    }
  }
}
</script>

<style>
</style>
