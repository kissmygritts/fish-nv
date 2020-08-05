<template>
  <div class="bg-gray-100">
    <header-nav ref="nav" />

    <!-- hero section -->
    <div
      id="hero"
      class="w-screen md:h-screen bg-cover bg-center bg-no-repeat flex md:items-center md:justify-center py-16 sm:py-32"
    >
      <!-- call to action section -->
      <div
        id="cta"
        class="text-white w-full md:w-3/4 lg:w-7/12 px-4 md:text-center"
      >
        <h1 class="text-3xl leading-tight font-light text-shadow">
          534 Fishable Waters and 39 Sport Fish Species
        </h1>
        <p class="mt-6 text-xl font-light leading-snug text-shadow">
          From desert creeks to high mountain lakes
          Nevada offers endless fishing possibilites. We've
          built this app to help you discover the perfect
          Nevada fishing adventure.
        </p>

        <!-- links -->
        <div class="flex flex-wrap w-full mt-8 text-center md:justify-center">
          <nuxt-link
            to="/map"
            class="w-full sm:w-64 text-white bg-blue-500 border-0 py-2 px-6 focus:outline-none hover:bg-blue-600 rounded-sm text-lg"
            prefetch
          >
            Explore the Map!
          </nuxt-link>
          <a
            href="https://nevada.licensing.kalkomey.com/"
            target="_blank"
            rel="noopener noreferrer"
            class="w-full sm:w-64 mt-2 sm:mt-0 sm:ml-2 text-gray-100 bg-gray-600 border-0 py-2 px-6 focus:outline-none hover:bg-gray-700 rounded-sm text-lg"
          >
            Buy a Fishing License
          </a>
        </div>
      </div>
    </div>

    <!-- FAQ section -->
    <section id="FAQ" class="text-gray-700 body-font">
      <div class="container px-5 lg:px-48 xl:px-64 py-24 mx-auto">
        <div class="text-center mb-12">
          <h2 class="text-2xl font-medium text-center title-font text-gray-800 mb-4">
            The Fish NV Map
          </h2>
          <p class="text-base leading-relaxed mx-auto px-12">
            Fish NV is an application to help you find ideal fishing locations.
            All the information is provided by fellow Nevada anglers.
            See below for more information about the data used within the app.
          </p>
        </div>
        <!-- FAQs -->
        <div class="flex flex-wrap sm:mx-auto sm:mb-2 -mx-2">
          <!-- first -->
          <div class="p-2 w-full">
            <div class="bg-gray-200 rounded-sm p-4 h-full items-center">
              <h3 class="font-semibold tracking-wide">
                What is a fishable water?
              </h3>
              <p class="mt-2 pl-4">
                NDOW fisheries biologist classify fishable waters within their respective areas.
                Not every stream, creek, or pond is considered a fishable water. Some of these
                don't contain any fish. Or they are ephemeral. Occasionally there is a mismatch
                between what NDOW considers a fishable water and what might look like a fishable
                water on a map. For further clarification call your local NDOW office.
              </p>
            </div>
          </div>
          <!-- next -->
          <div class="p-2 w-full">
            <div class="bg-gray-200 rounded-sm p-4 h-full items-center">
              <h3 class="font-semibold tracking-wide">
                What is a trophy fish?
              </h3>
              <p class="mt-2 pl-4">
                Potential trophy fish can be classified into a few separate categories (listed below).
              </p>
              <ul class="mt-2 list-inside list-disc pl-4">
                <li class="mt-1">
                  <span class="font-medium">Trophy Fish:</span> a trophy fish is a fish that meets the
                  minimum trophy fish weight for the respective species. For instance, the minimum
                  trophy weight for rainbow trout is 5 pounds.
                </li>
                <li class="mt-1">
                  <span class="font-medium">State Record:</span> a fish is considered a state record
                  if it is the largest fish of that species to every be caught and weighed on an official
                  scale, or validated by an NDOW biologist.
                </li>
                <li class="mt-1">
                  <span class="font-medium">Water Record:</span> a fish is considered a water record
                  if it is the largest fish of that species to every be caught in a respective water.
                  A water record does not need to meet the minimum trophy weight in order to be
                  considered a water record. For instance, a 1.15 pound redband trout caught in the
                  Jarbidge river can be considered a water record.
                </li>
                <li class="mt-1">
                  <span class="font-medium">Unofficial State Record:</span> If a fish is not certified
                  by an NDOW biologist or weighed on an official scale it isn't considered an official
                  record. However, it will still be listed as an unofficial record. There are currently
                  three fish that are considered unofficial state records because the weren't certified.
                </li>
              </ul>
            </div>
          </div>
          <!-- next -->
          <div class="p-2 w-full">
            <div class="bg-gray-200 rounded-sm p-4 h-full items-center">
              <h3 class="font-semibold tracking-wide">
                About the Data
              </h3>
              <p class="mt-2 pl-4">
                The data for this application comes from two sources maintained by the
                Nevada Department of Wildife: the Trophy Fish Database, and the Fishable
                Waters Database.
              </p>
              <p class="mt-2 pl-4">
                The Fishable Waters Database is used to generate the Nevada Fishing Guide every year.
                It contains a listing of every fishable water in Nevada as well as which species can
                be caught in that water. The fish guide is available at many local offices or downloaded
                from here.
              </p>
              <p class="mt-2 pl-4">
                The Trophy Fish Database contains user submitted fish data. Nevada anglers
                can submit fish records to NDOW for inclusion in an annual Trophy Fish Book generated
                by the department. This book isn't limited to trophy fish.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- footer -->
    <footer class="text-gray-500 bg-gray-800 body-font">
      <div class="container px-5 py-8 mx-auto flex items-center">
        <a href="http://www.ndow.org" class="title-font font-medium text-white" target="_blank" rel="noopener noreferrer">
          Nevada Department of Wildlife
        </a>
      </div>
    </footer>
  </div>
</template>

<script>
import HeaderNav from '@/components/header-nav.vue'

export default {
  components: {
    HeaderNav
  }
}
</script>

<style>
#hero {
  background-image:
    radial-gradient(
      rgba(0, 0, 0, 0.5),
      rgba(0, 0, 0, 0.05)
    ),
    url(~assets/img/hero-img.jpg)
    /* url(https://source.unsplash.com/qNhstTawQrI/1920x1080); */
    /* background-image: url(https://source.unsplash.com/qNhstTawQrI/1600x900); */
}

#cta {
  background: radial-gradient(
    rgba(0, 0, 0, 0.33),
    rgba(0, 0, 0, 0) 40%
  )
}

.text-shadow {
  text-shadow: 0 1px 20px #000000;
}
</style>
