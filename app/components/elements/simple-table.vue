<template>
  <div class="container mx-auto">
    <table class="table-atuo w-full text-left text-gray-700 border">
      <thead>
        <tr class="border-b capitalize">
          <th
            v-for="(field, index) in tableFields"
            :key="index"
          >
            {{ field }}
          </th>
        </tr>
      </thead>

      <tbody>
        <tr
          v-for="(row, rowno) in tableRows"
          :key="rowno"
        >
          <td v-for="(field, index) in tableFields" :key="index">
            {{ row[field] }}
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: 'SimpleTable',

  props: {
    tableData: {
      type: Array,
      required: true,
      default () {
        return []
      }
    }
  },

  computed: {
    tableFields () {
      return Object.keys(this.tableData[0])
    },

    tableRows () {
      // display only 25 rows for now, in production will use a more
      // advanced table display
      return this.tableData.slice(0, 25)
    }
  }

}
</script>

<style lang="postcss" scoped>
tbody > tr:nth-child(odd) {
  @apply bg-gray-100;
}

th,
td {
  @apply px-4 py-2;
}
</style>
