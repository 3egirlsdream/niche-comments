<template>
  <v-app>
    <v-app-bar app color="primary" dark>
      <div class="d-flex align-center">
        <v-icon large color="#aeddff darken-2">mdi-food</v-icon>

        <v-img alt="Vuetify Name" class="shrink mt-1 hidden-sm-and-down" contain min-width="100" src="https://cdn.vuetifyjs.com/images/logos/vuetify-name-dark.png" width="100" />
      </div>

      <v-spacer></v-spacer>

      <v-btn href="" target="_blank" text>
        <span class="mr-2">小众点评</span>
        <v-icon color='orange'>mdi-food-drumstick</v-icon>
      </v-btn>
    </v-app-bar>

    <v-main class="mt-2" style="text-align:center;">
      <card v-for="(item, i) in list" :key="i" :item="item" @refresh="init"/>
      <v-dialog v-model="showAdd" width="100vw" height="90vh">
        <add-comments @submit="showAdd = false" @refresh="init"/>
      </v-dialog>
    </v-main>
    <section
      class="footer"
      style="position: fixed; bottom: 0px; width: 100%;text-align: center;overflow: hidden;"
    >
     <v-bottom-navigation
      color="primary"
    >
      <v-btn  @click="showAdd = true">
         <span>新增评价</span>
        <v-icon dark>mdi-plus</v-icon>
      </v-btn>
    </v-bottom-navigation>
    </section>
  </v-app>
</template>

<script>
import axios from 'axios';
import card from "./components/card.vue";
import addComments from "./components/add-comment.vue";
export default {
  name: "App",

  components: {
    card,
    addComments,
  },

  data: () => ({
    showAdd: false,
    list:[],
  }),

  methods:{
    init(){

      let url = this.$base + '/api/NicheComments/GetList';
      axios.get(url).then((res)=>{
        if(res.data.success){
          this.list = res.data.data;
          for(let i = 0; i < this.list.length;i++){
            let item = this.list[i];
             if(item.DETAILS.length > 0 && item.DETAILS[0].atts.length > 0){
                item.att = 'http://cdn.endingisnihility.xyz/' + item.DETAILS[0].atts[0].CDN;
              }
              else{
                item.att = 'https://cdn.vuetifyjs.com/images/cards/sunshine.jpg'
              }
          }
        }
        else{
          alert(res.message.content)
        }
      })
    },
  },
  mounted(){
    this.init();
  }
};
</script>
