<template>
  <div>
  <section class="section">
    <div class="container">
      <h1 class="title">CRs</h1>
      <h2 class="subtitle">
        This section shows a table containing all CRs in the database with their respective IDs, Locations, Floor, and Gender.
      </h2>
      <CRList />
    </div>
  </section>
  </div>
</template>
<script>
import CRList from '../components/CRList';
export default {
  name: "CRs",
  components: {
      CRList
  }
};
</script>
