import express from 'express';
import http from 'http';
import cors from 'cors';
import morgan from 'morgan';
import { Server } from 'socket.io';
import dotenv from 'dotenv';
import { connectDB } from './config/db';

dotenv.config();

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: { origin: '*', methods: ['GET', 'POST'] },
});

app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

app.get('/health', (_req, res) => res.json({ ok: true }));

app.use('/auth', require('./routes/auth').default);
app.use('/contacts', require('./routes/contacts').default);

// Socket.IO signaling
io.on('connection', (socket) => {
  socket.on('presence:online', (userId: string) => {
    socket.data.userId = userId;
    socket.broadcast.emit('status:update', { userId, online: true });
  });

  socket.on('call:invite', (payload) => {
    socket.broadcast.emit('call:incoming', payload);
  });

  socket.on('call:answer', (payload) => {
    socket.broadcast.emit('call:answer', payload);
  });

  socket.on('call:candidate', (payload) => {
    socket.broadcast.emit('call:candidate', payload);
  });

  socket.on('call:reject', (payload) => {
    socket.broadcast.emit('call:reject', payload);
  });

  socket.on('call:end', (payload) => {
    socket.broadcast.emit('call:end', payload);
  });

  socket.on('disconnect', () => {
    if (socket.data.userId) {
      io.emit('status:update', { userId: socket.data.userId, online: false });
    }
  });
});

export const start = async () => {
  await connectDB();
  const port = process.env.PORT || 3000;
  server.listen(port as number, '0.0.0.0', () => console.log(`API listening on :${port}`));
}; 