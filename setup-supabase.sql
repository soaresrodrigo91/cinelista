-- CineLista: execute este script UMA vez no Supabase
-- (painel do projeto > SQL Editor > New query > cole tudo > Run)

create table public.titulos (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users(id) on delete cascade,
  nome        text not null,
  streaming   text not null,
  status      text not null default 'assistindo',
  temporada   int default 1,
  episodio    int default 1,
  link_direto text,
  criado_em   timestamptz default now()
);

-- Segurança: cada usuário só enxerga os próprios títulos
alter table public.titulos enable row level security;

create policy "cada usuario ve apenas o que e seu"
  on public.titulos
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
