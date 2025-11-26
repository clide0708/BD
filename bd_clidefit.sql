-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Tempo de geração: 26-Nov-2025 às 05:39
-- Versão do servidor: 8.0.31
-- versão do PHP: 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `bd_clidefit`
--
CREATE DATABASE IF NOT EXISTS `bd_clidefit` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `bd_clidefit`;

DELIMITER $$
--
-- Funções
--
DROP FUNCTION IF EXISTS `calcular_distancia_aproximada`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `calcular_distancia_aproximada` (`lat1` DECIMAL(10,8), `lon1` DECIMAL(11,8), `lat2` DECIMAL(10,8), `lon2` DECIMAL(11,8)) RETURNS DECIMAL(10,2) DETERMINISTIC READS SQL DATA BEGIN
    -- Fórmula de Haversine simplificada para distância aproximada em km
    RETURN ROUND(6371 * ACOS(
        COS(RADIANS(lat1)) * COS(RADIANS(lat2)) * 
        COS(RADIANS(lon2) - RADIANS(lon1)) + 
        SIN(RADIANS(lat1)) * SIN(RADIANS(lat2))
    ), 2);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `academias`
--

DROP TABLE IF EXISTS `academias`;
CREATE TABLE IF NOT EXISTS `academias` (
  `idAcademia` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nome_fantasia` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `razao_social` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cnpj` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `senha` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `telefone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `endereco` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_cadastro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `foto_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sobre` text COLLATE utf8mb4_general_ci,
  `tamanho_estrutura` enum('Pequena','Média','Grande','Muito grande') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `capacidade_maxima` int DEFAULT NULL,
  `ano_fundacao` year DEFAULT NULL,
  `estacionamento` tinyint(1) DEFAULT '0',
  `vestiario` tinyint(1) DEFAULT '0',
  `ar_condicionado` tinyint(1) DEFAULT '0',
  `wifi` tinyint(1) DEFAULT '0',
  `totem_de_carregamento_usb` tinyint(1) DEFAULT '0',
  `area_descanso` tinyint(1) DEFAULT '0',
  `avaliacao_fisica` tinyint(1) DEFAULT '0',
  `cadastro_completo` tinyint(1) NOT NULL DEFAULT '0',
  `status_conta` enum('Ativa','Inativa','Excluida') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Ativa',
  `idPlano` int NOT NULL DEFAULT '5',
  `treinos_adaptados` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`idAcademia`),
  UNIQUE KEY `cnpj` (`cnpj`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_academia_foto_url` (`foto_url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `academias`
--

TRUNCATE TABLE `academias`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `academia_horarios`
--

DROP TABLE IF EXISTS `academia_horarios`;
CREATE TABLE IF NOT EXISTS `academia_horarios` (
  `idHorario` int NOT NULL AUTO_INCREMENT,
  `idAcademia` int NOT NULL,
  `dia_semana` enum('Segunda-feira','Terça-feira','Quarta-feira','Quinta-feira','Sexta-feira','Sábado','Domingo') COLLATE utf8mb4_general_ci NOT NULL,
  `aberto_24h` tinyint(1) DEFAULT '0',
  `horario_abertura` time DEFAULT NULL,
  `horario_fechamento` time DEFAULT NULL,
  `fechado` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`idHorario`),
  UNIQUE KEY `unique_academia_dia` (`idAcademia`,`dia_semana`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `academia_horarios`
--

TRUNCATE TABLE `academia_horarios`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `agendamentos`
--

DROP TABLE IF EXISTS `agendamentos`;
CREATE TABLE IF NOT EXISTS `agendamentos` (
  `idAgendamento` int NOT NULL AUTO_INCREMENT,
  `idPersonal` int NOT NULL,
  `idAluno` int NOT NULL,
  `data_hora` datetime NOT NULL,
  `local` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `observacoes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`idAgendamento`),
  KEY `FK_Agend_Aluno` (`idAluno`),
  KEY `FK_Agend_Personal` (`idPersonal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `agendamentos`
--

TRUNCATE TABLE `agendamentos`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `agua`
--

DROP TABLE IF EXISTS `agua`;
CREATE TABLE IF NOT EXISTS `agua` (
  `idAgua` int NOT NULL AUTO_INCREMENT,
  `idAluno` int NOT NULL,
  `quantidade` int DEFAULT NULL,
  `data` datetime DEFAULT NULL,
  PRIMARY KEY (`idAgua`),
  KEY `FK_idAluno_Agua` (`idAluno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `agua`
--

TRUNCATE TABLE `agua`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `alunos`
--

DROP TABLE IF EXISTS `alunos`;
CREATE TABLE IF NOT EXISTS `alunos` (
  `idAluno` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cpf` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `rg` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `senha` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `numTel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `altura` decimal(5,2) DEFAULT NULL,
  `meta` enum('Perder peso','Manter peso','Ganhar peso','Ganhar massa muscular','Melhorar condicionamento','Outro') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `treinoTipo` enum('Sedentário','Leve','Moderado','Intenso') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `foto_perfil` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `foto_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_cadastro` datetime NOT NULL,
  `tipoPlano` enum('Básico(Gratuito)','Plus') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Básico(Gratuito)',
  `idPersonal` int DEFAULT NULL,
  `idAcademia` int DEFAULT NULL,
  `status_vinculo` enum('Ativo','Inativo','Pendente') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Inativo',
  `status_conta` enum('Ativa','Pendente','Excluida') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Ativa',
  `idade` int DEFAULT NULL,
  `data_nascimento` date DEFAULT NULL,
  `genero` enum('Masculino','Feminino','Outro') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `peso` decimal(6,2) DEFAULT NULL,
  `idPlano` int NOT NULL DEFAULT '1',
  `treinos_adaptados` tinyint(1) NOT NULL DEFAULT '0',
  `cadastro_completo` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idAluno`),
  UNIQUE KEY `cpf` (`cpf`),
  UNIQUE KEY `uq_numTel` (`numTel`),
  UNIQUE KEY `uq_rg` (`rg`),
  UNIQUE KEY `uq_email` (`email`),
  KEY `FK_Alunos_Personal` (`idPersonal`),
  KEY `FK_Alunos_Plano` (`idPlano`),
  KEY `idx_aluno_status` (`status_conta`),
  KEY `idx_aluno_meta` (`meta`),
  KEY `idx_aluno_treinos_adaptados` (`treinos_adaptados`),
  KEY `idx_aluno_data_nascimento` (`data_nascimento`),
  KEY `idx_aluno_genero` (`genero`),
  KEY `idx_aluno_foto_url` (`foto_url`),
  KEY `FK_Alunos_Academia` (`idAcademia`),
  KEY `idx_aluno_personal` (`idPersonal`),
  KEY `idx_aluno_idade` (`idade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `alunos`
--

TRUNCATE TABLE `alunos`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `assinaturas`
--

DROP TABLE IF EXISTS `assinaturas`;
CREATE TABLE IF NOT EXISTS `assinaturas` (
  `idAssinatura` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `tipo_usuario` enum('aluno','personal','academia') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `idPlano` int NOT NULL,
  `data_inicio` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `data_fim` datetime DEFAULT NULL,
  `status` enum('ativa','cancelada','pendente','expirada','inadimplente') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pendente',
  `id_gateway_assinatura` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`idAssinatura`),
  KEY `idx_usuario` (`idUsuario`,`tipo_usuario`),
  KEY `FK_Assinatura_Plano` (`idPlano`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `assinaturas`
--

TRUNCATE TABLE `assinaturas`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `convites`
--

DROP TABLE IF EXISTS `convites`;
CREATE TABLE IF NOT EXISTS `convites` (
  `idConvite` int NOT NULL AUTO_INCREMENT,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `idPersonal` int NOT NULL,
  `idAluno` int DEFAULT NULL,
  `email_aluno` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('pendente','aceito','negado') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pendente',
  `data_criacao` datetime NOT NULL,
  `data_resposta` datetime DEFAULT NULL,
  `visualizado` tinyint(1) NOT NULL DEFAULT '0',
  `tipo_remetente` enum('aluno','personal') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'personal',
  `tipo_destinatario` enum('aluno','personal') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'aluno',
  `mensagem` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`idConvite`),
  UNIQUE KEY `token` (`token`),
  KEY `idPersonal` (`idPersonal`),
  KEY `idAluno` (`idAluno`),
  KEY `idx_convites_tipos` (`tipo_remetente`,`tipo_destinatario`,`status`),
  KEY `idx_convites_status_tipos` (`status`,`tipo_remetente`,`tipo_destinatario`),
  KEY `idx_convites_usuarios_status` (`idPersonal`,`idAluno`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `convites`
--

TRUNCATE TABLE `convites`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `devs`
--

DROP TABLE IF EXISTS `devs`;
CREATE TABLE IF NOT EXISTS `devs` (
  `idDev` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `senha` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cpf` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cadastradoEm` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idDev`),
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `devs`
--

TRUNCATE TABLE `devs`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `enderecos_usuarios`
--

DROP TABLE IF EXISTS `enderecos_usuarios`;
CREATE TABLE IF NOT EXISTS `enderecos_usuarios` (
  `idEndereco` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `tipoUsuario` enum('aluno','personal') COLLATE utf8mb4_general_ci NOT NULL,
  `cep` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `logradouro` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `numero` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `complemento` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `bairro` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cidade` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `estado` varchar(2) COLLATE utf8mb4_general_ci NOT NULL,
  `pais` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Brasil',
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `data_criacao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `data_atualizacao` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idEndereco`),
  KEY `idx_usuario_tipo` (`idUsuario`,`tipoUsuario`),
  KEY `idx_cidade_estado` (`cidade`,`estado`),
  KEY `idx_cep` (`cep`),
  KEY `idx_localizacao` (`latitude`,`longitude`),
  KEY `idx_endereco_usuario` (`idUsuario`,`tipoUsuario`),
  KEY `idx_endereco_localizacao` (`cidade`,`estado`),
  KEY `idx_endereco_coordenadas` (`latitude`,`longitude`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `enderecos_usuarios`
--

TRUNCATE TABLE `enderecos_usuarios`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `exercicios`
--

DROP TABLE IF EXISTS `exercicios`;
CREATE TABLE IF NOT EXISTS `exercicios` (
  `idExercicio` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `grupoMuscular` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cadastradoPor` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `idPersonal` int DEFAULT NULL,
  `visibilidade` enum('global','personal') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'global',
  `tipo_exercicio` enum('normal','adaptado') COLLATE utf8mb4_general_ci DEFAULT 'normal',
  PRIMARY KEY (`idExercicio`),
  KEY `idPersonal` (`idPersonal`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `exercicios`
--

TRUNCATE TABLE `exercicios`;
--
-- Extraindo dados da tabela `exercicios`
--

INSERT INTO `exercicios` (`idExercicio`, `nome`, `grupoMuscular`, `descricao`, `cadastradoPor`, `idPersonal`, `visibilidade`, `tipo_exercicio`) VALUES
(1, 'Supino Reto', 'Peito', 'Exercício revisado', NULL, NULL, 'global', 'normal'),
(2, 'Máquina Declinada Supino e Crucifixo', 'Peito', 'Deite-se em banco declinado; no supino empurre a barra/pegada para cima até estender os braços; no crucifixo abra os braços com leve flexão nos cotovelos e retorne controlado.', NULL, NULL, 'global', 'normal'),
(3, 'Supino com Halteres', 'Peito', 'Deite-se no banco, segure halteres alinhados ao peito, empurre para cima até braços estendidos e desça controladamente.', NULL, NULL, 'global', 'normal'),
(4, 'Crucifixo com Halteres', 'Peito', 'Deite-se, braços semiflexionados; abra lateralmente até sentir alongamento no peitoral e traga os halteres de volta com controle.', NULL, NULL, 'global', 'normal'),
(5, 'Flexão de Braço', 'Peito', 'Posição de prancha com mãos alinhadas ao peito; flexione os cotovelos até o peito quase tocar o chão e empurre de volta até estender os braços.', NULL, NULL, 'global', 'normal'),
(6, 'Fly', 'Peito', 'Em banco reto ou inclinado, com leve flexão nos cotovelos abra os braços lateralmente e junte-os à frente contraindo o peitoral.', NULL, NULL, 'global', 'normal'),
(7, 'Paralela', 'Peito', 'Suspenda-se nas barras paralelas, incline o tronco levemente à frente, desça flexionando os cotovelos e empurre até estender os braços.', NULL, NULL, 'global', 'normal'),
(8, 'Máquina de Crucifixo Inclinada', 'Peito', 'Sente-se na máquina inclinada, segure as alças e junte-as à frente do peito com movimento controlado e ênfase na contração.', NULL, NULL, 'global', 'normal'),
(9, 'Supino com Barra', 'Peito', 'Deite-se no banco, segure a barra à largura dos ombros, desça ao peito mantendo controle e empurre até estender os braços.', NULL, NULL, 'global', 'normal'),
(10, 'Cross Over', 'Peito', 'Em pé entre os cabos, segure as alças e leve-as à frente do corpo com leve arco no tronco, cruzando as mãos se desejar foco na parte inferior do peitoral.', NULL, NULL, 'global', 'normal'),
(11, 'Voador para Peitoral', 'Peito', 'Sente-se no peck-deck, apoie os braços/antebraços e junte as alças concentrando a contração no centro do peitoral.', NULL, NULL, 'global', 'normal'),
(12, 'Tríceps Pulley', 'triceps', 'Em pé, segure a barra no pulley alto e estenda os cotovelos até travá-los; controle na volta para manter tensão no tríceps.', NULL, NULL, 'global', 'normal'),
(13, 'Tríceps Corda', 'triceps', 'No pulley alto com corda, estenda os antebraços separando as pontas da corda no final da extensão para maior amplitude.', NULL, NULL, 'global', 'normal'),
(14, 'Tríceps Unilateral', 'triceps', 'Segure o acessório com uma mão no pulley e estenda o braço mantendo o cotovelo imóvel; faça o movimento controlado e simétrico no outro lado.', NULL, NULL, 'global', 'normal'),
(15, 'Rosca Francesa no Cross', 'triceps', 'De pé no cross, segure a barra/pegada e flexione os cotovelos levando a carga em direção à testa ou têmpora; estenda até travar os braços.', NULL, NULL, 'global', 'normal'),
(16, 'Tríceps Coice Unilateral no Cross', 'triceps', 'Incline-se com tronco estável, segure o cabo e estenda o antebraço para trás mantendo o cotovelo fixo.', NULL, NULL, 'global', 'normal'),
(17, 'Rosca Francesa Unilateral com Halter', 'triceps', 'Sentado ou deitado, segure um halter com uma mão e faça a extensão do antebraço até estender totalmente o braço.', NULL, NULL, 'global', 'normal'),
(18, 'Rosca Francesa Unilateral no Cross', 'triceps', 'No cross, use pegada unilateral para flexionar o cotovelo e estender o antebraço, mantendo o tronco firme.', NULL, NULL, 'global', 'normal'),
(19, 'Tríceps Coice Unilateral com Halter', 'triceps', 'Apoie o tronco (banco ou inclinação), mantenha o cotovelo fixo e estenda o antebraço para trás até contrair o tríceps.', NULL, NULL, 'global', 'normal'),
(20, 'Tríceps Banco', 'triceps', 'Mãos apoiadas no banco atrás do quadril, flexione os cotovelos descendo o corpo e empurre até estender os braços.', NULL, NULL, 'global', 'normal'),
(21, 'Tríceps Garganta', 'triceps', 'Variação de extensão de tríceps com barra/pegada levando a carga em direção à garganta/peito alto e estendendo os cotovelos com controle.', NULL, NULL, 'global', 'normal'),
(22, 'Tríceps Testa no Cross', 'triceps', 'De pé no cross, segure a barra e flexione os cotovelos levando a barra em direção à testa; estenda controladamente.', NULL, NULL, 'global', 'normal'),
(23, 'Tríceps Testa com Barra', 'triceps', 'Deitado no banco, segure a barra com pegada pronada, flexione os cotovelos até a barra quase tocar a testa e estenda os braços.', NULL, NULL, 'global', 'normal'),
(24, 'Tríceps Máquina Articulada', 'triceps', 'Sente-se e ajuste o aparelho; empurre as alças até estender totalmente os braços e retorne com controle.', NULL, NULL, 'global', 'normal'),
(25, 'Tríceps Coice Bilateral no Cross', 'triceps', 'Incline o tronco, segure as alças e estenda ambos os braços simultaneamente para trás, mantendo os cotovelos quase fixos.', NULL, NULL, 'global', 'normal'),
(26, 'Desenvolvimento com Halteres e Barra', 'ombros', 'Sentado ou em pé, empurre halteres ou barra acima da cabeça até extensão total dos braços e desça controladamente.', NULL, NULL, 'global', 'normal'),
(27, 'Desenvolvimento na Máquina Pegada Tradicional e Convergente', 'ombros', 'Sente-se na máquina, alinhe a pegada e empurre as alças acima da cabeça até estender os braços; controle na descida.', NULL, NULL, 'global', 'normal'),
(28, 'Desenvolvimento Arnold', 'ombros', 'Sente-se com halteres à frente (palmas voltadas para você) e, ao subir, faça a rotação do pulso finalizando com palmas para frente.', NULL, NULL, 'global', 'normal'),
(29, 'Elevação Lateral com Halteres', 'ombros', 'Em pé, levante os halteres lateralmente até a altura dos ombros com leve flexão no cotovelo; mantenha movimento controlado.', NULL, NULL, 'global', 'normal'),
(30, 'Elevação Lateral no Cross', 'ombros', 'Segure o cabo em posição baixa e eleve o braço lateralmente até a altura do ombro, controlando a descida.', NULL, NULL, 'global', 'normal'),
(31, 'Elevação Frontal com Halteres', 'ombros', 'Em pé, levante os halteres à frente do corpo até a altura dos ombros com os braços estendidos e movimento controlado.', NULL, NULL, 'global', 'normal'),
(32, 'Elevação Frontal no Cross', 'ombros', 'Segure o cabo em posição baixa e eleve o braço à frente até a altura do ombro, mantendo o controle na descida.', NULL, NULL, 'global', 'normal'),
(33, 'Remada Alta com Barra', 'ombros', 'Segure a barra com pegada pronada, puxe-a até a altura do peito mantendo os cotovelos altos e desça controladamente.', NULL, NULL, 'global', 'normal'),
(34, 'Remada Alta no Cross', 'ombros', 'Segure as alças no cross, puxe-as para cima até o nível do peito com os cotovelos elevados, controlando o movimento de volta.', NULL, NULL, 'global', 'normal'),
(35, 'Crucifixo Invertido no Cross', 'ombros', 'Segure os cabos em posição baixa, abra os braços para trás com leve flexão nos cotovelos, contraindo a parte posterior dos ombros.', NULL, NULL, 'global', 'normal'),
(36, 'Crucifixo Invertido com Halteres', 'ombros', 'Incline o tronco para frente segurando halteres, abra os braços lateralmente com leve flexão no cotovelo e retorne controlado.', NULL, NULL, 'global', 'normal'),
(37, 'Face Pull', 'ombros', 'Segure a corda no pulley alto, puxe em direção ao rosto com cotovelos abertos para ativar o deltoide posterior e trapézio.', NULL, NULL, 'global', 'normal'),
(38, 'Rosca Francesa com Halter e Anilha', 'triceps', 'Segure o halter/anilha com as duas mãos acima da cabeça e flexione os cotovelos para trás, estendendo-os novamente com controle.', NULL, NULL, 'global', 'normal'),
(39, 'Voador Costas ou Crucifixo Invertido na Máquina', 'ombros', 'Sente-se na máquina, abra os braços para trás contraindo a musculatura posterior dos ombros e retorne devagar.', NULL, NULL, 'global', 'normal'),
(40, 'Rotação Interna e Externa de Ombro (Manguito Rotador)', 'ombros', 'Use o cabo para girar o braço internamente e externamente mantendo o cotovelo fixo, fortalecendo o manguito rotador.', NULL, NULL, 'global', 'normal'),
(41, 'Rosca Direta com Barra', 'biceps', 'Segure a barra com pegada supinada e flexione os cotovelos levando a barra até a altura dos ombros; desça controladamente.', NULL, NULL, 'global', 'normal'),
(42, 'Rosca Direta no Cross', 'biceps', 'Segure o cabo com pegada supinada e flexione o cotovelo puxando o cabo até o bíceps contrair; controle a descida.', NULL, NULL, 'global', 'normal'),
(43, 'Rosca Direta com Halteres', 'biceps', 'Com halteres em mãos, flexione os cotovelos levantando os pesos até a altura dos ombros e desça lentamente.', NULL, NULL, 'global', 'normal'),
(44, 'Rosca Martelo no Cross', 'biceps', 'Segure o cabo com pegada neutra e flexione o cotovelo puxando o cabo em direção ao ombro; controle o movimento de volta.', NULL, NULL, 'global', 'normal'),
(45, 'Rosca no Banco Scott', 'biceps', 'Sentado no banco scott, flexione os cotovelos levando a barra/halteres até contrair os bíceps e desça controladamente.', NULL, NULL, 'global', 'normal'),
(46, 'Rosca Alternada', 'biceps', 'Com halteres em cada mão, flexione um cotovelo de cada vez, girando o pulso ao subir; desça controladamente.', NULL, NULL, 'global', 'normal'),
(47, 'Rosca Inversa na Barra e no Cross Over', 'antebraco', 'Com pegada pronada, flexione os cotovelos levantando a barra ou puxando o cabo, focando no fortalecimento do antebraço.', NULL, NULL, 'global', 'normal'),
(48, 'Rosca Punho com Barra e no Cross Over', 'antebraco', 'Segure barra ou cabo e realize flexão e extensão dos punhos para fortalecer os músculos do antebraço.', NULL, NULL, 'global', 'normal'),
(49, 'Rosca Punho Invertido', 'antebraco', 'Segure a barra com pegada pronada e flexione os punhos para fortalecer os músculos extensores do antebraço.', NULL, NULL, 'global', 'normal'),
(50, 'Rolo de Pulso Wrist Roller', 'antebraco', 'Segure o rolo com pesos suspensos e enrole a corda movendo os punhos para cima e para baixo, fortalecendo o antebraço.', NULL, NULL, 'global', 'normal'),
(51, 'Barra Fixa', 'costas', 'Pendure-se na barra com pegada pronada e puxe o corpo até o queixo ultrapassar a barra; desça controladamente.', NULL, NULL, 'global', 'normal'),
(52, 'Puxador Frente e Costas', 'costas', 'Sentado no puxador, puxe a barra em direção ao peito ou atrás da nuca, mantendo as costas retas; controle a volta.', NULL, NULL, 'global', 'normal'),
(53, 'Remada Sentado no Puxador', 'costas', 'Sentado, puxe o cabo em direção ao abdômen, mantendo tronco estável e controle na extensão dos braços.', NULL, NULL, 'global', 'normal'),
(54, 'Remada Sentado no Cross', 'costas', 'Similar à remada no puxador, puxe os cabos em direção ao tronco mantendo os cotovelos próximos ao corpo.', NULL, NULL, 'global', 'normal'),
(55, 'Puxador no Cross Bilateral e Unilateral', 'costas', 'Segure um ou ambos os cabos e puxe em direção ao peito, controlando a extensão dos braços.', NULL, NULL, 'global', 'normal'),
(56, 'Remada na Máquina', 'costas', 'Sente-se na máquina e puxe as alças em direção ao corpo, concentrando na contração dos músculos das costas.', NULL, NULL, 'global', 'normal'),
(57, 'Remada Cavalo Livre', 'costas', 'Com barra, incline o tronco, puxe a barra em direção ao abdômen mantendo os cotovelos próximos ao corpo.', NULL, NULL, 'global', 'normal'),
(58, 'Remada Cavalo Máquina', 'costas', 'Sente-se e puxe a alavanca da máquina em direção ao corpo focando na contração dos músculos das costas.', NULL, NULL, 'global', 'normal'),
(59, 'Remada Curvada com Barra Livre', 'costas', 'Incline o tronco com barra e puxe em direção ao abdômen com cotovelos para trás; desça controladamente.', NULL, NULL, 'global', 'normal'),
(60, 'Remada Curvada no Cross Over', 'costas', 'Segure os cabos baixos e puxe-os em direção ao tronco com cotovelos próximos ao corpo; controle a volta.', NULL, NULL, 'global', 'normal'),
(61, 'Remada Unilateral com Halter (Serrote)', 'costas', 'Apoie um joelho e mão no banco, puxe o halter com a outra mão em direção ao tronco, mantendo o cotovelo próximo ao corpo.', NULL, NULL, 'global', 'normal'),
(62, 'Hiperextensão Lombar', 'costas', 'Posicione-se no banco para hiperextensão, flexione o tronco para frente e estenda-o para trabalhar a lombar.', NULL, NULL, 'global', 'normal'),
(63, 'Pull Over com Halter', 'costas', 'Deitado no banco, segure o halter acima do peito e leve-o para trás da cabeça, alongando o peitoral e costas.', NULL, NULL, 'global', 'normal'),
(64, 'Pulldown no Cross', 'costas', 'Puxe a barra do pulley alto até o peito, mantendo as costas retas e cotovelos alinhados ao tronco.', NULL, NULL, 'global', 'normal'),
(65, 'Abdominal Supra', 'abdomen', 'Deitado, eleve o tronco em direção aos joelhos, contraindo o abdômen superior.', NULL, NULL, 'global', 'normal'),
(66, 'Abdominal Infra', 'abdomen', 'Deitado, eleve as pernas estendidas em direção ao tronco, focando no abdômen inferior.', NULL, NULL, 'global', 'normal'),
(67, 'Abdominal Infra na Máquina', 'abdomen', 'Sente-se na máquina e eleve os joelhos em direção ao peito, ativando o abdômen inferior.', NULL, NULL, 'global', 'normal'),
(68, 'Abdominal Oblíquo', 'abdomen', 'Deitado, realize a flexão lateral do tronco para ativar os músculos oblíquos.', NULL, NULL, 'global', 'normal'),
(69, 'Abdominal Prancha', 'abdomen', 'Mantenha o corpo alinhado apoiado nos antebraços e ponta dos pés, contraindo o core por tempo determinado.', NULL, NULL, 'global', 'normal'),
(70, 'Abdominal Remador', 'abdomen', 'Deitado, eleve o tronco alternando o toque do cotovelo direito no joelho esquerdo e vice-versa.', NULL, NULL, 'global', 'normal'),
(71, 'Abdominal Lateral', 'abdomen', 'Deitado, flexione o tronco lateralmente para ativar os músculos do abdômen lateral.', NULL, NULL, 'global', 'normal'),
(72, 'Concha Abdominal ou Abdominal Canoa', 'abdomen', 'Sentado, incline o tronco para trás em V mantendo o equilíbrio para trabalhar o core.', NULL, NULL, 'global', 'normal'),
(73, 'Roda Abdominal', 'abdomen', 'Apoie as mãos na roda e estenda o corpo para frente, contraindo o abdômen para retornar.', NULL, NULL, 'global', 'normal'),
(74, 'Panturrilha Sentado na Máquina', 'panturrilha', 'Sente-se na máquina e eleve os calcanhares para trabalhar a panturrilha, controlando a descida.', NULL, NULL, 'global', 'normal'),
(75, 'Panturrilha em Pé', 'panturrilha', 'Em pé, eleve os calcanhares mantendo o equilíbrio para fortalecer a panturrilha.', NULL, NULL, 'global', 'normal'),
(76, 'Panturrilha no Leg Horizontal', 'panturrilha', 'Na máquina leg press horizontal, empurre a plataforma usando somente os dedos dos pés para ativar a panturrilha.', NULL, NULL, 'global', 'normal'),
(77, 'Panturrilha no Leg 45°', 'panturrilha', 'No leg press 45°, faça a extensão plantar elevando os calcanhares para ativar a panturrilha.', NULL, NULL, 'global', 'normal'),
(78, 'Panturrilha no Smith', 'panturrilha', 'Com barra no smith, faça a extensão plantar para fortalecer a panturrilha com carga adicional.', NULL, NULL, 'global', 'normal'),
(79, 'Agachamento Livre', 'quadriceps', 'Com barra apoiada nos ombros, flexione os joelhos e quadris descendo o corpo e volte à posição inicial.', NULL, NULL, 'global', 'normal'),
(80, 'Agachamento Sumô', 'quadriceps', 'Com pernas afastadas e pés virados para fora, agache mantendo a postura ereta e volte controladamente.', NULL, NULL, 'global', 'normal'),
(81, 'Agachamento no Hack Machine', 'quadriceps', 'Na máquina hack, execute o agachamento controlando o movimento para fortalecer as pernas.', NULL, NULL, 'global', 'normal'),
(82, 'Leg Press 45°', 'quadriceps', 'Empurre a plataforma inclinada usando os pés, estendendo os joelhos para ativar o quadríceps.', NULL, NULL, 'global', 'normal'),
(83, 'Cadeira Extensora', 'quadriceps', 'Sente-se e estenda os joelhos contra a resistência da máquina para trabalhar o quadríceps.', NULL, NULL, 'global', 'normal'),
(84, 'Afundo', 'quadriceps', 'Dê um passo à frente e flexione ambos os joelhos até o ângulo de 90°, suba controladamente.', NULL, NULL, 'global', 'normal'),
(85, 'Agachamento Búlgaro', 'quadriceps', 'Com um pé apoiado atrás em banco, agache com o outro mantendo o equilíbrio e volte à posição inicial.', NULL, NULL, 'global', 'normal'),
(86, 'Flexão de Quadril com Caneleira', 'quadriceps', 'De pé, flexione o quadril levantando a perna com caneleira para frente, trabalhando o quadríceps.', NULL, NULL, 'global', 'normal'),
(87, 'Passada e Avanço', 'quadriceps', 'Dê um passo largo à frente, flexione o joelho e volte para trás, alternando as pernas.', NULL, NULL, 'global', 'normal'),
(88, 'Cadeira Adutora', 'adutores', 'Sente-se e pressione as coxas para dentro contra a resistência da máquina para trabalhar os adutores.', NULL, NULL, 'global', 'normal'),
(89, 'Adução no Cross Over', 'adutores', 'Com cabos baixos, puxe as pernas para dentro cruzando na frente do corpo para ativar os adutores.', NULL, NULL, 'global', 'normal'),
(90, 'Mesa Flexora', 'posteriordecoxa', 'Deitado na máquina, flexione os joelhos contra a resistência para trabalhar os músculos posteriores da coxa.', NULL, NULL, 'global', 'normal'),
(91, 'Cadeira Flexora', 'posteriordecoxa', 'Sentado na máquina, flexione os joelhos para trás contra a resistência para ativar os posteriores da coxa.', NULL, NULL, 'global', 'normal'),
(92, 'Flexão de Joelho no Cross Over', 'posteriordecoxa', 'Com cabo no tornozelo, flexione o joelho para trás mantendo o tronco estável.', NULL, NULL, 'global', 'normal'),
(93, 'Stiff', 'posteriordecoxa', 'Com barra ou halteres, incline o tronco à frente mantendo as pernas estendidas e volte à posição inicial.', NULL, NULL, 'global', 'normal'),
(94, 'Glúteo Máquina', 'gluteos', 'Na máquina específica, empurre a alavanca com os quadris para trabalhar os glúteos.', NULL, NULL, 'global', 'normal'),
(95, 'Elevação Pélvica', 'gluteos', 'Deitado com joelhos flexionados, eleve o quadril contraindo os glúteos e desça controladamente.', NULL, NULL, 'global', 'normal'),
(96, 'Elevação Pélvica Unilateral', 'gluteos', 'Com uma perna elevada, eleve o quadril focando no trabalho unilateral dos glúteos.', NULL, NULL, 'global', 'normal'),
(97, 'Abdução de Quadril com Caneleira', 'gluteos', 'Deitado de lado, abduza a perna com caneleira para trabalhar os glúteos e abdutores.', NULL, NULL, 'global', 'normal'),
(98, 'Abdução no Cross Over', 'gluteos', 'Com cabo no tornozelo, abduza a perna lateralmente mantendo o tronco estável.', NULL, NULL, 'global', 'normal'),
(99, 'Cadeira Abdutora', 'gluteos', 'Sente-se e abra as coxas contra a resistência da máquina para trabalhar os abdutores e glúteos.', NULL, NULL, 'global', 'normal'),
(100, 'Glúteo no Cross Over', 'gluteos', 'Com cabo no tornozelo, realize extensão do quadril para trás, ativando os glúteos.', NULL, NULL, 'global', 'normal'),
(101, 'Agachamento Sumô com Halter', 'gluteos', 'Com halter entre as pernas, agache em posição sumô para ativar glúteos e adutores.', NULL, NULL, 'global', 'normal'),
(102, 'Agachamento Afundo com Halter', 'gluteos', 'Com halteres, execute o afundo para trabalhar glúteos e pernas.', NULL, NULL, 'global', 'normal'),
(103, 'Agachamento Búlgaro com Halter', 'gluteos', 'Com halteres, execute o agachamento búlgaro focando nos glúteos e quadríceps.', NULL, NULL, 'global', 'normal'),
(104, 'Agachamento Terra', 'gluteos', 'Com barra, flexione o quadril mantendo as costas retas e volte à posição inicial, ativando glúteos e posteriores.', NULL, NULL, 'global', 'normal'),
(105, 'Agachamento Terra Sumô', 'gluteos', 'Com pegada mais larga, execute o terra sumô para ativar glúteos e adutores.', NULL, NULL, 'global', 'normal'),
(106, 'Agachamento Terra Romeno', 'gluteos', 'Com barra, flexione o quadril mantendo pernas quase estendidas para alongar e ativar posteriores e glúteos.', NULL, NULL, 'global', 'normal'),
(107, 'Agachamento Terra Unilateral', 'gluteos', 'Com uma perna, execute o movimento de terra para trabalhar unilateralmente glúteos e estabilizadores.', NULL, NULL, 'global', 'normal'),
(108, 'Agachamento Terra com Halteres', 'gluteos', 'Com halteres, execute o terra para ativar glúteos e posteriores da coxa.', NULL, NULL, 'global', 'normal'),
(109, 'Agachamento Terra com Kettlebell', 'gluteos', 'Com kettlebell, execute o terra focando na ativação dos glúteos e posteriores.', NULL, NULL, 'global', 'normal'),
(110, 'Agachamento Terra com Barra Hexagonal', 'gluteos', 'Na barra hexagonal, execute o terra com pegada neutra para reduzir tensão lombar.', NULL, NULL, 'global', 'normal'),
(111, 'Agachamento Terra com Trap Bar', 'gluteos', 'Com trap bar, execute o terra para trabalhar glúteos e posteriores com menor impacto na coluna.', NULL, NULL, 'global', 'normal'),
(112, 'Agachamento Terra com Barra Olímpica', 'gluteos', 'Com barra olímpica, execute o terra tradicional para ativar glúteos e cadeia posterior.', NULL, NULL, 'global', 'normal'),
(113, 'Agachamento Terra com Barra Safety', 'gluteos', 'Com barra safety, execute o terra com maior segurança para trabalhar glúteos e posteriores.', NULL, NULL, 'global', 'normal'),
(121, 'Supino Diferenciado', 'Peito', 'Pô, tu vai fazer assim, assim e assado', 'daviramos1703@gmail.com', 1, 'personal', 'normal'),
(122, 'Supino Diferenciado', 'Peito', 'Faz assim', 'daviramos1703@gmail.com', 1, 'personal', 'adaptado'),
(123, 'Supino Diferenciado', 'Peito', 'Adasdas', 'daviramos1703@gmail.com', 1, 'personal', 'adaptado'),
(124, 'Supino Diferenciado', 'Peito', 'A', 'krebsenzo8@gmail.com', 1, 'personal', 'adaptado'),
(125, 'Supino Diferenciado', 'Peito', 'asdasd', 'krebsenzo8@gmail.com', 1, 'personal', 'adaptado'),
(126, 'AAAA', 'Peito', 'asdasd', 'krebsenzo8@gmail.com', 1, 'personal', 'normal'),
(127, 'Enzo', 'Peito', 'AAA', 'krebsenzo8@gmail.com', 1, 'personal', 'normal');

-- --------------------------------------------------------

--
-- Estrutura da tabela `itens_refeicao`
--

DROP TABLE IF EXISTS `itens_refeicao`;
CREATE TABLE IF NOT EXISTS `itens_refeicao` (
  `idItensRef` int NOT NULL AUTO_INCREMENT,
  `id_tipo_refeicao` int NOT NULL,
  `nome` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `quantidade` int NOT NULL,
  `medida` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`idItensRef`),
  KEY `id_tipo_refeicao` (`id_tipo_refeicao`),
  KEY `idx_tipo_ref` (`id_tipo_refeicao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `itens_refeicao`
--

TRUNCATE TABLE `itens_refeicao`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `medidas`
--

DROP TABLE IF EXISTS `medidas`;
CREATE TABLE IF NOT EXISTS `medidas` (
  `idMedida` int NOT NULL AUTO_INCREMENT,
  `idAluno` int NOT NULL,
  `peso` decimal(5,2) DEFAULT NULL,
  `altura` decimal(3,2) DEFAULT NULL,
  `braco_esquerdo` decimal(4,2) DEFAULT NULL,
  `braco_direito` decimal(4,2) DEFAULT NULL,
  `antebraco_esquerdo` decimal(4,2) DEFAULT NULL,
  `antebraco_direito` decimal(4,2) DEFAULT NULL,
  `ombro` decimal(4,2) DEFAULT NULL,
  `peitoral` decimal(4,2) DEFAULT NULL,
  `cintura` decimal(4,2) DEFAULT NULL,
  `abdomen` decimal(4,2) DEFAULT NULL,
  `quadril` decimal(4,2) DEFAULT NULL,
  `coxa_esquerda` decimal(4,2) DEFAULT NULL,
  `coxa_direita` decimal(4,2) DEFAULT NULL,
  `panturrilha_esquerda` decimal(4,2) DEFAULT NULL,
  `panturrilha_direita` decimal(4,2) DEFAULT NULL,
  `data_medicao` datetime NOT NULL,
  PRIMARY KEY (`idMedida`),
  KEY `FK_Medidas_Aluno` (`idAluno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `medidas`
--

TRUNCATE TABLE `medidas`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `modalidades`
--

DROP TABLE IF EXISTS `modalidades`;
CREATE TABLE IF NOT EXISTS `modalidades` (
  `idModalidade` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`idModalidade`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `modalidades`
--

TRUNCATE TABLE `modalidades`;
--
-- Extraindo dados da tabela `modalidades`
--

INSERT INTO `modalidades` (`idModalidade`, `nome`, `descricao`, `ativo`) VALUES
(1, 'Musculação', 'Treinamento com pesos para desenvolvimento de força e hipertrofia muscular', 1),
(2, 'CrossFit', 'Programa de treinamento de força e condicionamento que incorpora elementos de diversos esportes', 1),
(3, 'Calistenia', 'Treino usando o peso do próprio corpo para desenvolver força e resistência', 1),
(4, 'Boxe', 'Arte marcial e esporte de combate que utiliza apenas os punhos para ataque e defesa', 1),
(5, 'Muay Thai', 'Arte marcial tailandesa que utiliza socos, chutes, cotoveladas e joelhadas', 1),
(6, 'Jiu-Jitsu', 'Arte marcial japonesa e esporte de combate focado em técnicas de grappling e finalização', 1),
(7, 'Judô', 'Arte marcial japonesa que se concentra em projeções, imobilizações e finalizações', 1),
(8, 'Karatê', 'Arte marcial japonesa que utiliza golpes de mãos e pés para defesa pessoal', 1),
(9, 'Natação', 'Esporte aquático que trabalha todo o corpo e melhora a capacidade cardiorrespiratória', 1),
(10, 'Hidroginástica', 'Atividade física realizada na água, ideal para reabilitação e condicionamento de baixo impacto', 1),
(11, 'Pilates', 'Método de exercícios que fortalece o core, melhora a postura e a flexibilidade', 1),
(12, 'Yoga', 'Prática milenar que une posturas físicas, respiração e meditação para bem-estar integral', 1),
(13, 'Dança', 'Atividade artística e física que combina movimentos corporais com expressão musical', 1),
(14, 'Zumba', 'Programa de fitness que combina movimentos de dança latina com exercícios aeróbicos', 1),
(15, 'Spinning', 'Treino indoor em bicicletas estacionárias com variações de intensidade e ritmo', 1),
(16, 'Treinamento Funcional', 'Exercícios que simulam movimentos do dia a dia, melhorando a funcionalidade do corpo', 1),
(17, 'Corrida', 'Atividade aeróbica que melhora o condicionamento cardiovascular e queima calorias', 1),
(18, 'Ciclismo', 'Esporte que utiliza bicicleta para melhorar resistência cardiovascular e fortalecer membros inferiores', 1),
(19, 'Treinamento em Suspensão', 'Método que utiliza cordas e o peso do corpo para desenvolver força e equilíbrio', 1),
(20, 'Levantamento de Peso Olímpico', 'Esporte que envolve os movimentos de arranco e arremesso com halteres', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `modalidades_academia`
--

DROP TABLE IF EXISTS `modalidades_academia`;
CREATE TABLE IF NOT EXISTS `modalidades_academia` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idAcademia` int NOT NULL,
  `idModalidade` int NOT NULL,
  `data_associacao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_academia_modalidade` (`idAcademia`,`idModalidade`),
  KEY `idModalidade` (`idModalidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `modalidades_academia`
--

TRUNCATE TABLE `modalidades_academia`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `modalidades_aluno`
--

DROP TABLE IF EXISTS `modalidades_aluno`;
CREATE TABLE IF NOT EXISTS `modalidades_aluno` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idAluno` int NOT NULL,
  `idModalidade` int NOT NULL,
  `data_associacao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_aluno_modalidade` (`idAluno`,`idModalidade`),
  KEY `idModalidade` (`idModalidade`),
  KEY `idx_modalidades_aluno` (`idAluno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `modalidades_aluno`
--

TRUNCATE TABLE `modalidades_aluno`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `modalidades_personal`
--

DROP TABLE IF EXISTS `modalidades_personal`;
CREATE TABLE IF NOT EXISTS `modalidades_personal` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idPersonal` int NOT NULL,
  `idModalidade` int NOT NULL,
  `data_associacao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_personal_modalidade` (`idPersonal`,`idModalidade`),
  KEY `idModalidade` (`idModalidade`),
  KEY `idx_modalidades_personal` (`idPersonal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `modalidades_personal`
--

TRUNCATE TABLE `modalidades_personal`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `notificacoes`
--

DROP TABLE IF EXISTS `notificacoes`;
CREATE TABLE IF NOT EXISTS `notificacoes` (
  `idNotificacao` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `tipoUsuario` enum('aluno','personal','academia') COLLATE utf8mb4_general_ci NOT NULL,
  `titulo` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `mensagem` text COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `lida` tinyint(1) DEFAULT '0',
  `data_criacao` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idNotificacao`),
  KEY `idx_usuario` (`idUsuario`,`tipoUsuario`),
  KEY `idx_lida` (`lida`),
  KEY `idx_data` (`data_criacao`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `notificacoes`
--

TRUNCATE TABLE `notificacoes`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `nutrientes`
--

DROP TABLE IF EXISTS `nutrientes`;
CREATE TABLE IF NOT EXISTS `nutrientes` (
  `idNutrientes` int NOT NULL AUTO_INCREMENT,
  `alimento_id` int NOT NULL,
  `calorias` decimal(10,2) DEFAULT '0.00',
  `proteinas` decimal(10,2) DEFAULT '0.00',
  `carboidratos` decimal(10,2) DEFAULT '0.00',
  `gorduras` decimal(10,2) DEFAULT '0.00',
  `medida` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'g',
  PRIMARY KEY (`idNutrientes`),
  UNIQUE KEY `alimento_id` (`alimento_id`),
  KEY `idx_alimento` (`alimento_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `nutrientes`
--

TRUNCATE TABLE `nutrientes`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `pagamentos`
--

DROP TABLE IF EXISTS `pagamentos`;
CREATE TABLE IF NOT EXISTS `pagamentos` (
  `idPagamento` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `tipo_usuario` enum('aluno','personal','academia') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `idPlano` int NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `metodo_pagamento` enum('cartao_credito','cartao_debito','pix','boleto') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('pendente','aprovado','recusado','cancelado','reembolsado') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pendente',
  `id_gateway_pagamento` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_pagamento` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `data_confirmacao` datetime DEFAULT NULL,
  PRIMARY KEY (`idPagamento`),
  KEY `FK_Pagamento_Plano` (`idPlano`),
  KEY `idx_usuario_pagamento` (`idUsuario`,`tipo_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `pagamentos`
--

TRUNCATE TABLE `pagamentos`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `personal`
--

DROP TABLE IF EXISTS `personal`;
CREATE TABLE IF NOT EXISTS `personal` (
  `idPersonal` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cpf` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `rg` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cref_numero` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cref_categoria` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cref_regional` enum('AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO','Outro') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cref_verificado` tinyint(1) NOT NULL DEFAULT '0',
  `cref_data_verificacao` datetime DEFAULT NULL,
  `cref_observacao` text COLLATE utf8mb4_general_ci,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `senha` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `numTel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `idade` int DEFAULT NULL,
  `data_nascimento` date DEFAULT NULL,
  `genero` enum('Masculino','Feminino','Outro') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `foto_perfil` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `foto_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cref_foto_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_cadastro` datetime NOT NULL,
  `tipoPlano` enum('Básico(Gratuito)','Plus') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Básico(Gratuito)',
  `status_conta` enum('Ativa','Pendente','Excluida') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Ativa',
  `idPlano` int NOT NULL DEFAULT '3',
  `idAcademia` int DEFAULT NULL,
  `treinos_adaptados` tinyint(1) NOT NULL DEFAULT '0',
  `sobre` text COLLATE utf8mb4_general_ci,
  `cadastro_completo` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idPersonal`),
  UNIQUE KEY `cpf` (`cpf`),
  UNIQUE KEY `cref_numero` (`cref_numero`),
  UNIQUE KEY `numTel` (`numTel`),
  UNIQUE KEY `rg` (`rg`),
  UNIQUE KEY `email` (`email`),
  KEY `FK_Personal_Plano` (`idPlano`),
  KEY `idx_personal_academia` (`idAcademia`),
  KEY `idx_personal_status` (`status_conta`),
  KEY `idx_personal_treinos_adaptados` (`treinos_adaptados`),
  KEY `idx_personal_data_nascimento` (`data_nascimento`),
  KEY `idx_personal_genero` (`genero`),
  KEY `idx_personal_foto_url` (`foto_url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `personal`
--

TRUNCATE TABLE `personal`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `planos`
--

DROP TABLE IF EXISTS `planos`;
CREATE TABLE IF NOT EXISTS `planos` (
  `idPlano` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `valor_mensal` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tipo_usuario` enum('aluno','personal','academia') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `caracteristicas` json DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idPlano`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `planos`
--

TRUNCATE TABLE `planos`;
--
-- Extraindo dados da tabela `planos`
--

INSERT INTO `planos` (`idPlano`, `nome`, `descricao`, `valor_mensal`, `tipo_usuario`, `caracteristicas`, `ativo`, `created_at`, `updated_at`) VALUES
(1, 'Aluno Básico', 'Plano gratuito para alunos com funcionalidades essenciais', '0.00', 'aluno', '[\"Acesso a treinos básicos\", \"Visualização de exercícios\", \"Acompanhamento de medidas\"]', 1, '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(2, 'Aluno Plus', 'Plano premium para alunos com funcionalidades avançadas', '29.90', 'aluno', '[\"Acesso a todos os treinos\", \"Planos alimentares personalizados\", \"Suporte prioritário\", \"Relatórios detalhados\"]', 1, '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(3, 'Personal Básico', 'Plano gratuito para personal trainers', '0.00', 'personal', '[\"Gerenciar até 5 alunos\", \"Criar treinos básicos\", \"Acompanhamento de alunos\"]', 1, '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(4, 'Personal Plus', 'Plano premium para personal trainers', '99.90', 'personal', '[\"Gerenciar alunos ilimitados\", \"Criar treinos avançados\", \"Relatórios detalhados\", \"Suporte prioritário\", \"Acesso a recursos exclusivos\"]', 1, '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(5, 'Academia Premium', 'Plano completo para academias', '299.90', 'academia', '[\"Gerenciar múltiplos personais\", \"Relatórios corporativos\", \"Suporte dedicado\", \"API de integração\", \"Dashboard administrativo\"]', 1, '2025-10-02 22:55:48', '2025-10-02 22:55:48');

-- --------------------------------------------------------

--
-- Estrutura da tabela `progresso`
--

DROP TABLE IF EXISTS `progresso`;
CREATE TABLE IF NOT EXISTS `progresso` (
  `idProgresso` int NOT NULL AUTO_INCREMENT,
  `idAluno` int NOT NULL,
  `data` datetime NOT NULL,
  `peso` decimal(5,2) DEFAULT NULL,
  `altura` decimal(3,2) DEFAULT NULL,
  `observacoes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`idProgresso`),
  KEY `FK_Progresso_Aluno` (`idAluno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `progresso`
--

TRUNCATE TABLE `progresso`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `recuperacao_senha`
--

DROP TABLE IF EXISTS `recuperacao_senha`;
CREATE TABLE IF NOT EXISTS `recuperacao_senha` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `token_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `expiraEm` datetime NOT NULL,
  `tentativas` int NOT NULL DEFAULT '0',
  `usado` tinyint(1) NOT NULL DEFAULT '0',
  `criadoEm` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `email` (`email`),
  KEY `expiraEm` (`expiraEm`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `recuperacao_senha`
--

TRUNCATE TABLE `recuperacao_senha`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `refeicoes_tipos`
--

DROP TABLE IF EXISTS `refeicoes_tipos`;
CREATE TABLE IF NOT EXISTS `refeicoes_tipos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idAluno` int NOT NULL,
  `nome_tipo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `data_ref` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_aluno_data` (`idAluno`,`data_ref`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `refeicoes_tipos`
--

TRUNCATE TABLE `refeicoes_tipos`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `solicitacoes_academia`
--

DROP TABLE IF EXISTS `solicitacoes_academia`;
CREATE TABLE IF NOT EXISTS `solicitacoes_academia` (
  `idSolicitacao` int NOT NULL AUTO_INCREMENT,
  `token` varchar(64) COLLATE utf8mb4_general_ci NOT NULL,
  `idAcademia` int NOT NULL,
  `idUsuario` int NOT NULL,
  `tipo_usuario` enum('aluno','personal') COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('pendente','aceita','recusada') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pendente',
  `mensagem_solicitante` text COLLATE utf8mb4_general_ci,
  `mensagem_resposta` text COLLATE utf8mb4_general_ci,
  `data_criacao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `data_resposta` datetime DEFAULT NULL,
  `visualizado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idSolicitacao`),
  UNIQUE KEY `token` (`token`),
  KEY `idAcademia` (`idAcademia`),
  KEY `idx_usuario_tipo` (`idUsuario`,`tipo_usuario`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `solicitacoes_academia`
--

TRUNCATE TABLE `solicitacoes_academia`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `traducoes_alimentos`
--

DROP TABLE IF EXISTS `traducoes_alimentos`;
CREATE TABLE IF NOT EXISTS `traducoes_alimentos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome_original` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nome_traduzido` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `idioma_original` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'en',
  `idioma_traduzido` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pt',
  `data_criacao` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `data_atualizacao` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome_original_idioma_original` (`nome_original`,`idioma_original`),
  KEY `idx_nome_traduzido` (`nome_traduzido`)
) ENGINE=InnoDB AUTO_INCREMENT=497 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `traducoes_alimentos`
--

TRUNCATE TABLE `traducoes_alimentos`;
--
-- Extraindo dados da tabela `traducoes_alimentos`
--

INSERT INTO `traducoes_alimentos` (`id`, `nome_original`, `nome_traduzido`, `idioma_original`, `idioma_traduzido`, `data_criacao`, `data_atualizacao`) VALUES
(1, 'apple', 'maçã', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-14 03:06:42'),
(2, 'banana', 'banana', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-12 19:16:08'),
(3, 'orange', 'laranja', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(4, 'rice', 'arroz', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-06 09:48:01'),
(5, 'beans', 'feijão', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(6, 'chicken', 'frango', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(7, 'beef', 'carne bovina', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(8, 'fish', 'peixe', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(9, 'egg', 'ovo', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-07 05:39:19'),
(10, 'milk', 'leite', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(11, 'bread', 'pão', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(12, 'cheese', 'queijo', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(13, 'yogurt', 'iogurte', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-13 02:19:42'),
(14, 'pasta', 'massa', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(15, 'potato', 'batata', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(16, 'tomato', 'tomate', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(17, 'lettuce', 'alface', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(18, 'carrot', 'cenoura', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(19, 'broccoli', 'brócolis', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(20, 'spinach', 'espinafre', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(21, 'avocado', 'abacate', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(22, 'strawberry', 'morango', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(23, 'grape', 'uva', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(24, 'watermelon', 'melancia', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(25, 'pineapple', 'abacaxi', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(26, 'cucumber', 'pepino', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(27, 'onion', 'cebola', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(28, 'garlic', 'alho', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(29, 'pepper', 'pimentão', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(30, 'mushroom', 'cogumelo', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(31, 'corn', 'milho', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-06 09:20:45'),
(32, 'pea', 'ervilha', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(33, 'lentil', 'lentilha', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(34, 'oat', 'aveia', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(35, 'almond', 'amêndoa', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(36, 'walnut', 'noz', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(37, 'peanut', 'amendoim', 'en', 'pt', '2025-10-02 22:55:48', '2025-10-02 22:55:48'),
(40, 'applesauce', 'molho de maçã', 'en', 'pt', '2025-10-06 01:37:51', '2025-10-14 03:06:39'),
(42, 'apple juice', 'suco de maçã', 'en', 'pt', '2025-10-06 01:37:54', '2025-10-14 03:06:39'),
(44, 'apple cider', 'cidra de maçã', 'en', 'pt', '2025-10-06 01:37:57', '2025-10-14 03:06:39'),
(46, 'apple jelly', 'geleia de maçã', 'en', 'pt', '2025-10-06 01:37:59', '2025-10-14 03:06:39'),
(48, 'apple sauce', 'purê de maçã', 'en', 'pt', '2025-10-06 01:49:57', '2025-10-06 01:49:57'),
(49, 'apple pie', 'torta de maçã', 'en', 'pt', '2025-10-06 01:49:57', '2025-10-06 01:49:57'),
(50, 'apple crisp', 'crocante de maçã', 'en', 'pt', '2025-10-06 01:49:57', '2025-10-06 02:06:48'),
(51, 'apple strudel', 'strudel de maçã', 'en', 'pt', '2025-10-06 01:49:57', '2025-10-06 01:49:57'),
(52, 'apple turnover', 'folhado de maçã', 'en', 'pt', '2025-10-06 01:49:57', '2025-10-06 01:49:57'),
(53, 'apple butter', 'doce de maçã', 'en', 'pt', '2025-10-06 01:49:57', '2025-10-14 03:06:39'),
(54, 'apple muffin', 'muffin de maçã', 'en', 'pt', '2025-10-06 01:49:57', '2025-10-06 01:49:57'),
(55, 'apple cake', 'bolo de maçã', 'en', 'pt', '2025-10-06 01:49:57', '2025-10-06 01:49:57'),
(56, 'apple compote', 'compota de maçã', 'en', 'pt', '2025-10-06 01:49:57', '2025-10-06 01:49:57'),
(57, 'apple tart', 'tarte de maçã', 'en', 'pt', '2025-10-06 01:49:57', '2025-10-06 01:49:57'),
(58, 'red apple', 'maçã vermelha', 'en', 'pt', '2025-10-06 01:50:13', '2025-10-06 01:50:13'),
(59, 'green apple', 'maçã verde', 'en', 'pt', '2025-10-06 01:50:13', '2025-10-06 01:50:13'),
(60, 'fresh apple', 'maçã fresca', 'en', 'pt', '2025-10-06 01:50:13', '2025-10-06 01:50:13'),
(61, 'dried apple', 'maçã seca', 'en', 'pt', '2025-10-06 01:50:13', '2025-10-06 01:50:13'),
(62, 'apple slice', 'fatia de maçã', 'en', 'pt', '2025-10-06 01:50:13', '2025-10-06 01:50:13'),
(63, 'apple wedge', 'gomo de maçã', 'en', 'pt', '2025-10-06 01:50:13', '2025-10-06 01:50:13'),
(73, 'apple pie spice', 'especiarias para torta de maçã', 'en', 'pt', '2025-10-06 02:03:46', '2025-10-14 03:06:39'),
(75, 'apple pie filling', 'recheio de torta de maçã', 'en', 'pt', '2025-10-06 02:03:48', '2025-10-14 03:06:39'),
(77, 'apple cider vinegar', 'vinagre de maçã', 'en', 'pt', '2025-10-06 02:03:49', '2025-10-14 03:06:39'),
(79, 'applewood smoked bacon', 'bacon defumado applewood', 'en', 'pt', '2025-10-06 02:03:50', '2025-10-14 03:06:39'),
(342, 'banana leaves', 'folhas de bananeira', 'en', 'pt', '2025-10-07 04:49:29', '2025-10-12 19:16:08'),
(344, 'banana chips', 'Chips de banana', 'en', 'pt', '2025-10-07 04:49:31', '2025-10-12 19:16:08'),
(346, 'banana bread', 'Pão de banana 45', 'en', 'pt', '2025-10-07 04:49:33', '2025-10-12 19:16:08'),
(348, 'banana pepper', 'pimenta-banana', 'en', 'pt', '2025-10-07 04:49:34', '2025-10-12 19:16:08'),
(350, 'pink banana squash', 'abóbora-banana-rosa', 'en', 'pt', '2025-10-07 04:49:36', '2025-10-12 19:16:08'),
(352, 'banana blossoms', 'flores de bananeira', 'en', 'pt', '2025-10-07 04:49:38', '2025-10-12 19:16:08'),
(354, 'banana pepper rings', 'anéis de pimenta-banana', 'en', 'pt', '2025-10-07 04:49:39', '2025-10-12 19:16:08'),
(356, 'banana liqueur', 'licor de banana', 'en', 'pt', '2025-10-07 04:49:40', '2025-10-12 19:16:08'),
(358, 'banana extract', 'extrato de banana', 'en', 'pt', '2025-10-07 04:49:42', '2025-10-12 19:16:08'),
(374, 'eggnog', 'Gemada', 'en', 'pt', '2025-10-07 05:13:03', '2025-10-07 05:14:04'),
(376, 'eggplant', 'beringelas', 'en', 'pt', '2025-10-07 05:13:05', '2025-10-07 05:14:04'),
(378, 'egg whites', 'Clara de Ovo', 'en', 'pt', '2025-10-07 05:13:07', '2025-10-07 05:14:04'),
(380, 'egg yolk', 'gema de ovo', 'en', 'pt', '2025-10-07 05:13:09', '2025-10-07 05:14:04'),
(382, 'challah', 'Chalá', 'en', 'pt', '2025-10-07 05:13:10', '2025-10-07 05:14:04'),
(384, 'egg noodles', 'Massa de ovos', 'en', 'pt', '2025-10-07 05:13:12', '2025-10-07 05:14:04'),
(386, 'liquid egg whites', 'claras líquidas de ovo', 'en', 'pt', '2025-10-07 05:13:14', '2025-10-07 05:14:04'),
(388, 'egg replacer', 'substituto de ovo', 'en', 'pt', '2025-10-07 05:13:15', '2025-10-07 05:14:04'),
(390, 'egg roll wrappers', 'invólucros de rolo de ovo', 'en', 'pt', '2025-10-07 05:13:17', '2025-10-07 05:14:04'),
(441, 'soy yogurt', 'iogurte de soja', 'en', 'pt', '2025-10-07 05:22:25', '2025-10-13 02:19:42'),
(443, 'fat free yogurt', 'iogurte sem gordura', 'en', 'pt', '2025-10-07 05:22:27', '2025-10-13 02:19:42'),
(445, 'greek yogurt', 'iogurte grego', 'en', 'pt', '2025-10-07 05:22:27', '2025-10-13 02:20:04'),
(447, 'plain yogurt', 'iogurte natural', 'en', 'pt', '2025-10-07 05:22:29', '2025-10-13 02:19:42'),
(449, 'low fat plain yogurt', 'iogurte natural com baixo teor de gordura', 'en', 'pt', '2025-10-07 05:22:30', '2025-10-13 02:19:42'),
(451, 'frozen yogurt', 'SORVETE DE IOGURTE', 'en', 'pt', '2025-10-07 05:22:32', '2025-10-13 02:19:42'),
(453, 'vanilla yogurt', 'iogurte de baunilha', 'en', 'pt', '2025-10-07 05:22:34', '2025-10-13 02:19:42'),
(455, 'strawberry yogurt', 'iogurte de morango,', 'en', 'pt', '2025-10-07 05:22:36', '2025-10-13 02:19:42'),
(457, 'fat free greek yogurt', 'iogurte grego sem gordura', 'en', 'pt', '2025-10-07 05:22:37', '2025-10-13 02:19:42'),
(459, 'strawberry yogurt,', 'iogurte de morango,', 'en', 'pt', '2025-10-07 05:26:02', '2025-10-07 05:34:42'),
(484, 'Couscous', 'cuzcuz', 'en', 'pt', '2025-10-14 03:07:00', '2025-10-14 03:07:17'),
(486, 'dry couscous', 'cuscuz seco', 'en', 'pt', '2025-10-14 03:07:03', '2025-10-14 03:07:03'),
(488, 'dry israeli couscous', 'cuscuz israelita seco', 'en', 'pt', '2025-10-14 03:07:05', '2025-10-14 03:07:05'),
(490, 'cooked couscous', 'cuscuz cozido', 'en', 'pt', '2025-10-14 03:07:07', '2025-10-14 03:07:07'),
(492, 'whole wheat couscous', 'cuscuz de trigo integral', 'en', 'pt', '2025-10-14 03:07:08', '2025-10-14 03:07:08'),
(494, 'cooked israeli couscous', 'cuscuz israelita cozido', 'en', 'pt', '2025-10-14 03:07:10', '2025-10-14 03:07:10');

-- --------------------------------------------------------

--
-- Estrutura da tabela `treinos`
--

DROP TABLE IF EXISTS `treinos`;
CREATE TABLE IF NOT EXISTS `treinos` (
  `idTreino` int NOT NULL AUTO_INCREMENT,
  `idAluno` int DEFAULT NULL,
  `idPersonal` int DEFAULT NULL,
  `criadoPor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nome` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('Musculação','CrossFit','Calistenia','Pilates','Aquecimento','Treino Específico','Outros') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `data_criacao` datetime NOT NULL,
  `data_ultima_modificacao` datetime NOT NULL,
  `tipo_treino` enum('normal','adaptado') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'normal',
  `ultima_sessao_id` int DEFAULT NULL,
  PRIMARY KEY (`idTreino`),
  KEY `FK_Treinos_Aluno` (`idAluno`),
  KEY `FK_Treinos_Personal` (`idPersonal`),
  KEY `FK_Treino_UltimaSessao` (`ultima_sessao_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `treinos`
--

TRUNCATE TABLE `treinos`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `treino_exercicio`
--

DROP TABLE IF EXISTS `treino_exercicio`;
CREATE TABLE IF NOT EXISTS `treino_exercicio` (
  `idTreino_Exercicio` int NOT NULL AUTO_INCREMENT,
  `idTreino` int NOT NULL,
  `idExercicio` int DEFAULT NULL,
  `idExercAdaptado` int DEFAULT NULL,
  `data_criacao` datetime NOT NULL,
  `data_ultima_modificacao` datetime NOT NULL,
  `series` int DEFAULT NULL,
  `repeticoes` int DEFAULT NULL,
  `carga` decimal(5,2) DEFAULT NULL,
  `ordem` int DEFAULT NULL,
  `observacoes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `descanso` int DEFAULT NULL,
  PRIMARY KEY (`idTreino_Exercicio`),
  KEY `FK_TreinoExercicio_Treino` (`idTreino`),
  KEY `FK_TreinoExercicio_Exercicio` (`idExercicio`),
  KEY `FK_TreinoExercicio_ExercAdaptado` (`idExercAdaptado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `treino_exercicio`
--

TRUNCATE TABLE `treino_exercicio`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `treino_exercicio_historico`
--

DROP TABLE IF EXISTS `treino_exercicio_historico`;
CREATE TABLE IF NOT EXISTS `treino_exercicio_historico` (
  `idHistorico` int NOT NULL AUTO_INCREMENT,
  `idTreino_Exercicio` int NOT NULL,
  `idTreino` int NOT NULL,
  `idExercicio` int DEFAULT NULL,
  `idExercAdaptado` int DEFAULT NULL,
  `series` int DEFAULT NULL,
  `repeticoes` int DEFAULT NULL,
  `carga` decimal(10,2) DEFAULT NULL,
  `ordem` int DEFAULT NULL,
  `observacoes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `data_modificacao` datetime NOT NULL,
  `acao` enum('INSERT','UPDATE','DELETE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`idHistorico`),
  KEY `FK_Historico_TreinoExercicio` (`idTreino_Exercicio`),
  KEY `FK_Historico_Treino` (`idTreino`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `treino_exercicio_historico`
--

TRUNCATE TABLE `treino_exercicio_historico`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `treino_sessao`
--

DROP TABLE IF EXISTS `treino_sessao`;
CREATE TABLE IF NOT EXISTS `treino_sessao` (
  `idSessao` int NOT NULL AUTO_INCREMENT,
  `idTreino` int NOT NULL,
  `idUsuario` int NOT NULL,
  `tipo_usuario` enum('aluno','personal') COLLATE utf8mb4_general_ci NOT NULL,
  `data_inicio` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `data_fim` datetime DEFAULT NULL,
  `status` enum('em_progresso','concluido','cancelado') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'em_progresso',
  `progresso_json` json DEFAULT NULL,
  `porcentagem_concluida` int DEFAULT '0',
  `duracao_total` int DEFAULT NULL,
  `notas` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`idSessao`),
  KEY `idx_usuario_data` (`idUsuario`,`tipo_usuario`,`data_inicio`),
  KEY `idx_treino` (`idTreino`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `treino_sessao`
--

TRUNCATE TABLE `treino_sessao`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `usuarios_academia`
--

DROP TABLE IF EXISTS `usuarios_academia`;
CREATE TABLE IF NOT EXISTS `usuarios_academia` (
  `idVinculo` int NOT NULL AUTO_INCREMENT,
  `idAcademia` int NOT NULL,
  `idUsuario` int NOT NULL,
  `tipo_usuario` enum('aluno','personal') COLLATE utf8mb4_general_ci NOT NULL,
  `data_vinculo` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('ativo','inativo') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ativo',
  `data_desvinculo` datetime DEFAULT NULL,
  `motivo_desvinculo` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`idVinculo`),
  UNIQUE KEY `unique_usuario_academia` (`idAcademia`,`idUsuario`,`tipo_usuario`),
  KEY `idx_academia` (`idAcademia`),
  KEY `idx_usuario` (`idUsuario`,`tipo_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `usuarios_academia`
--

TRUNCATE TABLE `usuarios_academia`;
-- --------------------------------------------------------

--
-- Estrutura da tabela `videos`
--

DROP TABLE IF EXISTS `videos`;
CREATE TABLE IF NOT EXISTS `videos` (
  `idvideos` int NOT NULL AUTO_INCREMENT,
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `idExercicio` int DEFAULT NULL,
  `idExercAdaptado` int DEFAULT NULL,
  `cover` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_video` enum('normal','adaptado') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'normal',
  `titulo` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` text COLLATE utf8mb4_general_ci,
  `duracao` int DEFAULT NULL,
  PRIMARY KEY (`idvideos`),
  KEY `FK_Video_Exercicio` (`idExercicio`),
  KEY `FK_Video_ExercAdaptado` (`idExercAdaptado`)
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncar tabela antes do insert `videos`
--

TRUNCATE TABLE `videos`;
--
-- Extraindo dados da tabela `videos`
--

INSERT INTO `videos` (`idvideos`, `url`, `idExercicio`, `idExercAdaptado`, `cover`, `tipo_video`, `titulo`, `descricao`, `duracao`) VALUES
(1, 'https://www.youtube.com/watch?v=DrIZblSimW8', 1, NULL, '', 'normal', NULL, NULL, NULL),
(2, 'https://www.youtube.com/watch?v=kIFCWmiBOpo', 2, NULL, '', 'normal', NULL, NULL, NULL),
(3, 'https://www.youtube.com/watch?v=MzKobWFCmtk', 3, NULL, '', 'normal', NULL, NULL, NULL),
(4, 'https://www.youtube.com/watch?v=HwpcEMHePJ8', 4, NULL, '', 'normal', NULL, NULL, NULL),
(5, 'https://www.youtube.com/watch?v=D2ta8xvURwo', 5, NULL, '', 'normal', NULL, NULL, NULL),
(6, 'https://www.youtube.com/watch?v=P36j7gLzEZY', 6, NULL, '', 'normal', NULL, NULL, NULL),
(7, 'https://www.youtube.com/watch?v=nQ6DyydhAIo', 7, NULL, '', 'normal', NULL, NULL, NULL),
(8, 'https://www.youtube.com/watch?v=F9nNOp8Rfoo', 8, NULL, '', 'normal', NULL, NULL, NULL),
(9, 'https://www.youtube.com/watch?v=TVrxH3UJjfs', 9, NULL, '', 'normal', NULL, NULL, NULL),
(10, 'https://www.youtube.com/watch?v=bJdvab9uVUc', 10, NULL, '', 'normal', NULL, NULL, NULL),
(11, 'https://www.youtube.com/watch?v=bxM8uWGrP0E', 11, NULL, '', 'normal', NULL, NULL, NULL),
(12, 'https://www.youtube.com/watch?v=Qo2qqimmdFw', 12, NULL, '', 'normal', NULL, NULL, NULL),
(13, 'https://www.youtube.com/watch?v=ahOm8a3oncs', 13, NULL, '', 'normal', NULL, NULL, NULL),
(14, 'https://www.youtube.com/watch?v=hFb0YL6pPhY', 14, NULL, '', 'normal', NULL, NULL, NULL),
(15, 'https://www.youtube.com/watch?v=TnK4DsvAts4', 15, NULL, '', 'normal', NULL, NULL, NULL),
(16, 'https://www.youtube.com/watch?v=4DapiJicioo', 16, NULL, '', 'normal', NULL, NULL, NULL),
(17, 'https://www.youtube.com/watch?v=srgDQ6ie7qk', 17, NULL, '', 'normal', NULL, NULL, NULL),
(18, 'https://www.youtube.com/watch?v=hZB7xezXbMM', 18, NULL, '', 'normal', NULL, NULL, NULL),
(19, 'https://www.youtube.com/watch?v=CCLW6lekNTw', 19, NULL, '', 'normal', NULL, NULL, NULL),
(20, 'https://www.youtube.com/watch?v=YgcwPqxibnE', 20, NULL, '', 'normal', NULL, NULL, NULL),
(21, 'https://www.youtube.com/watch?v=DMPDjQdwhkA', 21, NULL, '', 'normal', NULL, NULL, NULL),
(22, 'https://www.youtube.com/watch?v=BTEkru3wrfg', 22, NULL, '', 'normal', NULL, NULL, NULL),
(23, 'https://www.youtube.com/watch?v=uFOs6zI883o', 23, NULL, '', 'normal', NULL, NULL, NULL),
(24, 'https://www.youtube.com/watch?v=z3fMvMyql8A', 24, NULL, '', 'normal', NULL, NULL, NULL),
(25, 'https://www.youtube.com/watch?v=mnOcntB2QE0', 25, NULL, '', 'normal', NULL, NULL, NULL),
(26, 'https://www.youtube.com/watch?v=t3Uu11HfaNQ', 26, NULL, '', 'normal', NULL, NULL, NULL),
(27, 'https://www.youtube.com/watch?v=Lsn4LVvtm44', 27, NULL, '', 'normal', NULL, NULL, NULL),
(28, 'https://www.youtube.com/watch?v=9w4pFCQvKg4', 28, NULL, '', 'normal', NULL, NULL, NULL),
(29, 'https://www.youtube.com/watch?v=m8J4xGmVXRA', 29, NULL, '', 'normal', NULL, NULL, NULL),
(30, 'https://www.youtube.com/watch?v=637o04QCWs0', 30, NULL, '', 'normal', NULL, NULL, NULL),
(31, 'https://www.youtube.com/watch?v=fNYeFdgR6Gs', 31, NULL, '', 'normal', NULL, NULL, NULL),
(32, 'https://www.youtube.com/watch?v=5gmwbzepi7E', 32, NULL, '', 'normal', NULL, NULL, NULL),
(33, 'https://www.youtube.com/watch?v=xkmxQaz6M3c', 33, NULL, '', 'normal', NULL, NULL, NULL),
(34, 'https://www.youtube.com/watch?v=V4m_uE1M0TM', 34, NULL, '', 'normal', NULL, NULL, NULL),
(35, 'https://www.youtube.com/watch?v=LHyYmMSTbj8', 35, NULL, '', 'normal', NULL, NULL, NULL),
(36, 'https://www.youtube.com/watch?v=QL1uD2E_xpg', 36, NULL, '', 'normal', NULL, NULL, NULL),
(37, 'https://www.youtube.com/watch?v=zpHgB1srbJA', 37, NULL, '', 'normal', NULL, NULL, NULL),
(38, 'https://www.youtube.com/watch?v=2Sb2_atoD2c', 38, NULL, '', 'normal', NULL, NULL, NULL),
(39, 'https://www.youtube.com/watch?v=rhlwE-J37x8', 39, NULL, '', 'normal', NULL, NULL, NULL),
(40, 'https://www.youtube.com/watch?v=EjiH-RcOR2U', 40, NULL, '', 'normal', NULL, NULL, NULL),
(41, 'https://www.youtube.com/watch?v=Q3motWl8P4w', 41, NULL, '', 'normal', NULL, NULL, NULL),
(42, 'https://www.youtube.com/watch?v=LoWCU2Yb4AY', 42, NULL, '', 'normal', NULL, NULL, NULL),
(43, 'https://www.youtube.com/watch?v=_3Mihov5a24', 43, NULL, '', 'normal', NULL, NULL, NULL),
(44, 'https://www.youtube.com/watch?v=OuEJB34uSKI', 44, NULL, '', 'normal', NULL, NULL, NULL),
(45, 'https://www.youtube.com/watch?v=jl2m6ch53NU', 45, NULL, '', 'normal', NULL, NULL, NULL),
(46, 'https://www.youtube.com/watch?v=gVC2jMVZVfE', 46, NULL, '', 'normal', NULL, NULL, NULL),
(47, 'https://www.youtube.com/watch?v=bCUMKcOefUU', 47, NULL, '', 'normal', NULL, NULL, NULL),
(48, 'https://www.youtube.com/watch?v=bKPmruztS8g', 48, NULL, '', 'normal', NULL, NULL, NULL),
(49, 'https://www.youtube.com/watch?v=1l7icabk0mo', 49, NULL, '', 'normal', NULL, NULL, NULL),
(50, 'https://www.youtube.com/watch?v=j7a4_SjM8ZM', 50, NULL, '', 'normal', NULL, NULL, NULL),
(51, 'https://www.youtube.com/watch?v=PXiJKmAyLR8', 51, NULL, '', 'normal', NULL, NULL, NULL),
(52, 'https://www.youtube.com/watch?v=OXH8gKrYzig', 52, NULL, '', 'normal', NULL, NULL, NULL),
(53, 'https://www.youtube.com/watch?v=toQuzSgZm8E', 53, NULL, '', 'normal', NULL, NULL, NULL),
(54, 'https://www.youtube.com/watch?v=P2HPQuUHMsQ', 54, NULL, '', 'normal', NULL, NULL, NULL),
(55, 'https://www.youtube.com/watch?v=-7OxAps9mvk', 55, NULL, '', 'normal', NULL, NULL, NULL),
(56, 'https://www.youtube.com/watch?v=3H5Kw5-_Lw8', 56, NULL, '', 'normal', NULL, NULL, NULL),
(57, 'https://www.youtube.com/watch?v=vMXNqjcc21c', 57, NULL, '', 'normal', NULL, NULL, NULL),
(58, 'https://www.youtube.com/watch?v=4O_9NktinIw', 58, NULL, '', 'normal', NULL, NULL, NULL),
(59, 'https://www.youtube.com/watch?v=wtcZa02D5-c', 59, NULL, '', 'normal', NULL, NULL, NULL),
(60, 'https://www.youtube.com/watch?v=zqvKtQippnA', 60, NULL, '', 'normal', NULL, NULL, NULL),
(61, 'https://www.youtube.com/watch?v=69JIUT2q6lU', 61, NULL, '', 'normal', NULL, NULL, NULL),
(62, 'https://www.youtube.com/watch?v=mahiVOFUv14', 62, NULL, '', 'normal', NULL, NULL, NULL),
(63, 'https://www.youtube.com/watch?v=gvbWkKYP0VY', 63, NULL, '', 'normal', NULL, NULL, NULL),
(64, 'https://www.youtube.com/watch?v=1EQU0jBpcds', 64, NULL, '', 'normal', NULL, NULL, NULL),
(65, 'https://www.youtube.com/watch?v=zEgL8MSaSs8', 65, NULL, '', 'normal', NULL, NULL, NULL),
(66, 'https://www.youtube.com/watch?v=gh7fXWsPKaM', 66, NULL, '', 'normal', NULL, NULL, NULL),
(67, 'https://www.youtube.com/watch?v=fCqyKmIVH00', 67, NULL, '', 'normal', NULL, NULL, NULL),
(68, 'https://www.youtube.com/watch?v=QYF8YgU8few', 68, NULL, '', 'normal', NULL, NULL, NULL),
(69, 'https://www.youtube.com/watch?v=PJMPwGvDxaQ', 69, NULL, '', 'normal', NULL, NULL, NULL),
(70, 'https://www.youtube.com/watch?v=NjE50Vz5Lkc', 70, NULL, '', 'normal', NULL, NULL, NULL),
(71, 'https://www.youtube.com/watch?v=I30xMS5gyPw', 71, NULL, '', 'normal', NULL, NULL, NULL),
(72, 'https://www.youtube.com/watch?v=QmIpJ498RNA', 72, NULL, '', 'normal', NULL, NULL, NULL),
(73, 'https://www.youtube.com/watch?v=u1DPdaxLMcw', 73, NULL, '', 'normal', NULL, NULL, NULL),
(74, 'https://www.youtube.com/watch?v=kWGRm-IDMQ4', 74, NULL, '', 'normal', NULL, NULL, NULL),
(75, 'https://www.youtube.com/watch?v=GKbh4fNX2gM', 75, NULL, '', 'normal', NULL, NULL, NULL),
(76, 'https://www.youtube.com/watch?v=uCgSv-4-S0A', 76, NULL, '', 'normal', NULL, NULL, NULL),
(77, 'https://www.youtube.com/watch?v=-OmMnWC4iT4', 77, NULL, '', 'normal', NULL, NULL, NULL),
(78, 'https://www.youtube.com/watch?v=w5xVs3hCvfg', 78, NULL, '', 'normal', NULL, NULL, NULL),
(79, 'https://www.youtube.com/watch?v=PxsKGxKsDL0', 79, NULL, '', 'normal', NULL, NULL, NULL),
(80, 'https://www.youtube.com/watch?v=_UfEXzV5Yf4', 80, NULL, '', 'normal', NULL, NULL, NULL),
(81, 'https://www.youtube.com/watch?v=u41-6ZMC528', 81, NULL, '', 'normal', NULL, NULL, NULL),
(82, 'https://www.youtube.com/watch?v=HY8i_j-wvys', 82, NULL, '', 'normal', NULL, NULL, NULL),
(83, 'https://www.youtube.com/watch?v=idOLAV3JGDc', 83, NULL, '', 'normal', NULL, NULL, NULL),
(84, 'https://www.youtube.com/watch?v=YILZe3FfIw8', 84, NULL, '', 'normal', NULL, NULL, NULL),
(85, 'https://www.youtube.com/watch?v=aKRVoiOQK3Y', 85, NULL, '', 'normal', NULL, NULL, NULL),
(86, 'https://www.youtube.com/watch?v=0M0i4jD5CGw', 86, NULL, '', 'normal', NULL, NULL, NULL),
(87, 'https://www.youtube.com/watch?v=FaGtwve4s-E', 87, NULL, '', 'normal', NULL, NULL, NULL),
(88, 'https://www.youtube.com/watch?v=OpkKv88HzR8', 88, NULL, '', 'normal', NULL, NULL, NULL),
(89, 'https://www.youtube.com/watch?v=HbLx5f5vnhY', 89, NULL, '', 'normal', NULL, NULL, NULL),
(90, 'https://www.youtube.com/watch?v=jMnDwCn72ws', 90, NULL, '', 'normal', NULL, NULL, NULL),
(91, 'https://www.youtube.com/watch?v=DKD0id35rgU', 91, NULL, '', 'normal', NULL, NULL, NULL),
(92, 'https://www.youtube.com/watch?v=Tux6Q2AW0eA', 92, NULL, '', 'normal', NULL, NULL, NULL),
(93, 'https://www.youtube.com/watch?v=ZEdksboBtg4', 93, NULL, '', 'normal', NULL, NULL, NULL),
(94, 'https://www.youtube.com/watch?v=5MOa-_qdw9s', 94, NULL, '', 'normal', NULL, NULL, NULL),
(95, 'https://www.youtube.com/watch?v=RqOJkeiET5Q', 95, NULL, '', 'normal', NULL, NULL, NULL),
(96, 'https://www.youtube.com/watch?v=iAKisU13ypU', 96, NULL, '', 'normal', NULL, NULL, NULL),
(97, 'https://www.youtube.com/watch?v=WFAvShrNgiw', 97, NULL, '', 'normal', NULL, NULL, NULL),
(98, 'https://www.youtube.com/watch?v=6E5soH4kpL8', 98, NULL, '', 'normal', NULL, NULL, NULL),
(99, 'https://www.youtube.com/watch?v=DmqaUQaskwo', 99, NULL, '', 'normal', NULL, NULL, NULL),
(100, 'https://www.youtube.com/watch?v=0NES5nQ7tnw', 100, NULL, '', 'normal', NULL, NULL, NULL),
(101, 'https://www.youtube.com/watch?v=bc6X06OWyPk', 101, NULL, '', 'normal', NULL, NULL, NULL),
(102, 'https://www.youtube.com/watch?v=rreRO8-pPYg', 102, NULL, '', 'normal', NULL, NULL, NULL),
(103, 'https://www.youtube.com/watch?v=cJ4J7XoPo6E', 103, NULL, '', 'normal', NULL, NULL, NULL),
(104, 'https://www.youtube.com/watch?v=CC7fg3SEof8', 104, NULL, '', 'normal', NULL, NULL, NULL),
(105, 'https://www.youtube.com/watch?v=7CaF6Rsw_SA', 105, NULL, '', 'normal', NULL, NULL, NULL),
(106, 'https://www.youtube.com/watch?v=tATrzTP56_M', 106, NULL, '', 'normal', NULL, NULL, NULL),
(107, 'https://www.youtube.com/watch?v=HqWvQkwr_Zk', 107, NULL, '', 'normal', NULL, NULL, NULL),
(108, 'https://www.youtube.com/watch?v=lBRDG-psDdE', 108, NULL, '', 'normal', NULL, NULL, NULL),
(109, 'https://www.youtube.com/watch?v=7hebjw6AGGM', 109, NULL, '', 'normal', NULL, NULL, NULL),
(110, 'https://www.youtube.com/watch?v=cRWpZBMJZrw', 110, NULL, '', 'normal', NULL, NULL, NULL),
(111, 'https://www.youtube.com/watch?v=EgbM4kXE-2s', 111, NULL, '', 'normal', NULL, NULL, NULL),
(112, 'https://www.youtube.com/watch?v=A7BzMkvbGSY', 112, NULL, '', 'normal', NULL, NULL, NULL),
(113, 'https://www.youtube.com/watch?v=KSjVpHvJhLo', 113, NULL, '', 'normal', NULL, NULL, NULL),
(122, 'https://www.youtube.com/watch?v=oBXSvS2QKxU', 121, NULL, 'https://img.youtube.com/vi/oBXSvS2QKxU/hqdefault.jpg', 'normal', NULL, NULL, NULL),
(123, 'https://www.youtube.com/watch?v=oBXSvS2QKxU', 122, NULL, 'https://img.youtube.com/vi/oBXSvS2QKxU/hqdefault.jpg', 'normal', NULL, NULL, NULL),
(124, 'https://www.youtube.com/watch?v=URbJlVt5lgM', 123, NULL, 'https://img.youtube.com/vi/URbJlVt5lgM/hqdefault.jpg', 'normal', NULL, NULL, NULL),
(125, 'https://www.youtube.com/watch?v=URbJlVt5lgM', 124, NULL, 'https://img.youtube.com/vi/URbJlVt5lgM/hqdefault.jpg', 'normal', NULL, NULL, NULL),
(126, 'https://www.youtube.com/watch?v=URbJlVt5lgM', 125, NULL, 'https://img.youtube.com/vi/URbJlVt5lgM/hqdefault.jpg', 'normal', NULL, NULL, NULL),
(127, 'https://www.youtube.com/watch?v=URbJlVt5lgM', 126, NULL, 'https://img.youtube.com/vi/URbJlVt5lgM/hqdefault.jpg', 'normal', NULL, NULL, NULL),
(128, 'https://www.youtube.com/watch?v=URbJlVt5lgM', 127, NULL, 'https://img.youtube.com/vi/URbJlVt5lgM/hqdefault.jpg', 'normal', NULL, NULL, NULL);

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `agendamentos`
--
ALTER TABLE `agendamentos`
  ADD CONSTRAINT `FK_Agend_Aluno` FOREIGN KEY (`idAluno`) REFERENCES `alunos` (`idAluno`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_Agend_Personal` FOREIGN KEY (`idPersonal`) REFERENCES `personal` (`idPersonal`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `agua`
--
ALTER TABLE `agua`
  ADD CONSTRAINT `FK_idAluno_Agua` FOREIGN KEY (`idAluno`) REFERENCES `alunos` (`idAluno`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `alunos`
--
ALTER TABLE `alunos`
  ADD CONSTRAINT `FK_Alunos_Academia` FOREIGN KEY (`idAcademia`) REFERENCES `academias` (`idAcademia`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_Alunos_Personal` FOREIGN KEY (`idPersonal`) REFERENCES `personal` (`idPersonal`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_Alunos_Plano` FOREIGN KEY (`idPlano`) REFERENCES `planos` (`idPlano`);

--
-- Limitadores para a tabela `assinaturas`
--
ALTER TABLE `assinaturas`
  ADD CONSTRAINT `FK_Assinatura_Plano` FOREIGN KEY (`idPlano`) REFERENCES `planos` (`idPlano`);

--
-- Limitadores para a tabela `convites`
--
ALTER TABLE `convites`
  ADD CONSTRAINT `convites_ibfk_1` FOREIGN KEY (`idPersonal`) REFERENCES `personal` (`idPersonal`) ON DELETE CASCADE,
  ADD CONSTRAINT `convites_ibfk_2` FOREIGN KEY (`idAluno`) REFERENCES `alunos` (`idAluno`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `exercicios`
--
ALTER TABLE `exercicios`
  ADD CONSTRAINT `exercicios_ibfk_1` FOREIGN KEY (`idPersonal`) REFERENCES `personal` (`idPersonal`);

--
-- Limitadores para a tabela `medidas`
--
ALTER TABLE `medidas`
  ADD CONSTRAINT `FK_Medidas_Aluno` FOREIGN KEY (`idAluno`) REFERENCES `alunos` (`idAluno`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `modalidades_academia`
--
ALTER TABLE `modalidades_academia`
  ADD CONSTRAINT `modalidades_academia_ibfk_1` FOREIGN KEY (`idAcademia`) REFERENCES `academias` (`idAcademia`) ON DELETE CASCADE,
  ADD CONSTRAINT `modalidades_academia_ibfk_2` FOREIGN KEY (`idModalidade`) REFERENCES `modalidades` (`idModalidade`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `modalidades_aluno`
--
ALTER TABLE `modalidades_aluno`
  ADD CONSTRAINT `modalidades_aluno_ibfk_1` FOREIGN KEY (`idAluno`) REFERENCES `alunos` (`idAluno`) ON DELETE CASCADE,
  ADD CONSTRAINT `modalidades_aluno_ibfk_2` FOREIGN KEY (`idModalidade`) REFERENCES `modalidades` (`idModalidade`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `modalidades_personal`
--
ALTER TABLE `modalidades_personal`
  ADD CONSTRAINT `modalidades_personal_ibfk_1` FOREIGN KEY (`idPersonal`) REFERENCES `personal` (`idPersonal`) ON DELETE CASCADE,
  ADD CONSTRAINT `modalidades_personal_ibfk_2` FOREIGN KEY (`idModalidade`) REFERENCES `modalidades` (`idModalidade`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `pagamentos`
--
ALTER TABLE `pagamentos`
  ADD CONSTRAINT `FK_Pagamento_Plano` FOREIGN KEY (`idPlano`) REFERENCES `planos` (`idPlano`);

--
-- Limitadores para a tabela `personal`
--
ALTER TABLE `personal`
  ADD CONSTRAINT `FK_Personal_Academia` FOREIGN KEY (`idAcademia`) REFERENCES `academias` (`idAcademia`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_Personal_Plano` FOREIGN KEY (`idPlano`) REFERENCES `planos` (`idPlano`);

--
-- Limitadores para a tabela `progresso`
--
ALTER TABLE `progresso`
  ADD CONSTRAINT `FK_Progresso_Aluno` FOREIGN KEY (`idAluno`) REFERENCES `alunos` (`idAluno`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `refeicoes_tipos`
--
ALTER TABLE `refeicoes_tipos`
  ADD CONSTRAINT `FK_Refeicoes_Aluno` FOREIGN KEY (`idAluno`) REFERENCES `alunos` (`idAluno`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `solicitacoes_academia`
--
ALTER TABLE `solicitacoes_academia`
  ADD CONSTRAINT `fk_solicitacao_academia` FOREIGN KEY (`idAcademia`) REFERENCES `academias` (`idAcademia`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `treinos`
--
ALTER TABLE `treinos`
  ADD CONSTRAINT `FK_Treino_UltimaSessao` FOREIGN KEY (`ultima_sessao_id`) REFERENCES `treino_sessao` (`idSessao`),
  ADD CONSTRAINT `FK_Treinos_Aluno` FOREIGN KEY (`idAluno`) REFERENCES `alunos` (`idAluno`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_Treinos_Personal` FOREIGN KEY (`idPersonal`) REFERENCES `personal` (`idPersonal`) ON DELETE CASCADE,
  ADD CONSTRAINT `treinos_ibfk_1` FOREIGN KEY (`ultima_sessao_id`) REFERENCES `treino_sessao` (`idSessao`);

--
-- Limitadores para a tabela `treino_exercicio`
--
ALTER TABLE `treino_exercicio`
  ADD CONSTRAINT `FK_TreinoExercicio_ExercAdaptado` FOREIGN KEY (`idExercAdaptado`) REFERENCES `exercadaptados` (`idExercAdaptado`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_TreinoExercicio_Exercicio` FOREIGN KEY (`idExercicio`) REFERENCES `exercicios` (`idExercicio`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_TreinoExercicio_Treino` FOREIGN KEY (`idTreino`) REFERENCES `treinos` (`idTreino`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `treino_sessao`
--
ALTER TABLE `treino_sessao`
  ADD CONSTRAINT `treino_sessao_ibfk_1` FOREIGN KEY (`idTreino`) REFERENCES `treinos` (`idTreino`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `usuarios_academia`
--
ALTER TABLE `usuarios_academia`
  ADD CONSTRAINT `fk_vinculo_academia` FOREIGN KEY (`idAcademia`) REFERENCES `academias` (`idAcademia`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `videos`
--
ALTER TABLE `videos`
  ADD CONSTRAINT `FK_Videos_ExercAdaptado` FOREIGN KEY (`idExercAdaptado`) REFERENCES `exercadaptados` (`idExercAdaptado`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_Videos_Exercicio` FOREIGN KEY (`idExercicio`) REFERENCES `exercicios` (`idExercicio`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
