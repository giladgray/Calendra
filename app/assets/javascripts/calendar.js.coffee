# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
# DAYS   = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

window.MONTHS =
    January: 31
    February: 28
    March: 31
    April: 30
    May: 31
    June: 30
    July: 31
    August: 31
    September: 30
    October: 31
    November: 30
    December: 31

window.HTML =
    # HTML GENERATORS (jQuery wrappers)
	tag: (tagname, classes, body...) ->
        html = $(tagname).addClass(classes)
        html.append text for text in body
        html
	div: (classes, body...) ->
        HTML.tag "<div>", classes, body...
	span: (classes, body...) ->
        HTML.tag "<span>", classes, body...
	li: (classes, body...) ->
        HTML.tag "<li>", classes, body...
	link: (href, classes, body...) ->
        # if body array is empty then assume classes is body content
        unless body? and body.length > 0
          body = [classes] 
          classes = undefined
        HTML.tag("<a>", classes, body...).attr("href", href)
	btn: (classes, text, href=null) ->
        if href?
          HTML.link href, "btn #{classes}", text
        else
          HTML.span "btn #{classes}", text
	icon: (icon, classes) ->
        HTML.tag '<i>', "icon-#{icon} #{classes}"
# str() function returns outer HTML of tag and children as string
# and enables the HTMLpers to be used in javascript templates through
# eco's raw output tag
$.fn.str = () -> @prop('outerHTML')

monthBox = (name, days) ->
    console.log "New month #{name} has #{days} days"
    body = HTML.div('body')
    width = 100 / days
    body.append(HTML.div('day', day).css('width', width + '%')) for day in [1..days]
    HTML.div 'month', HTML.tag('<h2>', 'title', name), body

@zoomLevel = 1.0
@defaultWidth = 200

$(document).ready ->
    cal = $("#calendar")
    for name, days of MONTHS
        cal.append monthBox(name, days)

    @defaultWidth = $('.month').width()
    @zoomLevel = 1.0
    $("#zoomIn").click zoomIn
    $("#zoomOut").click zoomOut

zoomIn = (event) -> zoom event, 0.25
zoomOut = (event) -> zoom event, -0.25

zoom = (event, increase) ->
    event.preventDefault()
    @zoomLevel += increase
    console.log "zooming by #{@zoomLevel}"
    $('.month').width(@defaultWidth * @zoomLevel)
    
    $('.month').removeClass 'small tiny'
    if @zoomLevel < 1 then $('.month').addClass 'tiny'
    else if @zoomLevel < 3 then $('.month').addClass 'small'
