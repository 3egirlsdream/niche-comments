<template>
  <div class="text-center">
    <v-card class="mx-2 px-2 py-2">
      <v-form ref="form" v-model="valid" :lazy-validation="lazy">

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

        <v-btn :disabled="!valid" color="success" class="mr-4" @click="validate">
          Validate
        </v-btn>

        <v-btn color="error" class="mr-4" @click="computeResult">
          Reset Form
        </v-btn>
      </v-form>
    </v-card>
    <v-dialog v-model="showAddItem" persistent class="justify-center">

      <v-card style="text-align:center;" class="py-2 px-2">
        <v-form ref="form" v-model="valid" :lazy-validation="lazy">
          <v-text-field v-model="newItem.project" :counter="10" :rules="nameRules" label="菜名" required class="mx-2"></v-text-field>
          <v-rating v-model="newItem.stars" :length="newItem.total" :half-increments="true" color="yellow accent-4"></v-rating>
          <v-file-input chips multiple label="File input w/ chips" style="overflow-x:hidden"></v-file-input>
          <v-btn color="warning" @click="addNewItem">
            添加
          </v-btn>
        </v-form>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  data: () => ({
    showAddItem: false,
    rating: 1,
    valid: true,
    name: "",
    nameRules: [
      (v) => !!v || "Name is required",
      (v) => (v && v.length <= 10) || "Name must be less than 10 characters",
    ],
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
    },
    score: "0",
    slides: [
          'First',
          'Second',
          'Third',
          'Fourth',
          'Fifth',
        ],
        cycle: false,
         colors: [
          'green',
          'secondary',
          'yellow darken-4',
          'red lighten-2',
          'orange darken-1',
        ],
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
  },
};
</script>