import Vue from 'vue'
import Vuex from 'vuex'
import axios from "axios"

Vue.use(Vuex)

const localTestURL = "https://crreviewapi.herokuapp.com"

const state = {
  allRoutes: [
    {
      title: "Restrictions",
      link: "restrictions"
    },
    {
      title: "Conditions",
      link: "conditions"
    },
    {
      title: "Restrictions and Conditions",
      link: "resandconds"
    },
    {
      title: "Body Type",
      link: "bodytype"
    },
    {
      title: "Personal Details",
      link: "personaldetails"
    },
    {
      title: "Family Relations",
      link: "familyrelations"
    },
    {
      title: "Nationality",
      link: "nationality"
    },
    {
      title: "Person Information",
      link: "personinformation"
    },
    {
      title: "Businesses",
      link: "businesses"
    },
    {
      title: "Civil Status",
      link: "civilstatus"
    },
    {
      title: "Driver's License Application Form",
      link: "dlaf"
    },
  ],
  businessList: [],
  peopleList: [],
  CRList: [],
  ReviewList: [],
}

const getters = {
  apiRoutes: (state) => state.allRoutes,
  ListofBusinesses: (state) => state.businessList,
  ListofBusinessNames: (state) => {
    var names = [];
    for (let i = 0; i < state.businessList.length; i++) {
      names.push(state.businessList[i].businessname)
    }
    return names;
  },
  ListofPeople: (state) => state.businessList,
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
    catch(err) {
      if (err.response) return err.response.status;
      else return err;
    }
  },
  async postBusiness({ commit }, data) {
    var business = {
      businessname: data.businessname.trim(),
      businessno: data.businessno.trim(),
      businessadd: data.businessadd.trim(),
    }
    try {
      var response = await axios.post(`${localTestURL}/api/businesses`, business);
      commit("addBusiness", response.data);
      return 500;
    } catch(err) {
      return err.response.status;
    }
  },
  async putBusiness({commit}, data) {
    var response = await axios.put(`${localTestURL}/api/businesses`, data);
    commit("updateBusiness", response.data)
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
  setBusinesses: (state, data) => state.businessList = data,
  setCRs: (state, data) => state.CRList = data,
  setReviews: (state, data) => state.ReviewList = data,
  setPeople: (state, data) => state.peopleList = data,
  addBusiness: (state, data) => {

    for (let i = 0; i < state.businessList.length; i++) {
      if (state.businessList[i].businessname.toLowerCase() > data.businessname.toLowerCase()) {
        state.businessList.splice(i, 0, data);
        break;
      }
    }
  },
  updateBusiness: (state, data) => {
    for (let i = 0; i < state.businessList.length; i++) {
      if (state.businessList[i].businessname == data.businessname) {
        state.businessList[i].businessno = data.businessno;
        state.businessList[i].businessadd = data.businessadd;
        break;
      } 
    }
  },
  deleteTheCR: (state, crid) => state.CRList = state.CRList.filter(x => x.id != crid),
  deleteTheReview: (state, reviewid) => state.ReviewList = state.ReviewList.filter(x => x.id != reviewid),
}
export default new Vuex.Store({
  state,
  getters,
  actions,
  mutations
})
