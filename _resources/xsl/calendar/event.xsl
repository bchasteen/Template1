<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE stylesheet[
<!ENTITY nbsp   "&#160;">
]>
<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:ou="http://omniupdate.com/XSL/Variables" 
	xmlns:fn="http://omniupdate.com/XSL/Functions"
	xmlns:functx="http://www.functx.com" 
	xmlns:media="http://search.yahoo.com/mrss/"
	xmlns:ouc="http://omniupdate.com/XSL/Variables" 
	exclude-result-prefixes="ou xsl xs fn ouc functx media">
	
	<xsl:import href="../_shared/common.xsl"/>
	<xsl:import href="../navigation/leftcolumn.xsl"/>
	
	<xsl:template name="page-content">
		<main id="content">
			<div class="container-fluid">
				<div class="container">
					<div class="row">
						<xsl:if test="ou:pcfparam('layout') = 'two-column'"><xsl:call-template name="left-column"/></xsl:if>
						<div id="main-column" class="{if (ou:pcfparam('layout') = 'two-column') then 'col-md-8' else 'col-md-12'} col-md-12">
							<xsl:if test="ou:pcfparam('breadcrumb') != ''"><h1><xsl:value-of select="ou:pcfparam('breadcrumb')"/></h1></xsl:if>
							<xsl:if test="ou:pcfparam('start-date') != ''">
								<span class="meta-date sep">
									<a href="?page=1&amp;pubDate={ou:pcfparam('start-date')}" rel="bookmark">
										<time class="entry-date published updated" datetime="{ou:pcfparam('start-date')}">
											<xsl:try>
												<xsl:value-of select="ou:displayLongDate(ou:pcfparam('start-date'))" />

												<xsl:catch><xsl:value-of select="ou:displayLongDate(ou:pcfparam('start-date'))"/></xsl:catch>
											</xsl:try>
										</time>
									</a>
								</span>
							</xsl:if>
							<xsl:apply-templates select="ouc:div[@label='maincontent']" />
						</div>
					</div>
				</div>
			</div>
		</main>
	</xsl:template>
</xsl:stylesheet>
