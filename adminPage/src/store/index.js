/*
Authors: JV Afable, JP Chanchico, Lance Lim

This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.

Code History:
  Feb 27, 2020: Lance Lim - Initialized file.
  Mar 10, 2020: Lance Lim - Added authorization.
*/

import Vue from 'vue'
import Vuex from 'vuex'
import axios from "axios"

Vue.use(Vuex)

const localTestURL = "https://crreviewapi.herokuapp.com"

const state = {
  CRList: [],
  ReviewList: [],
  token: localStorage.getItem('user'),
}

const getters = {
  ListofCRs: (state) => state.CRList,
  ListofReviews: (state) => state.ReviewList,
  JWTToken: (state) => state.token,
}

const actions = {
  async adminLogin({ commit }, form) {
    var username = form.username;
    var password = form.password;

    var formData = new FormData();
    formData.append("username", username);
    formData.append("password", password);

    var response;
    try  {
      response = await axios.post(`${localTestURL}/login`, formData);

      commit('setToken', response.data.token);
      return 200;
    }
    catch (err) {
      return err.response.status;
    }
    
  },
  async fetchTable({ commit }, details) {
    var table = details.table;
    var response;
    try {
      if (table == "crs") {
        response = await axios.get(`${localTestURL}/api/crs`);
        commit('setCRs', response.data);
      } else if (table == "reviews") {
        response = await axios.get(`${localTestURL}/api/reviews/${details.id}`)
        commit('setReviews', response.data.reviews);
      }
      return 200;
    }
    catch (err) {
      return err.response.status;
    }
  },
  async deleteCR({ commit }, crid) {
    var headers = {
      Authorization: `Bearer ${localStorage.getItem('user')}`
    }
    let config = {
      headers
    }
    var response = await axios.delete(`${localTestURL}/admin/crs/${crid}`, config);
    if (response.status == 200) {
      commit("deleteTheCR", crid);
      return true;
    } else {
      return false;
    }
  },
  async deleteReview({ commit }, reviewid) {
    var headers = {
      Authorization: `Bearer ${localStorage.getItem('user')}`
    }
    let config = {
      headers
    }
    var response = await axios.delete(`${localTestURL}/admin/reviews/${reviewid}`, config);
    if (response.status == 200) {
      commit("deleteTheReview", reviewid);
      return true;
    } else return false;
  }
}

const mutations = {
  setCRs: (state, data) => state.CRList = data,
  setToken: (state, token) => {
    localStorage.setItem('user', token);
    state.token = token;
  },
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
