const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const ListingSchema = new Schema({
    accountId: {
        type: String,
        required: [true, "accountId is required"],
    },
    title: {
        type: String,
        required: [true, "title is required"],
    },
    price: {
        type: String,
        required: [true, "price is required"],
    },
    availability: {
        type: Boolean,
        required: [true, "availability is required"],
    },
});

module.exports = Listing = mongoose.model("listings", ListingSchema);
