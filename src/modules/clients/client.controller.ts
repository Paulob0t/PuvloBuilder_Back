import { FastifyRequest, FastifyReply } from 'fastify';
import { prisma } from '../../lib/prisma.js';
import type { CreateClientBody, UpdateClientBody, ClientParams } from './client.types.js';

export async function listClientsHandler(request: FastifyRequest, reply: FastifyReply) {
  const clients = await prisma.client.findMany({
    include: {
      project: {
        select: {
          id: true,
          title: true,
          slug: true,
          routePrefix: true,
        },
      },
    },
    orderBy: { createdAt: 'desc' },
  });

  return reply.send({ clients });
}

export async function getClientByIdHandler(request: FastifyRequest, reply: FastifyReply) {
  const { id } = (request.params || {}) as ClientParams;
  const client = await prisma.client.findUnique({
    where: { id },
    include: {
      project: {
        select: {
          id: true,
          title: true,
          slug: true,
          routePrefix: true,
        },
      },
    },
  });

  if (!client) {
    return reply.status(404).send({ message: 'Cliente no encontrado' });
  }

  return reply.send({ client });
}

export async function createClientHandler(request: FastifyRequest, reply: FastifyReply) {
  const body = (request.body || {}) as CreateClientBody;
  const { name, email, phone, company, status, notes, projectId } = body;

  if (!name || !name.trim()) {
    return reply.status(400).send({ message: 'El nombre del cliente es obligatorio' });
  }
  if (!email || !email.trim()) {
    return reply.status(400).send({ message: 'El correo electrónico es obligatorio' });
  }

  // Verificar si ya existe un cliente con ese email
  const existing = await prisma.client.findUnique({
    where: { email: email.trim().toLowerCase() },
  });
  if (existing) {
    return reply.status(409).send({ message: 'Ya existe un cliente con ese correo electrónico' });
  }

  // Verificar si el proyecto asignado existe
  if (projectId) {
    const project = await prisma.project.findUnique({ where: { id: projectId } });
    if (!project) {
      return reply.status(404).send({ message: 'El proyecto seleccionado no existe' });
    }
  }

  const client = await prisma.client.create({
    data: {
      name: name.trim(),
      email: email.trim().toLowerCase(),
      phone: phone ? phone.trim() : null,
      company: company ? company.trim() : null,
      status: status || 'active',
      notes: notes ? notes.trim() : null,
      projectId: projectId || null,
    },
    include: {
      project: {
        select: {
          id: true,
          title: true,
          slug: true,
          routePrefix: true,
        },
      },
    },
  });

  return reply.status(201).send({ client, message: 'Cliente registrado exitosamente' });
}

export async function updateClientHandler(request: FastifyRequest, reply: FastifyReply) {
  const { id } = (request.params || {}) as ClientParams;
  const body = (request.body || {}) as UpdateClientBody;
  const { name, email, phone, company, status, notes, projectId } = body;

  const client = await prisma.client.findUnique({ where: { id } });
  if (!client) {
    return reply.status(404).send({ message: 'Cliente no encontrado' });
  }

  if (email && email.trim().toLowerCase() !== client.email) {
    const existing = await prisma.client.findUnique({
      where: { email: email.trim().toLowerCase() },
    });
    if (existing) {
      return reply.status(409).send({ message: 'Ya existe otro cliente con ese correo electrónico' });
    }
  }

  if (projectId) {
    const project = await prisma.project.findUnique({ where: { id: projectId } });
    if (!project) {
      return reply.status(404).send({ message: 'El proyecto seleccionado no existe' });
    }
  }

  const updatedClient = await prisma.client.update({
    where: { id },
    data: {
      name: name !== undefined ? name.trim() : undefined,
      email: email !== undefined ? email.trim().toLowerCase() : undefined,
      phone: phone !== undefined ? (phone ? phone.trim() : null) : undefined,
      company: company !== undefined ? (company ? company.trim() : null) : undefined,
      status: status !== undefined ? status : undefined,
      notes: notes !== undefined ? (notes ? notes.trim() : null) : undefined,
      projectId: projectId !== undefined ? (projectId || null) : undefined,
    },
    include: {
      project: {
        select: {
          id: true,
          title: true,
          slug: true,
          routePrefix: true,
        },
      },
    },
  });

  return reply.send({ client: updatedClient, message: 'Cliente actualizado exitosamente' });
}

export async function deleteClientHandler(request: FastifyRequest, reply: FastifyReply) {
  const { id } = (request.params || {}) as ClientParams;

  const client = await prisma.client.findUnique({ where: { id } });
  if (!client) {
    return reply.status(404).send({ message: 'Cliente no encontrado' });
  }

  await prisma.client.delete({ where: { id } });

  return reply.send({ message: 'Cliente eliminado correctamente', id });
}
