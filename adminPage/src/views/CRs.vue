<!--
Authors: JV Afable, JP Chanchico, Lance Lim

This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.

Code History:
	Feb 27, 2020: Lance Lim - Initialized file.
-->

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
