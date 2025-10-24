import { Router } from "express";
import { db } from "../db.js";
import { ObjectId } from "mongodb";
import { requireAuth } from "../middleware/auth.js";

const router = Router();
const tasks = () => db().collection("tasks");

// All below routes require auth
router.use(requireAuth);

// CREATE
router.post("/", async (req, res) => {
  try {
    const now = new Date();
    const doc = {
      userId: new ObjectId(req.user.userId),
      title: (req.body.title || "").trim(),
      description: (req.body.description || "").trim(),
      status: req.body.status || "todo", // todo | in_progress | done
      priority: req.body.priority || "medium", // low | medium | high
      createdAt: now,
      updatedAt: now,
    };
    if (!doc.title) return res.status(400).json({ error: "title required" });

    const r = await tasks().insertOne(doc);
    res.json({ _id: r.insertedId, ...doc });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// READ (current user)
router.get("/", async (req, res) => {
  const list = await tasks()
    .find({ userId: new ObjectId(req.user.userId) })
    .sort({ createdAt: -1 })
    .toArray();
  res.json(list);
});

// UPDATE
router.put("/:id", async (req, res) => {
  try {
    const _id = new ObjectId(req.params.id);
    const update = {
      ...(req.body.title !== undefined
        ? { title: String(req.body.title) }
        : {}),
      ...(req.body.description !== undefined
        ? { description: String(req.body.description) }
        : {}),
      ...(req.body.status !== undefined
        ? { status: String(req.body.status) }
        : {}),
      ...(req.body.priority !== undefined
        ? { priority: String(req.body.priority) }
        : {}),
      updatedAt: new Date(),
    };
    const r = await tasks().findOneAndUpdate(
      { _id, userId: new ObjectId(req.user.userId) },
      { $set: update },
      { returnDocument: "after" }
    );
    if (!r.value) return res.status(404).json({ error: "not found" });
    res.json(r.value);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// DELETE
router.delete("/:id", async (req, res) => {
  const _id = new ObjectId(req.params.id);
  const r = await tasks().deleteOne({
    _id,
    userId: new ObjectId(req.user.userId),
  });
  if (!r.deletedCount) return res.status(404).json({ error: "not found" });
  res.json({ ok: true });
});

export default router;
