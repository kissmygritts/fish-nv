/* eslint-disable */
<template>
  <div class="flex flex-wrap -m-4 text-center justify-start">
    <stat-item
      v-for="(record, index) in waterRecords"
      :key="index"
      :stat-title="record.species"
      :pounds="record.pounds"
      :ounces="record.ounces"
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

  props: {
    waterRecords: {
      type: Array,
      required: true,
      default () {
        return []
      }
    }
  }
}
</script>
