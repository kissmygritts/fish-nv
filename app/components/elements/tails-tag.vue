<template>
  <span class="px-3 py-1 text-xs md:text-sm bg-gray-200 inline-block mb-2">
    {{ text }}
  </span>
</template>

<script>
export default {
  name: 'TailsTag',
  props: {
    text: {
      type: String,
      required: true,
      default: 'text'
    }
  }
}
</script>
