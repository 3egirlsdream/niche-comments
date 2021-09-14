import Vue from 'vue'
import App from './App.vue'
import vuetify from './plugins/vuetify'
Vue.config.productionTip = false
if (window.location.hostname == 'localhost1') {
  Vue.prototype.$base = 'https://localhost:44389'
}
else {
  Vue.prototype.$base = 'http://42.194.131.197:4396'
}
new Vue({
  vuetify,
  render: h => h(App)
}).$mount('#app')
