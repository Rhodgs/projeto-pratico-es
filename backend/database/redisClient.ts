// backend/database/redisClient.ts
import Redis from 'ioredis';

// Lê a URL de conexão do Redis a partir do .env
const REDIS_URL = process.env.REDIS_URL;

if (!REDIS_URL) {
  throw new Error('REDIS_URL não foi definida no arquivo .env');
}

export const redis = new Redis(REDIS_URL);

redis.on('connect', () => {
  console.log('Conectado ao Redis com sucesso.');
});

redis.on('error', (erro) => {
  console.error('Erro na conexão com o Redis:', erro);
});