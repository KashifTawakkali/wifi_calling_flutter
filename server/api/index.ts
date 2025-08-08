import type { VercelRequest, VercelResponse } from '@vercel/node';
import express from 'express';
import mongoose from 'mongoose';
import cors from 'cors';
import morgan from 'morgan';
import auth from '../src/routes/auth';
import contacts from '../src/routes/contacts';

const app = express();
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

app.get('/', (_req, res) => res.json({ ok: true, service: 'wifi-calling-api' }));
app.use('/auth', auth);
app.use('/contacts', contacts);
app.get('/health', (_req, res) => res.json({ ok: true }));

// Not found handler
app.use((_req, res) => res.status(404).json({ message: 'Not found' }));

let isConnected = false;

async function ensureDb() {
  if (isConnected) return;
  const mongoUri = process.env.MONGO_URI as string | undefined;
  if (mongoUri) {
    await mongoose.connect(mongoUri);
    isConnected = true;
    return;
  }
  const url = process.env.URL as string | undefined;
  const dbName = process.env.DBNAME as string | undefined;
  const user = process.env.USERNAME as string | undefined;
  const pass = process.env.PASSWORD as string | undefined;
  if (!url || !dbName || !user || !pass) {
    throw new Error('Missing Mongo env vars');
  }
  await mongoose.connect(url, { dbName, user, pass } as any);
  isConnected = true;
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  try {
    await ensureDb();
  } catch (e: any) {
    console.error('DB connect failed', e?.message || e);
    return res.status(500).json({ message: 'DB connect failed' });
  }
  return new Promise<void>((resolve) => {
    app(req as any, res as any, () => resolve());
  });
} 