<template>
  <div class="flex h-screen w-screen">
    <main id="map" class="bg-blue-400 flex-grow">
      <client-only>
        <l-map ref="map" :center="center" :zoom="zoom" @ready="renderGeometry()">
          <l-tile-layer :url="url" />
          <!-- <geo-json-layer
            v-if="hasGeometry"
            ref="geojsonContainer"
            :geojson="geometry.results"
            :filter-ids="filterIds"
            :enable-tooltip="true"
            :visible="geometry.visible"
            @click:feature="navigateTo"
          /> -->
        </l-map>
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
// import L from 'leaflet'
// import GeoJsonLayer from '@/components/elements/geojson-layer.vue'
import SearchContainer from '@/components/search-container.vue'

export default {
  components: {
    // GeoJsonLayer,
    SearchContainer
  },

  data () {
    return {
      url: 'https://{s}.tile.osm.org/{z}/{x}/{y}.png',
      center: [38.64954285997146, -116.77592011899117],
      zoom: 6,
      search: {
        loading: false,
        results: null,
        params: null
      },
      geometry: {
        visible: true,
        loading: false,
        results: null
      }
    }
  },

  computed: {
    hasGeometry () {
      return !!this.geometry.results
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
    }
  },

  updated () {
    /* eslint-disable-next-line */
    console.log('INDEX.VUE updated')
    /* eslint-disable-next-line */
    console.log(this.$refs)
  },

  methods: {
    navigateTo (feature) {
      this.$router.push({
        path: `fishable-waters/${feature.id}`
      })
    },

    async searchFishableWaters ({ params }) {
      // set search.params -- probably not needed
      this.search.params = params

      // construct the query
      const qs = new URLSearchParams()
      if (params.s) {
        qs.append('s', params.s)
      }
      const url = `/api/fishable-waters?${qs.toString()}`

      /* eslint-disable-next-line */
      console.log(url)

      // start query to search
      this.search.loading = true
      const res = await this.$axios.get(url)
      this.search.results = res.data
      this.search.loading = false

      // emit event after load?
      this.$emit('search-done')

      // toggle geojson visible
      this.geometry.visible = false
      this.geometry.visible = true
    },

    async loadGeometry () {
      this.geometry.loading = true
      const res = await this.$axios.get('/api/geojson/fishable_waters?columns=water_name,id')
      this.geometry.results = res.data.geojson
      this.geometry.loading = false
    },

    async renderGeometry () {
      if (!this.hasGeometry) {
        await this.loadGeometry()
      }

      const gl = this.$refs.map.$L.geoJson(this.geometry.results)
      gl.addTo(this.$refs.map.mapObject)
    }
  }

}
</script>

<style>
#map {
  height: 100vh;
}
</style>
