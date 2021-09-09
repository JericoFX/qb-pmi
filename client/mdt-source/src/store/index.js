import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    officers: [],
    duty: false,
    identifier: '0',
  },
  mutations: {
  },
  actions: {
    setMdtData({ state }, data) {
      console.log(data)
      state.officers = Object.values(data.officers)
      state.duty = data.duty
      state.identifier = data.identifier
    }
  },
  modules: {
  }
})
