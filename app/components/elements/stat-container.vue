/* eslint-disable */
<template>
  <div class="flex flex-wrap -m-4 text-center justify-start">
    <stat-item
      v-for="(record, index) in waterRecords"
      :key="index"
      :stat="record.weight"
      :stat-title="record.species"
    />
  </div>
</template>

<script>
import StatItem from '@/components/elements/stat-item.vue'

export default {
  name: 'StatContainer',

  components: {
    StatItem
  },

  data () {
    return {
      waterRecords: [
        {
          species: 'rainbow trout',
          weight: 13.4
        }, {
          species: 'brown trout',
          weight: 4.6
        }, {
          species: 'redband trout',
          weight: 2.6
        }, {
          species: 'catfish',
          weight: 20.0
        }, {
          species: 'largemouth bass',
          weight: 25.14
        }
      ]
    }
  }
}
</script>
