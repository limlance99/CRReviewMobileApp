<template>
  <div id="app">
    <section class="hero is-primary is-small">
      <div class="hero-head">
        <b-navbar type="is-primary">
          <template slot="brand">
            <b-navbar-item tag="router-link" :to="{ path: '/' }">
              <img :src="logo" alt="LOGO" />
            </b-navbar-item>
          </template>
          <template slot="start">
            <b-navbar-item tag="router-link" to="/crs">CRs</b-navbar-item>
            <!-- <b-navbar-item tag="router-link" to="/routes">Database</b-navbar-item> -->
          </template>

          <template slot="end">
            <b-navbar-dropdown label="Tables" hoverable>
              <b-navbar-item tag="router-link" to="/crs">CRs</b-navbar-item>
            </b-navbar-dropdown>
          </template>
        </b-navbar>
      </div>

      <!-- Hero content: will be in the middle -->
      <div class="hero-body">
        <section class="section">
          <div class="container">
            <figure class="image is-128x128 center">
              <img :src="logo" />
            </figure>
            <h1 class="title has-text-centered">UP CR Review</h1>
            <h2 class="subtitle has-text-centered">Ah.</h2>
          </div>
        </section>
      </div>
    </section>
    <router-view />
    <footer class="footer">
        <figure class="image is-64x64 center">
          <img :src="turtle" alt="Turtle" />
        </figure>
      <div class="content has-text-centered">
        <p>
          <strong>A project</strong> by JV Afable, JP Chanchico, and Lance Lim.
        </p>
      </div>
    </footer>
  </div>
</template>

<script>
export default {
  data() {
    return {
      logo: require("@/assets/launchlogo.png"),
      turtle: require("@/assets/turtlez.png")
    };
  }
};
</script>

<style lang="scss">
@import "~bulma/sass/utilities/_all";

// Set your colors
$primary: #000000;
$primary-invert: findColorInvert($primary);

$whoabackground: #95A844;
$whoabackground-invert: findColorInvert($whoabackground);

$twitter: #4099ff;
$twitter-invert: findColorInvert($twitter);

// Setup $colors to use as bulma classes (e.g. 'is-twitter')
$colors: (
  "white": (
    $white,
    $black
  ),
  "black": (
    $black,
    $white
  ),
  "light": (
    $light,
    $light-invert
  ),
  "dark": (
    $dark,
    $dark-invert
  ),
  "primary": (
    $primary,
    $primary-invert
  ),
  "info": (
    $info,
    $info-invert
  ),
  "success": (
    $success,
    $success-invert
  ),
  "warning": (
    $warning,
    $warning-invert
  ),
  "danger": (
    $danger,
    $danger-invert
  ),
  "twitter": (
    $twitter,
    $twitter-invert
  ),
  "whoabackground": (
    $whoabackground,
    $whoabackground-invert
  )
);

// Links
$link: $primary;
$link-invert: $primary-invert;
$link-focus-border: $primary;
$navbar-dropdown-background-color: $black;
$footer-padding: 3rem 1.5rem 3rem;

.center {
  display: block;
  margin-left: auto;
  margin-right: auto;
  width: 50%;
}
// Import Bulma and Buefy styles
@import "~bulma";
@import "~buefy/src/scss/buefy";
</style>
