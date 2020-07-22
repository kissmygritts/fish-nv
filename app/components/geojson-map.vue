<template>
  <client-only>
    <l-map ref="map" @ready="setMapBounds()">
      <l-tile-layer :url="url" />
      <l-geo-json
        ref="geojson"
        :geojson="geojson"
        :options="options"
      />
    </l-map>
  </client-only>
</template>

<script>
export default {
  name: 'GeoJsonMap',

  props: {
    enableTooltip: {
      type: Boolean,
      default: false,
      required: false
    },

    geojson: {
      type: Object,
      default () {
        return null
      }
    }
  },

  data () {
    return {
      url: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager_labels_under/{z}/{x}/{y}.png'
    }
  },

  computed: {
    onEachFeature () {
      return (feature, layer) => {
        // add hover tooltip
        if (this.enableTooltip) {
          layer.bindTooltip(
            feature.properties.water_name,
            {
              permanent: false,
              sticky: true
            }
          )
        }

        // add on click navigation
        layer.on({
          click: () => {
            this.$emit('feature:click', feature.properties)
          }
        })
      }
    },

    options () {
      return {
        onEachFeature: this.onEachFeature
      }
    }
  },

  methods: {
    setMapBounds () {
      this.$refs.map.setBounds(this.$refs.geojson.getBounds(), {
        padding: [500, 500]
      })
    }
  }
}
</script>
