-- Desativa as chaves estrangeiras temporariamente
SET CONSTRAINTS ALL DEFERRED;

-- Redefine a tabela 'check_ins' sem a restrição de chave estrangeira
CREATE TABLE new_check_ins (
    id SERIAL PRIMARY KEY NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    attendee_id INTEGER NOT NULL
);
INSERT INTO new_check_ins (attendee_id, created_at, id) SELECT attendee_id, created_at, id FROM check_ins;
DROP TABLE check_ins;
ALTER TABLE new_check_ins RENAME TO check_ins;
CREATE UNIQUE INDEX check_ins_attendee_id_key ON check_ins (attendee_id);

-- Redefine a tabela 'attendees'
CREATE TABLE new_attendees (
    id SERIAL PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    event_id TEXT NOT NULL
);
INSERT INTO new_attendees (created_at, email, event_id, id, name) SELECT created_at, email, event_id, id, name FROM attendees;
DROP TABLE attendees;
ALTER TABLE new_attendees RENAME TO attendees;
CREATE UNIQUE INDEX attendees_event_id_email_key ON attendees (event_id, email);

-- Ativa as chaves estrangeiras
SET CONSTRAINTS ALL IMMEDIATE;
