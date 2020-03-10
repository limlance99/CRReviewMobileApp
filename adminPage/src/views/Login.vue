<!--
Authors: JV Afable, JP Chanchico, Lance Lim

This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.

Code History:
	March 10, 2020: Lance Lim - Initialized file.
-->

<template>
  <div class="modal-card" style="width:300px;">
    <form v-on:submit.prevent="Login">
      <section class="modal-card-body">
        <b-field label="Username">
          <b-input v-model="username" placeholder="Your username" required></b-input>
        </b-field>

        <b-field label="Password">
          <b-input
            v-model="password"
            type="password"
            password-reveal
            placeholder="Your password"
            required
          ></b-input>
        </b-field>
      </section>
      <footer class="modal-card-foot">
        <button class="button is-primary" @click="Login" @keyup.enter="Login">Login</button>
        <p id="errorMessage" v-if="hasError">Invalid username or password.</p>
      </footer>
      <b-loading :active.sync="isLoading"></b-loading>
    </form>
  </div>
</template>

<script>
import { mapActions } from "vuex";
export default {
  name: "home",
  data() {
    return {
      username: "",
      password: "",
      isLoading: false,
      hasError: false
    };
  },
  methods: {
    ...mapActions(["adminLogin"]),
    async Login() {
      this.isLoading = true;
      var form = {
        username: this.username,
        password: this.password
      };
      var status = await this.adminLogin(form);
      if (status != 200) {
        this.hasError = true;
      } else {
        this.hasError = false;
        this.$router.push("/");
      }

      this.isLoading = false;
    }
  }
};
</script>

<style scoped>
#errorMessage {
  color: red;
}
</style>