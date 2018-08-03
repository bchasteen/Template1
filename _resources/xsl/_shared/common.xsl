<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE stylesheet [
<!ENTITY nbsp   "&#160;">
<!ENTITY lsaquo "&#8249;">
<!ENTITY rsaquo "&#8250;">
<!ENTITY laquo  "&#171;">
<!ENTITY raquo  "&#187;">
<!ENTITY copy   "&#169;">
<!ENTITY copy   "&#169;">
<!ENTITY rarr	"&#8594;">
]>
<!-- 
Implementations Skeletor v3 - 5/10/2014

HOME PAGE 
A complex page type.

Contributors: Your Name Here
Last Updated: Enter Date Here
-->
<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:ou="http://omniupdate.com/XSL/Variables" 
	xmlns:fn="http://omniupdate.com/XSL/Functions" 
	xmlns:ouc="http://omniupdate.com/XSL/Variables" 
	xmlns:media="http://search.yahoo.com/mrss/"
	xmlns:functx="http://www.functx.com" 
	exclude-result-prefixes="ou xsl xs fn ouc functx media">
	
	<xsl:import href="template-matches.xsl"/>
	<xsl:import href="ouvariables.xsl"/>
	<xsl:import href="functions.xsl"/>
	<xsl:import href="cas.xsl"/>
	<xsl:import href="functx-functions.xsl"/>
	<xsl:import href="custom-functions.xsl"/>
	<xsl:import href="tag-management.xsl"/>
	<xsl:import href="ougalleries.xsl"/>
	<xsl:import href="../../ldp/forms/xsl/forms.xsl"/>
	<xsl:import href="breadcrumb.xsl"/>
	<xsl:import href="../navigation/nav.xsl"/>
	<xsl:import href="../calendar/calendar.xsl"/>
	
	<!-- System Params - don't edit -->
	<xsl:param name="ou:action"/>
	<!-- Default: for HTML5 use below output declaration -->
	<xsl:output method="html" indent="yes" encoding="UTF-8" include-content-type="no"/>
	<xsl:strip-space elements="*"/>

	<xsl:template match="/document">
		<!-- CAS protected Pages.  Set by a parameter in _props.pcf  the local .pcf file that you want to protect. -->
		<xsl:if test="ou:hasCas($props-protection) and $ou:action = 'pub'">
			<xsl:call-template name="cas-protect"><xsl:with-param name="protection" select="$props-protection"/></xsl:call-template>
		</xsl:if>
		<xsl:if test="ou:pcfparam('destination') != ''"><xsl:call-template name="redirect"/></xsl:if>
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE HTML&gt;</xsl:text>
		<html lang="en">
			<head>
				<xsl:copy-of select="ou:includeFile('/_resources/includes/headcode.inc')"/>
				<title>
					<xsl:value-of select="$page-title"/>
					<xsl:call-template name="title"><xsl:with-param name="path" select="$dirname"/></xsl:call-template>
				</title>
				<link rel="icon" type="image/png" href="http://www.uga.edu/favicon.png" />
				<xsl:copy-of select="ou:includeFile('/_resources/includes/css.inc')"/>
				<xsl:apply-templates select="headcode/node()"/>
				<xsl:if test="descendant::calendar|descendant::calendar-only|descendant::calendar-events-only">
					<link rel="stylesheet" href="/_resources/js/calendar/calendar.css" />
				</xsl:if>
				<xsl:call-template name="form-headcode"/> <!-- Add Form Code -->
				<xsl:if test="descendant::gallery">
					<xsl:apply-templates select="ou:gallery-headcode(ou:pcfparam('gallery-type'))"/>
				</xsl:if>
			</head>
			<body>
				<a class="sr-only sr-only-focusable skip-link" href="#content">Skip to main content</a>
				<xsl:if test="ou:hasCas($props-protection)">
					<xsl:apply-templates select="ou:casMessage($props-protection)"/>
				</xsl:if>
				<xsl:apply-templates select="bodycode/node()"/>
				<xsl:call-template name="header" />
				<xsl:call-template name="page-content" />
				<xsl:call-template name="breadcrumb-nav"/>
				<xsl:call-template name="footer" />
				<xsl:apply-templates select="footcode/node()"/>
				<xsl:call-template name="form-footcode"/><!-- Add Form Code -->
				<xsl:if test="descendant::gallery">
					<xsl:apply-templates select="ou:gallery-footcode(ou:pcfparam('gallery-type'))"/>
				</xsl:if>
				<xsl:if test="descendant::calendar|descendant::calendar-only|descendant::calendar-events-only">
					<xsl:apply-templates mode="calendar-scripts"/>
				</xsl:if>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="header">
		<header role="banner" id="page-header">
			<div class="container top nopad-side">
				<nav>
					<div class="collapse" id="quick-links">
						<xsl:copy-of select="ou:includeFile('/_resources/includes/quick_links.inc')"/>
					</div>
					<a class="accordion-toggle" role="button" data-toggle="collapse" href="#quick-links" aria-expanded="false" aria-controls="quick-links">
						UGA Links <span aria-hidden="true" class="caret"></span>
					</a>
				</nav>
				<div class="row padd-side clearfix">
					<div class="col-md-9 page-heading">
						<h1>
							<a href="/">
								<img src="/_resources/images/logos/uga_logo.png" alt="UGA Logo"/>
							</a>
						</h1>
					</div>
					<div class="col-md-3 col-md-12 search-menu">
						<nav>
							<ul>
								<li class="first leaf"><a href="/contact/" title="">Contact Us</a></li>
								<li class="last leaf"><a href="#">Second Link</a></li>
							</ul>
						</nav>
						<xsl:copy-of select="ou:includeFile('/_resources/includes/search.inc')"/>
					</div>
				</div>
			</div>
			<nav id="custom-bootstrap-menu" class="navbar navbar-default yamm" role="navigation">
				<div class="container">
					<div class="navbar-header">
						<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-menubuilder"><span class="sr-only">Toggle navigation</span><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button>
					</div>
					<div class="collapse navbar-collapse navbar-menubuilder">
						<xsl:choose>
							<xsl:when test="$ou:action != 'pub'">
								<xsl:call-template name="siteNav"><xsl:with-param name="rootRel" select="''"/></xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:processing-instruction name="php">include($_SERVER['DOCUMENT_ROOT'] . "/_resources/includes/_site-nav.html"); ?</xsl:processing-instruction>					
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</div>
			</nav>
		</header>
	</xsl:template>
	
	<xsl:template name="footer">
		<footer class="footer">
			<xsl:copy-of select="ou:includeFile('/_resources/includes/footer.inc')"/>
			<div><ouc:ob /></div>
		</footer>
		<xsl:copy-of select="ou:includeFile('/_resources/includes/footcode.inc')" />
		<xsl:copy-of select="ou:includeFile('/_resources/includes/analytics.inc')" />
	</xsl:template>
	
	<xsl:template name="redirect">
		<xsl:processing-instruction name="php">header("HTTP/1.1 301 Moved Permanently");
			header("Location: <xsl:value-of select="ou:pcfparam('destination')"/>"); 
		?</xsl:processing-instruction>
	</xsl:template>
</xsl:stylesheet>