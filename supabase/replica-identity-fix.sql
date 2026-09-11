-- Apply this once to EXISTING Selah projects in the Supabase SQL Editor.
--
-- PostgreSQL's default replica identity exposes only the primary key in a
-- DELETE payload. Realtime therefore cannot evaluate user_id filters for a
-- delete, and another signed-in device can miss the live removal. FULL keeps
-- the old row (including user_id) in the WAL. The Flutter client also handles
-- the primary-key-only form as a compatibility fallback.
BEGIN;
ALTER TABLE highlights REPLICA IDENTITY FULL;
ALTER TABLE notes REPLICA IDENTITY FULL;
ALTER TABLE history REPLICA IDENTITY FULL;
ALTER TABLE search_history REPLICA IDENTITY FULL;
COMMIT;
