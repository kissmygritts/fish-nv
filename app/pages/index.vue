<template>
  <div class="flex h-screen w-screen">
    <main id="map" class="bg-blue-400 flex-grow">
      <client-only>
        <l-map :center="center" :zoom="zoom">
          <l-tile-layer :url="url" />
        </l-map>
      </client-only>

      <!-- <geo-json-layer
        :geojson="fishableWaters.geojson"
        :enable-tooltip="true"
        @click:feature="navigateTo"
      /> -->
    </main>

    <aside class="bg-gray-100 w-1/4 flex flex-col px-8 overflow-y-auto">
      <!-- search container -->
      <search-container @selected="doSomething" />
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
// import GeoJsonLayer from '@/components/elements/geojson-layer.vue'
import SearchContainer from '@/components/search-container'

export default {
  components: {
    // GeoJsonLayer,
    SearchContainer
  },

  // async asyncData ({ $axios }) {
  //   const res = await $axios.get('/api/geojson/fishable_waters?columns=water_name,id')

  //   return {
  //     fishableWaters: res.data
  //   }
  // },

  data () {
    return {
      url: 'https://{s}.tile.osm.org/{z}/{x}/{y}.png',
      center: [38.64954285997146, -116.77592011899117],
      zoom: 6,
      search: {
        loading: false,
        results: null,
        params: null
      }
    }
  },

  computed: {
    hasSearchResults () {
      return !!this.search.results
    }
  },

  methods: {
    navigateTo (feature) {
      this.$router.push({
        path: `fishable-waters/${feature.id}`
      })
    },

    /* eslint-disable-next-line */
    async doSomething ({ params }) {
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
    },

    async searchFishableWaters () {
      this.search.loading = true
      /* eslint-disable-next-line */
      // const res = await this.$axios.get(`/api/fishable-waters?water_name=${this.search.query}`)
      const res = await this.$axios.get(this.searchUrl)
      this.search.results = res.data
      this.search.loading = false
    }
  }
}
</script>

<style>
#map {
  height: 100vh;
}
</style>
