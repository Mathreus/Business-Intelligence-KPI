SELECT DISTINCT
  CASE
    WHEN cli.regio = 'AC' THEN 'Acre'
    WHEN cli.regio = 'AP' THEN 'Amapá'
    WHEN cli.regio = 'AM' THEN 'Amazonas'
    WHEN cli.regio = 'PA' THEN 'Pará'
    WHEN cli.regio = 'RO' THEN 'Rondônia'
    WHEN cli.regio = 'RR' THEN 'Roraima'
    WHEN cli.regio = 'TO' THEN 'Tocantins'
    WHEN cli.regio = 'AL' THEN 'Alagoas'
    WHEN cli.regio = 'BA' THEN 'Bahia'
    WHEN cli.regio = 'CE' THEN 'Ceará'
    WHEN cli.regio = 'MA' THEN 'Maranhão'
    WHEN cli.regio = 'PB' THEN 'Paraíba'
    WHEN cli.regio = 'PE' THEN 'Pernambuco'
    WHEN cli.regio = 'PI' THEN 'Piauí'
    WHEN cli.regio = 'RN' THEN 'Rio Grande do Norte'
    WHEN cli.regio = 'SE' THEN 'Sergipe'
    WHEN cli.regio = 'DF' THEN 'Brasília'
    WHEN cli.regio = 'GO' THEN 'Goiás'
    WHEN cli.regio = 'MT' THEN 'Mato Grosso'
    WHEN cli.regio = 'MS' THEN 'Mato Grosso do Sul'
    WHEN cli.regio = 'ES' THEN 'Espírito Santo'
    WHEN cli.regio = 'MG' THEN 'Minas Gerais'
    WHEN cli.regio = 'RJ' THEN 'Rio de Janeiro'
    WHEN cli.regio = 'SP' THEN 'São Paulo'
    WHEN cli.regio = 'PR' THEN 'Paraná'
    WHEN cli.regio = 'RS' THEN 'Rio Grande do Sul'
    WHEN cli.regio = 'SC' THEN 'Itajaí'
    ELSE 'N/D'
  END Estado,
  FIN.BUKRS AS Empresa,
  FIN.BUDAT AS DataLcto,
  FORMAT_DATE('%m-%y', FIN.BUDAT) as Mes_Ano,
  FIN.ZBD1T AS DiasVencer, 
  FIN.BUDAT + CAST(FIN.ZBD1T AS INT64) AS DataVencimento,
  DATE_ADD(FIN.BUDAT, INTERVAL (CAST(FIN.ZBD1T AS INT64) + 30) DAY) AS Data_Inadimplencia,
  DATE_DIFF(CURRENT_DATE(), FIN.BUDAT + CAST(FIN.ZBD1T AS INT64), DAY) AS Diferenca_Dias, 
  FIN.MADAT AS Data_Ultima_Cobranca,
  FIN.AUGDT AS DataCompensacao,
  CASE
    WHEN DATE_DIFF(CURRENT_DATE(), FIN.BUDAT + CAST(FIN.ZBD1T AS INT64), DAY) <= 30 THEN '1 a 30' 
    WHEN DATE_DIFF(CURRENT_DATE(), FIN.BUDAT + CAST(FIN.ZBD1T AS INT64), DAY) <= 60 THEN '31 a 60'
    WHEN DATE_DIFF(CURRENT_DATE(), FIN.BUDAT + CAST(FIN.ZBD1T AS INT64), DAY) <= 90 THEN '61 a 90'
    WHEN DATE_DIFF(CURRENT_DATE(), FIN.BUDAT + CAST(FIN.ZBD1T AS INT64), DAY) <= 120 THEN '91 a 120'
    WHEN DATE_DIFF(CURRENT_DATE(), FIN.BUDAT + CAST(FIN.ZBD1T AS INT64), DAY) <= 150 THEN '121 a 150'
    WHEN DATE_DIFF(CURRENT_DATE(), FIN.BUDAT + CAST(FIN.ZBD1T AS INT64), DAY) <= 180 THEN '151 a 180'
    WHEN DATE_DIFF(CURRENT_DATE(), FIN.BUDAT + CAST(FIN.ZBD1T AS INT64), DAY) <= 360 THEN '180 a 360'
    WHEN DATE_DIFF(CURRENT_DATE(), FIN.BUDAT + CAST(FIN.ZBD1T AS INT64), DAY) <= 720 THEN '360 a 720 (1-2 anos)'
    WHEN DATE_DIFF(CURRENT_DATE(), FIN.BUDAT + CAST(FIN.ZBD1T AS INT64), DAY) <= 1080 THEN '720 a 1080 (2-3 anos)'
    WHEN DATE_DIFF(CURRENT_DATE(), FIN.BUDAT + CAST(FIN.ZBD1T AS INT64), DAY) <= 1440 THEN '1080 a 1440 (3-4 anos)'
    WHEN DATE_DIFF(CURRENT_DATE(), FIN.BUDAT + CAST(FIN.ZBD1T AS INT64), DAY) <= 2160 THEN '1440 a 2160 (4-5 anos)'
    WHEN DATE_DIFF(CURRENT_DATE(), FIN.BUDAT + CAST(FIN.ZBD1T AS INT64), DAY) <= 2520 THEN '2160 a 2520 (5-6 anos)'
    WHEN DATE_DIFF(CURRENT_DATE(), FIN.BUDAT + CAST(FIN.ZBD1T AS INT64), DAY) <= 2880 THEN '2520 a 2880 (6-7 anos)'
    ELSE '2880 acima (7 anos acima)'
  END AS  AgingList, 
  FIN.KUNNR AS ID_Externo,
  CLI.NAME1 AS Cliente,
  CASE
    WHEN CLI.KATR6 = '01' THEN 'Consumo'
    WHEN CLI.KATR6 = '02' THEN 'Revenda'
    ELSE 'Identificar'
  END SetorAtividade,
  CASE
    WHEN FIN.SHKZG = 'S' THEN 'Débito'
    ELSE 'Crédito'
  END Deb_Cred,
  CASE
    WHEN FIN.BLART = 'RV' THEN 'Fatura'
    WHEN FIN.BLART = 'DX' THEN 'Acordo'
    WHEN FIN.BLART = 'C2' THEN 'Carga'
    WHEN FIN.BLART = 'SA' THEN 'Razão'
    WHEN FIN.BLART = 'DB' THEN 'Renegociação'
	ELSE 'Não identificado'
  END Lancamento,
  CASE
    WHEN FIN.ZLSCH = 'E' THEN 'Boleto'
    WHEN FIN.ZLSCH = 'I' THEN 'Carteira'
    WHEN FIN.ZLSCH = 'H' THEN 'Cobrança'
    WHEN FIN.ZLSCH = 'K' THEN 'PIX'
    ELSE 'Não Identificado'
  END FormaPGTO,  
  FIN.ZTERM AS CondPGTO, 
  FIN.UMSKZ AS CodigoRazao,
  FIN.BUZEI AS Parcela,
  FIN.DMBTR AS Montante,
  VEND.CNAME AS Vendedor
FROM
  `production-servers-magnumtires.prdmgm_sap_cdc_processed.bsid` AS FIN 
INNER JOIN
  `production-servers-magnumtires.prdmgm_sap_cdc_processed.kna1` AS CLI ON
  FIN.KUNNR = CLI.KUNNR
INNER JOIN
  `Portal_do_Vendedor.Clientes_x_Vendedores` AS VEND ON
  CLI.KUNNR = VEND.kunnr AND
  CLI.NAME1 = VEND.name1
WHERE
  (LEFT(FIN.KUNNR, 6) <> '000000' OR RIGHT(FIN.KUNNR, 4) = '7001' OR RIGHT(FIN.KUNNR, 4) = '8001')
  AND FIN.KUNNR NOT IN ('1000017583', '1000016271', '1000020903', '5200000003', '5200000004')
  AND FIN.SHKZG = 'S'
  AND FIN.BLART IN ('C2', 'DX', 'RV', ' SA', 'DR', 'DB')
  AND FIN.BLART <> 'ZP'
  AND FIN.AUGDT IS NULL
  AND FIN.KUNNR > '1000000000'
  AND FIN.ZLSCH NOT IN ('J', 'W', 'V')
  AND CLI.NAME1 NOT LIKE '%Cliente%' 
  AND CLI.NAME1 NOT LIKE '%CLIENTE%'
  AND DATE_DIFF(CURRENT_DATE(), DATE_ADD(DATE(FIN.BUDAT), INTERVAL CAST(FIN.ZBD1T AS INT64) DAY), DAY) > 30