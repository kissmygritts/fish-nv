<template>
  <div class="bg-gray-100 text-gray-900 pb-24">
    <div class="article pt-12">
      <!-- header -->
      <div class="article__head">
        <h1 class="text-5xl leading-none capitalize">
          {{ species.species }}
          <span class="text-3xl font-thin tracking-wide text-gray-600 pl-2 italic normal-case">
            {{ species.scientific_name }}
          </span>
        </h1>
      </div>

      <!-- stats -->
      <h2 class="text-2xl text-gray-700 leading-normal font-light tracking-wide bleed mt-16">
        Quick Stats
      </h2>
      <div class="bleed flex flex-wrap justify-between px-4">
        <!-- stat items -->
        <div class="p-4 sm:w-1/4 w-1/2">
          <h2 class="title-font font-medium sm:text-4xl text-3xl text-gray-900">
            {{ stateRecord.pounds }}<span class="text-base">lbs</span>
            {{ stateRecord.ounces }}<span class="text-base">oz</span>
          </h2>
          <p class="leading-normal uppercase text-sm font-light tracking-wide">
            State Record
          </p>
        </div>
        <!-- stat items -->
        <div class="p-4 sm:w-1/4 w-1/2">
          <h2 class="title-font font-medium sm:text-4xl text-3xl text-gray-900">
            {{ species.min_trophy_weight }}<span class="text-base">lbs</span>
          </h2>
          <p class="leading-normal uppercase text-sm font-light tracking-wide">
            Min Trophy Weight
          </p>
        </div>
        <!-- stat items -->
        <div class="p-4 sm:w-1/4 w-1/2">
          <h2 class="title-font font-medium sm:text-4xl text-3xl text-gray-900">
            {{ fishEntries.totalRecords }}
          </h2>
          <p class="leading-normal uppercase text-sm font-light tracking-wide">
            Total Entries
          </p>
        </div>
        <!-- stat items -->
        <div class="p-4 sm:w-1/4 w-1/2">
          <h2 class="title-font font-medium sm:text-4xl text-3xl text-gray-900">
            {{ waterBodies.geojson.features.length }}
          </h2>
          <p class="leading-normal uppercase text-sm font-light tracking-wide">
            Water Bodies
          </p>
        </div>
      </div>

      <!-- description -->
      <div class="article__content mt-20 bg-white rounded shadow-2xl -mb-32 p-8 z-0">
        <p class="text-xl text-gray-600 italic font-light text-center">
          {{ species.description }}
        </p>
      </div>

      <!-- img -->
      <div class="article__img--full">
        <img
          src="~/assets/img/rainbow-trout.jpg"
          alt="rainbow trout in a stream"
          class="article__img"
        >
      </div>

      <!-- map preamble -->
      <div class="article__content mt-16">
        <h2 class="text-4xl tracking-wide">
          Where to find {{ species.species }}
        </h2>
        <p class="text-lg font-thin text-gray-700 mt-6">
          Based on data collected by, and the experience of NDOW fisheries biologists,
          {{ species.species }} have been documented in the water bodies shown in the
          map below. We make every effort to ensure our data is complete and accurate.
          That said, it is possible to catch {{ species.species }} outside of a water
          body shown below. It is also possible to not catch a {{ species.species }} in
          the waters shown below. They call it fishing for a reason.
        </p>
      </div>

      <!-- actual map -->
      <div class="article__map--bleed mt-8">
        <geo-json-map
          :enable-tooltip="true"
          :geojson="waterBodies.geojson"
          class="w-full"
          @feature:click="navigateTo"
        />
      </div>

      <!-- table preamble -->
      <div class="article__content mt-16">
        <h2 class="text-4xl tracking-wide">
          All {{ species.species }} entries
        </h2>
        <p class="text-lg font-thin text-gray-700 mt-6">
          Below is a table of {{ species.species }} submitted to NDOW through the
          trophy fish program. For more information about the trophy fish program
          see this link (add link).
        </p>
      </div>

      <!-- actual table -->
      <div class="article__table--bleed mt-8">
        <vue-good-table
          mode="remote"
          :columns="columns"
          :rows="rows"
          :pagination-options="paginationOptions"
          :sort-options="{ enabled: false }"
          :total-rows="fishEntries.totalRecords"
          :row-style-class="rowStyles"
          @on-page-change="onPageChange"
          @on-per-page-change="onPerPageChange"
        >
          <template slot="table-row" slot-scope="props">
            <span v-if="props.column.field === 'water_name'">
              <nuxt-link
                :to="{name: 'fishable-waters-id', params: { id: props.row.water_id }}"
                class="underline text-blue-700"
                :prefetch="false"
              >
                {{ props.row.water_name }}
              </nuxt-link>
            </span>
            <span v-else>
              {{ props.formattedRow[props.column.field] }}
            </span>
          </template>
        </vue-good-table>
      </div>
    </div>
  </div>
</template>

<script>
/* eslint-disable */
import { VueGoodTable } from 'vue-good-table'
import 'vue-good-table/dist/vue-good-table.css'
import GeoJsonMap from '@/components/geojson-map.vue'

export default {
  components: {
    GeoJsonMap,
    VueGoodTable
  },

  async asyncData ({ params, $axios }) {
    const url = `/api/species/${params.id}`

    const species = await $axios.$get(url)
    const fishEntries = await $axios.$get(`${url}/fish-entries?order=desc.fish_weight&&page=1&per_page=15`)
    const waterBodies = await $axios.$get(`${url}/water-bodies`)

    return {
      species,
      fishEntries,
      waterBodies,
      url
    }
  },

  data () {
    return {
      columns: [
        {
          label: 'Angler Name',
          field: 'angler_name'
        }, {
          label: 'Water Body',
          field: 'water_name'
        }, {
          label: 'Pounds',
          field: 'pounds'
        }, {
          label: 'Ounces',
          field: 'ounces'
        }, {
          label: 'Fish Length',
          field: 'fish_length'
        }, {
          label: 'Trophy Status',
          field: 'trophy_status'
        }, {
          label: 'water_id',
          field: 'water_id',
          hidden: true
        }
      ],
      paginationOptions: {
        enabled: true,
        perPage: 15,
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
        perPage: 15
      },
      stateRecord: {
        pounds: null,
        ounces: null
      }
    }
  },

  computed: {
    rows () {
      return this.fishEntries.data
        .map(m => ({
          angler_name: m.angler_name,
          pounds: m.pounds,
          ounces: m.ounces,
          fish_length: m.fish_length,
          water_name: m.water_name,
          trophy_status: m.trophy_classification,
          water_id: m.water_id
        }))
    },

    querystring () {
      const querystring = new URLSearchParams()

      // default ordering, don't change this for now
      querystring.append('order', 'desc.fish_weight')

      querystring.append('page', this.query.page || 1)
      querystring.append('per_page', this.query.perPage || 15)

      return querystring.toString()
    }
  },

  created () {
    this.stateRecord.pounds = this.fishEntries.data[0].pounds
    this.stateRecord.ounces = this.fishEntries.data[0].ounces

    // this.$nextTick(() => {
    //   this.stateRecord.pounds = this.fishEntries.data[0].pounds
    //   this.stateRecord.ounces = this.fishEntries.data[0].ounces
    // })
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

    navigateTo (feature) {
      this.$router.push({
        name: 'fishable-waters-id',
        params: {
          id: feature.id
        }
      })
    }
  }
}
</script>

<style scoped>
.article {
  display: grid;
  grid-template-columns:
    [full-start] minmax(1em, 1fr)
    [bleed-start] minmax(1em, 1fr)
    [main-start] minmax(0, 40em)
    [main-end] minmax(1em, 1fr)
    [bleed-end] minmax(1em, 1fr)
    [full-end];
}

.article__head {
  grid-column: bleed;
}

.article__content {
  grid-column: main;
}

.article__img--full {
  grid-column: full;
}

.article__img {
  object-fit: cover;
  width: 100%;
  max-height: 85vh;
}

.article__map--bleed {
  grid-column: bleed;
  height: 500px;
}

.article__table--bleed {
  grid-column: bleed;
}

.bleed {
  grid-column: bleed;
}
</style>
