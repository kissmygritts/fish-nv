<template>
  <div class="bg-gray-100 text-gray-900 pb-24">
    <div class="article">
      <!-- header -->
      <div class="article__head">
        <h1 class="text-5xl leading-loose capitalize">
          {{ species.species }}
          <span class="text-3xl font-thin tracking-wide text-gray-600 pl-2 italic normal-case">
            {{ species.scientific_name }}
          </span>
        </h1>
      </div>

      <!-- description -->
      <div class="article__content my-32">
        <p class="text-xl text-gray-700 font-thin text-center">
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
          :geojson="waterBodies.geojson"
          class="w-full"
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
          @on-page-change="onPageChange"
          @on-per-page-change="onPerPageChange"
        />
      </div>
    </div>
  </div>
</template>

<script>
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
    const fishEntries = await $axios.$get(`${url}/fish-entries?order=desc.fish_weight&&page=1&per_page=25`)
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
          label: 'Pounds',
          field: 'pounds'
        }, {
          label: 'Ounces',
          field: 'ounces'
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
        perPage: 25
      }
    }
  },

  computed: {
    rows () {
      return this.fishEntries.data
        .map(m => ({
          angler_name: m.angler_name,
          pounds: m.pounds,
          ounces: m.ounces
        }))
    },

    querystring () {
      const querystring = new URLSearchParams()

      // default ordering, don't change this for now
      querystring.append('order', 'desc.fish_weight')

      querystring.append('page', this.query.page || 1)
      querystring.append('per_page', this.query.perPage || 25)

      return querystring.toString()
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
      const data = await this.$axios.$get(url)
      this.fishEntries = data
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
</style>
