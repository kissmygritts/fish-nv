<!-- eslint-disble -->
<template>
  <div class="text-gray-900">
    <header class="px-2 py-6 md:px-4 md:py-8 lg:px-8 container mx-auto">
      <h1 class="text-4xl leading-loose">
        {{ fishableWater.water_name }}
        <span class="text-2xl font-thin tracking-wide text-gray-600 pl-2">
          {{ fishableWater.label }}
        </span>
      </h1>
      <div>
        <tw-tag
          v-for="(tag, index) in tags"
          :key="index"
          :text="tag"
          class="mr-2 rounded capitalize"
        />
      </div>
    </header>

    <!-- map of the fishable water -->
    <div id="map" class="w-full">
      <geo-json-map
        :geojson="parsedGeoJson"
        class="w-full"
      />
    </div>

    <!-- water records -->
    <div>
      <!-- if hasFishEntries === true -->
      <div v-if="hasFishEntries">
        <div class="bg-gray-100 text-gray-700">
          <div class="w-100 pt-12 container px-5 py-12 mx-auto">
            <h2 class="text-lg tracking-wide font-light text-left md:text-center">
              Water Records
            </h2>
            <stat-container
              :water-records="waterRecords"
              class="pt-10 pb-5"
            />
          </div>
        </div>

        <div class="w-100 text-center pt-16 container mx-auto">
          <h2 class="text-lg tracking-wide font-light text-left md:text-center px-5">
            All Fish Entries
          </h2>

          <!-- <simple-table
            :table-data="fishTable"
            class="pt-10 pb-5"
          /> -->
          <vue-good-table
            mode="remote"
            :pagination-options="paginationOptions"
            :columns="columns"
            :rows="rows"
            :total-rows="fishEntries.totalRecords"
            @on-page-change="onPageChange"
          />
        </div>
      </div>
      <!-- if hasFishEntreis === false -->
      <div v-else class="bg-gray-100 py-16">
        <div class="container mx-auto flex flex-wrap items-center justify-center">
          <div class="img-container">
            <img
              id="img"
              class="object-contain h-full w-full"
              src="~/assets/img/undraw_fishing_hoxa.png"
            >
          </div>
          <div class="w-4/5 px-6 text-center md:text-left md:w-1/2 lg:w-1/3 md:-ml-8 lg:ml-0">
            <h3 class="text-gray-800 text-xl tracking-wide uppercase leading-loose">
              You can be first!
            </h3>
            <p class="text-gray-700">
              Fish have not been caught and reported to NDOW from {{ fishableWater.water_name }}.
              You can be the first!
            </p>
            <div class="mt-6">
              <a
                href="#"
                class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
              >
                Buy a fishing license
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
/* eslint-disable */
import { VueGoodTable } from 'vue-good-table'
import 'vue-good-table/dist/vue-good-table.css'
import GeoJsonMap from '@/components/geojson-map.vue'
// import SimpleTable from '@/components/elements/simple-table.vue'
import StatContainer from '@/components/elements/stat-container.vue'
import TwTag from '@/components/elements/tw-tag.vue'

export default {
  components: {
    GeoJsonMap,
    // SimpleTable,
    StatContainer,
    TwTag,
    VueGoodTable
  },

  async asyncData ({ params, $axios }) {
    const url = `/api/fishable-waters/${params.id}`

    const fishableWater = await $axios.$get(url)
    const fishEntries = await $axios.$get(`${url}/fish-entries?order=species&order=desc.fish_weight`)
    const waterRecords = await $axios.$get(`${url}/water-records`)

    return {
      fishableWater,
      fishEntries,
      url,
      waterRecords
    }
  },

  data () {
    return {
      columns: [
        {
          label: 'Angler Name',
          field: 'angler_name'
        }, {
          label: 'Species',
          field: 'species'
        }, {
          label: 'Pounds',
          field: 'pounds',
          type: 'number'
        }, {
          label: 'Ounces',
          field: 'ounces',
          type: 'number'
        }, {
          label: 'Angler State',
          field: 'angler_state'
        }
      ],
      paginationOptions: {
        enabled: true,
        perPage: 25,
        perPageDropdown: [15, 25, 50, 75],
        dropdownAllowAll: false
      },
      query: {
        columnFilters: {},
        sort: {
          field: '',
          type: ''
        },
        page: 1,
        perPage: 25
      }
    }
  },

  computed: {
    rows () {
      return this.fishEntries.data
        .map(m => ({
          angler_name: m.angler_name,
          species: m.species,
          pounds: m.pounds,
          ounces: m.ounces,
          angler_state: m.angler_state
        }))
    },

    // columns () {
    //   return Object.keys(this.rows)
    // },

    hasFishEntries () {
      return this.fishEntries.data.length > 0
    },

    parsedGeoJson () {
      return JSON.parse(this.fishableWater.geojson)
    },

    tags () {
      return [
        `${this.fishableWater.region} region`,
        `${this.fishableWater.county} county`,
        ...this.fishableWater.species
      ]
    }
  },

  methods: {
    updateQuery (props) {
      this.query = Object.assign({}, this.query, props)
    },

    onPageChange (params) {
      this.updateQuery({ page: params.currentPage })
      this.loadTable()
    },

    async loadTable () {
      const url = `${this.url}/fish-entries?order=species&order=desc.fish_weight&page=${this.query.page}&per_page=${this.query.perPage}`
      console.log(url)
      const data = await this.$axios.$get(url)
      this.fishEntries = data
    }
  }
}
</script>

<style scoped>
#map {
  height: 50vh;
}

.img-container {
  width: 325px;
  height: 325px;
}

#img {
  mix-blend-mode: multiply;
}
</style>
