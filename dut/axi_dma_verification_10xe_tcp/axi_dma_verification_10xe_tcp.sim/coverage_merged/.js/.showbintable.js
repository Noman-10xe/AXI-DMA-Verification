var coll1 = document.getElementsByClassName("bintable1");
var i;

for (i = 0; i < coll1.length; i++) {
  coll1[i].addEventListener("click", function() {
    this.classList.toggle("bintableactive1");
    var content = this.nextElementSibling;
    if (content.style.maxHeight){
      content.style.maxHeight = null;
    } else {
      content.style.maxHeight = content.scrollHeight + "px";
    }
  });
}


var coll2 = document.getElementsByClassName("bintable2");

for (i = 0; i < coll2.length; i++) {
  coll2[i].addEventListener("click", function() {
    this.classList.toggle("bintableactive2");
    var content = this.nextElementSibling;
    if (content.style.maxHeight){
      content.style.maxHeight = null;
    } else {
      content.style.maxHeight = content.scrollHeight + "px";
    }
  });
}


var coll3 = document.getElementsByClassName("bintable3");

for (i = 0; i < coll3.length; i++) {
  coll3[i].addEventListener("click", function() {
    this.classList.toggle("bintableactive3");
    var content = this.nextElementSibling;
    if (content.style.maxHeight){
      content.style.maxHeight = null;
    } else {
      content.style.maxHeight = content.scrollHeight + "px";
    }
  });
}

