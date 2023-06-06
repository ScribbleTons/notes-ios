const mongoose = require("mongoose");

const Note = mongoose.model("Note", {
    note: {
        type: String
    },
    checked: {type: Boolean, default: false}
});


module.exports = Note;