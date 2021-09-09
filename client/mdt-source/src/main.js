import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import vuetify from './plugins/vuetify'

Vue.config.productionTip = false

var mdt = new Vue({
  router,
  store,
  vuetify,
  render: h => h(App)
}).$mount('#app')

document.onkeyup = function(data) {
  if (data.code == "Escape") {
    mdt.$children[0].closeMDT();
  }
};