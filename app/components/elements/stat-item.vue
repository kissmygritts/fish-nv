<template>
  <div class="p-4 sm:w-1/4 w-1/2">
    <h2 class="title-font font-medium sm:text-4xl text-3xl text-gray-900">
      {{ stat }} <span class="text-base">lbs</span>
    </h2>
    <p class="leading-normal uppercase text-sm font-light tracking-wide">
      {{ statTitle }}
    </p>
  </div>
</template>

<script>
export default {
  name: 'StatItem',

  props: {
    stat: {
      type: Number,
      require: true,
      default: 0
    },
    statTitle: {
      type: String,
      require: true,
      default: 'Title'
    }
  }
}
</script>
