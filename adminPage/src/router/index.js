import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('@/views/Home.vue')
  },
  {
    path: '/crs',
    name: "CRs",
    component: () => import('@/views/CRs.vue'),
  },
  {
    path: '/reviews/:crid',
    name: "Reviews",
    props: true,
    component: () => import('@/views/Reviews.vue'),
  },
  {
    path: '*',
    name: "NotFound",
    component: () => import('@/views/NotFound.vue'),
  },
  
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
