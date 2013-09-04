# This is the main asset package file for the project
# Other coffeescript files can be included by using 
# the below calls (remove the underscores):
#= _require filename
#= _require_tree dir
#= require_tree .

onPageinit = ->

onScript = ->

	color = ->
		r = Math.random() * 255
		g = Math.random() * 255
		b = Math.random() * 255
		r = r.toFixed(0)
		g = g.toFixed(0)
		b = b.toFixed(0)
		return [r,g,b]


	hideSplash = ->
		clearTimeout(@falseSplash);
		$.mobile.changePage "#controls", { transition: "slideup" }
		console.log "Bu!"
	@falseSplash = setTimeout(hideSplash, 1000)

	socket = io.connect(window.location.href)

	pos_x = []
	pos_y = []

	x_sum = 0.0
	y_sum = 0.0
	temp_x = 0
	temp_y = 0
	fix = 10
	flag = 0

	ball   = document.querySelector '.ball'
	garden = document.querySelector '.garden'
	output = document.querySelector '.output'
	count = document.querySelector '.count'

	maxX = garden.clientWidth  - ball.clientWidth
	maxY = garden.clientHeight - ball.clientHeight

	$("a.arriba").on('taphold', ->
		socket.emit 'web:forward', {}
	).on('tap', ->
		socket.emit 'web:stop', {}
	)

	$("a.der").on 'tap', ->
		socket.emit 'web:right', {}
	
	$("a.izq").on 'tap', ->
		socket.emit 'web:left', {}
	
	$("a.color").on 'tap', ->
		rgb = color()

		socket.emit 'web:color', {'color': rgb}	

	handleOrientation = (event) ->
		x = event.beta  # In degree in the range [-180,180]
		y = event.gamma # In degree in the range [-90,90]
		#console.log x
		temp_x = x if temp_x is 0 
		temp_y = y if temp_y is 0 

		pos_x.push(x)
		#console.log pos_x.length
		if pos_x.length is 20
			for num in pos_x
				promedio += num
				#console.log promedio
			promedio = promedio / 100
			pos_x = []
			console.log "El promedio es:" + promedio

		if not ( (temp_x+5) > (x-0) > (temp_x-5) )
			temp_x = x.toFixed(0) - 0
			x = temp_x	

			if(x > 0)
				x = 0
			if(x < -90)
				x = -90 
			x += 90

			if x < 50 and flag is 0
				flag = 1
				socket.emit 'web:forward', {}
			else if flag is 1
				flag = 0
				socket.emit 'web:stop', {}
			
			output.innerHTML = "beta : " + x + "\n"
			ball.style.top  = (maxX*x/180 - 10) + "px"
				#pos_x.push(temp_x)
		
		if not( (temp_y+3) > (y.toFixed(0)-0) > (temp_y-3) )
			temp_y = y.toFixed(0) - 0
			y = temp_y
			count.innerHTML = "gamma: " + y + "\n"
			y += 90
			ball.style.left = (maxY*y/180 - 10) + "px"
			#pos_y.push(temp_y)

		return

	#window.addEventListener("deviceorientation", handleOrientation, true)
	return

$(document).on 'ready', onScript
$(document).on 'pageinit', onPageinit


