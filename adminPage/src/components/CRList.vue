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
        <b-table-column field="id" label="ID" sortable>{{ props.row.id }}</b-table-column>

        <b-table-column
          field="location.address"
          label="Location"
          sortable
        >{{ props.row.location.address }}</b-table-column>

        <b-table-column field="floor" label="Floor" sortable>{{ props.row.floor }}</b-table-column>

        <b-table-column field="gender" label="Gender">{{ props.row.gender }}</b-table-column>
        <b-table-column>
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
      this.data = this.ListofPeople;
      this.tableLoading = false;
    },

    async removeCR(id) {
      this.tableLoading = true;
      var response = await this.deleteCR(id);
      if (response) {
        this.data = this.ListofCRs;
        this.$buefy.toast.open('CR added successfully!');
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
      case 500:
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