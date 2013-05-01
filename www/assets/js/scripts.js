var Globals = {
	initialize: function() {
		Custom.init();
		Convert.init();
		Fade.initialize();
		Nav.initialize();
	}
}
window.onload = Globals.initialize;

/*

CUSTOM FORM ELEMENTS

Created by Ryan Fait
www.ryanfait.com

*/

var checkboxHeight = "27";
var radioHeight = "27";
var selectWidth = "251";

document.write('<style type="text/css">input.styled { display: none; } select.styled { position: relative; width: ' + selectWidth + 'px; opacity: 0; filter: alpha(opacity=0); z-index: 5; }</style>');

var Custom = {
	init: function() {
		var inputs = document.getElementsByTagName("input"), span = Array(), textnode, option, active;
		for(a = 0; a < inputs.length; a++) {
			if((inputs[a].type == "checkbox" || inputs[a].type == "radio") && inputs[a].className == "styled") {
				span[a] = document.createElement("span");
				span[a].className = inputs[a].type;

				if(inputs[a].checked == true) {
					if(inputs[a].type == "checkbox") {
						position = "0 -" + (checkboxHeight*2) + "px";
						span[a].style.backgroundPosition = position;
					} else {
						position = "0 -" + (radioHeight*2) + "px";
						span[a].style.backgroundPosition = position;
					}
				}
				inputs[a].parentNode.insertBefore(span[a], inputs[a]);
				inputs[a].onchange = Custom.clear;
				span[a].onmousedown = Custom.pushed;
				span[a].onmouseup = Custom.check;
				document.onmouseup = Custom.clear;
			}
		}
		inputs = document.getElementsByTagName("select");
		for(a = 0; a < inputs.length; a++) {
			if(inputs[a].className == "styled") {
				option = inputs[a].getElementsByTagName("option");
				active = option[0].childNodes[0].nodeValue;
				textnode = document.createTextNode(active);
				for(b = 0; b < option.length; b++) {
					if(option[b].selected == true) {
						textnode = document.createTextNode(option[b].childNodes[0].nodeValue);
					}
				}
				span[a] = document.createElement("span");
				span[a].className = "select";
				span[a].id = "select" + inputs[a].name;
				span[a].appendChild(textnode);
				inputs[a].parentNode.insertBefore(span[a], inputs[a]);
				inputs[a].onchange = Custom.choose;
			}
		}
	},
	pushed: function() {
		element = this.nextSibling;
		if(element.checked == true && element.type == "checkbox") {
			this.style.backgroundPosition = "0 -" + checkboxHeight*3 + "px";
		} else if(element.checked == true && element.type == "radio") {
			this.style.backgroundPosition = "0 -" + radioHeight*3 + "px";
		} else if(element.checked != true && element.type == "checkbox") {
			this.style.backgroundPosition = "0 -" + checkboxHeight + "px";
		} else {
			this.style.backgroundPosition = "0 -" + radioHeight + "px";
		}
	},
	check: function() {
		element = this.nextSibling;
		if(element.checked == true && element.type == "checkbox") {
			this.style.backgroundPosition = "0 0";
			element.checked = false;
		} else {
			if(element.type == "checkbox") {
				this.style.backgroundPosition = "0 -" + checkboxHeight*2 + "px";
			} else {
				this.style.backgroundPosition = "0 -" + radioHeight*2 + "px";
				group = this.nextSibling.name;
				inputs = document.getElementsByTagName("input");
				for(a = 0; a < inputs.length; a++) {
					if(inputs[a].name == group && inputs[a] != this.nextSibling) {
						inputs[a].previousSibling.style.backgroundPosition = "0 0";
					}
				}
			}
			element.checked = true;
		}
	},
	clear: function() {
		inputs = document.getElementsByTagName("input");
		for(var b = 0; b < inputs.length; b++) {
			if(inputs[b].type == "checkbox" && inputs[b].checked == true && inputs[b].className == "styled") {
				inputs[b].previousSibling.style.backgroundPosition = "0 -" + checkboxHeight*2 + "px";
			} else if(inputs[b].type == "checkbox" && inputs[b].className == "styled") {
				inputs[b].previousSibling.style.backgroundPosition = "0 0";
			} else if(inputs[b].type == "radio" && inputs[b].checked == true && inputs[b].className == "styled") {
				inputs[b].previousSibling.style.backgroundPosition = "0 -" + radioHeight*2 + "px";
			} else if(inputs[b].type == "radio" && inputs[b].className == "styled") {
				inputs[b].previousSibling.style.backgroundPosition = "0 0";
			}
		}
	},
	choose: function() {
		option = this.getElementsByTagName("option");
		for(d = 0; d < option.length; d++) {
			if(option[d].selected == true) {
				document.getElementById("select" + this.name).childNodes[0].nodeValue = option[d].childNodes[0].nodeValue;
			}
		}
	}
}
var Convert = {
	init: function() {
		var spans = document.getElementsByTagName("span");
		for (var i = 0; i < spans.length; i++) {
			if(spans[i].className == "address") {
				string = spans[i].childNodes[0].nodeValue;
				email = string.split("_")[0] + "@" + string.split("_")[2];
				spans[i].innerHTML = '<a href="mailto:' + email + '">' + email + '</a>';
			}
		}
	}
}
var stage = new Array(), img, rotate = 0, opac = 100, int;
var Fade = {
	initialize: function() {
		if(document.getElementById("stage")) {

			img = document.getElementById("stage");

			stage[0] = new Image();
			stage[0].src = "/workspace/images/stage-one.png";
			stage[1] = new Image();
			stage[1].src = "/workspace/images/stage-two.png";
			stage[2] = new Image();
			stage[2].src = "/workspace/images/stage-three.png";

			setTimeout("Fade.fadeOut()", 3000);
		}
	},
	fadeOut: function() {
		opac = (opac - 10);
		img.style.opacity = (opac / 100);
		img.style.filter = "alpha(opacity=" + opac + ")";
		if(opac == 90) {
			int = setInterval("Fade.fadeOut()", 50);
		} else if(opac == 0) {
			clearInterval(int);
			Fade.switchImage(img);
		}
	},
	fadeIn: function() {
		opac = (opac + 20);
		img.style.opacity = (opac / 100);
		img.style.filter = "alpha(opacity=" + opac + ")";
		if(opac == 20) {
			int = setInterval("Fade.fadeIn()", 50);
		} else if(opac == 100) {
			clearInterval(int);
			setTimeout("Fade.fadeOut()", 5000);
		}
	},
	switchImage: function() {
		rotate++;
		if(rotate == stage.length) {
			rotate = 0;
		}
		img.src = stage[rotate].src;
		Fade.fadeIn();
	}
}
var Nav = {
	initialize: function() {

	},
	swapin: function() {
		if(this.id == "home") {
			document.getElementById("nav").style.backgroundPosition = "100% -190px";
		}
		if(this.id == "services" || this.id == "services active") {
			document.getElementById("nav").style.backgroundPosition = "100% -380px";
		}
		if(this.id == "portfolio" || this.id == "portfolio active") {
			document.getElementById("nav").style.backgroundPosition = "100% -570px";
		}
		if(this.id == "resources" || this.id == "resources active") {
			document.getElementById("nav").style.backgroundPosition = "100% -760px";
		}
		if(this.id == "contact" || this.id == "contact active") {
			document.getElementById("nav").style.backgroundPosition = "100% -950px";
		}
	},
	swapout: function() {
			document.getElementById("nav").style.backgroundPosition = "100% 0";
	}
}
