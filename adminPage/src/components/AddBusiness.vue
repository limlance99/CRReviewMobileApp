<template>
    <div class="modal-card">
        <b-loading :active.sync="isLoading"></b-loading>
      <header class="modal-card-head">
        <p class="modal-card-title">New Business</p>
      </header>
      <section class="modal-card-body">
        <b-field label="Business Name"
        :type="{'is-danger' : NameError}">
          <b-input v-model="newBusiness.businessname" maxlength="100"></b-input>
        </b-field>

        <b-field
          label="Contact Number"
          :type="{'is-danger' : NumberError}"
          :message="{'Please input numbers only.': NumberError}"
        >
          <b-input v-model="newBusiness.businessno" maxlength="20"></b-input>
        </b-field>

        <b-field label="Address">
          <b-input v-model="newBusiness.businessadd" maxlength="100"></b-input>
        </b-field>
      </section>
      <footer class="modal-card-foot">
        <b-button class="is-text card-footer-item" @click="$parent.close()">Close</b-button>
        <b-button class="is-text card-footer-item" @click="addBusiness" :disabled="NumberError">Add</b-button>
      </footer>
    </div>
</template>

<script>
import {mapActions} from 'vuex';
export default {
  data() {
    return {
      newBusiness: {
        businessname: "",
        businessno: "",
        businessadd: ""
      },
      NumberError: false,
      NameError: false,
      isLoading: false,
    };
  },
  methods: {
      ...mapActions(['postBusiness']),
    async addBusiness() {
        this.isLoading = true;
        var status = await this.postBusiness(this.newBusiness);
        this.isLoading = false;
        if (status == 409) {
            this.NameError = true;
            this.$buefy.toast.open('Business already exists!');
        } else if (status == 500) {
            this.$parent.close();
            this.$buefy.toast.open('Business added successfully!');
        }
    }
  },
  watch: {
    newBusiness: {
      handler(newVal) {
        if (newVal.businessno != "") {
           this.NumberError = !(newVal.businessno.match(/^[0-9]+$/));
        } else {
            this.NumberError = false;
        }
      },
      deep: true
    }
  }
};
</script>