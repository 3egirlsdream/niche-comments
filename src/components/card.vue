<template>
  <v-card class="mx-2 my-2">
    <v-img :src="item.att" height="200px" @click="show = !show"></v-img>

    <v-card-title>
      {{item.SHOP_NAME}}
      <v-spacer></v-spacer>
      <v-btn icon @click="show = !show">
        <v-icon>{{ show ? 'mdi-chevron-up' : 'mdi-chevron-down' }}</v-icon>
      </v-btn>
    </v-card-title>

    <v-expand-transition>
      <div v-show="show">
        <v-divider></v-divider>

        <v-subheader>
          <font style="width:100px">环境</font>
          <v-rating v-model="item.ENVIRONMENT_SCORE" :length="5" :half-increments="false" color="yellow accent-4" readonly></v-rating>
        </v-subheader>
        <v-subheader>
          <font style="width:100px">其他</font>
          <v-rating v-model="item.OTHER_SCORE" :length="5" :half-increments="false" color="yellow accent-4" readonly></v-rating>
        </v-subheader>
        <v-subheader v-for="(im, i) in item.DETAILS" :key="i">
          <font style="width:100px">{{im.project}}</font>
          <v-rating v-model="im.stars" :length="5" :half-increments="true" color="yellow accent-4"></v-rating>
        </v-subheader>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn @click="del(item.ID)">删除</v-btn>
        </v-card-actions>
      </div>
    </v-expand-transition>
  </v-card>
</template>

<script>
import axios from "axios";
export default {
  props: {
    item: Object,
  },
  data: () => ({
    show: false,
  }),
  methods: {
    del(id) {
      let url = this.$base + "/api/NicheComments/Delete?ID=" + id;
      axios.get(url).then((res) => {
        if (!res.data.success) {
         alert(res.message.content);
         this.$emit('refresh')
        }
        else{
          alert('删除成功！')
          this.$emit('refresh')
        }
      });
    },
  },
  mounted() {
    console.log(this.item);
  },
};
</script>

