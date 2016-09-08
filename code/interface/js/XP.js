var timercount = 0;
var timestart  = null;
 
function showtimer() {
    if (timercount) {
        clearTimeout(timercount);
        clockID = 0;
    }
    if (!timestart) {
        timestart = new Date();
    }
    var timeend = new Date();
    var timedifference = timeend.getTime() - timestart.getTime();
    timeend.setTime(timedifference);
    var minutes_passed = timeend.getMinutes();
    if (minutes_passed < 10) {
        minutes_passed = "0" + minutes_passed;
    }
    var seconds_passed = timeend.getSeconds();
    if (seconds_passed < 10) {
        seconds_passed = "0" + seconds_passed;
    }
    var milliseconds_passed = timeend.getMilliseconds();
    if (milliseconds_passed < 10) {
        milliseconds_passed = "00" + milliseconds_passed;
    }
    else if (milliseconds_passed < 100) {
        milliseconds_passed = "0" + milliseconds_passed;
    }
    
    document.timeform.timetextarea.value = minutes_passed + ":" + seconds_passed + "." + milliseconds_passed;
    timercount = setTimeout("showtimer()", 1);
}
 
function sw_start() {
    if (!timercount) {
	timestart   = new Date();
	document.timeform.timetextarea.value = "00:00.000";
	document.timeform.laptime.value = "";
	timercount  = setTimeout("showtimer()", 1);
    }
    else{
	var timeend = new Date();
        var timedifference = timeend.getTime() - timestart.getTime();
        timeend.setTime(timedifference);
        var minutes_passed = timeend.getMinutes();
        if(minutes_passed < 10){
            minutes_passed = "0" + minutes_passed;
        }
        var seconds_passed = timeend.getSeconds();
        if(seconds_passed < 10){
            seconds_passed = "0" + seconds_passed;
        }
        var milliseconds_passed = timeend.getMilliseconds();
        if(milliseconds_passed < 10){
            milliseconds_passed = "00" + milliseconds_passed;
        }
        else if(milliseconds_passed < 100){
            milliseconds_passed = "0" + milliseconds_passed;
        }
        document.timeform.laptime.value = minutes_passed + ":" + seconds_passed + "." + milliseconds_passed;
    }
}
 
function Stop() {
    if(timercount) {
        clearTimeout(timercount);
        timercount  = 0;
        var timeend = new Date();
        var timedifference = timeend.getTime() - timestart.getTime();
        timeend.setTime(timedifference);
        var minutes_passed = timeend.getMinutes();
        if(minutes_passed < 10){
            minutes_passed = "0" + minutes_passed;
        }
        var seconds_passed = timeend.getSeconds();
        if(seconds_passed < 10){
            seconds_passed = "0" + seconds_passed;
        }
        var milliseconds_passed = timeend.getMilliseconds();
        if(milliseconds_passed < 10){
            milliseconds_passed = "00" + milliseconds_passed;
        }
        else if(milliseconds_passed < 100){
            milliseconds_passed = "0" + milliseconds_passed;
        }
        document.timeform.timetextarea.value = minutes_passed + ":" + seconds_passed + "." + milliseconds_passed;
    }
    timestart = null;
}
 
function Reset() {
    timestart = null;
    document.timeform.timetextarea.value = "00:00.000";
    document.timeform.laptime.value = "";
}

function found(_sndCollection){
	if(saveXP[indexTargetSnd][indexSaveXP-1] && saveXP[indexTargetSnd][indexSaveXP-2])
	{
		if(targetSnd[indexTargetSnd] == saveXP[indexTargetSnd][indexSaveXP-1].oggFile || ((saveXP[indexTargetSnd][indexSaveXP-1].oggFile=='pause' || saveXP[indexTargetSnd][indexSaveXP-1].oggFile=='target_' + targetSnd[indexTargetSnd]) && saveXP[indexTargetSnd][indexSaveXP-2].oggFile==targetSnd[indexTargetSnd]))
		{
			// Arret Audio
			audioStop(_sndCollection);
	
			// sauvegarde temps final
			saveXP[indexTargetSnd][indexSaveXP] = {};
			saveXP[indexTargetSnd][indexSaveXP].time = document.timeform.timetextarea.value;
			saveXP[indexTargetSnd][indexSaveXP].timeDebut = timeDebut;
		
			// Stop chrono
			Stop();
			document.timeform.etat.value = "Pause";
	
			if(indexTargetSnd < targetSnd.length-1)
			{
				//chargement New target sound
				indexTargetSnd++;
				currentTargetSnd.src = targetSnd[indexTargetSnd];
				document.timeform.numeroSoncible.value = indexTargetSnd+1;
	
				// Reset save XP
				indexSaveXP = 0;
				saveXP[indexTargetSnd] = [];
				Reset();
				// message
				alert("Well done! You have found the target sound, continue!")
			}	
			else
			{
				// Save de l'email et de la checkbox
				saveXP[indexTargetSnd][indexSaveXP].emailadd = document.timeform.nomSujet.value;
				saveXP[indexTargetSnd][indexSaveXP].box = document.getElementById('box').checked;
				saveXP[indexTargetSnd][indexSaveXP].Abandon = false;
				d3.selectAll('circle').remove()
				saveXPString = JSON.stringify(saveXP);
				// Recuperation du nom
				nomSujet = document.timeform.nomSujet.value;
				var regAt = new RegExp("(@)","g");
				nomSujet = nomSujet.replace(regAt,"at");
				regAt2 = new RegExp("\\.","g");
				nomSujet = nomSujet.replace(regAt2,"dot");
				nomSujet = nomSujet.replace(/ /g,"");
				indexAudioDevice = document.getElementById('indexAudioDevice')
				audioDevice = indexAudioDevice.options[indexAudioDevice.selectedIndex].value;
				audioDevice = audioDevice.replace(/ /g,"");
				Write("saveData.php", "name=" + nomSujet + "&audioDevice=" + audioDevice + "&typeXP=" + typeXP + "&file=saveXP/&content=" + saveXPString);	
				// Suppression du bouton Found
				element = document.getElementById("foundbutton");
				element.parentNode.removeChild(element);
				element = document.getElementById("currentTargetSnd");
				element.parentNode.removeChild(element);
				// etat recherche fin
				document.timeform.etat.value = "End";
				document.timeform.numeroSoncible.value = "";
				deleteWarning();
				alert("It is over! Thank you for participating!");
				setTimeout(function(){window.close()},3000);
			}
		}
		else
		{
			alert("You have not found the target sound, continue!");
		}
	}
	else
	{
		alert("You have not heard a sound yet!");
	}
	
}

function playTargetSnd(){

	audioStop(_sndCollection);
	currentTargetSnd.load();
	currentTargetSnd.play();
	// relevé temps 
	if(document.timeform.timetextarea.value != "00:00.000")
	{
		sw_start();
	}
	// save donnes XP
	saveXP[indexTargetSnd][indexSaveXP] = {};
	saveXP[indexTargetSnd][indexSaveXP].oggFile = 'target_' + targetSnd[indexTargetSnd];
	saveXP[indexTargetSnd][indexSaveXP].time = document.timeform.timetextarea.value;
	indexSaveXP ++;
	console.log(saveXP);
}

function saveDataXP(_oggFile){
    if(_oggFile == 'pause') {
	if(indexSaveXP-1 >=0 && saveXP[indexTargetSnd][indexSaveXP-1].oggFile != "pause") {
	    if(document.timeform.timetextarea.value != "00:00.000") {
		sw_start();
	    }
	    // save donnes XP
	    saveXP[indexTargetSnd][indexSaveXP] = {};
	    saveXP[indexTargetSnd][indexSaveXP].oggFile = _oggFile;
	    saveXP[indexTargetSnd][indexSaveXP].time = document.timeform.timetextarea.value;
	    indexSaveXP ++;
	}	
    } else {
	// relevé temps 
	sw_start();
	// save donnes XP
	saveXP[indexTargetSnd][indexSaveXP] = {};
	saveXP[indexTargetSnd][indexSaveXP].oggFile = _oggFile;
	saveXP[indexTargetSnd][indexSaveXP].time = document.timeform.timetextarea.value;
	indexSaveXP ++;
    }
    console.log(saveXP);
}

function deleteWarning(){
    $(window).bind('beforeunload',function(e){
	return null
    });
}


function closeSave(){
    // Arret Audio
    audioStop(_sndCollection);
	
    // sauvegarde temps final
    saveXP[indexTargetSnd][indexSaveXP] = {};
    saveXP[indexTargetSnd][indexSaveXP].time = document.timeform.timetextarea.value;
    saveXP[indexTargetSnd][indexSaveXP].timeDebut = timeDebut;
			
    // Save de l'email et de la checkbox
    saveXP[indexTargetSnd][indexSaveXP].emailadd = document.timeform.nomSujet.value;
    saveXP[indexTargetSnd][indexSaveXP].box = document.getElementById('box').checked;
    saveXP[indexTargetSnd][indexSaveXP].Abandon = true;
    saveXPString = JSON.stringify(saveXP);
    // Recuperation du nom
    nomSujet = document.timeform.nomSujet.value;
    var regAt = new RegExp("(@)","g");
    nomSujet = nomSujet.replace(regAt,"at");
    regAt2 = new RegExp("\\.","g");
    nomSujet = nomSujet.replace(regAt2,"dot");
    nomSujet = nomSujet.replace(/ /g,"");
    indexAudioDevice = document.getElementById('indexAudioDevice')
    audioDevice = indexAudioDevice.options[indexAudioDevice.selectedIndex].value;
    audioDevice = audioDevice.replace(/ /g,"");
    Write("saveData.php", "name=" + nomSujet + "&audioDevice=" + audioDevice + "&typeXP=" + typeXP + "&file=saveAbandon/&content=" + saveXPString);	
}
