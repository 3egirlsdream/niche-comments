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
      <card/>
      <v-dialog v-model="showAdd" width="100vw" height="90vh">
        <add-comments @submit="showAdd = false"/>
      </v-dialog>
      
      <v-bottom-navigation
      scroll-target="#scroll-area-2"
      hide-on-scroll
      absolute
      color="primary"
    >
      <v-btn  @click="showAdd = true">
         <span>新增评价</span>
        <v-icon dark>mdi-plus</v-icon>
      </v-btn>
    </v-bottom-navigation>
    </v-main>
  </v-app>
</template>

<script>
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
  }),
};
</script>
