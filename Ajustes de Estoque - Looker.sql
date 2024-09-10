SELECT
  CASE 
    WHEN SUBSTR(est.prctr, 5, 2) = 'AC' THEN 'Acre'
    WHEN SUBSTR(est.prctr, 5, 2) = 'AL' THEN 'Alagoas'
    WHEN SUBSTR(est.prctr, 5, 2) = 'AP' THEN 'Amapá'
    WHEN SUBSTR(est.prctr, 5, 2) = 'AM' THEN 'Amazonas'
    WHEN SUBSTR(est.prctr, 5, 2) = 'BA' THEN 'Bahia'
    WHEN SUBSTR(est.prctr, 5, 2) = 'CE' THEN 'Ceará'
    WHEN SUBSTR(est.prctr, 5, 2) = 'DF' THEN 'Brasília'
    WHEN SUBSTR(est.prctr, 5, 2) = 'ES' THEN 'Espírito Santo'
    WHEN SUBSTR(est.prctr, 5, 2) = 'GO' THEN 'Goiás'
    WHEN SUBSTR(est.prctr, 5, 2) = 'MA' THEN 'Maranhão'
    WHEN SUBSTR(est.prctr, 5, 2) = 'MT' THEN 'Mato Grosso'
    WHEN SUBSTR(est.prctr, 5, 2) = 'MS' THEN 'Mato Grosso do Sul'
    WHEN SUBSTR(est.prctr, 5, 2) = 'MG' THEN 'Minas Gerais'
    WHEN SUBSTR(est.prctr, 5, 2) = 'PA' THEN 'Pará'
    WHEN SUBSTR(est.prctr, 5, 2) = 'PB' THEN 'Paraíba'
    WHEN SUBSTR(est.prctr, 5, 2) = 'PR' THEN 'Paraná'
    WHEN SUBSTR(est.prctr, 5, 2) = 'PE' THEN 'Pernambuco'
    WHEN SUBSTR(est.prctr, 5, 2) = 'PI' THEN 'Piauí'
    WHEN SUBSTR(est.prctr, 5, 2) = 'RJ' THEN 'Rio de Janeiro'
    WHEN SUBSTR(est.prctr, 5, 2) = 'RN' THEN 'Rio Grande do Norte'
    WHEN SUBSTR(est.prctr, 5, 2) = 'RS' THEN 'Rio Grande do Sul'
    WHEN SUBSTR(est.prctr, 5, 2) = 'RO' THEN 'Rondônia'
    WHEN SUBSTR(est.prctr, 5, 2) = 'RR' THEN 'Roraima'
    WHEN SUBSTR(est.prctr, 5, 2) = 'SC' THEN 'Itajaí'
    WHEN SUBSTR(est.prctr, 5, 2) = 'SP' THEN 'São Paulo'
    WHEN SUBSTR(est.prctr, 5, 2) = 'SE' THEN 'Sergipe'
    WHEN SUBSTR(est.prctr, 5, 2) = 'TO' THEN 'Tocantins'
    ELSE 'Estado Desconhecido'
  END AS Estado,
	est.bukrs as Empresa, 
	est.werks as Centro,
	cen.NAME1 as Descricao_Centro,
	CASE
		WHEN est.werks IN ('2013', '2015') THEN 'Angélica Mota'
		WHEN est.werks IN ('2004', '2008', '2019', '2021', '2025', '2026', '2028', '2029', '2302', '1005', '1006', '1007', '2701', '2702', '2703', '2704', '2705', '2706', '2034', 			'2035') THEN 'Carla Brito'
		WHEN est.werks IN ('2501', '2503', '2601', '2604', '2605', '2902', '3101', '2603', '2901', '2904', '2905', '2502', '2504', '3001', '3002', '3003', '2602', '2903', '3201') THEN 'Carlos Rolim'
		WHEN est.werks IN ('2016', '2020', '2023', '2032') THEN 'Juliana Almeida'
		WHEN est.werks IN ('2012', '2014', '2105') THEN 'Cynthia Lima'
		WHEN est.werks IN ('1002', '2001', '2101', '2104') THEN 'Matriz'
		WHEN est.werks IN ('2002', '2007', '2022', '2027', '2011', '2024', '2802', '2803', '2030') THEN 'Neusa Sousa'
		WHEN est.werks IN ('2003', '2006', '2010', '2031', '2201', '2204', '2206', '2402', '1004', '2005', '2009', '2018', '2202') THEN 'Rafael Cajazeiras'
		ELSE 'Gestor Indefinido'
	END AS Gestor_Administrativo,
	est.budat_mkpf as Data,
	format_date('%m-%y', est.budat_mkpf) as Mes_Ano,
	est.lgort as Deposito,
	est.mblnr as Doc_Material,
	CASE
		WHEN est.shkzg = 'S' THEN 'Entrada'
		WHEN est.shkzg = 'H' THEN 'Saída'
		ELSE 'Não Identificado'
	END AS Movimentacao,
	est.bwart as Tipo_Movimento,
	right(est.matnr, 6) as Cod_Material,
  mat.maktx as Texto_Breve_Material,
	cast(est.menge as int) as QTD,
	est.salk3 as Montante, 
	est.usnam_mkpf as Usuario
FROM 
	`production-servers-magnumtires.prdmgm_sap_cdc_processed.nsdm_v_mseg` AS est
INNER JOIN
	`production-servers-magnumtires.prdmgm_sap_cdc_processed.makt` AS mat ON
	est.mandt = mat.mandt and
	right(est.matnr, 6) = right(mat.matnr, 6)
INNER JOIN	
	`production-servers-magnumtires.prdmgm_sap_cdc_processed.t001w` AS CEN ON
	est.werks = cen.werks
WHERE
	est.bwart between '701' and '718'

     