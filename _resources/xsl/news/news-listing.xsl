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
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ou="http://omniupdate.com/XSL/Variables" xmlns:fn="http://omniupdate.com/XSL/Functions" xmlns:ouc="http://omniupdate.com/XSL/Variables" exclude-result-prefixes="ou xsl xs fn ouc">
	<xsl:import href="../_shared/common.xsl"/>	
	<xsl:import href="../navigation/leftcolumn.xsl"/>

	<xsl:template name="page-content">
		<main id="content">
			<div class="container-fluid">
				<div class="container">
					<div class="row">
						<xsl:variable name="feed" select="if (ou:pcfparam('rss-feed') != '') then ou:pcfparam('rss-feed') else $ou:feed"/>
						<xsl:variable name="limit" select="if (ou:pcfparam('rss-limit') != '') then ou:pcfparam('rss-limit') else 5" />
						<xsl:variable name="pagination" select="if (ou:pcfparam('rss-pagination') != '') then ou:pcfparam('rss-pagination') else 'false'" />
						
						<xsl:if test="ou:pcfparam('layout') = 'two-column'">
							<xsl:call-template name="left-column"/>
						</xsl:if>
						<div id="main-column" class="{if (ou:pcfparam('layout') = 'two-column') then 'col-md-8' else 'col-md-12'} col-md-12">

							<xsl:choose>
								<xsl:when test="$ou:action = 'pub'">
									<xsl:processing-instruction name="php">
									$feed = "<xsl:value-of select="$feed"/>";
									$num_items = "<xsl:value-of select="$limit" />";
									$pagination = "<xsl:value-of select="$pagination"/>";
									include($_SERVER['DOCUMENT_ROOT'] . "/_resources/php/news.php"); 
									?</xsl:processing-instruction>
								</xsl:when>
								<xsl:otherwise>
									<p>News items will be displayed on publish.</p>
									<p><strong>Feed </strong><xsl:value-of select="concat($domain, $feed)" /></p>
									<p><strong>Limit </strong><xsl:value-of select="$limit" /></p>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:try>
								<xsl:copy-of select="ouc:div[@label='autopublish']"/>
								<xsl:catch></xsl:catch>
							</xsl:try>
						</div>
					</div>
				</div>
			</div>
		</main>
	</xsl:template>
	
</xsl:stylesheet>
