function checkdisp(a, b) {
    var checkBox = document.getElementById(a);
    var text = document.getElementById(b);
    if (checkBox.checked == true){
        text.style.display = "block";
    } else {
       text.style.display = "none";
    }
}