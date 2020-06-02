<template>
  <div class="text-gray-900">
    <header class="px-2 py-6 md:px-4 md:py-8 lg:px-8">
      <h1 class="text-4xl leading-loose">
        {{ fishableWater.water_name }}
        <span class="text-2xl font-thin tracking-wide text-gray-600 pl-2">
          {{ fishableWater.label }}
        </span>
      </h1>
      <div>
        <tw-tag
          v-for="(tag, index) in tags"
          :key="index"
          :text="tag"
          class="mr-2 rounded capitalize"
        />
      </div>
    </header>

    <div id="map" class="w-full">
      <geo-json-map
        :geojson="parsedGeoJson"
        class="w-full"
      />
    </div>

    <div class="bg-gray-100 text-gray-700">
      <div class="w-100 pt-12 container px-5 py-12 mx-auto">
        <h2 class="text-lg tracking-wide font-light text-left md:text-center">
          Water Records
        </h2>
        <stat-container class="pt-10 pb-5" />
      </div>
    </div>

    <div class="w-100 text-center pt-16">
      TABLE FOR RECORDS FROM WATER
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import GeoJsonMap from '@/components/geojson-map.vue'
import StatContainer from '@/components/elements/stat-container.vue'
import TwTag from '@/components/elements/tw-tag.vue'

export default {
  components: {
    GeoJsonMap,
    StatContainer,
    TwTag
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
    },

    tags () {
      return [
        `${this.fishableWater.region} region`,
        `${this.fishableWater.county} county`,
        ...this.fishableWater.species
      ]
    }
  }
}
</script>

<style scoped>
#map {
  height: 50vh;
}
</style>
