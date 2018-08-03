String.prototype.endsWith = function(suffix) {
    return this.indexOf(suffix, this.length - suffix.length) !== -1;
};
function fixPath(url){
	if(!url) return 0;

	// Remove file extension
	if(url.indexOf(".") >= 0)
		url = url.substring(url.indexOf(".") , -1);

	// Add slash if it doesn't have one;
	return url.endsWith("/") ? url : url + "/"; 
}
function findParents(el){
	if(!el) return 0;

	if(el.parentElement.nodeName == "LI")
		el.parentElement.setAttribute("class",  el.parentElement.getAttribute("class") + " active");

	if(el.parentElement.nodeName !== "NAV")
		findParents(el.parentElement);
}
	
var li = document.querySelectorAll("#left-column nav ul li");
var path = fixPath(location.pathname);
var link = "";

for(var i in li){
	if (!li.hasOwnProperty(i)) continue;

	if(li[i].getElementsByTagName("a")[0] != undefined)
		link = fixPath(li[i].getElementsByTagName("a")[0].pathname);

	if(link &&  link == path){
		li[i].setAttribute("class", li[i].getAttribute("class") + " active");
		findParents(li[i]);

	}
}