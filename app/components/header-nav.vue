<template>
  <nav class="bg-gray-800">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between h-16">
        <div class="flex items-center">
          <div class="flex-shrink-0 text-lg text-gray-100 font-bold tracking-wider">
            FishNV
          </div>
          <div class="hidden md:block">
            <div class="ml-10 flex items-baseline">
              <a
                class="cursor-pointer ml-4 px-3 py-2 rounded-sm text-sm font-medium text-gray-300 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700"
                @click="scrollTo('FAQ')"
              >
                FAQ
              </a>
            </div>
          </div>
        </div>
        <div class="">
          <div class="ml-4 flex items-center md:ml-6">
            <nuxt-link
              to="/map"
              class="bg-blue-500 text-white border-0 py-1 px-4 focus:outline-none hover:bg-blue-600 rounded-sm text-base"
              prefetch
            >
              Explore Map
            </nuxt-link>
          </div>
        </div>
      </div>
    </div>
  </nav>
</template>

<script>
export default {
  name: 'HeaderNav',

  methods: {
    scrollTo (el) {
      if (process.client) {
        document
          .getElementById(el)
          .scrollIntoView({ behavior: 'smooth' })
      }
    }
  }
}
</script>
