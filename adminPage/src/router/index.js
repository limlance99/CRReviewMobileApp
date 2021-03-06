/*
Authors: JV Afable, JP Chanchico, Lance Lim

This is a course requirement for CS 192 Software Engineering II
under the supervision of Asst. Prof. Ma. Rowena C. Solamo of
the Department of Computer Science, College of Engineering,
University of the Philippines, Diliman for the AY 2019-2020.

Code History:
  Feb 27, 2020: Lance Lim - Initialized file.
  March 10, 2020: Lance Lim - Added authorization redirection.
*/

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
    path: '/login',
    name: 'login',
    component: () => import('@/views/Login.vue')
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

router.beforeEach((to, from, next) => {
  // redirect to login page if not logged in and trying to access a restricted page
  const publicPages = ['/login'];
  const authRequired = !publicPages.includes(to.path);
  const loggedIn = localStorage.getItem('user');

  if (authRequired && !loggedIn) {
    return next('/login');
  } else if (!authRequired && loggedIn) {
    return next('/');
  }

  next();
})
export default router
