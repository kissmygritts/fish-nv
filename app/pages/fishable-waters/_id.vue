<template>
  <div class="text-gray-900">
    <header class="px-2 py-6 md:px-4 md:py-8 lg:px-8">
      <h1 class="text-4xl">
        {{ fishableWater.water_name }}
      </h1>
    </header>

    <div class="flex flex-wrap w-100">
      <div id="map" class="w-full lg:w-3/5 bg-blue-400">
        <geo-json-map :geojson="parsedGeoJson" />
      </div>
      <div class="w-full lg:w-2/5 bg-green-400 py-8 px-6">
        <table class="text-xl table-auto min-w-full">
          <tr>
            <td class="font-bold tracking-wide">
              Name
            </td>
            <td class="py-1">
              {{ fishableWater.water_name }}
            </td>
          </tr>
          <tr>
            <td class="font-bold tracking-wide">
              Label
            </td>
            <td class="py-1">
              {{ fishableWater.label }}
            </td>
          </tr>
          <tr>
            <td class="font-bold tracking-wide">
              Region
            </td>
            <td class="py-1">
              {{ fishableWater.region }}
            </td>
          </tr>
          <tr>
            <td class="font-bold tracking-wide">
              County
            </td>
            <td class="py-1">
              {{ fishableWater.county }}
            </td>
          </tr>
          <tr>
            <td class="font-bold tracking-wide">
              Species
            </td>
            <td class="py-1">
              {{ fishableWater.species.join(', ') }}
            </td>
          </tr>
        </table>
      </div>
    </div>

    <div class="w-100 text-center pt-16">
      LEVEL FOR RECORDS
    </div>

    <div class="w-100 text-center pt-16">
      TABLE FOR RECORDS FROM WATER
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import GeoJsonMap from '@/components/geojson-map.vue'

export default {
  components: {
    GeoJsonMap
  },

  async asyncData ({ params }) {
    const url = `http://localhost:3030/fishable-waters/${params.id}`
    const res = await axios.get(url)
    return {
      fishableWater: res.data
    }
  },

  computed: {
    parsedGeoJson () {
      return JSON.parse(this.fishableWater.geojson)
    }
  }
}
</script>

<style scoped>
#map {
  height: 400px;
}
</style>
