function createXHR() 
{
    var request = false;
        try {
            request = new ActiveXObject('Msxml2.XMLHTTP');
        }
        catch (err2) {
            try {
                request = new ActiveXObject('Microsoft.XMLHTTP');
            }
            catch (err3) {
		try {
			request = new XMLHttpRequest();
		}
		catch (err1) 
		{
			request = false;
		}
            }
        }
    return request;
}



function Write(url, content)	// url is the script and data is a string of parameters
	{ 
		var xhr = createXHR();

		xhr.onreadystatechange=function()
		{ 
			if(xhr.readyState == 4)
			{
				//alert("Envoyé " + content);
			}
		}; 
		xhr.open("POST", url, true);		
		xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		xhr.send(content); 
	} 