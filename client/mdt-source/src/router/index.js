import Vue from 'vue'
import VueRouter from 'vue-router'
import Duty from '../views/Duty.vue'
import Person from '../views/Person.vue'
import Vehicles from '../views/Vehicles.vue'
import Warrants from '../views/Warrants.vue'
import Firearms from '../views/Firearms.vue'
import Impound from '../views/Impound.vue'


Vue.use(VueRouter)

const routes = [
  { path: '/', name: 'Duty', component: Duty},
  { path: '/person', name: 'Person', component: Person},
  { path: '/vehicles', name: 'Vehicles', component: Vehicles},
  { path: '/warrants', name: 'Warrants', component: Warrants},
  { path: '/firearms', name: 'Firearms', component: Firearms},
  { path: '/impound', name: 'Impound', component: Impound},
]

const router = new VueRouter({
  routes
})

export default router
