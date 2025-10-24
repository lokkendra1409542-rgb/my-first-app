import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { connectDB } from "./db.js";
import itemsRouter from "./routes/items.js";

dotenv.config();
const app = express();

app.use(
  cors({ origin: "*", methods: ["GET", "POST", "PATCH", "PUT", "DELETE"] })
);
app.use(express.json({ limit: "1mb" }));

app.get("/", (_req, res) => res.send("OK"));
app.use("/api/items", itemsRouter);

const PORT = process.env.PORT || 5000;
connectDB().then(() => {
  app.listen(PORT, () => console.log(`🚀 API on http://0.0.0.0:${PORT}`));
});
