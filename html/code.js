$(function () {
    
    function display(bool) {
        if (bool) {
            $("#cardiv").show();
        } else {
            $("#cardiv").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
        if(item.type === "lock") {
            if (item.seat == "-1") {
                var element = document.getElementById("driver");
                element.classList.add("btnlock");
            } else if (item.seat == "0") {
                var element = document.getElementById("passenger0");
                element.classList.add("btnlock");
            } else if (item.seat == "1") {
                var element = document.getElementById("passenger1");
                element.classList.add("btnlock");
            } else if (item.seat == "2") {
                var element = document.getElementById("passenger2");
                element.classList.add("btnlock");
            }
        }
    })

    document.onkeyup = function (data) {  
        if (data.which == 27) {
            $.post('http://alttab_seats/exit', JSON.stringify({}));
        } 
        else if (data.which == 8) {
            $.post('http://alttab_seats/exit', JSON.stringify({}));
        }
    }

    $("#driver").click(function () {
        $.post('http://alttab_seats/switch', JSON.stringify({
            seat: "-1"
        }))
        return
    })

    $("#passenger0").click(function () {
        $.post('http://alttab_seats/switch', JSON.stringify({
            seat: "0"
        }))
        return
    })

    $("#passenger1").click(function () {
        $.post('http://alttab_seats/switch', JSON.stringify({
            seat: "1"
        }))
        return
    })

    $("#passenger2").click(function () {
        $.post("http://alttab_seats/switch", JSON.stringify({
            seat: "2"
        }))
        return
    })

})