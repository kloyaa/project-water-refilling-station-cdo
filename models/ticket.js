const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const VerificationSchema = new Schema({
    accountId: {
        type: String,
        required: [true, "accountId is required"],
    },
    name: {
        first: {
            type: String,
            required: [true, "firstName required"],
        },
        last: {
            type: String,
            required: [true, "lastName required"],
        },
    },
    address: {
        type: String,
        required: [true, "address is required"],
    },
    contactNumber: {
        type: String,
        required: [true, "contactNumber is required"],
    },
    img: {
        type: String,
        required: [true, "img is required"],
    },
    date: {
        createdAt: {
            type: Date,
            default: Date.now,
        },
        updatedAt: {
            type: Date,
        },
    },
    description: {
        type: String,
        required: [true, "description is required"],
    },
    status: {
        type: String,
        enum: ["pending", "verified", "rejected"],
        required: [true, "status is required"],
    },
});

module.exports = Verification = mongoose.model("verifications", VerificationSchema);