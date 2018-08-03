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
	exclude-result-prefixes="ou xsl xs fn ouc functx">
	
	<xsl:import href="../_shared/common.xsl"/>
	
	<xsl:template name="left-column">
		<xsl:param name="cols" select="4"/> <!-- Default column width -->

		<xsl:variable name="section-nav" select="if($dirname = '/') then $dirname else concat('/', ou:sequence($dirname, '/')[1], '/')"/>

		<div id="left-column" class="col-md-{$cols} col-sm-{$cols} col-xs-12">
			<xsl:choose>
				<xsl:when test="doc-available(concat($ou:root, $ou:site, $section-nav, '_nav.pcf'))">
					<xsl:try>
						<xsl:choose>
							<xsl:when test="$ou:action != 'pub'">
								<p class="bg-info" style="padding:10px">
									<span class="glyphicon glyphicon-list-alt" style="font-size:20px;" aria-hidden="true"></span>
									<xsl:text> Local menu _nav.pcf will display upon publish.</xsl:text></p>
							</xsl:when>
							<xsl:otherwise>
								<xsl:processing-instruction name="php"> include($_SERVER['DOCUMENT_ROOT'] . "<xsl:value-of select="$section-nav"/>/_nav.html"); ?</xsl:processing-instruction>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:catch><p class="bg-warning">No local _nav file found.</p></xsl:catch>
					</xsl:try>
				</xsl:when>
				<xsl:otherwise>
					<nav aria-label="Side Navigation">
						<ul class="parent list-unstyled menu">
							<xsl:try>
								<xsl:comment> ouc:div label="navigation" group="Administrators" button-text="Navigation" path="<xsl:value-of select="$dirname"/>_nav.inc" </xsl:comment>
								
								<xsl:copy-of select="ou:includeFile(concat($dirname, '_nav.inc'))"/>
								<xsl:comment> /ouc:div </xsl:comment>
								<xsl:catch></xsl:catch>
							</xsl:try>
						</ul>
					</nav>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:try>
				<xsl:copy-of select="ouc:div[@label='autopublish']"/>
				<xsl:catch></xsl:catch>
			</xsl:try>
			<xsl:try>
				<xsl:apply-templates select="ouc:div[@label='leftcolumn']"/>
				<xsl:catch></xsl:catch>
			</xsl:try>
		</div>
	</xsl:template>
</xsl:stylesheet>