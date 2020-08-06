<!-- eslint-disble -->
<template>
  <div class="text-gray-900 pb-24">
    <header class="px-2 py-6 md:px-4 md:py-8 lg:px-8 container mx-auto">
      <h1 class="text-4xl leading-loose">
        {{ fishableWater.water_name }}
        <span class="text-2xl font-thin tracking-wide text-gray-600 pl-2">
          {{ fishableWater.label }}
        </span>
      </h1>
      <div>
        <tails-tag
          v-for="(tag, index) in tags"
          :key="index"
          :text="tag"
          class="mr-2 rounded capitalize"
        />
      </div>

      <!-- nav links -->
      <div class="pt-2">
        <a
          class="text-blue-700 underline cursor-pointer"
          @click="previousPage"
        >
          &larr; Previous Page
        </a>
        <nuxt-link
          to="/map"
          class="pl-2 text-blue-700 underline"
        >
          Explore Map
        </nuxt-link>
      </div>
    </header>

    <!-- map of the fishable water -->
    <div id="map" class="w-full">
      <geo-json-map
        :geojson="fishableWater.geojson"
        class="w-full"
      />
    </div>

    <!-- water records -->
    <div>
      <!-- if hasFishEntries === true -->
      <div v-if="hasFishEntries">
        <div class="bg-gray-100 text-gray-700">
          <div class="w-100 pt-12 container px-5 py-12 mx-auto">
            <h2 class="text-2xl tracking-wide font-hairline text-left md:text-center">
              Water Records
            </h2>
            <stat-container
              :water-records="waterRecords"
              class="pt-10 pb-5"
            />
          </div>
        </div>

        <!-- table of all fish entries -->
        <div class="w-100 pt-16 container mx-auto">
          <!-- table description -->
          <div class="w-7/12 mx-auto">
            <h2 class="text-4xl tracking-wide ">
              All Fish Entries
            </h2>
            <p class="text-lg font-thin text-gray-700 mt-6">
              The table below shows all the fish caught at {{ fishableWater.water_name }}
              and submitted to NDOW as part of the Trophy Fish Program. For more information
              about the trophy fish program see this link (add link).
            </p>

            <!-- table legend -->
            <div class="mt-6">
              <h4 class="text-xl tracking-wide">
                Table Legend
              </h4>
              <div class="text-grey-700 font-thin">
                <div class="flex items-center pt-2">
                  <div class="bg-yellow-200 w-8 h-8 border" />
                  <div class="pl-4">
                    State Record - this fish is the largest caught of the specified species
                  </div>
                </div>
                <div class="flex items-center pt-2">
                  <div class="bg-blue-100 w-8 h-8 border" />
                  <div class="pl-4">
                    Water Record - this fish is the largest caught in the specified fishable water
                  </div>
                </div>
                <div class="flex items-center pt-2">
                  <div class="bg-purple-100 w-8 h-8 border" />
                  <div class="pl-4">
                    Trophy Fish - this fish meets the minimum trophy requirements
                  </div>
                </div>
              </div>
            </div>
          </div>

          <vue-good-table
            class="pt-10"
            mode="remote"
            :pagination-options="paginationOptions"
            :sort-options="{ enabled: false }"
            :columns="columns"
            :rows="rows"
            :total-rows="fishEntries.totalRecords"
            :row-style-class="rowStyles"
            @on-page-change="onPageChange"
            @on-per-page-change="onPerPageChange"
          >
            <template slot="table-row" slot-scope="props">
              <span v-if="props.column.field === 'species'">
                <nuxt-link
                  :to="{name: 'species-id', params: { id: props.row.species_id }}"
                  class="underline text-blue-700"
                  prefetch
                >
                  {{ props.row.species }}
                </nuxt-link>
              </span>
              <span v-else>
                {{ props.formattedRow[props.column.field] }}
              </span>
            </template>
          </vue-good-table>
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
                href="https://nevada.licensing.kalkomey.com/"
                target="_blank"
                rel="noopener noreferrer"
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
import StatContainer from '@/components/elements/stat-container.vue'
import TailsTag from '@/components/elements/tails-tag.vue'

export default {
  components: {
    GeoJsonMap,
    StatContainer,
    TailsTag,
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
        }, {
          label: 'Year',
          field: 'date_caught'
        }, {
          label: 'Trophy Status',
          field: 'trophy_status',
          hidden: true
        }, {
          label: 'species_id',
          field: 'species_id',
          hidden: true
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
        .map(m => {
          const dateCaught = new Date(m.date_caught)

          return {
            angler_name: m.angler_name,
            species: m.species,
            pounds: m.pounds,
            ounces: m.ounces,
            angler_state: m.angler_state,
            trophy_status: m.trophy_classification,
            species_id: m.species_id,
            date_caught: dateCaught.getFullYear()
          }
        }
      )
    },

    querystring () {
      let querystring = new URLSearchParams()

      // default ordering, don't change this for now
      querystring.append('order', 'species')
      querystring.append('order', 'desc.fish_weight')

      querystring.append('page', this.query.page || 1)
      querystring.append('per_page', this.query.perPage || 25)

      return querystring.toString()
    },

    hasFishEntries () {
      return this.fishEntries.data.length > 0
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

    onPerPageChange (params) {
      this.updateQuery({ perPage: params.currentPerPage })
      this.loadTable()
    },

    async loadTable () {
      const url = `${this.url}/fish-entries?${this.querystring}`
      console.log(url)
      const data = await this.$axios.$get(url)
      this.fishEntries = data
    },

    rowStyles (row) {
      const styles = {
        'state record': 'bg-yellow-200',
        'water record': 'bg-blue-100',
        'trophy fish': 'bg-purple-100'
      }
      return styles[row.trophy_status]
    },

    previousPage () {
      this.$router.back()
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
