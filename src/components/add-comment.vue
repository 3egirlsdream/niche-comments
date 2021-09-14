<template>
  <div class="text-center">
    <v-card class=" px-2 py-2">
      <v-form ref="form" v-model="valid" :lazy-validation="lazy">

        <v-text-field v-model="shopName" :rules="nameRules" label="店名" required class="mx-2"></v-text-field>
        <v-subheader>环境<v-rating v-model="base[0].stars" :length="base[0].total" :half-increments="base[0].half" color="yellow accent-4"></v-rating>
        </v-subheader>
        <v-subheader>其他<v-rating v-model="base[1].stars" :length="base[1].total" :half-increments="base[1].half" color="yellow accent-4"></v-rating>
        </v-subheader>

        <v-subheader>味道</v-subheader>

        <v-expansion-panels class="my-2">
          <v-expansion-panel v-for="(item,i) in taste" :key="i">
            <v-expansion-panel-header>
              {{item.project}}
              <template v-slot:actions>
                <v-icon v-for="(em, i) in item.score" :key="i" color="purple darken-4" v-text="`mdi-numeric-${em}-box`"></v-icon>
              </template>
            </v-expansion-panel-header>
            <v-expansion-panel-content>
              <v-rating v-model="item.stars" :length="item.total" :half-increments="item.half" color="yellow accent-4"></v-rating>
              <v-carousel :continuous="false" :cycle="cycle" :show-arrows="false" hide-delimiter-background delimiter-icon="mdi-minus" height="300">
                <v-carousel-item v-for="(slide, i) in slides" :key="i">
                  <v-sheet :color="colors[i]" height="100%" tile>
                    <v-row class="fill-height" align="center" justify="center">
                      <div class="display-3">{{ slide }} Slide</div>
                    </v-row>
                  </v-sheet>
                </v-carousel-item>
              </v-carousel>
            </v-expansion-panel-content>
          </v-expansion-panel>
        </v-expansion-panels>
        <v-btn class="mx-2" fab dark color="indigo" @click="showAddItem = true">
          <v-icon dark>mdi-plus</v-icon>
        </v-btn>
        <v-divider class="my-2" />

        <v-btn color="error" class="mx-2" :disabled="!shopName" @click="submitComment">
          保存
        </v-btn>
      </v-form>
    </v-card>
    <v-dialog v-model="showAddItem" persistent class="justify-center">

      <v-card style="text-align:center;" class="py-2 px-2">
        <v-form ref="form" v-model="valid" :lazy-validation="lazy">
          <v-text-field v-model="newItem.project" :rules="nameRules" label="菜名" required class="mx-2"></v-text-field>
          <v-rating v-model="newItem.stars" :length="newItem.total" :half-increments="true" color="yellow accent-4"></v-rating>
          <v-file-input chips multiple label="File input w/ chips" style="overflow-x:hidden" @change="uploadIMG"></v-file-input>
          <v-btn color="warning" @click="addNewItem" :disabled="!newItem.project">
            添加
          </v-btn>
        </v-form>
      </v-card>
    </v-dialog>
    <v-alert type="success" v-show="alert">
      {{message}}
    </v-alert>
  </div>
</template>

<script>
import axios from "axios";
export default {
  data: () => ({
    alert: false,
    shopName: null,
    showAddItem: false,
    rating: 1,
    valid: true,
    name: "",
    nameRules: [(v) => !!v || "不能为空"],
    email: "",
    emailRules: [
      (v) => !!v || "E-mail is required",
      (v) => /.+@.+\..+/.test(v) || "E-mail must be valid",
    ],
    select: null,
    items: ["Item 1", "Item 2", "Item 3", "Item 4"],
    checkbox: false,
    lazy: false,
    base: [
      { project: "环境", stars: 2, memo: "12", total: 5, half: false },
      { project: "其他", stars: 2, memo: "12", total: 5, half: false },
    ],
    taste: [],
    newItem: {
      project: "",
      stars: 2,
      memo: "12",
      total: 5,
      half: true,
      score: "0",
      atts: [],
    },
    score: "0",
    slides: ["First", "Second", "Third", "Fourth", "Fifth"],
    cycle: false,
    colors: [
      "green",
      "secondary",
      "yellow darken-4",
      "red lighten-2",
      "orange darken-1",
    ],
    token: "",
    filelist: [],
    message: "",
  }),
  watch: {
    base: {
      handler() {
        this.computeResult();
      },
      deep: true,
    },
    taste: {
      handler() {
        this.computeResult();
      },
      deep: true,
    },
  },
  methods: {
    validate() {
      this.$refs.form.validate();
    },
    reset() {
      this.$refs.form.reset();
    },
    addNewItem() {
      let _ = JSON.parse(JSON.stringify(this.newItem));
      this.taste.push(_);
      this.showAddItem = false;
    },
    computeResult() {
      let bs = (this.base[1].stars * 0.1) / 5 + (this.base[0].stars * 0.1) / 5;
      for (let i = 0; i < this.taste.length; i++) {
        this.taste[i].score = (
          (((this.taste[i].stars * 2) / 10) * 0.8 + bs) *
          100
        )
          .toFixed(0)
          .toString();
      }
    },
    addItem() {},
    submitComment() {
      let self = this;
      let data = {
        SHOP_NAME: this.shopName,
        ENVIRONMENT_SCORE: this.base[0].stars,
        OTHER_SCORE: this.base[1].stars,
        DETAILS: this.taste,
      };
      console.log(JSON.stringify(data));
      let url = this.$base + "/api/NicheComments/Submit";
      axios
        .post(url, data, {
          headers: {
            "Content-Type": "application/json",
          },
        })
        .then(function (response) {
          if (response != null && response.data.success) {
            self.$emit('toast',  "保存成功");
            self.$emit("refresh");
          }
        })
        .catch(function (error) {
          this.$emit('toast', error);
          this.$emit("refresh");
        });
      this.$emit("submit");
    },
    uploadIMG(e) {
      console.log(e);
      this.newItem.atts = [];
      for (let i = 0; i < e.length; i++) {
        this.upload(e[i]);
      }
    },
    upload(file) {
      let self = this;
      var formData = new FormData();
      formData.append("file", file);
      formData.append("token", this.token);
      axios({
        headers: {
          "content-type": "multipart/form-data",
        },
        method: "post",
        url: "http://up-z2.qiniup.com",
        data: formData,
      }).then(function (response) {
        if (response != null && response.data != null) {
          let _ = {
            MUSIC_NAME: file.name,
            ARTISTS: file.name,
            CDN: response.data.key,
            QUALITY: "SQ",
          };
          self.newItem.atts.push(_);
          //self.percent = parseInt(self.filelist.length / self.total * 100)
          self.$emit('toast', "上传成功");
        } else {
          self.$emit('toast', response.data.message.content);
        }
      });
    },
    getToken() {
      let self = this;
      axios
        .get("http://47.107.186.141:4396/api/Qiniu/GetToken")
        .then(function (response) {
          if (response != null) {
            self.token = response.data.data;
            console.log(response.data.data);
          }
        });
    },
  },
  mounted() {
    this.getToken();
  },
};
</script>