const express = require('express');
const morgan = require("morgan")

require('./db/mongoose');

const Note = require('./models');

const app = express();

app.use(express.json());

// Use morgan middleware for logging
app.use(morgan('dev'));

app.get('/notes', async (req, res) => {
	try {
		const notes = await Note.find({}, { __v: 0 });
		res.status(200).json(notes );
	} catch (error) {
		res.status(400).json({ error });
	}
});

app.post('/note', async (req, res) => {
	try {
		if (!req.body?.note) {
			return res.status(400).json({ error: 'Note not included in the body' });
		}
		const note = new Note(req.body);
		await note.save();
		res.status(200).json({ note });
	} catch (error) {
		res.status(401).json({ error });
	}
});

app.patch('/note/:id', async (req, res) => {
	try {
		if (!req.body?.note) {
			return res
				.status(400)
				.json({ error: 'Note not included in the body or missing id' });
		}

		const note = await Note.findById(req.params?.id, { __v: 0 });

		note.note = req.body.note;

		await note.save();

		res.status(200).json({ note });
	} catch (error) {
		res.status(500).json({ error });
	}
});


app.delete('/note/:id', async (req, res) => {
	try {
		const note = await Note.findOneAndRemove({_id:req.params?.id});

		if (!note) return res.status(404).json({ message: 'Note not found.' });

		res.status(200).json({status:"success", message: 'Note deleted' });
	} catch (error) {
		res.status(500).json({ error });
	}
});

app.listen(4000, () => {
	console.log('Server is running http://localhost:4000');
});
