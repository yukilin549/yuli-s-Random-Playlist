-- 在 Supabase 專案的 SQL Editor 執行一次
create table if not exists public.song_rooms (
  room_id uuid primary key,
  songs jsonb not null default '[]'::jsonb,
  history jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.song_rooms enable row level security;
-- 共享連結持有人均可讀寫該歌單。這是協作式公開權限，不適用私人或敏感資料。
create policy "shared_song_rooms_read" on public.song_rooms for select to anon using (true);
create policy "shared_song_rooms_insert" on public.song_rooms for insert to anon with check (true);
create policy "shared_song_rooms_update" on public.song_rooms for update to anon using (true) with check (true);
-- 如已建立同名 policies，請勿重複執行 CREATE POLICY。
