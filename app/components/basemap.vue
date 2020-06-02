<template>
  <client-only>
    <l-map :center="center" :zoom="zoom">
      <l-tile-layer :url="url" />
      <marker-with-tooltip
        v-for="(water, index) in fishableWaters"
        :key="index"
        :fishable-water-id="water.id"
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
      center: [38.64954285997146, -116.77592011899117],
      zoom: 6
    }
  }
}
</script>
