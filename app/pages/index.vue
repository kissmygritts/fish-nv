<template>
  <div id="map" class="w-full">
    <basemap
      :fishable-waters="fishableWaters"
    />
  </div>
</template>

<script>
import Basemap from '@/components/basemap.vue'

export default {
  components: { Basemap },

  async asyncData ({ $axios }) {
    const res = await $axios.get('/api/fishable-waters')

    return {
      fishableWaters: res.data
    }
  }
}
</script>

<style>
/* Sample `apply` at-rules with Tailwind CSS
.container {
  @apply min-h-screen flex justify-center items-center text-center mx-auto;
}
*/
#map {
  height: 100vh;
}
</style>
