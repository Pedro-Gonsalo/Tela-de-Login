import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/Login.vue'

const routes = [
  {
    path: '/',
    name: 'home',
    component: Login
  },
  {
    path: '/cadastro',
    name: 'cadastro',
    component: () => import('../views/Cadastro.vue')
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
