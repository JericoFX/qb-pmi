<template>
  <v-container fluid style="min-height: 71vh">
    <v-row>
      <v-col>
        <v-card dark class="elevation-1 ml-4 mr-4">
          <v-card-title>
            Officers
            <v-spacer></v-spacer>
            <v-btn depressed color="primary" @click="toggleDuty">
              On/Off Duty
            </v-btn>
          </v-card-title>
          <v-data-table
            :headers="officerHeaders"
            :items="officers"
            :items-per-page="10"
            sort-by="onDuty"
            dark
            sort-desc
          >
            <template v-slot:[`item.onDuty`]="{ item }">
              <v-icon v-if="item.onDuty" color="green"
                >mdi-checkbox-blank-circle</v-icon
              >
              <v-icon v-else color="red">mdi-checkbox-blank-circle</v-icon>
            </template>
          </v-data-table>
        </v-card>
      </v-col>
      <v-col>
        <v-card dark class="elevation-1 ml-4 mr-4">
          <v-card-title>
            Vehicles in service
            <v-spacer></v-spacer>
          </v-card-title>
          <v-data-table
            :headers="pvehicleHeaders"
            :items="pvehicles"
            :single-expand="false"
            :expanded.sync="expanded"
            item-key="plate"
            show-expand
            dark
          >
            <template v-slot:expanded-item="{ headers, item }">
              <td :colspan="headers.length" style="background-color: #333333">
                <v-simple-table style="background-color: #333333">
                  <template v-slot:default>
                    <thead>
                      <tr>
                        <th class="text-left">Duty</th>
                        <th class="text-left">Callsign</th>
                        <th class="text-left">Name</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr v-for="occupant in item.occupants" :key="occupant">
                        <td>
                          <v-icon
                            v-if="officerFromId(occupant).onDuty"
                            color="green"
                            >mdi-checkbox-blank-circle</v-icon
                          >
                          <v-icon v-else color="red"
                            >mdi-checkbox-blank-circle</v-icon
                          >
                        </td>
                        <td>{{ officerFromId(occupant).callsign }}</td>
                        <td>
                          {{
                            officerFromId(occupant).firstname +
                            " " +
                            officerFromId(occupant).lastname
                          }}
                        </td>
                      </tr>
                    </tbody>
                  </template>
                </v-simple-table>
              </td>
            </template>
            <template v-slot:[`item.actions`]="{ item }">
              <v-btn v-if="inVehicle(item)" icon color="red" @click="toggleInVehicle(item, false)">
                <v-icon>mdi-car-arrow-right</v-icon>
              </v-btn>
              <v-btn v-else icon color="green" @click="toggleInVehicle(item, true)">
                <v-icon>mdi-car-arrow-left</v-icon>
              </v-btn>
              <v-btn icon color="orange" @click="storeVehicle(item)">
                <v-icon>mdi-garage-alert</v-icon>
              </v-btn>
            </template>
          </v-data-table>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapState, mapActions } from "vuex";
import Nui from "../utils/Nui";
export default {
  name: "Duty",

  data() {
    return {
      officerHeaders: [
        {
          text: "Duty",
          align: "start",
          value: "onDuty",
        },
        { text: "Callsign", value: "callsign" },
        { text: "First Name", value: "firstname" },
        { text: "Last Name", value: "lastname" },
        { text: "Phone", value: "phone" },
        { text: "Radio", value: "radio" },
      ],
      pvehicleHeaders: [
        {
          text: "Plate",
          align: "start",
          value: "plate",
        },
        { text: "Vehicle", value: "model" },
        { text: "Owner Name", value: "ownerName" },
        { text: "Owner Callsign", value: "ownerCallSign" },
        { text: "", value: "actions", align: "end", sortable: false,},
        { text: "", value: "data-table-expand" },
      ],
      expanded: [],
    };
  },

  computed: {
    ...mapState(["officers", "citizenId", "pvehicles"]),
  },

  methods: {
    toggleDuty() {
      Nui.send("dutyToggle");
    },
    officerFromId(citId) {
      for (const officer of this.officers) {
        if (officer.citizenid == citId) {
          return officer;
        }
      }
    },
    inVehicle(item){
      for (const occupant of item.occupants) {
        if(this.citizenId == occupant){
          return true
        }
      }
      return false;
    },
    storeVehicle(item){
      Nui.send("storeVehicle", item.plate);
    },
    toggleInVehicle(item, getIn){
      item.getIn = getIn;
      Nui.send("toggleInVehicle", item);
    },
  },

  components: {},
};
</script>
