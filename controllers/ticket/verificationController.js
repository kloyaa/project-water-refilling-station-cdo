require("dotenv").config();
const cloudinary = require("../../services/img-upload/cloundinary");
const Verification = require("../../models/ticket");
const Profile = require("../../models/profile");


// POST
async function createVerificationTicket(req, res) {
    try {

        const hasPending = await Verification.findOne({ accountId: req.body.accountId});
        if(hasPending) {
            return res.status(400).send({ message: "Account Id has pending ticket"});
        }
        const filePath = req.file.path;
        const options = { 
            folder: process.env.CLOUDINARY_FOLDER + "/tickets/verification", 
            unique_filename: true 
        };
        const uploadedImg = await cloudinary.uploader.upload(filePath, options);

        req.body.img = uploadedImg.url;

        return new Verification(req.body)
            .save()
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).send(err.errors));
    } catch (error) {
        console.error(error);
    }
}

// GET
async function getAllVerificationTickets(req, res) {
    try {
        const { status } = req.query;
        if(status == "pending") {
           return Verification.find({status})
                .sort({ createdAt: -1 }) // filter by date
                .select({  __v: 0 }) // Do not return _id and __v
                .then((value) => res.status(200).json(value))
                .catch((err) => res.status(400).json(err));
        }
        return Verification.find({status})
            .sort({ createdAt: -1 }) // filter by date
            .select({  __v: 0 }) // Do not return _id and __v
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
};

async function getSingleVerificationTicket(req, res) {
    try {
        const accountId = req.params.id;
        return Verification.findOne({ accountId })
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
};

// UPDATE
async function updateProfileVerificationStatus(req, res) {
    try {
        const {_id, accountId, verified, status} = req.body;
        // UPDATE PROFILE STATUS
        Profile.findOneAndUpdate(
            { accountId },
            { verified })
            .then(() => console.log({message: "Profile updated"}))
            .catch(() => res.status(400).json({ 
                message: "accountId doesn't exist or has already been deleted"
            }));
       
        // UPDATE SUBMITTED TICKET
        Verification.findByIdAndUpdate(_id,
            { status }, 
            { new: true, runValidators: true })
            .then((value) => {
                if (value) 
                    return res.status(200).json({ message: "Verification updated"});
                return res.status(400).json({ message: "_id doesn't exist or has already been deleted"});
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
};

// DELETE
async function deleteVerificationTicket(req, res) {
    try {
        const _id = req.params.id;
        Verification.findByIdAndDelete(_id)
            .then((value) => {
                if (value) 
                    return res.status(200).json({ message: "deleted"});
                return res.status(200).json({ message: "_id doesn't exist or has already been deleted"});
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.log(error);
    }
};


module.exports = { 
    createVerificationTicket, 
    getAllVerificationTickets, 
    getSingleVerificationTicket,  
    updateProfileVerificationStatus,
    deleteVerificationTicket
};