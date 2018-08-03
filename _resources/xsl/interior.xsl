<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE stylesheet[
<!ENTITY nbsp   "&#160;">
]>
<!-- 
Implementations Skeletor v3 - 5/10/2014

HOME PAGE 
A complex page type.

Contributors: Your Name Here
Last Updated: Enter Date Here
-->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ou="http://omniupdate.com/XSL/Variables" xmlns:fn="http://omniupdate.com/XSL/Functions" xmlns:functx="http://www.functx.com" xmlns:ouc="http://omniupdate.com/XSL/Variables" exclude-result-prefixes="ou xsl xs fn ouc">
	<xsl:import href="_shared/common.xsl"/>	
	<xsl:import href="navigation/leftcolumn.xsl"/>
	
	<xsl:template name="page-content">
		<main id="content">
			<div class="container-fluid">
				<div class="container">
					<div class="row">
						<xsl:if test="ou:pcfparam('layout') = 'two-column'"><xsl:call-template name="left-column"/></xsl:if>
						<div id="main-column" class="{if (ou:pcfparam('layout') = 'two-column') then 'col-md-8' else 'col-md-12'} col-md-12">
							<xsl:if test="ou:pcfparam('breadcrumb') != ''">
								<h1><xsl:value-of select="ou:pcfparam('breadcrumb')"/></h1>
							</xsl:if>
							<xsl:apply-templates select="ouc:div[@label='maincontent']" />
						</div>
					</div>
				</div>
			</div>
		</main>
	</xsl:template>
</xsl:stylesheet>
