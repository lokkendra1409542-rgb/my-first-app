import { Router } from "express";
import { db } from "../db.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

const router = Router();
const users = () => db().collection("users");

const publicUser = (u) => ({ _id: u._id, name: u.name, email: u.email });

router.post("/signup", async (req, res) => {
  try {
    const name = String(req.body.name || "").trim();
    const email = String(req.body.email || "")
      .trim()
      .toLowerCase();
    const password = String(req.body.password || "");

    if (!name || !email || !password) {
      return res.status(400).json({ error: "name, email, password required" });
    }
    const hash = await bcrypt.hash(password, 10);
    const now = new Date();

    const doc = {
      name,
      email,
      passwordHash: hash,
      createdAt: now,
      updatedAt: now,
    };
    const r = await users().insertOne(doc);

    const token = jwt.sign(
      { userId: r.insertedId, email },
      process.env.JWT_SECRET,
      { expiresIn: "7d" }
    );
    res.json({ user: publicUser({ _id: r.insertedId, ...doc }), token });
  } catch (e) {
    if (e.code === 11000)
      return res.status(409).json({ error: "email already exists" });
    res.status(500).json({ error: e.message });
  }
});

router.post("/login", async (req, res) => {
  const email = String(req.body.email || "")
    .trim()
    .toLowerCase();
  const password = String(req.body.password || "");
  const u = await users().findOne({ email });
  if (!u) return res.status(401).json({ error: "invalid credentials" });

  const ok = await bcrypt.compare(password, u.passwordHash || "");
  if (!ok) return res.status(401).json({ error: "invalid credentials" });

  const token = jwt.sign(
    { userId: u._id, email: u.email },
    process.env.JWT_SECRET,
    { expiresIn: "7d" }
  );
  res.json({ user: publicUser(u), token });
});

export default router;
