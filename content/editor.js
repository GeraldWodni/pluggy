function $id(id) { return document.getElementById(id); }
$id("save").addEventListener("click", function() {
    var filename = $id("filename").value;
    var content = $id("editor").value;
    fetch( "/files/save/" + filename, {
        method: "POST",
        body: content
    })
    .then(function(){ alert("File saved")})
    .catch(function() { alert("Error saving file")})
});
