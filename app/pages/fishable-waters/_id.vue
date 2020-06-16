<template>
  <div class="text-gray-900">
    <header class="px-2 py-6 md:px-4 md:py-8 lg:px-8 container mx-auto">
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
    <div>
      <!-- if hasFishEntries === true -->
      <div v-if="hasFishEntries">
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

        <div class="w-100 text-center pt-16 container mx-auto">
          <h2 class="text-lg tracking-wide font-light text-left md:text-center px-5">
            All Fish Entries
          </h2>

          <simple-table
            :table-data="fishTable"
            class="pt-10 pb-5"
          />
        </div>
      </div>
      <!-- if hasFishEntreis === false -->
      <div v-else class="bg-gray-100 py-16">
        <div class="container mx-auto flex flex-wrap items-center justify-center">
          <div class="img-container">
            <img
              id="img"
              class="object-contain h-full w-full"
              src="~/assets/img/undraw_fishing_hoxa.png"
            >
          </div>
          <div class="w-4/5 px-6 text-center md:text-left md:w-1/2 lg:w-1/3 md:-ml-8 lg:ml-0">
            <h3 class="text-gray-800 text-xl tracking-wide uppercase leading-loose">
              You can be first!
            </h3>
            <p class="text-gray-700">
              Fish have not been caught and reported to NDOW from {{ fishableWater.water_name }}.
              You can be the first!
            </p>
            <div class="mt-6">
              <a
                href="#"
                class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
              >
                Buy a fishing license
              </a>
            </div>
          </div>
        </div>
      </div>
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

    hasFishEntries () {
      return !!this.fishableWater.fish_entries
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

.img-container {
  width: 325px;
  height: 325px;
}

#img {
  mix-blend-mode: multiply;
}
</style>
