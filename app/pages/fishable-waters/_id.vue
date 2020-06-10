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

    <!-- map of the fishable water -->
    <div id="map" class="w-full">
      <geo-json-map
        :geojson="parsedGeoJson"
        class="w-full"
      />
    </div>

    <!-- water records -->
    <div class="bg-gray-100 text-gray-700">
      <div class="w-100 pt-12 container px-5 py-12 mx-auto">
        <h2 class="text-lg tracking-wide font-light text-left md:text-center">
          Water Records
        </h2>
        <stat-container
          :water-records="getWaterRecords"
          class="pt-10 pb-5"
        />
      </div>
    </div>

    <div class="w-100 text-center pt-16">
      <h2 class="text-lg tracking-wide font-light text-left md:text-center">
        All Fish Entries
      </h2>

      <simple-table
        :table-data="fishTable"
        class="pt-10 pb-5"
      />
    </div>
  </div>
</template>

<script>
import GeoJsonMap from '@/components/geojson-map.vue'
import SimpleTable from '@/components/elements/simple-table.vue'
import StatContainer from '@/components/elements/stat-container.vue'
import TwTag from '@/components/elements/tw-tag.vue'

export default {
  components: {
    GeoJsonMap,
    SimpleTable,
    StatContainer,
    TwTag
  },

  async asyncData ({ params, $axios }) {
    const url = `/api/fishable-waters/${params.id}`

    const res = await $axios.get(url)
    return {
      fishableWater: res.data
    }
  },

  computed: {
    getWaterRecords () {
      const fishArray = this.fishableWater.fish_entries

      const fishObj = fishArray.reduce((acc, obj) => {
        // I borrowed this function from MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/Reduce
        const key = obj.species

        if (!acc[key]) {
          acc[key] = { weight: 0 }
        }

        if (obj.fish_weight && obj.fish_weight > acc[key].weight) {
          acc[key] = obj
        }

        return acc
      }, {})

      return Object.keys(fishObj).map(m => ({
        species: m,
        weight: fishObj[m].fish_weight,
        pounds: fishObj[m].pounds,
        ounces: fishObj[m].ounces
      }))
    },

    fishTable () {
      return this.fishableWater.fish_entries
        .map(m => ({
          'angler name': m.angler_name,
          species: m.species,
          pounds: m.pounds,
          ounces: m.ounces,
          'angler city': m.angler_city,
          'angler state': m.angler_state
        }))
        .slice(0, 25)
    },

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
