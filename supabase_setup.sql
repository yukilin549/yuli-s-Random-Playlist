-- 雨里歌單隨機點單曲：僅管理員可寫入（Supabase SQL Editor 執行）
-- 適用全新專案，也會收回舊版允許匿名寫入的 RLS policy。
create table if not exists public.song_rooms (
  room_id uuid primary key,
  songs jsonb not null default '[]'::jsonb,
  history jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

create table if not exists public.song_admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);

alter table public.song_rooms enable row level security;
alter table public.song_admins enable row level security;

-- 撤銷舊版本匿名可新增、更新歌曲的權限。
drop policy if exists "shared_song_rooms_read" on public.song_rooms;
drop policy if exists "shared_song_rooms_insert" on public.song_rooms;
drop policy if exists "shared_song_rooms_update" on public.song_rooms;
drop policy if exists "song_rooms_public_read" on public.song_rooms;
drop policy if exists "song_rooms_admin_insert" on public.song_rooms;
drop policy if exists "song_rooms_admin_update" on public.song_rooms;
drop policy if exists "song_rooms_admin_delete" on public.song_rooms;
drop policy if exists "song_admins_read_self" on public.song_admins;

-- Anonymous 使用者僅可查詢歌曲（沒有新增、修改、刪除權限）。
grant usage on schema public to anon, authenticated;
grant select on public.song_rooms to anon, authenticated;
revoke insert, update, delete on public.song_rooms from anon;
grant insert, update, delete on public.song_rooms to authenticated;
grant select on public.song_admins to authenticated;
revoke all on public.song_admins from anon;
revoke insert, update, delete on public.song_admins from authenticated;

create policy "song_rooms_public_read" on public.song_rooms
  for select to anon, authenticated using (true);

create policy "song_admins_read_self" on public.song_admins
  for select to authenticated using (user_id = (select auth.uid()));

create policy "song_rooms_admin_insert" on public.song_rooms
  for insert to authenticated
  with check (exists(select 1 from public.song_admins where user_id = (select auth.uid())));
create policy "song_rooms_admin_update" on public.song_rooms
  for update to authenticated
  using (exists(select 1 from public.song_admins where user_id = (select auth.uid())))
  with check (exists(select 1 from public.song_admins where user_id = (select auth.uid())));
create policy "song_rooms_admin_delete" on public.song_rooms
  for delete to authenticated
  using (exists(select 1 from public.song_admins where user_id = (select auth.uid())));

-- 注意：管理員 UUID 要在 Supabase Authentication > Users 建好管理員帳號後，
-- 再另外於 SQL Editor 執行以下語句（請將值改為該使用者的真實 UUID）：
-- insert into public.song_admins (user_id) values ('xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx') on conflict do nothing;
