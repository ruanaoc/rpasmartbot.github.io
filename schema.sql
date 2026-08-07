-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.users (
  id text NOT NULL,
  name text NOT NULL,
  email text NOT NULL UNIQUE,
  cpf text NOT NULL UNIQUE,
  password_hash text NOT NULL,
  role text DEFAULT 'operator'::text CHECK (role = ANY (ARRAY['superadmin'::text, 'admin'::text, 'operator'::text])),
  status text DEFAULT 'pending'::text CHECK (status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text])),
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT users_pkey PRIMARY KEY (id)
);
CREATE TABLE public.incidents (
  id text NOT NULL,
  protocol text NOT NULL,
  title text NOT NULL,
  routine text NOT NULL,
  description text NOT NULL,
  resolution_time timestamp with time zone NOT NULL,
  responsible text NOT NULL,
  image text,
  status text DEFAULT 'active'::text CHECK (status = ANY (ARRAY['active'::text, 'resolved'::text])),
  created_at timestamp with time zone DEFAULT now(),
  created_by text,
  created_by_id text,
  resolved_at timestamp with time zone,
  resolved_by text,
  CONSTRAINT incidents_pkey PRIMARY KEY (id)
);
CREATE TABLE public.incident_emails (
  id integer NOT NULL DEFAULT nextval('incident_emails_id_seq'::regclass),
  incident_id text NOT NULL,
  email text NOT NULL,
  CONSTRAINT incident_emails_pkey PRIMARY KEY (id),
  CONSTRAINT incident_emails_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(id)
);
CREATE TABLE public.logs (
  id text NOT NULL,
  type text NOT NULL,
  user_name text DEFAULT 'Sistema'::text,
  details text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT logs_pkey PRIMARY KEY (id)
);
CREATE TABLE public.sessions (
  token text NOT NULL,
  user_id text NOT NULL,
  expires_at timestamp with time zone NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT sessions_pkey PRIMARY KEY (token),
  CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
