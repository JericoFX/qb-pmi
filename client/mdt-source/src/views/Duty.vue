<template>
  <v-container fluid style="min-height: 71vh">
    <v-row>
      <v-col>
      <v-data-table
        :headers="headers"
        :items="officers"
        :items-per-page="10"
        class="elevation-1 pa-4 ml-4 mr-4"
        sort-by="onDuty"
        dark
        sort-desc
      >
      <template v-slot:[`item.onDuty`]="{ item }">
          <v-icon v-if="item.onDuty" color="green">mdi-checkbox-blank-circle</v-icon>
        <v-icon v-else color="red">mdi-checkbox-blank-circle</v-icon>
        </template>
      </v-data-table>
      </v-col>
      <v-col>
      </v-col>
  </v-container>
</template>

<script>
import { mapState, mapActions } from "vuex";
export default {
  name: "Duty",

  data() {
    return {
      headers: [
        {
          text: "Duty",
          align: "start",
          value: "onDuty",
        },
        { text: "Callsign", value: "callsign" },
        { text: "First Name", value: "firstname" },
        { text: "Last Name", value: "lastname" },
        { text: "Phone", value: "phone" },
        { text: "ID", value: "citizenid" },
      ],
    };
  },

  computed: {
    ...mapState(["officers"]),
  },

  methods: {},

  components: {},
};
</script>
