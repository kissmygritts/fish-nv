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

    <aside class="bg-gray-100 w-1/4 flex flex-col px-8">
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
          type="text"
          class="block w-full pl-10 py-3 text-gray-800 placeholder-gray-500 rounded-md shadow-sm focus:outline-none focus:shadow-outline"
          placeholder="Search..."
        >
      </div>
      <!-- results -->
      <div class="w-full h-full bg-white mt-2">
        <pre><code>
          search results
        </code></pre>
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
      url: 'https://{s}.tile.osm.org/{z}/{x}/{y}.png',
      center: [38.64954285997146, -116.77592011899117],
      zoom: 6
    }
  },

  methods: {
    navigateTo (feature) {
      this.$router.push({
        path: `fishable-waters/${feature.id}`
      })
    }
  }
}
</script>

<style>
#map {
  height: 100vh;
}
</style>
