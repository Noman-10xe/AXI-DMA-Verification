// When the user scrolls the page, execute myFunction
window.onscroll = function() {mysticky()};

// Get the navbar
var grpheader = document.getElementById("grpheader");

// Get the offset position of the navbar
var sticky = grpheader.offsetTop;

// Add the sticky class to the navbar when you reach its scroll position. Remove "sticky" when you leave the scroll position
function mysticky() {
  if (window.pageYOffset >= sticky) {
    grpheader.classList.add("sticky")
  } else {
    grpheader.classList.remove("sticky");
  }
} 
