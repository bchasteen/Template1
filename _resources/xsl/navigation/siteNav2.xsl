<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE stylesheet[
<!ENTITY nbsp   "&#160;">
<!ENTITY lsaquo "&#8249;">
<!ENTITY rsaquo "&#8250;">
<!ENTITY laquo  "&#171;">
<!ENTITY raquo  "&#187;">
<!ENTITY copy   "&#169;">
<!ENTITY rarr   "&#8594;">
]>
<!-- 
Implementations Skeletor v3 - 5/10/2014

HOME PAGE 
A complex page type.

Contributors: Your Name Here
Last Updated: Enter Date Here
-->
<xsl:stylesheet 
	version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:ou="http://omniupdate.com/XSL/Variables" 
	xmlns:fn="http://omniupdate.com/XSL/Functions" 
	xmlns:functx="http://www.functx.com" 
	xmlns:ouc="http://omniupdate.com/XSL/Variables" 
	exclude-result-prefixes="ou xsl xs fn ouc">
	
	<xsl:import href="../_shared/common.xsl"/>
	<xsl:import href="nav2.xsl"/>
	
	<!-- Default: for HTML5 use below output declaration -->
	<xsl:output method="html" version="5.0" indent="yes" encoding="UTF-8" include-content-type="no"/>
	<xsl:strip-space elements="*"/>
	<xsl:template name="page-content"/>
	<xsl:template match="/document">
		<nav>
			<ul class="parent list-unstyled menu">				
				<xsl:call-template name="siteNav2">
					<xsl:with-param name="rootRel" select="''"/>
				</xsl:call-template>
			</ul>

			<xsl:copy-of select="ouc:div[@label='maincontent']"/>
		</nav>
	</xsl:template>	
	
</xsl:stylesheet>
