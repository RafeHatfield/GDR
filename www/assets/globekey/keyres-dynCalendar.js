/**
* Filename.......: dyncalendar.js
* Project........: Popup Calendar
* Last Modified..: $Date: 2002/07/22 18:17:05 $
* CVS Revision...: $Revision: 1.2 $
* Copyright......: 2001, 2002 Richard Heyes
*/

/*
* Global variables
*/
  dynCalendar_layers          = new Array();
  dynCalendar_mouseoverStatus = 0;
  dynCalendar_mouseX          = 0;
  dynCalendar_mouseY          = 0;
  var snifferLoaded;

/*
* The calendar constructor
*
* @access public
* @param string objName      Name of the object that you create
* @param string callbackFunc Name of the callback function
* @param string OPTIONAL     Optional layer name
* @param string OPTIONAL     Optional images path
*/
  function dynCalendar(objName, callbackFunc, numberYears, formName, imgDir)
  {
    // Properties
    this.today          = new Date();
    this.date           = this.today.getDate();
    this.month          = this.today.getMonth();
    this.year           = this.today.getFullYear();

    this.objName        = objName; // used for callback
    this.formName       = formName;
    this.callbackFunc   = callbackFunc; // name of the callback function
    this.imagesPath     = imgDir; // change if images are on different directory
    this.layerID        = 'dynCalendar_layer_' + dynCalendar_layers.length;

    this.offsetX        = 5;
    this.offsetY        = 5;

    this.useMonthCombo  = 1; // set to '0' for text only
    this.useYearCombo   = 1; // set to '0' for text only
    this.yearComboRange = numberYears-1;

    this.currentMonth   = this.month;
    this.currentYear    = this.year;

    // Public Methods
    this.show              = dynCalendar_show;
    this.writeHTML         = dynCalendar_writeHTML;

    // Accessor methods
    this.setOffset         = dynCalendar_setOffset;
    this.setOffsetX        = dynCalendar_setOffsetX;
    this.setOffsetY        = dynCalendar_setOffsetY;
    this.setImagesPath     = dynCalendar_setImagesPath;
    this.setMonthCombo     = dynCalendar_setMonthCombo;
    this.setYearCombo      = dynCalendar_setYearCombo;
    this.setCurrentMonth   = dynCalendar_setCurrentMonth;
    this.setCurrentYear    = dynCalendar_setCurrentYear;
    this.setYearComboRange = dynCalendar_setYearComboRange;

    // Layer manipulation
    this._getLayer         = dynCalendar_getLayer;
    this._hideLayer        = dynCalendar_hideLayer;
    this._showLayer        = dynCalendar_showLayer;
    this._setLayerPosition = dynCalendar_setLayerPosition;
    this._setHTML          = dynCalendar_setHTML;

    // Miscellaneous
    this._getDaysInMonth   = dynCalendar_getDaysInMonth;
    this._mouseover        = dynCalendar_mouseover;

    // Constructor type code
    dynCalendar_layers[dynCalendar_layers.length] = this;

    // Action only if browserSniffer.js has been loaded
    if(snifferLoaded)
    {
      if(arguments[5]!='opt')
        this.writeHTML();
    }
  }

/**
* Shows the calendar, or updates the layer if already visible.
*
* @access public
* @param integer month Optional month number (0-11)
* @param integer year  Optional year (YYYY format)
*/
  function dynCalendar_show()
  {
    // Variable declarations to prevent globalisation
    var month, year;
    var monthnames, numdays, thisMonth, firstOfMonth;
    var ret, row, i, cssClass, linkHTML, previousMonth, previousYear;
    var nextMonth, nextYear, prevImgHTML, prevLinkHTML, nextImgHTML, nextLinkHTML;
    var monthComboOptions, monthCombo, yearComboOptions, yearCombo, yearLink, html;

    // Get the selected month and year
    if (this.objName == 'calendarArrive') {
      this.currentDay = document.forms[this.formName].fd.selectedIndex;
      this.currentMonth = document.forms[this.formName].fm.selectedIndex;
      this.currentYear = document.forms[this.formName].fy.options[document.forms[this.formName].fy.selectedIndex].text;
    } else if (this.objName == 'calendarDepart') {
      this.currentDay = document.forms[this.formName].td.selectedIndex;
      this.currentMonth = document.forms[this.formName].tm.selectedIndex;
      this.currentYear = document.forms[this.formName].ty.options[document.forms[this.formName].ty.selectedIndex].text;
    }

    this.currentMonth = month = arguments[0] != null ? arguments[0] : this.currentMonth;
    this.currentYear  = year  = arguments[1] != null ? arguments[1] : this.currentYear;

    monthnames = new Array('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');
    numdays    = this._getDaysInMonth(month, year);

    thisMonth    = new Date(year, month, 1);
    firstOfMonth = thisMonth.getDay();

    // First few blanks up to first day
    ret = new Array(new Array());
    for(i=0; i<firstOfMonth; i++){
      ret[0][ret[0].length] = '<td>&nbsp;</td>';
    }

    // Main body of calendar
    row = 0;
    i   = 1;
    while(i <= numdays){
      if(ret[row].length == 7){
        ret[++row] = new Array();
      }
      cssClass = (i == this.date && month == this.month && year == this.year) ? 'dynCalendar_today' : 'dynCalendar_day';
      // Diable link if date before current date
      if(new Date(year,month,i+1) < this.today) {
        linkHTML = i++;
      // Highlight current date
      }else if(i == this.currentDay+1) {
        linkHTML = '<a class="dynlinks" href="javascript: '+ this.callbackFunc +'('+ i +', '+ (Number(month) + 1) +', '+ year +', \''+ this.objName +'\', \''+ this.formName +'\'); '+ this.objName +'._hideLayer()" onMouseOver="window.status=\''+ i +' '+ monthnames[Number(month)] +' '+ year +'\'; return true" onMouseOut="window.status=\'\'; return true"><font color=red>' + (i++) + '</font></a>';
      }else{
        linkHTML = '<a class="dynlinks" href="javascript: '+ this.callbackFunc +'('+ i +', '+ (Number(month) + 1) +', '+ year +', \''+ this.objName +'\', \''+ this.formName +'\'); '+ this.objName +'._hideLayer()" onMouseOver="window.status=\''+ i +' '+ monthnames[Number(month)] +' '+ year +'\'; return true" onMouseOut="window.status=\'\'; return true">' + (i++) + '</a>';
      }
      ret[row][ret[row].length] = '<td align="center" class="' + cssClass + '">' + linkHTML + '</td>';
    }

    // Format the HTML
    for(i=0; i<ret.length; i++){
      ret[i] = ret[i].join('\n') + '\n';
    }

    // Set month & year prevImgHTML link
    previousYear  = thisMonth.getFullYear();
    previousMonth = thisMonth.getMonth() - 1;
    if(previousMonth < 0){
      previousMonth = 11;
      previousYear--;
    }
    nextYear  = thisMonth.getFullYear();
    nextMonth = thisMonth.getMonth() + 1;
    if(nextMonth > 11){
      nextMonth = 0;
      nextYear++;
    }

    // Set previous month and next month image link
    if(thisMonth > new Date(this.year,this.month,1)) {
      prevImgHTML  = '<img src="' + this.imagesPath + '/prev.gif" alt="' + monthnames[previousMonth] + ' ' + previousYear + '" border="0" />';
    }else{
      prevImgHTML  = '';
    }
    if(previousYear >= this.year){
      prevLinkHTML = '<a href="javascript: ' + this.objName + '.show(' + previousMonth + ', ' + previousYear + ')" onMouseOver="window.status=\'Previous Month\'; return true" onMouseOut="window.status=\'\'; return true">' + prevImgHTML + '</a>';
    }else{
      prevLinkHTML = '';
    }

    nextImgHTML  = '<img src="' + this.imagesPath + '/next.gif" alt="' + monthnames[nextMonth] + ' ' + nextYear + '" border="0" />';
    if(nextYear <= (this.year + this.yearComboRange)){
      nextLinkHTML = '<a href="javascript: ' + this.objName + '.show(' + nextMonth + ', ' + nextYear + ')" onMouseOver="window.status=\'Next Month\'; return true" onMouseOut="window.status=\'\'; return true">' + nextImgHTML + '</a>';
    }else{
      nextLinkHTML = '';
    }
    // Build month combo
    if (this.useMonthCombo) {
      monthComboOptions = '';
      for (i=0; i<12; i++) {
        selected = (i == thisMonth.getMonth() ? 'selected="selected"' : '');
        monthComboOptions += '<option value="' + i + '" ' + selected + '>' + monthnames[i] + '</option>';
      }
      monthCombo = '<select class="dynCalendar_select" name="months" onchange="' + this.objName + '.show(this.options[this.selectedIndex].value, ' + this.objName + '.currentYear)">' + monthComboOptions + '</select>';
    } else {
      monthCombo = monthnames[thisMonth.getMonth()];
    }

    // Build year combo
    if (this.useYearCombo) {
      yearComboOptions = '';
      //for (i = thisMonth.getFullYear() ; i <= (thisMonth.getFullYear() + this.yearComboRange); i++) {
      for (i = curYear ; i <= (curYear + this.yearComboRange); i++) {
        selected = (i == thisMonth.getFullYear() ? 'selected="selected"' : '');
        yearComboOptions += '<option value="' + i + '" ' + selected + '>' + i + '</option>';
      }
      yearCombo = '<select class="dynCalendar_select" style="border: 1px groove" name="years" onchange="' + this.objName + '.show(' + this.objName + '.currentMonth, this.options[this.selectedIndex].value)">' + yearComboOptions + '</select>';
     }

    // Link for years
    yearLink = thisMonth.getFullYear();

    html = '';
    //html += "year:"+year+" month:"+ month+" this.year:"+this.year+" this.month:"+this.month;
    html += '<table border="0" bgcolor="#eeeeee" width="200" style="border-collapse: collapse">';
    html += '<tr><td class="dynCalendar_header">&nbsp;' + prevLinkHTML + '</td><td colspan="5" align="center" class="dynCalendar_header" NOWRAP>' + monthCombo + ' ' + yearCombo + '</td><td align="right" class="dynCalendar_header">' + nextLinkHTML + '&nbsp;</td></tr>';
    html += '<tr>';
    html += '<td class="dynCalendar_dayname" width="14%">Sun</td>';
    html += '<td class="dynCalendar_dayname" width="15%">Mon</td>';
    html += '<td class="dynCalendar_dayname" width="14%">Tue</td>';
    html += '<td class="dynCalendar_dayname" width="14%">Wed</td>';
    html += '<td class="dynCalendar_dayname" width="14%">Thu</td>';
    html += '<td class="dynCalendar_dayname" width="15%">Fri</td>';
    html += '<td class="dynCalendar_dayname" width="14%">Sat</td></tr>';
    html += '<tr>' + ret.join('</tr>\n<tr>') + '</tr>';
    html += '</table>';
    html += '<table border="0" bgcolor="#eeeeee" width="200" style="border-collapse: collapse">';
    html += '<tr>';
    // Set link to last year
    html += '<td align="center" class="dynCalendar_dayname" width="33%">';
    if(yearLink-1 >= this.year){
      html += '<a href="javascript: ' + this.objName + '.show(' + this.month + ', ' + (yearLink - 1) + ')" onMouseOver="window.status=\'Previous Year\'; return true" onMouseOut="window.status=\'\'; return true">';
      html += '<b>&lt;&lt;</b> ';
      html += yearLink - 1 ;
      html += '</a>';
    }else{
      html += yearLink - 1;
    }
    html += '</td>';
    // Set link to current date
    html += '<td width="33%" class="dynCalendar_dayname" align="center">';
    html += '<a class="dynlinks" href="javascript: ' + this.objName + '.show(' + this.month + ', ' + this.year + ')" onMouseOver="window.status=\'Current Date\'; return true" onMouseOut="window.status=\'\'; return true">';
    html += 'Today';
    html += '</a>';
    html += '</td>';
    // Set link to next year
    html += '<td align="center" class="dynCalendar_dayname">';
    if(yearLink+1 <= (this.year + this.yearComboRange)){
      html += '<a class="dynlinks" href="javascript: ' + this.objName + '.show(' + this.month + ', ' + (yearLink + 1) + ')" onMouseOver="window.status=\'Next Year\'; return true" onMouseOut="window.status=\'\'; return true">';
      html += yearLink + 1;
      html += ' <b>&gt;&gt;</b> ';
      html += '</a>';
    }else{
      html += yearLink + 1;
    }
    html += '</td>';
    html += '</tr>';
    html += '</table>';

    this._setHTML(html);
    if (!arguments[0] && !arguments[1]) {
      this._showLayer();
      this._setLayerPosition();
    }
  }

/**
* Writes HTML to document for layer
*
* @access public
*/
  function dynCalendar_writeHTML()
  {
    //if (is_ie5up || is_nav6up || is_gecko)
    {
    var foo = '<a href="javascript: ' + this.objName + '.show()">';
      foo += '<img src="' + this.imagesPath + 'dynCalendar.gif" border="0" width="16" height="16" ';
      foo += 'onMouseOver="window.status=\'Set Dates\'; return true" ';
      foo += 'onMouseOut="window.status=\'\'; return true" id="'+this.layerID+'_icon"/>';
      foo += '</a>';
      
      //################################################################################
      // Fixed 13/03/2009 by Oh (Move this section to function at bottom of this file)
      //################################################################################
      //foo += '<div class="dynCalendar" id="' + this.layerID + '" ';
      //foo += 'onmouseover="' + this.objName + '._mouseover(true)" ';
      //foo += 'onmouseout="' + this.objName + '._mouseover(false)"></div>';
      //################################################################################
      
      if(arguments[0]=='opt')
        return foo;
      else
        document.write(foo);
    }
  }

/**
* Sets the offset to the mouse position
* that the calendar appears at.
*
* @access public
* @param integer Xoffset Number of pixels for vertical
*                        offset from mouse position
* @param integer Yoffset Number of pixels for horizontal
*                        offset from mouse position
*/
  function dynCalendar_setOffset(Xoffset, Yoffset)
  {
    this.setOffsetX(Xoffset);
    this.setOffsetY(Yoffset);
  }

/**
* Sets the X offset to the mouse position
* that the calendar appears at.
*
* @access public
* @param integer Xoffset Number of pixels for horizontal
*                        offset from mouse position
*/
  function dynCalendar_setOffsetX(Xoffset)
  {
    this.offsetX = Xoffset;
  }

/**
* Sets the Y offset to the mouse position
* that the calendar appears at.
*
* @access public
* @param integer Yoffset Number of pixels for vertical
*                        offset from mouse position
*/
  function dynCalendar_setOffsetY(Yoffset)
  {
    this.offsetY = Yoffset;
  }

/**
* Sets the images path
*
* @access public
* @param string path Path to use for images
*/
  function dynCalendar_setImagesPath(path)
  {
    this.imagesPath = path;
  }

/**
* Turns on/off the month dropdown
*
* @access public
* @param boolean useMonthCombo Whether to use month dropdown or not
*/
  function dynCalendar_setMonthCombo(useMonthCombo)
  {
    this.useMonthCombo = useMonthCombo;
  }

/**
* Turns on/off the year dropdown
*
* @access public
* @param boolean useYearCombo Whether to use year dropdown or not
*/
  function dynCalendar_setYearCombo(useYearCombo)
  {
    this.useYearCombo = useYearCombo;
  }

/**
* Sets the current month being displayed
*
* @access public
* @param boolean month The month to set the current month to
*/
  function dynCalendar_setCurrentMonth(month)
  {
    this.currentMonth = month;
  }

/**
* Sets the current year being displayed
*
* @access public
* @param boolean year The year to set the current year to
*/
  function dynCalendar_setCurrentYear(year)
  {
    this.currentYear = year;
  }

/**
* Sets the range of the year combo. Displays this number of
* years either side of the year being displayed.
*
* @access public
* @param integer range The range to set
*/
  function dynCalendar_setYearComboRange(range)
  {
    this.yearComboRange = range;
  }

/**
* Returns the layer object
*
* @access private
*/
  function dynCalendar_getLayer()
  {
    var layerID = this.layerID;

    if (document.getElementById(layerID)) {

      return document.getElementById(layerID);

    } else if (document.all(layerID)) {
      return document.all(layerID);
    }
  }

/**
* Hides the calendar layer
*
* @access private
*/
  function dynCalendar_hideLayer()
  {
    this._getLayer().style.visibility = 'hidden';
  }

/**
* Shows the calendar layer
*
* @access private
*/
  function dynCalendar_showLayer()
  {
    this._getLayer().style.visibility = 'visible';
  }

/**
* Sets the layers position
*
* @access private
*/
  function dynCalendar_setLayerPosition()
  {
    //this._getLayer().style.top  = (dynCalendar_mouseY + this.offsetY) + 'px';
    //this._getLayer().style.left = (dynCalendar_mouseX + this.offsetX) + 'px';
    
    //################################################################################
    // Fixed 13/03/2009 by Oh
    //################################################################################
    var p = _dynCalendar_FindPos( document.getElementById( this.layerID+'_icon' ) );
    dynCalendar_mouseX = p.x;
    dynCalendar_mouseY = p.y;
    
    this._getLayer().style.top  = (dynCalendar_mouseY + this.offsetY) + 'px';
    this._getLayer().style.left = (dynCalendar_mouseX + this.offsetX) + 'px';
		this._getLayer().style.position = 'absolute';
		this._getLayer().style.zIndex = '1000';
		//################################################################################
  }

/**
* Sets the innerHTML attribute of the layer
*
* @access private
*/
  function dynCalendar_setHTML(html)
  {
    this._getLayer().innerHTML = html;
  }

/**
* Returns number of days in the supplied month
*
* @access private
* @param integer month The month to get number of days in
* @param integer year  The year of the month in question
*/
  function dynCalendar_getDaysInMonth(month, year)
  {
    monthdays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month != 1) {
      return monthdays[month];
    } else {
      return ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0 ? 29 : 28);
    }
  }

/**
* onMouse(Over|Out) event handler
*
* @access private
* @param boolean status Whether the mouse is over the
*                       calendar or not
*/
  function dynCalendar_mouseover(status)
  {
    dynCalendar_mouseoverStatus = status;
    return true;
  }


// Action only if browserSniffer.js has been loaded
if(snifferLoaded == 1) {
  /**
  * onMouseMove event handler
  */
  //################################################################################
  // Layer Bug Fixed 13/03/2009 By Oh  (Not use this section)
  //################################################################################
  /* 
  dynCalendar_oldOnmousemove = document.onmousemove ? document.onmousemove : new Function;

  document.onmousemove = function ()
  {
    //if (is_ie5up || is_nav6up || is_gecko)
    {
      if (arguments[0]) {
        dynCalendar_mouseX = arguments[0].pageX;
        dynCalendar_mouseY = arguments[0].pageY;
      } else {
        dynCalendar_mouseX = event.clientX + document.body.scrollLeft;
        dynCalendar_mouseY = event.clientY + document.body.scrollTop;
        arguments[0] = null;
      }

      dynCalendar_oldOnmousemove();
    }
  }
  */
  //################################################################################
  
  /**
  * Callbacks for document.onclick
  */
  dynCalendar_oldOnclick = document.onclick ? document.onclick : new Function;

  document.onclick = function ()
  {
    //if (is_ie5up || is_nav6up || is_gecko)
    {
      if(!dynCalendar_mouseoverStatus){
        for(i=0; i<dynCalendar_layers.length; ++i){
          dynCalendar_layers[i]._hideLayer();
        }
      }
      dynCalendar_oldOnclick(arguments[0] ? arguments[0] : null);
    }
  }
}

//################################################################################
// Layer Bug Fixed 13/03/2009 By Oh
//################################################################################
window.onload = _dynCalendar_element;

function _dynCalendar_element()
{
  var foo = '';
  var d = document.createElement('div');
    
  for(i=0; i<dynCalendar_layers.length; ++i)
  {
    l = dynCalendar_layers[i];
    foo += '<div class="dynCalendar" id="' + l.layerID + '" ';
    foo += 'onmouseover="' + l.objName + '._mouseover(true)" ';
    foo += 'onmouseout="' + l.objName + '._mouseover(false)"></div>';
  }

  d.innerHTML = foo;
  document.body.appendChild(d);
}

function _dynCalendar_FindPos(objx)
{
  var p = {};
  
  var obj = objx;
  var curleft = 0;
  if(obj.offsetParent)
  {
    while(1) 
    {
      curleft += obj.offsetLeft;
      if(!obj.offsetParent)
        break;
      obj = obj.offsetParent;
    }
  }
  else if(obj.x)
      curleft += obj.x;
  p.x = curleft;
  
  var obj = objx;
  var curtop = 0;
  if(obj.offsetParent)
  {
    while(1)
    {
      curtop += obj.offsetTop;
      if(!obj.offsetParent)
        break;
      obj = obj.offsetParent;
    }
  }
  else if(obj.y)
      curtop += obj.y;
  p.y = curtop;
  
  return p;
}
//################################################################################
