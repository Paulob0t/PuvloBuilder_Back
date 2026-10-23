import { FastifyInstance } from 'fastify';
import {
  listClientsHandler,
  getClientByIdHandler,
  createClientHandler,
  updateClientHandler,
  deleteClientHandler,
} from './client.controller.js';
import { authenticateSuperAdmin } from '../../middlewares/auth.js';

export async function clientRoutes(fastify: FastifyInstance) {
  fastify.get('/', { preHandler: [authenticateSuperAdmin] }, listClientsHandler);
  fastify.get('/:id', { preHandler: [authenticateSuperAdmin] }, getClientByIdHandler);
  fastify.post('/', { preHandler: [authenticateSuperAdmin] }, createClientHandler);
  fastify.put('/:id', { preHandler: [authenticateSuperAdmin] }, updateClientHandler);
  fastify.delete('/:id', { preHandler: [authenticateSuperAdmin] }, deleteClientHandler);
}
