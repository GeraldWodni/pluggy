function svgTag( tag ) {
    return document.createElementNS('http://www.w3.org/2000/svg', tag);
}

Element.prototype.attr = function( name, value ) {
    if( arguments.length == 1 )
        return this.getAttribute( name );
    else
        this.setAttribute( name, value );
    return this;
}
Element.prototype.append = function( element ) {
    this.appendChild( element );
    return this;
}
function random( min, max ) {
    return Math.random() * ( max-min ) + min;
}

var $svg = document.getElementById("bg");

function randomAnim( $elem, hueMin, hueMax, sat, light ) {
    if( Math.random() < 0.1 )
        $elem.attr( "class", "anim" )
             .attr( "style", 'animation-delay:' + random(0,10) + 's' );
    else
        $elem.attr( "style", 'fill:hsl(' + random(hueMin, hueMax) + ', ' + sat + '%, ' + light + '%)' )
}

function randomCircles() {
    for( var i = 0; i < 100; i++ ) {
        var $circle = svgTag("circle")
            .attr("cx", random( 0, 1000 ) )
            .attr("cy", random( 0, 1000 ) )
            .attr("r", random( 75, 125 ) );
        randomAnim( $circle, -90, 60, 100, 50);
        $svg.append( $circle );
    }
}

function randomGrid() {
    var count = 15, size = Math.ceil( 1000 / count );
    for( var y = 0; y < count; y++ )
        for( var x = 0; x < count; x++ )
        {
            var $rect = svgTag("rect")
                .attr( "x", x*size )
                .attr( "y", y*size )
                .attr( "width", size )
                .attr( "height", size )
            randomAnim( $rect, 180, 300, 80, 50 );
            $svg.append( $rect );
        }
}

window.addEventListener("load", function() { if(Math.random() < 0.5) randomCircles(); else randomGrid(); } );
