# Banco_de_Dados

Como posso truncar todas as tabelas do meu banco de dados MySQL (com exceção das tabelas 'recuperacao_senha', 'exercicios', 'devs', 'exercadaptados', 'videos', 'traducoes_alimentos', 'nutrientes', 'pagamentos' e 'planos') de uma só vez?

SELECT CONCAT('TRUNCATE TABLE ', table_name, ';') AS stmt FROM information_schema.tables WHERE table_schema = 'bd_clidefit' AND table_name NOT IN ('exercicios', 'devs', 'exercadaptados', 'videos', 'traducoes_alimentos', 'pagamentos', 'planos', 'modalidades') AND table_type = 'BASE TABLE';

TRUNCATE TABLE academia_horarios;
TRUNCATE TABLE academias;
TRUNCATE TABLE agendamentos;
TRUNCATE TABLE agua;
TRUNCATE TABLE alunos;
TRUNCATE TABLE assinaturas;
TRUNCATE TABLE convites;
TRUNCATE TABLE enderecos_usuarios;
TRUNCATE TABLE itens_refeicao;
TRUNCATE TABLE medidas;
TRUNCATE TABLE modalidades_academia;
TRUNCATE TABLE modalidades_aluno;
TRUNCATE TABLE modalidades_personal;
TRUNCATE TABLE notificacoes;
TRUNCATE TABLE nutrientes;
TRUNCATE TABLE personal;
TRUNCATE TABLE progresso;
TRUNCATE TABLE recuperacao_senha;
TRUNCATE TABLE refeicoes_tipos;
TRUNCATE TABLE solicitacoes_academia;
TRUNCATE TABLE treino_exercicio;
TRUNCATE TABLE treino_exercicio_historico;
TRUNCATE TABLE treino_sessao;
TRUNCATE TABLE treinos;
TRUNCATE TABLE usuarios_academia;
