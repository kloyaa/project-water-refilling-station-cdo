const express = require("express");
const router = express.Router();

const order = require("../controllers/order/orderController");

// @path: api/order
// @Description: Create order
router.post("/order", (req, res) =>
    order.createOrder(req, res)
);

// @path: api/order
// @Description: Get orders
router.get("/order", (req, res) =>
    order.getOrders(req, res)
);

// @path: api/order
// @Description: Update order status
router.put("/order", (req, res) =>
    order.updateOrderStatus(req, res)
);

// @path: api/order/6242ee4393cf6a015647ce91
// @Description: Delete order
router.delete("/order/:id", (req, res) =>
    order.deleteOrder(req, res)
);

module.exports = router;
