
// Ecouteurs
// https://developer.mozilla.org/en-US/docs/DOM/EventTarget.addEventListener

var sndIndex;

function Construction_ecouteurs(_sndCollection,nodeTemp,dataTemp,last,parentName,cercleNoir){
    // NB : _sndCollection garde sa taille max .....
    if(cercleNoir)
	sndIndex = d3.selectAll("circle").filter(function(d){return d.name == parentName}).attr('sndIndex');
    for(ii=0;ii<dataTemp.length-1;ii++)	{
	_sndCollection[ii].addEventListener("ended", function(_event) {
	    focusSound(nodeTemp,sndIndex,dataTemp,last);
    	    _sndCollection[sndIndex].play()
	    
	    // relevé temps 
	    saveDataXP(dataTemp[sndIndex].oggFile)				
	    sndIndex++;
	    //console.log(sndIndex)
	    d3.selectAll("circle").filter(function(d){return d.name == parentName}).attr('sndIndex',function(d){return sndIndex});
	    //console.log(parentName + d3.selectAll("circle").filter(function(d){return d.name == parentName}).attr('sndIndex'));
    	},false);	
    }
    
    _sndCollection[dataTemp.length-1].addEventListener("ended", function(_event) {
    	sndIndex=1;
	d3.selectAll("circle").filter(function(d){return d.name == parentName}).attr('sndIndex', function(d){return sndIndex});
	//console.log(parentName + d3.selectAll("circle").filter(function(d){return d.name == parentName}).attr('sndIndex'));
	focusSound(nodeTemp,0,dataTemp,last);
    	_sndCollection[0].play()
	
	// relevé temps 
	saveDataXP(dataTemp[0].oggFile)	
	
    },false);
	    					
    focusSound(nodeTemp,sndIndex-1,dataTemp,last);
    _sndCollection[sndIndex-1].play();
    //console.log(parentName + d3.selectAll("circle").filter(function(d){return d.name == parentName}).attr('sndIndex'));	
}	

// focus (trait gras)
function focusSound(nodeTemp,index,dataTemp,last) {
    // test index du sample
    if(index==0) {
	var index1 = dataTemp.length-1;
	var index2 = index;
    } else {
	var index1 = index-1;
	var index2 = index;
    }
    // suppression old focus node
    circleTemp=dataTemp[index1].name;
    d3.selectAll("circle").filter(function(d){return d.name == circleTemp})
	.transition().duration(500)
	.style('stroke-width', '1');
    // leaf node
    d3.selectAll("circle")
	.filter(function(d){return d3.select(this).attr('class') == "leaf node"})
	.style('fill','rgba(74,74,74,1)');
    //focus
    circleTemp=dataTemp[index2].name;
    if (last) {
	d3.selectAll("circle")
	    .filter(function(d){return d.name == circleTemp})
	    .style('fill','black');	
    } else {
	d3.selectAll("circle")
	    .filter(function(d){return d.name == circleTemp})
	    .remove();
	nodeTemp
	    .filter(function(d){return d.name ==circleTemp})
	    .append('circle')
	    .attr("r", function(d) { return d.r; })
	    .attr("name", function(d) { return d.name; })
	    .attr("class",function(d) {return d.children ? "node" : "leaf node"; })
	    .attr('sndIndex',1)
	    .style('stroke', 'black')
	    .style('stroke-width', '4');	
    }	
}	

// AudioStop
function audioStop(_sndCollection) {						
    for(ii=0;ii<_sndCollection.length;ii++){
	_sndCollection[ii].pause();
	_sndCollection[ii].src="";
    }
}

// Creation_playlist
function Creation_playlist(children) {	
    setTimeout(function(){document.body.style.cursor="progress";});
    //	var index = 1;			
    // Creation de la playlist
    for(ii=0;ii<children.length;ii++) {
	var _mySnd = new Audio(children[ii].oggFile);
	_sndCollection[ii] = new Audio();
	_sndCollection[ii].src = _mySnd.src;
	_sndCollection[ii].addEventListener("stalled", function () {document.body.style.cursor="progress";});
	_sndCollection[ii].addEventListener("play", function () {document.body.style.cursor="";});
	_sndCollection[ii].addEventListener("playing", function () {document.body.style.cursor="";});
	_sndCollection[ii].addEventListener("ended", function () {document.body.style.cursor="";});
	_sndCollection[ii].load();
    }
    return _sndCollection;
}


function shuffle(array) {
    var tmp, current, top = array.length;

    if(top) while(--top) {
    	current = Math.floor(Math.random() * (top + 1));
    	tmp = array[current];
    	array[current] = array[top];
    	array[top] = tmp;
    }

    return array;
}

function findIndexSnd(parentChildren,oggFile){
    var indexSnd = 0;
    for(var ii=0;ii<parentChildren.length;ii++)
	if(oggFile == parentChildren[ii].oggFile)
	    indexSnd=ii;
    return indexSnd;
}
