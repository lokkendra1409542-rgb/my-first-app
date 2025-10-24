import express from "express";
import { ObjectId } from "mongodb";
import { getDB } from "../db.js";
const router = express.Router();
const COLL = "items";

router.post("/", async (req, res) => {
  const doc = { ...req.body, created_at: new Date(), updated_at: new Date() };
  if (!doc.name) return res.status(400).json({ error: "name required" });
  const db = getDB();
  const r = await db.collection(COLL).insertOne(doc);
  res.status(201).json({ _id: r.insertedId, ...doc });
});

router.get("/", async (_req, res) => {
  const db = getDB();
  const docs = await db
    .collection(COLL)
    .find()
    .sort({ created_at: -1 })
    .toArray();
  res.json(docs);
});

router.patch("/:id", async (req, res) => {
  const { id } = req.params;
  if (!ObjectId.isValid(id))
    return res.status(400).json({ error: "invalid id" });
  const db = getDB();
  const r = await db
    .collection(COLL)
    .findOneAndUpdate(
      { _id: new ObjectId(id) },
      { $set: { ...req.body, updated_at: new Date() } },
      { returnDocument: "after" }
    );
  if (!r.value) return res.status(404).json({ error: "not found" });
  res.json(r.value);
});

router.delete("/:id", async (req, res) => {
  const { id } = req.params;
  if (!ObjectId.isValid(id))
    return res.status(400).json({ error: "invalid id" });
  const db = getDB();
  const r = await db.collection(COLL).deleteOne({ _id: new ObjectId(id) });
  res.json({ ok: r.deletedCount === 1 });
});

export default router;
