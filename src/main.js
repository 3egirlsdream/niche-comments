import Vue from 'vue'
import App from './App.vue'
import vuetify from './plugins/vuetify'
Vue.config.productionTip = false
if (window.location.hostname == 'localhost') {
  Vue.prototype.$base = 'https://localhost:44389'
}
else {
  Vue.prototype.$base = 'http://47.107.186.141:4396'
}
new Vue({
  vuetify,
  render: h => h(App)
}).$mount('#app')
