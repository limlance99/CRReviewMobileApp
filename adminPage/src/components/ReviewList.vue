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

        <b-table-column field="createdat" label="Date Created">{{ props.row.createdat }}</b-table-column>

        <b-table-column field="rating1" label="Rating 1">{{ props.row.rating1 }}</b-table-column>
        <b-table-column field="rating2" label="Rating 2">{{ props.row.rating2 }}</b-table-column>
        <b-table-column field="rating3" label="Rating 3">{{ props.row.rating3 }}</b-table-column>

        <b-table-column field="reviewtext" label="Review Text">{{ props.row.reviewtext }}</b-table-column>
        <b-table-column label="Delete">
          <b-button type="is-warning" @click="removeReview(props.row.id)">Delete</b-button>
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
  props: ["crid"],
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
    ...mapGetters(["ListofReviews"])
  },
  methods: {
    ...mapActions(["fetchTable", "deleteReview"]),

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

    goToReviews(crid) {
      this.$router.push({ path: `/reviews/${crid}` });
    },
    async removeReview(id) {
      this.tableLoading = true;
      var response = await this.deleteReview(id);
      if (response) {
        this.data = this.ListofReviews;
        this.$buefy.toast.open("Review deleted successfully!");
      } else {
        this.$buefy.toast.open("An error occured :(");
      }
      this.tableLoading = false;
    }
  },

  async mounted() {
    this.tableLoading = true;
    var details = {
      table: "reviews",
      field: this.sortField,
      order: this.sortOrder,
      id: this.crid
    };
    let status = await this.fetchTable(details);
    switch (status) {
      case 500:
        this.data = this.ListofReviews;
        console.log(this.data);
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