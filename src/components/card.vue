<template>
  <v-card class="mx-2 my-2">
    <v-carousel :show-arrows="false" height="200">
      <v-carousel-item
        v-for="(src,i) in item.URLS"
        :key="i"
        :src="'http://cdn.endingisnihility.xyz/' + src"
      ></v-carousel-item>
    </v-carousel>
    <!-- <v-img :src="item.att" height="200px" @click="show = !show"></v-img> -->
  
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
          <font style="width:70px">环境</font>
          <v-rating v-model="item.ENVIRONMENT_SCORE" :length="5" :half-increments="false" color="yellow accent-4" readonly></v-rating>
        </v-subheader>
        <v-subheader>
          <font style="width:70px">其他</font>
          <v-rating v-model="item.OTHER_SCORE" :length="5" :half-increments="false" color="yellow accent-4" readonly></v-rating>
        </v-subheader>
        
        <v-subheader v-for="(im, i) in item.DETAILS" :key="i">
          <font style="width:70px">{{im.project}}</font>
          <v-rating v-model="im.stars" :length="5" :half-increments="true" color="yellow accent-4" readonly></v-rating>
          <v-icon v-for="(em, i) in im.score" :key="i" color="purple darken-4" v-text="`mdi-numeric-${em}-box`"></v-icon>
        </v-subheader>
        <v-card-actions>
          <v-btn @click="add(item)" color="primary">新增</v-btn>
          <v-spacer></v-spacer>
          <v-btn @click="deleted = true" color="error">删除</v-btn>
        </v-card-actions>
        <v-dialog v-model="deleted" persistent max-width="290">
          <v-card>
            <v-card-title><v-icon>mdi-delete</v-icon>删除确认?</v-card-title>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="green darken-1" text @click="deleted = false">取消</v-btn>
              <v-btn color="green darken-1" text @click="deleted = false, del(item.ID)">确定</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
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
    deleted:false,
    show: false,
  }),
  methods: {
    add(item){
      this.$emit('add', item);
    },
    del(id) {
      let url = this.$base + "/api/NicheComments/Delete?ID=" + id;
      axios.get(url).then((res) => {
        if (!res.data.success) {
         this.$emit('toast', res.data.message.content);
         this.$emit('refresh')
        }
        else{
          this.$emit('toast', '删除成功！');
          this.$emit('refresh')
        }
      });
    },
  },
  created() {
    let base = this.item.ENVIRONMENT_SCORE * 0.1 / 5 + this.item.OTHER_SCORE * 0.1 / 5;
    for(let i = 0; i < this.item.DETAILS.length;i++){
      let e = this.item.DETAILS[i];
      e.show = true;
      e.score = ((e.stars * 2 * 0.8 / 10 + base) * 100).toFixed(0).toString();
    }
    console.log(this.item);
  },
};
</script>

