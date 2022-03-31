const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const enumAccountType = ["customer", "laundry"];
      
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
  firstName: {
    type: String,
    required: [true, "firstName is required"],
  },
  lastName: {
    type: String,
    required: [true, "lastName is required"],
  },
  bio: { type: String },
  img: {
    avatar: { type: String},
    banner: { type: String}
  },
  address: {
    name: {
      type: String,
      //required: [true, "name is required"],
    },
    coordinates: {
      latitude: {
        type: String,
        //required: [true, "latitude is required"],
      },
      longitude: {
        type: String,
        // required: [true, "longitude is required"],
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
  verified: {
    type: Boolean,
    required: [true, "verified status is required"],
  },
  date: {
    createdAt: {
      type: Date,
      default: Date.now,
    },
    updatedAt: {
      type: Date,
    }
  }
});

module.exports = Profile = mongoose.model("profiles", ProfileSchema);
