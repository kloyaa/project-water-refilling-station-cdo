const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const enumAccountType = ["customer", "station"];
      
const ProfileSchema = new Schema({
  accountId: {
    type: String,
    required: [true, "accountId is required"],
  },
  accountType: {
    type: String,
    enum: enumAccountType,
    required: [true, "accountType is required"],
  },
  name: {
    first: {
      type: String,
      required: [true, "firstName is required"],
    },
    last: {
      type: String,
      required: [true, "lastName is required"],
    },
  },
  address: {
    name: {
      type: String,
      required: [true, "name is required"],
    },
    coordinates: {
      latitude: {
        type: String,
        required: [true, "latitude is required"],
      },
      longitude: {
        type: String,
        required: [true, "longitude is required"],
      },
    },
  },
  contact: {
    email: {
      type: String,
      // required: [true, "email is required"],
    },
    number: {
      type: String,
      //required: [true, "contactNo is required"],
    },
  },
  img: { type: String },
  date: {
    createdAt: {
      type: Date,
      default: Date.now,
    },
    updatedAt: {
      type: Date,
    }
  },
  visibility: { 
    type: Boolean,        
    required: [true, "visibility is required"],
  },
  verified: {
    type: Boolean,
    required: [true, "verified status is required"],
  },
  /*  
    * STATION PROPERTIES
    * ALL MUST BE OPTIONAL
    * USE ONLY IF ACCOUNT TYPE IS STATION
  */
  stationName: { type: String },
  serviceHrs: { type: String },

});

module.exports = Profile = mongoose.model("profiles", ProfileSchema);
