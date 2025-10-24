import { MongoClient } from "mongodb";
import dotenv from "dotenv";
dotenv.config();

const client = new MongoClient(process.env.MONGO_URL, {
  maxPoolSize: 20,
  serverSelectionTimeoutMS: 8000,
});

let _db;
export async function connectDB() {
  if (_db) return _db;
  await client.connect();
  _db = client.db(process.env.DB_NAME || "vertex_suite");

  // Useful indexes
  await _db.collection("users").createIndex({ email: 1 }, { unique: true });
  await _db.collection("tasks").createIndex({ userId: 1, createdAt: -1 });

  return _db;
}
export const db = () => _db;
