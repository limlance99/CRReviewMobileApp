import Vue from 'vue'
import Vuex from 'vuex'
import axios from "axios"

Vue.use(Vuex)

const localTestURL = "https://crreviewapi.herokuapp.com"

const state = {
  CRList: [],
  ReviewList: [],
}

const getters = {
  ListofCRs: (state) => state.CRList,
  ListofReviews: (state) => state.ReviewList,
}

const actions = {
  async fetchTable({ commit }, details) {
    var table = details.table;
    // var field = details.field;
    // var order = details.order;
    // console.log(details);
    var response;
    try {
      if (table == "crs") {
        response = await axios.get(`${localTestURL}/api/crs`);
        commit('setCRs', response.data);
      } else if (table == "reviews") {
        response = await axios.get(`${localTestURL}/api/reviews/${details.id}`)
        commit('setReviews', response.data.reviews);
      }
      return 500;
    }
    catch (err) {
      if (err.response) return err.response.status;
      else return err;
    }
  },
  async deleteCR({ commit }, crid) {
    var response = await axios.delete(`${localTestURL}/api/crs/${crid}`);
    console.log(response);
    if (response.status == 200) {
      commit("deleteTheCR", crid);
      return true;
    } else {
      return false;
    }
  },
  async deleteReview({ commit }, reviewid) {
    var response = await axios.delete(`${localTestURL}/api/reviews/${reviewid}`);
    if (response.status == 200) {
      commit("deleteTheReview", reviewid);
      return true;
    } else return false;
  }
}

const mutations = {
  setCRs: (state, data) => state.CRList = data,
  setReviews: (state, data) => state.ReviewList = data,
  deleteTheCR: (state, crid) => state.CRList = state.CRList.filter(x => x.id != crid),
  deleteTheReview: (state, reviewid) => state.ReviewList = state.ReviewList.filter(x => x.id != reviewid),
}
export default new Vuex.Store({
  state,
  getters,
  actions,
  mutations
})
