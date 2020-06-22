<template>
  <div class="flex h-screen w-screen">
    <main id="map" class="bg-blue-400 flex-grow">
      <client-only>
        <fishable-waters-map
          :geojson="geojson"
          @ready="loadGeometry"
        />
      </client-only>
    </main>

    <aside class="bg-gray-100 w-1/4 flex flex-col px-8 overflow-y-auto">
      <!-- search container -->
      <search-container @selected="searchFishableWaters" />
      <!-- results -->
      <div class="w-full mt-2">
        <div v-if="hasSearchResults">
          <div
            v-for="water in search.results"
            :key="water.id"
          >
            <div
              class="flex items-center justify-between p-3 w-full bg-white border-b-2 border-gray-100 last:border-b-0 rounded-none last:border-b-full"
            >
              <div>
                <h2 class="text-gray-800 text-lg">
                  {{ water.water_name }}
                </h2>
              </div>
              <div>
                <h3 class="text-gray-500 font-light tracking-wide">
                  {{ water.label }}
                </h3>
              </div>
            </div>
          </div>
        </div>
      </div>
    </aside>
  </div>
</template>

<script>
import FishableWatersMap from '@/components/fishable-waters-map'
import SearchContainer from '@/components/search-container.vue'

export default {
  components: {
    FishableWatersMap,
    SearchContainer
  },

  data () {
    return {
      search: {
        loading: false,
        results: null,
        params: null
      },
      geometry: {
        loading: false,
        results: {}
      }
    }
  },

  computed: {
    hasGeometry () {
      // return !!this.geometry.results
      return Object.keys(this.geometry.results).length > 0
    },

    hasSearchResults () {
      return !!this.search.results
    },

    filterIds () {
      if (this.hasSearchResults) {
        return this.search.results.map(m => m.id)
      } else {
        return []
      }
    },

    geojson () {
      if (!this.hasGeometry) {
        return {}
      }

      if (!this.hasSearchResults) {
        return this.geometry.results
      }

      const features = this.geometry.results.features.filter((feature) => {
        return this.filterIds.includes(feature.properties.id)
      })
      const geojson = {
        type: 'featureCollection',
        features
      }

      return geojson
    }
  },

  methods: {
    navigateTo (feature) {
      this.$router.push({
        path: `fishable-waters/${feature.id}`
      })
    },

    async searchFishableWaters ({ params }) {
      this.search.loading = true

      // set search.params -- probably not needed
      this.search.params = params

      // if params, do the thing
      if (params.s) {
        // init query string object
        const qs = new URLSearchParams()

        qs.append('s', params.s)
        const url = `/api/fishable-waters?${qs.toString()}`

        /* eslint-disable-next-line */
        console.log(url)

        // start query to search
        const res = await this.$axios.get(url)
        this.search.results = res.data
      } else {
        // else, no params or params are null, set search results = null
        this.search.results = null
        this.search.params = null
      }

      this.search.loading = false
    },

    async loadGeometry () {
      this.geometry.loading = true
      const res = await this.$axios.get('/api/geojson/fishable_waters?columns=water_name,id')
      this.geometry.results = res.data.geojson
      this.geometry.loading = false
    }
  }

}
</script>

<style>
#map {
  height: 100vh;
}
</style>
