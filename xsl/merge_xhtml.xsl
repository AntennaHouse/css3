<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" encoding="UTF-8"
		indent="yes"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
		doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>

	<xsl:template match="/html">
		<html>
			<head>
				<xsl:copy-of select="head/*"/>
				<link rel="stylesheet" type="text/css" href="commonltr.css"/>
			</head>
			<body>
				<div class="toc">
					<xsl:apply-templates select="body/*" mode="toc"/>
				</div>
				<xsl:apply-templates select="body/*"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="a[@href][not(@href='')]">
		<p class="topic">
			<a>
				<xsl:attribute name="name" select="lower-case(replace(@href,'.*/(.*).html','$1'))"/>
				<xsl:attribute name="id" select="lower-case(replace(@href,'.*/(.*).html','$1'))"/>
			</a>
			<xsl:apply-templates select="document(@href, /html)/html/body/*" mode="content"/>
		</p>
	</xsl:template>

	<xsl:template match="ul">
		<div>
			<xsl:attribute name="class">
				<xsl:text>depth</xsl:text>
				<xsl:value-of select="count(ancestor-or-self::*[ul])"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="a[@href][not(@href='')]" mode="content">
		<xsl:copy>
			<xsl:attribute name="href">
				<xsl:text>#</xsl:text>
				<xsl:value-of select="lower-case(replace(@href,'.*/(.*).html','$1'))"/>
			</xsl:attribute>
			<xsl:copy-of select="@*[not(name()='href')]"/>
			<xsl:apply-templates mode="content"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="img" mode="content">
		<xsl:copy>
			<xsl:attribute name="src" select="replace(@src,'[.]{2}/','')"/>
			<xsl:copy-of select="@*[not(name()='src')]"/>
			<xsl:apply-templates mode="content"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="node()" mode="content">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="content"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="a[@href][not(@href='')]" mode="toc">
		<xsl:copy>
			<xsl:attribute name="href">
				<xsl:text>#</xsl:text>
				<xsl:value-of select="lower-case(replace(@href,'.*/(.*).html','$1'))"/>
			</xsl:attribute>
			<xsl:copy-of select="@*[not(name()='href')]"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="node()" mode="toc">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="toc"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
