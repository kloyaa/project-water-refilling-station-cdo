const Listing = require("../../models/listing");

const createListing = (req, res) => {
    try {
        return new Listing(req.body)
            .save()
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err.errors));
    } catch (error) {
        console.error(error);
    }
}

const getListings = (req, res) => {
    try {
        const accountId = req.query.accountId;
        const availability = req.query.availability;
        if(availability != undefined) {
            return Listing.find({ accountId, availability })
                    .sort({ _id: -1})
                    .then((value) => res.status(200).json(value))
                    .catch((err) => res.status(400).json(err));
        }
        return Listing.find({ accountId })
                .sort({ _id: -1})
                .then((value) => res.status(200).json(value))
                .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
}

const deleteListing = (req, res) => {
    try {
        const id = req.params.id;
        Listing.findByIdAndDelete(id)
            .then((value) => {
                if (!value) 
                    return res.status(400).json({ message: "_id not found" });
                return res.status(200).json({ message: "_id deleted"});
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.log(error);
    }
}

module.exports = {
    createListing,
    getListings,
    deleteListing
}