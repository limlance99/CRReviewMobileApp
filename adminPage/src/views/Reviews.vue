<template>
  <div>
  <section class="section">
    <div class="container">
      <h1 class="title">Reviews of CR {{crid}} </h1>
      <h2 class="subtitle">
        This section shows a table containing all Reviews of CR {{crid}} in the database.
      </h2>
      <ReviewList :crid="crid" />
    </div>
  </section>
  </div>
</template>
<script>
import ReviewList from '../components/ReviewList';
export default {
  name: "Reviews",
  components: {
      ReviewList
  },
  data() {
      return {
          crid: this.$route.params.crid,
      }
  }
};
</script>
