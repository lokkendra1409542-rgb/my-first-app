import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { connectDB } from "./db.js";
import authRouter from "./routes/auth.js";
import tasksRouter from "./routes/tasks.js";

dotenv.config();
const app = express();

app.use(cors({ origin: "*", methods: ["GET", "POST", "PUT", "DELETE"] }));
app.use(express.json({ limit: "1mb" }));

app.get("/", (_req, res) => res.send("OK"));
app.use("/api/auth", authRouter);
app.use("/api/tasks", tasksRouter);

const PORT = process.env.PORT || 5000;
connectDB().then(() => {
  app.listen(PORT, () => console.log(`🚀 API http://0.0.0.0:${PORT}`));
});
