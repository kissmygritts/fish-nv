<template>
  <div class="h-screen w-full">
    <basemap :fishable-waters="fishableWaters" />
  </div>
</template>

<script>
import axios from 'axios'
import Basemap from '@/components/basemap.vue'

export default {
  components: { Basemap },

  async asyncData ({ params }) {
    const res = await axios.get('http://localhost:3030/fishable-waters')
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
</style>
