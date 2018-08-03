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

	<xsl:mode name="patch" on-no-match="shallow-copy"/>
	<xsl:mode name="copy" on-no-match="shallow-skip"/>
	
	<xsl:output method="html" version="4.0" indent="yes" encoding="UTF-8" include-content-type="no" omit-xml-declaration="yes"/>
	<xsl:strip-space elements="*"/>
	
	<xsl:template name="page-content"/>

	<xsl:template match="ul/li//li/a" mode="copy">
		<strong><a href="{@href}" data-toggle="dropdown"><xsl:value-of select="text()"/></a></strong>
	</xsl:template>

	<xsl:template match="li/ul/li" mode="copy">
		<div class="col-sm-4">
			<xsl:apply-templates select="a"/>
			<xsl:if test="descendant::ul">
				<xsl:apply-templates select="ul"/>
			</xsl:if>
		</div>
	</xsl:template>
	
	<xsl:template match="li/ul" mode="copy">
		<ul class="dropdown-menu yamm-content">
			<li class="submenu-item">
			<xsl:apply-templates select="li" mode="copy"/>
			</li>
		</ul>
	</xsl:template>
	
	<xsl:template match="ul" mode="patch">
		<xsl:for-each select="li">
			<li class="dropdown yamm-fullwidth">
				<xsl:if test="a">
					<a class="dropdown-toggle disabled" href="{a/@href}" data-toggle="dropdown"><xsl:value-of select="a/text()"/></a>
				</xsl:if>
				<xsl:if test="ul">
					<xsl:apply-templates select="ul" mode="copy"/>
				</xsl:if>
			</li>
		</xsl:for-each>
	</xsl:template>

	<!-- Get rid of any stray paragraphs -->
	<xsl:template match="p" mode="patch"/>
	
	<xsl:template match="/document">
		<ul class="nav navbar-nav navbar-left parent list-unstyled menu">				
			<xsl:call-template name="siteNav"><xsl:with-param name="rootRel" select="''"/></xsl:call-template>

			<xsl:try>
				<xsl:apply-templates select="ouc:div[@label='maincontent']" mode="patch"/>
				<xsl:catch></xsl:catch>
			</xsl:try>
		</ul>
		<xsl:if test="$ou:action != 'pub'">
		<div class="bg-warning" style="padding:10px;border:1px solid #990">
			<h1 class="text-warning">About the Menu</h1>
			<p>This menu will provide a simple listing of the items on your website for a mega menu with SOME options.</p>
			<p>EITS does not provide customization. You may customize and use it if you find it helpful for your site.</p>
			<p>There is no file sorting.  All files will be listed unless they are restricted by directory or filename.</p>
			<p>There is another option to list certain directories (such as a calendar) and not list the posts for it.</p>
			<p>The source code for this page can be edited and the HTML inserted or you can click the Main Content button and add it there.</p>
			<p>Create the list items and then put any lists you would like created within them.  Avoid adding "ul" tags to top level items.</p>
			<pre style="padding:30px;">
&lt;ul&gt;
	&lt;li&gt;
		&lt;a href="/directory/"&gt;Directory&lt;/a&gt;
		&lt;ul&gt;
			&lt;li&gt;&lt;a href="/directory/faculty/"&gt;Faculty&lt;/a&gt;&lt;/li&gt;
			&lt;li&gt;&lt;a href="/directory/staff/"&gt;Staff&lt;/a&gt;&lt;/li&gt;
		&lt;/ul&gt;
	&lt;/li&gt;
	&lt;li&gt;
		&lt;a href="/events"&gt;Events&lt;/a&gt;
	&lt;/li&gt;
&lt;/ul&gt;
			</pre>
		</div>
		</xsl:if>
		<xsl:try>
			<xsl:copy-of select="ouc:div[@label='autopublish']"/>
			<xsl:catch></xsl:catch>
		</xsl:try>
	</xsl:template>	
	
</xsl:stylesheet>
