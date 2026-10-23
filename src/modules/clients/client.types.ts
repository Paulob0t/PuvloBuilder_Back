export interface CreateClientBody {
  name: string;
  email: string;
  phone?: string;
  company?: string;
  status?: string;
  notes?: string;
  projectId?: string | null;
}

export interface UpdateClientBody {
  name?: string;
  email?: string;
  phone?: string;
  company?: string;
  status?: string;
  notes?: string;
  projectId?: string | null;
}

export interface ClientParams {
  id: string;
}
