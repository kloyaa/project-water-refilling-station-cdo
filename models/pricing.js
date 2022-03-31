const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const PricingSchema = new Schema({
    accountId: {
        type: String,
        required: [true, "accountId is required"],
    },
    pricing: {
        type: String,
        required: [true, "pricing is required"],
    }
});

module.exports = Pricing = mongoose.model("pricings", PricingSchema);
