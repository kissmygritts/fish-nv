<template>
  <div class="flex h-screen w-screen">
    <main id="map" class="bg-blue-400 flex-grow">
      <!-- <l-map :center="center" :zoom="zoom">
        <l-tile-layer :url="url" />
        <geo-json-layer
          :geojson="fishableWaters.geojson"
          :enable-tooltip="true"
          @click:feature="navigateTo"
        />
      </l-map> -->
      <p class="text-center">
        map
      </p>
    </main>

    <aside class="bg-gray-100 w-1/4 flex flex-col px-8 overflow-y-auto">
      <!-- search box -->
      <div class="relative py-4">
        <div
          class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none"
        >
          <svg
            class="w-5 h-5 text-gray-500"
            fill="none"
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
        </div>
        <input
          id="search"
          v-model="search.query"
          type="text"
          class="block w-full pl-10 py-3 text-gray-800 placeholder-gray-500 rounded-md shadow-sm focus:outline-none focus:shadow-outline"
          placeholder="Search..."
          @keyup.enter="searchFishableWaters"
        >
      </div>
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

export default {
  // components: { GeoJsonLayer },

  async asyncData ({ $axios }) {
    const res = await $axios.get('/api/geojson/fishable_waters?columns=water_name,id')

    return {
      fishableWaters: res.data
    }
  },

  data () {
    return {
      search: {
        query: null,
        loading: false,
        results: null
      },
      url: 'https://{s}.tile.osm.org/{z}/{x}/{y}.png',
      center: [38.64954285997146, -116.77592011899117],
      zoom: 6
    }
  },

  computed: {
    hasSearchResults () {
      return !!this.search.results
    },

    searchUrl () {
      if (this.search.query) {
        let s = this.search.query
          .replaceAll(/\s*[,;:.-_]\s*/g, ',')
        s = new URLSearchParams({ s })
        return `/api/fishable-waters?${s.toString()}`
      } else {
        return ''
      }
    }
  },

  methods: {
    navigateTo (feature) {
      this.$router.push({
        path: `fishable-waters/${feature.id}`
      })
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
