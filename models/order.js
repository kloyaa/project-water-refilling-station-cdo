const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const enumOrderStatus = [
    "pending", 
    "in-progress", 
    "ready", 
    "to-pick-up", 
    "picked-up", 
    "delivered", 
    "cancelled"
];

const OrderSchema = new Schema({
    refNumber: {
        type: String,
        required: [true, "orderId is required"],
    },
    header: {
        customer: {
            accountId: {
                type: String,
                required: [true, "customer accountId is required"],
            },
            avatar: {
                type: String,
                required: [true, "customer avatar is required"],
            },
            firstName: {
                type: String,
                required: [true, "customer firstName is required"],
              },
            lastName: {
                type: String,
                required: [true, "customer lastName is required"],
            },
            contactNo: {
                type: String,
                required: [true, "customer contactNo is required"],
            },
            address: {
                type: String,
                required: [true, "customer address is required"],
            }
        },
        laundry: {
            accountId: {
                type: String,
                required: [true, "laundry accountId is required"],
            },
            banner: {
                type: String,
                required: [true, "laundry banner is required"],
            },
            name: {
                type: String,
                required: [true, "laundry name is required"],
            },
            contactNo: {
                type: String,
                required: [true, "laundry contactNo is required"],
            },
            address: {
                type: String,
                required: [true, "laundry address is required"],
            }
        },
    },
    content: {
        addOns: { type: Array },
        description: {
            type: String,
            required: [true, "description is required"],
        },
        weight: {
            type: String,
            required: [true, "weight is required"],
        },
        total: {
            type: String,
            required: [true, "total is required"],
        }
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
    status: {
        type: String,
        required: [true, "status is required"],
        enum: enumOrderStatus,
    }
});

//VALIDATE
OrderSchema.path('content.addOns').validate((data) => data.length >= 1, 'Length must be >= 1');

module.exports = Order = mongoose.model("orders", OrderSchema);
