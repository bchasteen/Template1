<?php
error_reporting(0);
ini_set('display_errors', '0');

function compare($a, $b) 
{
    return ($a['pubDate'] == $b['pubDate']) ? 0 : ($a['pubDate'] > $b['pubDate']) ? -1 : 1;
}

function pagination($page, $numberOfPages)
{
	$link = '?page=';
	$range = 50;
	$ret = "";
	if($numberOfPages > 1){
		$ret = '<nav><ul class="pagination">';
		if ($page > 1) {
			#
			# get previous page num
			$prevpage = $page - 1;
			$ret .= '<li><a href="'.$link.$prevpage.'" aria-label="Previous"><span aria-hidden="true">&#139;</span></a></li>';
		}

		#
		# loop to show links to range of pages around current page
		#	page=12 range=40 
		$start = (($page - $range) < 0) ? 0 : $page - $range;
		for ($x = $start; $x < (($page + $range) + 1); $x++) {
			#
			# if it's a valid page number...
			if (($x > 0) && ($x <= $numberOfPages))
				$ret.= ($x == $page)
					? "<li class=\"active\"><a href=\"#\">$x <span class=\"sr-only\">(current)</span></a></li>" 
					: "<li><a href=\"$link$x\">$x</a></li>";
		}
		
		#
		# if not on last page, show forward and last page links        
		if ($page < $numberOfPages) {
			#
			# get next page
			$nextpage = $page + 1;
			$ret.= '<li><a href="'.$link.$nextpage.'" aria-label="Next"><span aria-hidden="true">&#155;</span></a></li>';
		}
		$ret.= "</ul></nav>";
	}
	echo $ret;
}

/**
* Get either all the RSS items, or items based on a tag and search parameter passed
* to the function.  If no search parameter, then the search will be performed by 
* category.
*
* @param $path String - Either relative or absolute path to an XML file to display
* @param $searchby String - XML node to search for (default:<category>)
* @param $tag String - Value to search for within XML node
*/
function getRSScategory($path, $tag="", $searchby="")
{
	if(!$path) return [];
	
	$posts = [];
	$path = substr($path, 0, 1) == "/" ? $_SERVER["DOCUMENT_ROOT"].$path : $path;
	$xml = simplexml_load_file($path);
	
	#
	# If tag has a comma, turn it into an array and then get the first element.
	# otherwise, simply get the tag value.
	$tag = strpos($tag, ",") ? explode(",", $tag) : $tag;
	$tag = is_array($tag) ? $tag[0] : $tag;

	if(!$xml) return false;
	
	$items = $xml->xpath(empty($tag) ? "/rss/channel/item" : "/rss/channel/item[" . (empty($searchby) ? "category" : $searchby) . "='" . trim($tag) . "']");
	
	foreach($items as $item){
		$item->registerXPathNamespace("media", "http://search.yahoo.com/mrss/");
		$img = $item->xpath('./media:content');
		$pubDate = (new DateTime($item->pubDate, new DateTimeZone("America/New_York")))->getTimestamp();
		$endDate = isset($item->endDate) ? (new DateTime($item->endDate, $timezone))->getTimestamp() : NULL;
		
		$posts[] = [
			"title" => strval($item->title),
			"description" => strval($item->description),
			"author" => strval($item->author),
			"link"  => strval($item->link),
			"pubDate" => $pubDate,
			"endDate" => $endDate,
			"category" => $item->category,
			"image" => isset($img[0]) ? [
				"src" => strval($img[0]->attributes()->url),
				"thumb" => strval($item->xpath('./media:content/media:thumbnail')[0]->attributes()->url),
				"alt" => strval($item->xpath('./media:content/media:title')[0])
			] : []
		];
	}
	usort($posts, "compare"); // Sort items descending by pubDate;
	return $posts;	
}	

/**
* Options: 
* limit: Integer - number of items to show
* images: Boolean - show or hide images
* dates: Boolean - show or hide dates
* dateFormat: String - PHP Date Format to use (default:'n/j/y')
* description: Boolean - show or hide description
* style: String - CSS class to add to the <ul>
* json: Boolean - Return output as JSON encoded string instead of HTML (default: false)
*
* Parameters:
* @rss SimpleXMLObject - the Feed to output
* @config String - JSON encoded String with options for displaying output
**/
function displayRSS($rss, $config)
{
	if(!$items || count($items) < 1){
		echo "<p>No events found</p>";
		return 0;
	} 
	
	# Get Options
	$opt = json_decode($config);
	
	# Set Options
	$items = isset($opt->limit) && intval($opt->limit) > 0 ? array_slice($rss, 0, $limit) : $rss;
	$json = isset($opt->json) ? $opt->json : false;
	$format = isset($opt->dateFormat) ? $opt->dateFormat : "Y-m-d";
	$mediaObject = isset($opt->media) ? filter_var($opt->media, FILTER_VALIDATE_BOOLEAN) : false;
	$pagination = isset($opt->pagination) ? filter_var($opt->pagination, FILTER_VALIDATE_BOOLEAN) : false;
	
	# Display Output
	if(filter_var($json, FILTER_VALIDATE_BOOLEAN)){
		echo json_encode($items);
		exit(0);
	}
	
	if($mediaObject){
		foreach($items as $item){
			$alt = empty($item["image"]["alt"]) ? $item["title"] : $item["image"]["alt"];
			$img = '<img class="media-object" src="'.($item["image"] ? $item["image"]["thumb"] : "/_resources/images/template/placeholder.png").'" alt="'.$alt.'" />';
			$datetime = DateTime::createFromFormat("U", intval($item["pubDate"]), new DateTimeZone("America/New_York"));
			echo '
			<div class="media">
				<div class="media-left">
					<a href="'.$item["link"].'">'.$img.'</a>
				</div>
				<div class="media-body">
					<h4 class="media-heading"><a href="'.$item["link"].'">'.htmlentities($item["title"]).'</a></h4>
					<div class="media-description">';
						echo (isset($opt->dates) && filter_var($opt->dates, FILTER_VALIDATE_BOOLEAN)) ? '<p class="date">'. $datetime->format($format) .'</p>' : '';
						echo (isset($opt->description) && filter_var($opt->description, FILTER_VALIDATE_BOOLEAN)) ? '<p>'.htmlentities($item["description"]).'</p>' : '';
			echo 	'</div>
				</div>
			</div>';
		}
	} else {
		echo '<ul'.(isset($opt->style) ? ' class="'.$opt->style.'">' : ">");
		foreach($items as $item){
			$alt = empty($item["image"]["alt"]) ? $item["title"] : $item["image"]["alt"];
			$img = '<img class="media-object" src="'.($item["image"] ? $item["image"]["thumb"] : "/_resources/images/template/placeholder.png").'" alt="'.$alt.'" />';
			$datetime = DateTime::createFromFormat("U", intval($item["pubDate"]), new DateTimeZone("America/New_York"));

			echo '<li>';
			echo (isset($opt->images) && filter_var($opt->images, FILTER_VALIDATE_BOOLEAN)) ? sprintf('<div class="list-image">%s</div>', ($item["link"] ? '<a href="'.$item["link"].'">'.$img.'</a>' : $img)) : ''; 
			echo '<strong><a href="'.$item["link"].'">'.htmlentities($item["title"]).'</a></strong>';
			echo (isset($opt->dates) && filter_var($opt->dates, FILTER_VALIDATE_BOOLEAN)) ? '<p class="date">'. $datetime->format($format) .'</p>' : '';
			echo (isset($opt->description) && filter_var($opt->description, FILTER_VALIDATE_BOOLEAN)) ? '<p>'.htmlentities($item["description"]).'</p>' : '';
			echo '</li>';
		}
		echo '</ul>';
	}
	if($pagination)
		echo pagination($items, $config);
}
?>