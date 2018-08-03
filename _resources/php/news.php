<?php
ini_set('display_errors', '0');
libxml_use_internal_errors(true);

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
#
# Error Checking
if(empty($feed))
	exit("RSS Feed is empty");

if(empty($num_items) || intval($num_items < 1))
	exit("Number of items is empty");

if(empty($pagination))
	exit("Pagination must be true or false");

#
# XML
$posts = [];
$path = strpos($feed, $_SERVER["DOCUMENT_ROOT"]) === false ? $_SERVER["DOCUMENT_ROOT"].$feed : $feed;
$xml = simplexml_load_file($path);
if(!$xml)
	exit("Invalid XML Path");
#
# Get and sort items
$items = $xml->xpath("/rss/channel/item");
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

#
# Initial pagination setup
$page = filter_input(INPUT_GET, "page", FILTER_VALIDATE_INT);
$num_pages = ceil(count($posts) / $num_items);
$page = ($page > 0 && $page <= $num_pages) ? $page : 1;
$start = ($page - 1) * $num_items;
$end = $start + $num_items;

if(!count($posts)) 
	exit("<p class=\"bg-info\">No current items found</p>");

echo "<ul>";
for( $i = $start; $i < $end; $i++ ){
	if( $i >= count($posts) ) break;
	$img = '<img class="media-object" src="'.($posts[$i]["image"] ? $posts[$i]["image"]["thumb"] : "/_resources/images/template/placeholder.png").'" alt="'.$posts[$i]["image"]["alt"].'" />';
	$date = DateTime::createFromFormat("U", intval($posts[$i]["pubDate"]), new DateTimeZone("America/New_York"));
	echo '<li><a href="'.$posts[$i]["link"].'">'.$posts[$i]["title"].'</a> <p>'.$date->format("F dS, Y").'</p></li>';
}
echo "</ul>";

if(filter_var($pagination, FILTER_VALIDATE_BOOLEAN))
	pagination($page, $num_pages);
?>
