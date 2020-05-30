<template>
  <client-only>
    <l-map>
      <l-tile-layer :url="url" />
      <marker-with-tooltip
        v-for="(water, index) in fishableWaters"
        :key="index"
        :lat-lng="water.coordinates"
      >
        <p>{{ water.water_name }}</p>
      </marker-with-tooltip>
    </l-map>
  </client-only>
</template>

<script>
import MarkerWithTooltip from '@/components/marker-with-tooltip.vue'

export default {
  name: 'Basemap',

  components: { MarkerWithTooltip },

  props: {
    fishableWaters: {
      type: Array,
      required: true
    }
  },

  data () {
    return {
      url: 'https://{s}.tile.osm.org/{z}/{x}/{y}.png',
      mapPoints: [
        [47.4132, -1.2914],
        [0, 0]
      ]
    }
  }
}
</script>
