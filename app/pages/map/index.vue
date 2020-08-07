<template>
  <div class="flex flex-col lg:flex-row text-gray-700 h-full">
    <!-- map container -->
    <main class="flex-1 w-full">
      <client-only>
        <fishable-waters-map
          :geojson="geojson"
          @ready="loadGeometry"
        />
      </client-only>
    </main>

    <aside class="hidden lg:block bg-gray-100 lg:w-1/3 xl:w-1/4 flex flex-col px-4 overflow-y-auto">
      <!-- search container -->
      <search-container @selected="searchFishableWaters" />
      <!-- results -->
      <div class="w-full mt-2 mb-4">
        <div v-if="hasSearchResults">
          <p class="p-2 text-lg">
            Found {{ search.results.length }} Fishable Waters
          </p>
          <div
            v-for="water in search.results"
            :key="water.id"
          >
            <nuxt-link :to="{ name: 'fishable-waters-id', params: { id: water.id } }" prefetch>
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
            </nuxt-link>
          </div>
        </div>
      </div>

      <footer class="text-center mt-auto mb-2">
        <nuxt-link to="/" class="text-gray-800 hover:text-blue-500">
          Fish NV Home
        </nuxt-link>
      </footer>
    </aside>

    <!-- mobile menu buttons -->
    <div class="lg:hidden h-16 bg-green-500 w-100 inline-flex">
      <button
        class="w-1/3 relative inline-flex items-center justify-center border border-gray-300 bg-white text-sm"
        @click="showMap"
      >
        Map
      </button>
      <button
        class="w-1/3 relative inline-flex items-center justify-center border border-gray-300 bg-white text-sm"
        @click="toggleWatersPanel"
      >
        Waters
      </button>
      <button
        class="w-1/3 relative inline-flex items-center justify-center border border-gray-300 bg-white text-sm"
        @click="toggleFiltersPanel"
      >
        Filters
      </button>
    </div>

    <!-- overlay panel -->
    <client-only>
      <transition name="fade">
        <div
          v-if="watersPanelVisible"
          class="lg:hidden overlay-panel bg-gray-100 overflow-y-scroll"
        >
          <div class="w-full mt-2 mb-4">
            <div v-if="hasSearchResults">
              <p class="p-2 text-lg">
                Found {{ search.results.length }} Fishable Waters
              </p>
              <div
                v-for="water in search.results"
                :key="water.id"
              >
                <nuxt-link :to="{ name: 'fishable-waters-id', params: { id: water.id } }" prefetch>
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
                </nuxt-link>
              </div>
            </div>
          </div>
        </div>
      </transition>
    </client-only>

    <client-only>
      <transition name="fade">
        <div
          v-if="filtersPanelVisible"
          class="lg:hidden overlay-panel bg-gray-100 p-4 md:p-8"
        >
          <search-container @selected="searchFishableWaters" />
        </div>
      </transition>
    </client-only>
  </div>
</template>

<script>
import geobuf from 'geobuf'
import Pbf from 'pbf'
import FishableWatersMap from '@/components/fishable-waters-map.vue'
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
      },
      watersPanelVisible: false,
      filtersPanelVisible: false
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

  mounted () {
    this.searchFishableWaters({ params: { s: null } })
  },

  methods: {
    toggleWatersPanel () {
      this.watersPanelVisible = !this.watersPanelVisible
      this.filtersPanelVisible = false
    },

    toggleFiltersPanel () {
      this.filtersPanelVisible = !this.filtersPanelVisible
      this.watersPanelVisible = false
    },

    showMap () {
      this.watersPanelVisible = false
      this.filtersPanelVisible = false
    },

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
        // else, no params or params are null, return all results
        const res = await this.$axios.get('/api/fishable-waters')

        this.search.results = res.data
        this.search.params = null
      }

      this.search.loading = false
    },

    async loadGeometry () {
      this.geometry.loading = true

      const res = await this.$axios.get('/api/geobuf', {
        responseType: 'arraybuffer'
      })
      const geojson = geobuf.decode(new Pbf(res.data))

      this.geometry.results = geojson
      this.geometry.loading = false
    }
  }

}
</script>

<style>
#map {
  flex: 1 0 auto;
  min-height: auto;
}

.overlay-panel {
  position: absolute;
  height: calc(100% - 4rem);
  width: 100%;
  top: 0;
  left: 0;
  z-index: 1001;
}

.fade-enter-active {
  transition: opacity .1s;
}

.fade-leave-active {
  transition: opacity .2s;
}

.fade-enter, .fade-leave-to {
  opacity: 0;
}
</style>
