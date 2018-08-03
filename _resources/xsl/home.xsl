<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE stylesheet>
<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:ou="http://omniupdate.com/XSL/Variables" 
	xmlns:fn="http://omniupdate.com/XSL/Functions" 
	xmlns:ouc="http://omniupdate.com/XSL/Variables" 
	exclude-result-prefixes="ou xsl xs fn ouc">
	
	<xsl:import href="_shared/common.xsl"/>
	<xsl:template name="breadcrumb-nav"/>
	
	<xsl:template name="page-content">
		<main id="content">
			<div class="container-fluid feature">
				<div class="container">
					<div class="row">
						<div class="col-md-6 feature_blurb">
							<a href="{feature/ouc:div[@label='feature-link']}">
								<h2><xsl:value-of select="substring(feature/ouc:div[@label='feature-title'], 0, 99)"/></h2>
								<p><xsl:value-of select="substring(feature/ouc:div[@label='feature-description'], 0, 299)"/></p>
								<p>Learn more &#9656;</p>
							</a>
						</div>
						<div class="col-md-6 center-block feature_image">
							<a href="{feature/ouc:div[@label='feature-link']}">
								<img class="img-responsive" alt="{feature/ouc:div[@label='feature-image']/img/@alt}" src="{feature/ouc:div[@label='feature-image']/img/@src}" />
							</a>
						</div>
					</div>
				</div>
			</div>
			<div class="container-fluid">
				<div class="container">
					<div class="row">
						<div class="col-md-12">
							<xsl:apply-templates select="ouc:div[@label='carousel']" />
						</div>
					</div>
				</div>
			</div>
			<div class="container-fluid padd-top">
				<xsl:call-template name="home-cols"/>
			</div>
		</main>
	</xsl:template>
	
	<xsl:template name="home-cols">
		<div class="container">
			<div class="row">
				<div class="{if(ou:pcfparam('layout') = 'two-column') then 'col-md-9 left-col' else 'col-md-4 left-col'}">
					<section>
						<article>
							<xsl:apply-templates select="ouc:div[@label='maincontent']" />
						</article>
					</section>
				</div>
				<xsl:if test="ou:pcfparam('layout') = 'three-column' or ou:pcfparam('layout') = ''">
					<div class="col-md-5 middle-col">
						<section>
							<article>
								<h2 class="block-title">Events &amp; Announcements</h2>
								<xsl:apply-templates select="ouc:div[@label='middlecontent']" />
							</article>
						</section>
					</div>
				</xsl:if>
				<div class="col-md-3 right-col">
					<section>
						<article>
							<h2 class="block-title">Quicklinks</h2>
							<xsl:apply-templates select="ouc:div[@label='rightcontent']" />
						</article>
					</section>
				</div>
			</div>
		</div>		
	</xsl:template>
</xsl:stylesheet>
