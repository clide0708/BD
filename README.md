# Banco_de_Dados

Como posso truncar todas as tabelas do meu banco de dados MySQL (com exceção das tabelas 'recuperacao_senha', 'exercicios', 'devs', 'exercadaptados', 'videos', 'traducoes_alimentos', 'nutrientes', 'pagamentos' e 'planos') de uma só vez?

SELECT CONCAT('TRUNCATE TABLE `', table_name, '`;') AS stmt
FROM information_schema.tables
WHERE table_schema = 'bd_tcc'
  AND table_name NOT IN ('recuperacao_senha', 'exercicios', 'devs', 'exercadaptados', 'videos', 'traducoes_alimentos', 'nutrientes', 'pagamentos', 'planos')
  AND table_type = 'BASE TABLE';

TRUNCATE TABLE `academias`;
TRUNCATE TABLE `agendamentos`;
TRUNCATE TABLE `agua`;
TRUNCATE TABLE `alunos`;
TRUNCATE TABLE `assinaturas`;
TRUNCATE TABLE `itens_refeicao`;
TRUNCATE TABLE `personal`;
TRUNCATE TABLE `refeicoes_tipos`;
TRUNCATE TABLE `treino_exercicio`;
TRUNCATE TABLE `treino_exercicio_historico`;
TRUNCATE TABLE `treinos`;
