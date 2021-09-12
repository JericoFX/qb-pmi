<template>
  <v-card dark elevation="0">
    <v-navigation-drawer v-model="drawer" mini-variant dark>
      <v-list-item class="px-2">
        <v-list-item-avatar>
          <v-img src="https://i.imgur.com/LU4u0b5.jpg"></v-img>
        </v-list-item-avatar>

        <v-list-item-title>John Leider</v-list-item-title>

        <v-btn icon @click.stop="mini = !mini">
          <v-icon>mdi-chevron-left</v-icon>
        </v-btn>
      </v-list-item>

      <v-divider></v-divider>

      <v-list dense>
        <v-list-item
          v-for="item in items"
          :key="item.title"
          link
          @click="pageTo(item.link)"
        >
          <v-tooltip right>
            <template v-slot:activator="{ on, attrs }">
              <v-list-item-icon v-bind="attrs" v-on="on">
                <v-icon :color="activeItemColor(item.link)">{{ item.icon }}</v-icon>
              </v-list-item-icon>
            </template>
            <span>{{ item.title }}</span>
          </v-tooltip>

          <v-list-item-content>
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
  </v-card>
</template>
<script>
export default {
  data() {
    return {
      drawer: true,
      items: [
        { title: "Duty", icon: "mdi-police-badge", link: "/" },
        { title: "Person", icon: "mdi-account", link: "/person" },
        { title: "Vehicles", icon: "mdi-car", link: "/vehicles" },
        { title: "Warrants", icon: "mdi-alarm-light", link: "/warrants" },
        { title: "Firearms", icon: "mdi-pistol", link: "/firearms" },
        { title: "Impound", icon: "mdi-lock", link: "/impound" },
      ],
      mini: true,
    };
  },

  methods: {
    pageTo(link) {
      this.$router.push(link).catch(() => {});
    },
    activeItemColor(link){
      if(link == this.currentRouteName){
        return "primary"
      }else{
        return "white"
      }
    }
  },

  computed: {
    currentRouteName() {
      return this.$route.path;
    },
  },
};
</script>