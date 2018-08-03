<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE stylesheet>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ou="http://omniupdate.com/XSL/Variables" xmlns:fn="http://omniupdate.com/XSL/Functions" xmlns:ouc="http://omniupdate.com/XSL/Variables" exclude-result-prefixes="ou xsl xs fn ouc">
	<xsl:import href="_shared/common.xsl"/>	
	<xsl:template name="breadcrumb-nav"/>
	
	<xsl:template name="page-content">
		<main id="content">
			<div class="container-fluid">
				<div class="container">
					<div class="row">
						<div id="main-column" class="col-md-12">
							<h1><xsl:value-of select="ou:pcfparam('breadcrumb')"/></h1>
							<xsl:apply-templates select="ouc:div[@label='maincontent']" />
						</div>
					</div>
				</div>
			</div>
		</main>
	</xsl:template>
</xsl:stylesheet>
