import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    officers: [],
    duty: false,
    identifier: '0',
    citizenId: '',
    pvehicles: [],
    activePerson: {},
  },
  mutations: {
  },
  actions: {
    setMdtData({ state }, data) {
      state.officers = Object.values(data.officers)
      state.duty = data.duty
      state.identifier = data.identifier
      state.citizenId = data.citizenId
      state.pvehicles = Object.values(data.pvehicles)
    },
    updateOfficer({ state }, data) {
      if(state.citizenId == data.citId){
        state.duty =  data.officer.onDuty;
      }
      for (const officer of state.officers) {
        if(officer.citizenid == data.citId){
          officer.onDuty =  data.officer.onDuty
          officer.radio =  data.officer.radio
          console.log(officer)
          return
        }
      }
    },
    updatePvehicles({ state }, data) {
      state.pvehicles = Object.values(data.pvehicles)
    },
    recordRequest({ state }, data) {
      console.log(data)
      state.activePerson = data.activePerson
    },
  },
  modules: {
  }
})
