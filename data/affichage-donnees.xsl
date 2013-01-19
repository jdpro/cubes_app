<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:belin="http://www.belin_editions.com/ses/cubes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<xsl:output method="html" encoding="UTF-8" indent="yes" />
	<xsl:template match="/">
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
				<title>Décomposition de l'agrégat</title>
			</head>
			<body>
			<h3>Décomposition de l'agrégat</h3>
				<xsl:apply-templates />
			</body>
		</html>

	</xsl:template>
	<xsl:template match="belin:agregat|belin:composante">
		<ul><li><dl>
			<dt>[<xsl:value-of select="@article" />] <strong><xsl:value-of select="@libelle" /></strong> 
			</dt><dd><xsl:value-of select="@definition" /></dd>
			
		</dl>
		<xsl:apply-templates /></li></ul>
	</xsl:template>



</xsl:stylesheet>