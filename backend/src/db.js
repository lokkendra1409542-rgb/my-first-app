import { MongoClient } from "mongodb";
import dotenv from "dotenv";
dotenv.config();

const client = new MongoClient(process.env.MONGO_URI, {
  maxPoolSize: 20,
  serverSelectionTimeoutMS: 8000,
});
let db;

export async function connectDB() {
  if (db) return db;
  await client.connect();
  db = client.db(process.env.DB_NAME);
  console.log("✅ Mongo connected:", db.databaseName);
  return db;
}

export function getDB() {
  if (!db) throw new Error("DB not initialized");
  return db;
}
