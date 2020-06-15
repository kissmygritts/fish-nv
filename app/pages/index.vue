<template>
  <div id="map" class="w-full">
    <l-map :center="center" :zoom="zoom">
      <l-tile-layer :url="url" />
      <geo-json-layer :geojson="fishableWaters.geojson" :enable-tooltip="true" />
    </l-map>
  </div>
</template>

<script>
import GeoJsonLayer from '@/components/elements/geojson-layer.vue'
// import Basemap from '@/components/basemap.vue'

export default {
  components: { GeoJsonLayer },

  async asyncData ({ $axios }) {
    const res = await $axios.get('/api/geojson/fishable_waters?columns=water_name,id')

    return {
      fishableWaters: res.data
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

<style>
/* Sample `apply` at-rules with Tailwind CSS
.container {
  @apply min-h-screen flex justify-center items-center text-center mx-auto;
}
*/
#map {
  height: 100vh;
}
</style>
