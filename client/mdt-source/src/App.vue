<template>
  <v-app v-show="display">
    <v-container fluid style="padding: 7%; max-height: 100vh">
      <v-system-bar color="primary" dark>
        <v-spacer></v-spacer>
        <v-icon v-if="duty" color="green">mdi-checkbox-blank-circle</v-icon>
        <v-icon v-else color="red">mdi-checkbox-blank-circle</v-icon>
        <span v-if="duty" class="pr-1">On Duty</span>
        <span v-else class="pr-1">Off Duty</span>
        <span class="pr-1">#{{ identifier }}</span>
        <span>{{ time }}</span>
      </v-system-bar>
      <v-card
        tile
        class="overflow-y-auto"
        style="max-height: calc(100vh - 39%)"
      >
        <v-row :class="layout">
          <v-col
            class="ma-0 pl-3 pr-10"
            cols="auto"
            style="background-color: #2a2a2a"
          >
            <NavBar style="position: fixed" />
          </v-col>
          <v-col :class="layout">
            <router-view style="background-color: #2a2a2a" />
          </v-col>
        </v-row>
      </v-card>
    </v-container>
  </v-app>
</template>

<script>
import Nui from "./utils/Nui";
import testData from "./utils/testData"
import NavBar from "./components/NavBar.vue";
import { mapState, mapActions } from "vuex";
export default {
  name: "App",
  components: {
    NavBar,
  },

  data: () => ({
    layout: "pa-0 ma-0",
    display: false,
  }),

  methods: {
    ...mapActions(["setMdtData", "updateDuty", "updatePvehicles", "recordRequest"]),
    closeMDT() {
      Nui.send("close");
      this.display = false;
    },
  },

  computed: {
    ...mapState(["identifier", "duty"]),
    time() {
      return new Date().toLocaleString("en-GB").substring(11, 17);
    },
  },

  destroyed() {
    window.removeEventListener("message", this.listener);
  },

  mounted() {
    this.$vuetify.theme.themes.light = {
      primary: "#1976D2",
      secondary: "#424242",
      accent: "#82B1FF",
      error: "#FF5252",
      info: "#2196F3",
      success: "#4CAF50",
      warning: "#FFC107",
    };

    document.onreadystatechange = () => {
      if (document.readyState == "complete") {
        window.addEventListener("message", (event) => {
          var eld = event.data;

          if (eld.open) {
            this.display = true;
            this.setMdtData(eld);
          }
          if (eld.close) {
            this.display = false;
          }
          if(eld.type == "dutyUpdate"){
            this.updateDuty(eld)
          }
          if(eld.type == "pvehiclesUpdate"){
            this.updatePvehicles(eld)
          }
          if(eld.type == "recordRequestResult"){
            this.recordRequest(eld)
          }
          
        });
      }
    };

    if (process.env.NODE_ENV === "development") {
      this.display = true;
      testData.populate();
    }
  },
};
</script>
<style>
@import url("https://fonts.googleapis.com/css2?family=Fugaz+One&display=swap");
.fugaz {
  font-family: "Fugaz One";
}
::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}
/* Track */
::-webkit-scrollbar-track {
  background: #2a2a2a;
}
/* Handle */
::-webkit-scrollbar-thumb {
  -webkit-border-radius: 6px;
  border-radius: 6px;
  background: rgba(33, 150, 243, 1);
  -webkit-box-shadow: inset 0 0 6px rgba(255, 255, 255, 0.5);
}
::-webkit-scrollbar-thumb:window-inactive {
  background: rgba(33, 150, 243, 1);
}
</style>