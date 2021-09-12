<template>
  <v-container fluid style="min-height: 71vh">
    <v-row>
      <v-col md="4" class="pr-0">
        <v-card dark class="elevation-1 ml-4 mr-4 overflow-y-auto" max-height="68vh">
          <v-card-title>
            People
            <v-spacer></v-spacer>
            <v-text-field
              style="top: 12px"
              dense
              label="Search"
              color="primary"
              outlined
            ></v-text-field>
            <v-tooltip bottom>
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  icon
                  depressed
                  color="primary"
                  @click="toggleDuty"
                  v-bind="attrs"
                  v-on="on"
                >
                  <v-icon>mdi-fingerprint</v-icon>
                </v-btn>
              </template>
              <span>Search by print</span>
            </v-tooltip>
            <v-tooltip bottom>
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  icon
                  depressed
                  color="primary"
                  @click="toggleDuty"
                  v-bind="attrs"
                  v-on="on"
                >
                  <v-icon>mdi-account</v-icon>
                </v-btn>
              </template>
              <span>Search by name</span>
            </v-tooltip>
            <v-tooltip bottom>
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  icon
                  depressed
                  color="primary"
                  @click="toggleDuty"
                  v-bind="attrs"
                  v-on="on"
                >
                  ID
                </v-btn>
              </template>
              <span>Search by ID</span>
            </v-tooltip>
          </v-card-title>
          <v-data-table
            :headers="peopleHeaders"
            :items="people"
            :items-per-page="10"
            sort-by="onDuty"
            dark
            sort-desc
          >
            <template v-slot:[`item.actions`]="{ item }">
              <v-btn
                icon
                depressed
                color="primary"
                @click="getPersonRecords(item)"
                v-bind="attrs"
                v-on="on"
              >
                <v-icon>mdi-magnify</v-icon>
              </v-btn>
            </template>
          </v-data-table>
        </v-card>
      </v-col>
      <v-col md="4" class="pl-0 pr-0">
        <v-card elevation="1" dark max-height="68vh" class="overflow-y-auto">
          <v-card-title>
            {{ activePerson.name }}
          </v-card-title>
          <v-card-subtitle>
            {{ activePerson.char.nationality }} {{ activePerson.gender }},
            {{ age(activePerson.char.birthdate) }} years old
          </v-card-subtitle>
          <v-container class="pt-0">
            <v-row>
              <v-col></v-col>
              <v-col cols="auto" justify="end" align="right">
                <v-card
                  style="right: 0"
                  color="white"
                  elevation="1"
                  max-height="270"
                  max-width="250"
                  ><v-img :src="activePerson.record.mugshot_url"></v-img
                ></v-card>
              </v-col>
            </v-row>
          </v-container>
          <v-card-actions>
            <v-btn class="ma-2" outlined color="primary">
              Issue Ticket
            </v-btn>
            <v-btn class="ma-2" outlined color="primary">
              Create Report
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
      <v-col md="4">
        <v-card elevation="1" dark max-height="68vh" class="overflow-y-auto">
          <v-card-title> Report </v-card-title>
          <v-card-subtitle> </v-card-subtitle>
          <v-card-actions> </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapState, mapActions } from "vuex";
export default {
  name: "Person",

  data() {
    return {
      peopleHeaders: [
        {
          text: "Name",
          align: "start",
          value: "name",
        },
        { text: "Phone no", value: "phone" },
        { text: "ID", value: "citizenid" },
        { text: "", value: "actions" },
      ],
      people: [
        {
          name: "Tia-Sun Li",
          phone: "0688928688",
          citizenid: "UPP60694",
        },
      ],
    };
  },

  computed: {
    ...mapState(["activePerson"]),
  },

  methods: {
    age(birthdate) {
      var today = new Date();
      var birthDate = new Date(birthdate);
      var age = today.getFullYear() - birthDate.getFullYear();
      var m = today.getMonth() - birthDate.getMonth();
      if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
        age--;
      }
      return age;
    },
  },

  components: {},
};
</script>
