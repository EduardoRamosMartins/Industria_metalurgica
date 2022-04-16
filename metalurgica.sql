-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 16-Abr-2022 às 22:31
-- Versão do servidor: 10.4.22-MariaDB
-- versão do PHP: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `metalurgica`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `pr_entrada_estoque` (IN `cod_id_item` INT, IN `Qtd` INT)  BEGIN
    	UPDATE estoque_ferramentas
        set Estoque = Estoque + Qtd
        where id_item = cod_id_item;
    end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pr_saida_estoque` (IN `cod_id_item` INT, IN `Qtd` INT)  BEGIN
    	UPDATE estoque_ferramentas
        set Estoque = Estoque - Qtd
        where Id_item = cod_id_item;
    end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `assiduidade_funcionarios`
--

CREATE TABLE `assiduidade_funcionarios` (
  `cod` int(11) NOT NULL,
  `id_funcionario` int(11) NOT NULL,
  `faltas` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `assiduidade_funcionarios`
--

INSERT INTO `assiduidade_funcionarios` (`cod`, `id_funcionario`, `faltas`) VALUES
(1, 1, 0),
(2, 2, 0),
(3, 3, 0),
(4, 4, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `dds_ferramentas`
--

CREATE TABLE `dds_ferramentas` (
  `cod` int(11) NOT NULL,
  `descricao` varchar(255) NOT NULL,
  `fornecedor` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `dds_ferramentas`
--

INSERT INTO `dds_ferramentas` (`cod`, `descricao`, `fornecedor`) VALUES
(1, 'Fresa 10mm', 'GandonTools'),
(2, 'Fresa 14mm', 'GandonTools'),
(3, 'Broca MD 9mm', 'GandonTools'),
(4, 'Broca HSS 3mm', 'GandonTools');

-- --------------------------------------------------------

--
-- Estrutura da tabela `dds_funcionarios`
--

CREATE TABLE `dds_funcionarios` (
  `cod` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `dt_entrada` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `dds_funcionarios`
--

INSERT INTO `dds_funcionarios` (`cod`, `nome`, `dt_entrada`) VALUES
(1, 'Jeferson', '2022-04-15'),
(2, 'Calebe', '2022-04-15'),
(3, 'João', '2022-04-15'),
(4, 'Michel', '2022-04-15');

-- --------------------------------------------------------

--
-- Estrutura da tabela `dds_pecas`
--

CREATE TABLE `dds_pecas` (
  `cod` int(11) NOT NULL,
  `descricao` varchar(255) NOT NULL,
  `cliente` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `dds_pecas`
--

INSERT INTO `dds_pecas` (`cod`, `descricao`, `cliente`) VALUES
(1, 'KK16383', 'Cercena'),
(2, 'Garfo 4151', 'Farina'),
(3, 'Receptáculo', 'CBC'),
(4, 'Ferrolho', 'CBC');

-- --------------------------------------------------------

--
-- Estrutura da tabela `dds_prod_diaria`
--

CREATE TABLE `dds_prod_diaria` (
  `cod` int(11) NOT NULL,
  `id_peca` int(11) NOT NULL,
  `dt_prod` date NOT NULL,
  `maquina` int(3) NOT NULL,
  `qtd_pcs` int(5) DEFAULT NULL,
  `id_funcionario` int(11) NOT NULL,
  `funcionario_falta` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Acionadores `dds_prod_diaria`
--
DELIMITER $$
CREATE TRIGGER `trg_faltas_funcionarios` AFTER INSERT ON `dds_prod_diaria` FOR EACH ROW BEGIN
    	UPDATE assiduidade_funcionarios
        SET faltas = faltas + new.funcionario_falta
        WHERE id_funcionario = new.id_funcionario;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `estoque_ferramentas`
--

CREATE TABLE `estoque_ferramentas` (
  `cod` int(11) NOT NULL,
  `id_item` int(3) NOT NULL,
  `estoque` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `estoque_ferramentas`
--

INSERT INTO `estoque_ferramentas` (`cod`, `id_item`, `estoque`) VALUES
(1, 1, 0),
(2, 2, 0),
(3, 3, 0),
(4, 4, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `ferramentaria`
--

CREATE TABLE `ferramentaria` (
  `cod` int(3) NOT NULL,
  `id_item` int(3) NOT NULL,
  `qtd_comprada` int(4) NOT NULL,
  `custo_un` decimal(10,2) DEFAULT NULL,
  `dt_compra` date NOT NULL,
  `custo_tot_compra` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `ferramentaria`
--

INSERT INTO `ferramentaria` (`cod`, `id_item`, `qtd_comprada`, `custo_un`, `dt_compra`, `custo_tot_compra`) VALUES
(1, 1, 10, '250.00', '2022-04-16', '2500.00'),
(2, 2, 10, '300.00', '2022-04-16', '3000.00'),
(3, 3, 10, '40.00', '2022-04-16', '400.00'),
(4, 4, 10, '10.00', '2022-04-16', '100.00');

--
-- Acionadores `ferramentaria`
--
DELIMITER $$
CREATE TRIGGER `trg_tot_custo` BEFORE INSERT ON `ferramentaria` FOR EACH ROW BEGIN
        	set new.custo_tot_compra = (new.custo_un * new.qtd_comprada);
        END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `sq_qualidade`
--

CREATE TABLE `sq_qualidade` (
  `cod` int(11) NOT NULL,
  `id_peca` int(11) NOT NULL,
  `dt_qualidade` date NOT NULL,
  `pcs_aprovadas` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `assiduidade_funcionarios`
--
ALTER TABLE `assiduidade_funcionarios`
  ADD PRIMARY KEY (`cod`),
  ADD KEY `fk_id_funcionario_dds_funcionarios` (`id_funcionario`);

--
-- Índices para tabela `dds_ferramentas`
--
ALTER TABLE `dds_ferramentas`
  ADD PRIMARY KEY (`cod`);

--
-- Índices para tabela `dds_funcionarios`
--
ALTER TABLE `dds_funcionarios`
  ADD PRIMARY KEY (`cod`);

--
-- Índices para tabela `dds_pecas`
--
ALTER TABLE `dds_pecas`
  ADD PRIMARY KEY (`cod`);

--
-- Índices para tabela `dds_prod_diaria`
--
ALTER TABLE `dds_prod_diaria`
  ADD PRIMARY KEY (`cod`),
  ADD KEY `fk_id_peca_dds_peca` (`id_peca`),
  ADD KEY `fk_id_funcionarios_dds_funcionarios` (`id_funcionario`);

--
-- Índices para tabela `estoque_ferramentas`
--
ALTER TABLE `estoque_ferramentas`
  ADD PRIMARY KEY (`cod`),
  ADD KEY `fk_id_item_dds_ferramentas2` (`id_item`);

--
-- Índices para tabela `ferramentaria`
--
ALTER TABLE `ferramentaria`
  ADD PRIMARY KEY (`cod`),
  ADD KEY `fk_id_item_dds_ferramentas` (`id_item`);

--
-- Índices para tabela `sq_qualidade`
--
ALTER TABLE `sq_qualidade`
  ADD PRIMARY KEY (`cod`),
  ADD KEY `id_peca_dds_pecas` (`id_peca`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `assiduidade_funcionarios`
--
ALTER TABLE `assiduidade_funcionarios`
  MODIFY `cod` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `dds_ferramentas`
--
ALTER TABLE `dds_ferramentas`
  MODIFY `cod` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `dds_funcionarios`
--
ALTER TABLE `dds_funcionarios`
  MODIFY `cod` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `dds_pecas`
--
ALTER TABLE `dds_pecas`
  MODIFY `cod` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `dds_prod_diaria`
--
ALTER TABLE `dds_prod_diaria`
  MODIFY `cod` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `estoque_ferramentas`
--
ALTER TABLE `estoque_ferramentas`
  MODIFY `cod` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `ferramentaria`
--
ALTER TABLE `ferramentaria`
  MODIFY `cod` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `sq_qualidade`
--
ALTER TABLE `sq_qualidade`
  MODIFY `cod` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `assiduidade_funcionarios`
--
ALTER TABLE `assiduidade_funcionarios`
  ADD CONSTRAINT `fk_id_funcionario_dds_funcionarios` FOREIGN KEY (`id_funcionario`) REFERENCES `dds_funcionarios` (`cod`);

--
-- Limitadores para a tabela `dds_prod_diaria`
--
ALTER TABLE `dds_prod_diaria`
  ADD CONSTRAINT `fk_id_funcionarios_dds_funcionarios` FOREIGN KEY (`id_funcionario`) REFERENCES `dds_funcionarios` (`cod`),
  ADD CONSTRAINT `fk_id_peca_dds_peca` FOREIGN KEY (`id_peca`) REFERENCES `dds_pecas` (`cod`);

--
-- Limitadores para a tabela `estoque_ferramentas`
--
ALTER TABLE `estoque_ferramentas`
  ADD CONSTRAINT `fk_id_item_dds_ferramentas2` FOREIGN KEY (`id_item`) REFERENCES `dds_ferramentas` (`cod`);

--
-- Limitadores para a tabela `ferramentaria`
--
ALTER TABLE `ferramentaria`
  ADD CONSTRAINT `fk_id_item_dds_ferramentas` FOREIGN KEY (`id_item`) REFERENCES `dds_ferramentas` (`cod`);

--
-- Limitadores para a tabela `sq_qualidade`
--
ALTER TABLE `sq_qualidade`
  ADD CONSTRAINT `id_peca_dds_pecas` FOREIGN KEY (`id_peca`) REFERENCES `dds_pecas` (`cod`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
