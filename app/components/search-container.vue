<template>
  <div class="text-gray-700 py-4">
    <h2 class="text-lg">
      Filter Fishable Waters
    </h2>
    <p
      class="text-sm text-orange-700 underline cursor-pointer"
      @click="clearFilters"
    >
      Clear Filters
    </p>
    <!-- species input -->
    <div class="mt-2 py-2">
      <label for="species">Select Species</label>
      <div class="relative inline-block w-full mt-1">
        <select
          id="species"
          v-model="species.selected"
          name="species"
          class="block appearance-none w-full bg-white px-4 py-3 pr-8 rounded-md shadow-sm leading-tight focus:outline-none focus:shadow-outline"
          @change="selected"
        >
          <option
            v-for="(fish, index) in species.options"
            :key="index"
            :value="fish"
          >
            {{ fish }}
          </option>
        </select>
        <div
          class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700"
        >
          <svg
            class="w-4 h-4"
            fill="none"
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path d="M19 9l-7 7-7-7" />
          </svg>
        </div>
      </div>
    </div>
    <!-- water type -->
    <div class="py-2">
      <label for="water-type">Select Water Type</label>
      <div class="relative inline-block w-full mt-1">
        <select
          id="waterType"
          v-model="waterType.selected"
          name="water-type"
          class="block appearance-none w-full bg-white px-4 py-3 pr-8 rounded-md shadow-sm leading-tight focus:outline-none focus:shadow-outline"
          @change="selected"
        >
          <option value="" />
          <option value="creek">
            creek
          </option>
          <option value="stream">
            stream
          </option>
          <option value="river">
            river
          </option>
          <option value="pond">
            pond
          </option>
          <option value="lake">
            lake
          </option>
          <option value="reservoir">
            reservoir
          </option>
        </select>
        <div
          class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700"
        >
          <svg
            class="w-4 h-4"
            fill="none"
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path d="M19 9l-7 7-7-7" />
          </svg>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SearchContainer',

  data () {
    return {
      waterType: {
        selected: null
      },
      species: {
        selected: null,
        options: [
          '',
          'arctic grayling',
          'black crappie',
          'bluegill sunfish',
          'bonneville cutthoat trout',
          'bowcutt trout',
          'brook trout',
          'brown trout',
          'bull trout',
          'bullhead catfish',
          'carp',
          'channel catfish',
          'crappie',
          'cutthroat',
          'golden trout',
          'green sunfish',
          'kokanee salmon',
          'lahontan cutthroat trout',
          'largemouth bass',
          'mackinaw trout',
          'northern pike',
          'pumpkinseed',
          'rainbow trout',
          'redband trout',
          'redear sunfish',
          'sacramento perch',
          'silver salmon',
          'smallmouth bass',
          'spotted bass',
          'striped bass',
          'tiger musky',
          'tiger trout',
          'walleye',
          'white bass',
          'white catfish',
          'white crappie',
          'whitefish',
          'wiper',
          'yellow perch',
          'yellowstone cutthroat trout'
        ]
      }
    }
  },

  computed: {
    payload () {
      const speciesString = this.species.selected
        ? Array.isArray(this.species)
          ? this.species.selected.join(' or ')
          : this.species.selected
        : ''
      const waterString = this.waterType.selected || ''

      const s = [speciesString, waterString]
        .filter(str => str !== '')
        .join()

      return {
        s: s === '' ? null : s
      }
    }
  },

  methods: {
    selected (e) {
      this.$emit('selected', {
        params: this.payload
      })
    },

    clearFilters () {
      this.waterType.selected = null
      this.species.selected = null

      // call selected method to run search
      this.selected()
    }
  }
}
</script>

<style>

</style>
