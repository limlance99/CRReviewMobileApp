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
  <section>
    <b-table
      :data="data"
      ref="table"
      :loading="tableLoading"
      backend-sorting
      :default-sort-direction="defaultSortOrder"
      :default-sort="[sortField, sortOrder]"
      @sort="onSort"
    >
      <template slot-scope="props">
        <b-table-column field="id" label="ID">{{ props.row.id }}</b-table-column>

        <b-table-column field="createdat" label="Created At">{{ parseDate(props.row.createdat) }}</b-table-column>

        <b-table-column
          field="location.address"
          label="Location"
        >{{ props.row.location.address }}</b-table-column>

        <b-table-column field="floor" label="Floor">{{ props.row.floor }}</b-table-column>

        <b-table-column field="gender" label="Gender">{{ props.row.gender }}</b-table-column>
        <b-table-column label="Edit">
          <b-button
            type="is-success"
            @click="goToReviews(props.row.id)"
          >Edit Reviews</b-button>
        </b-table-column>
        <b-table-column label="Delete">
          <b-button 
            type="is-warning"
            @click="removeCR(props.row.id)"
          >Delete</b-button>
        </b-table-column>
      </template>

      <template slot="empty">
        <p v-if="tableLoading">Loading...</p>
        <p v-else>{{DetailMessage}}</p>
      </template>
    </b-table>
  </section>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
export default {
  data() {
    return {
      data: [],
      tableLoading: false,
      defaultSortOrder: "desc",
      sortField: "fullname",
      sortOrder: "desc",
      DetailMessage: "Nothing Here"
    };
  },
  computed: {
    ...mapGetters(["ListofCRs"])
  },
  methods: {
    ...mapActions(["fetchTable", "deleteCR"]),

    async onSort(field, order) {
      this.sortField = field;
      this.sortOrder = order;
      this.tableLoading = true;
      var details = {
        table: "crs",
        field,
        order
      };
      await this.fetchTable(details);
      this.data = this.ListofCRs;
      this.tableLoading = false;
    },

    parseDate(dateString) {
      var formattedDate = new Date(dateString.replace(' ', 'T'));
      return formattedDate;
    },
    goToReviews(crid) {
      this.$router.push({path: `/reviews/${crid}`});
    },
    async removeCR(id) {
      this.tableLoading = true;
      var response = await this.deleteCR(id);
      if (response) {
        this.data = this.ListofCRs;
        this.$buefy.toast.open('CR deleted successfully!');
      } else {
        this.$buefy.toast.open('An error occured :(');
      }
      this.tableLoading = false;
    }
  },

  async mounted() {
    this.tableLoading = true;
    var details = {
      table: "crs",
      field: this.sortField,
      order: this.sortOrder
    };
    let status = await this.fetchTable(details);
    switch (status) {
      case 200:
        this.data = this.ListofCRs;
        break;
      case 409:
        this.data = [];
        this.DetailMessage = "Nothing Here";
        break;
      default:
        this.data = [];
        this.DetailMessage = "Could not connect to the database.";
    }
    this.tableLoading = false;
  }
};
</script>