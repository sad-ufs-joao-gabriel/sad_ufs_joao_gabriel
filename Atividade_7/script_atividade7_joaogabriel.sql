
CREATE TABLE public.dim_curso (
                Id_curso INTEGER NOT NULL,
                Descricao VARCHAR NOT NULL,
                CONSTRAINT id_curso PRIMARY KEY (Id_curso)
);


CREATE SEQUENCE public.dim_tempo_id_tempo_seq;

CREATE SEQUENCE public.dim_tempo_ano_seq;

CREATE SEQUENCE public.dim_tempo_semestre_seq;

CREATE TABLE public.dim_tempo (
                Id_tempo INTEGER NOT NULL DEFAULT nextval('public.dim_tempo_id_tempo_seq'),
                Ano INTEGER NOT NULL DEFAULT nextval('public.dim_tempo_ano_seq'),
                Semestre INTEGER NOT NULL DEFAULT nextval('public.dim_tempo_semestre_seq'),
                CONSTRAINT id_tempo PRIMARY KEY (Id_tempo)
);


ALTER SEQUENCE public.dim_tempo_id_tempo_seq OWNED BY public.dim_tempo.Id_tempo;

ALTER SEQUENCE public.dim_tempo_ano_seq OWNED BY public.dim_tempo.Ano;

ALTER SEQUENCE public.dim_tempo_semestre_seq OWNED BY public.dim_tempo.Semestre;

CREATE SEQUENCE public.dim_disciplinas_id_disciplina_seq;

CREATE SEQUENCE public.dim_disciplinas_descricao_seq;

CREATE TABLE public.dim_disciplinas (
                id_disciplina INTEGER NOT NULL DEFAULT nextval('public.dim_disciplinas_id_disciplina_seq'),
                Descricao VARCHAR NOT NULL DEFAULT nextval('public.dim_disciplinas_descricao_seq'),
                CONSTRAINT id_disciplina PRIMARY KEY (id_disciplina)
);


ALTER SEQUENCE public.dim_disciplinas_id_disciplina_seq OWNED BY public.dim_disciplinas.id_disciplina;

ALTER SEQUENCE public.dim_disciplinas_descricao_seq OWNED BY public.dim_disciplinas.Descricao;

CREATE SEQUENCE public.dim_aluno_id_aluno_seq;

CREATE TABLE public.dim_aluno (
                id_aluno INTEGER NOT NULL DEFAULT nextval('public.dim_aluno_id_aluno_seq'),
                Nome VARCHAR NOT NULL,
                Idade INTEGER NOT NULL,
                CONSTRAINT id_aluno PRIMARY KEY (id_aluno)
);


ALTER SEQUENCE public.dim_aluno_id_aluno_seq OWNED BY public.dim_aluno.id_aluno;

CREATE TABLE public.fato_aulas (
                Id_tempo INTEGER NOT NULL,
                id_aluno INTEGER NOT NULL,
                Id_curso INTEGER NOT NULL,
                id_disciplina INTEGER NOT NULL,
                Quant_aprovados INTEGER NOT NULL,
                Quant_reprovados INTEGER NOT NULL,
                Quant_disc_curso INTEGER NOT NULL,
                Quant_alunos_curso INTEGER NOT NULL,
                CONSTRAINT fato_aulas_cp PRIMARY KEY (Id_tempo, id_aluno, Id_curso, id_disciplina)
);


ALTER TABLE public.fato_aulas ADD CONSTRAINT dim_curso_fato_aulas_fk
FOREIGN KEY (Id_curso)
REFERENCES public.dim_curso (Id_curso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fato_aulas ADD CONSTRAINT dim_tempo_fato_aulas_fk
FOREIGN KEY (Id_tempo)
REFERENCES public.dim_tempo (Id_tempo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fato_aulas ADD CONSTRAINT dim_disciplinas_fato_aulas_fk
FOREIGN KEY (id_disciplina)
REFERENCES public.dim_disciplinas (id_disciplina)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fato_aulas ADD CONSTRAINT dim_aluno_fato_aulas_fk
FOREIGN KEY (id_aluno)
REFERENCES public.dim_aluno (id_aluno)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
