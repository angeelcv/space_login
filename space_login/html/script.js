document.getElementById("registration-form").addEventListener("submit", function (e) {
    e.preventDefault();
    const data = {
        firstname: document.getElementById("name").value, 
        gender: document.getElementById("gender").value,
    };

    fetch(`https://${GetParentResourceName()}/submit`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(data),
    }).then(() => {
        document.getElementById("registration-menu").style.display = "none";
    });
});

window.addEventListener("message", function (event) {
    if (event.data.action === "show") {
        document.getElementById("registration-menu").style.display = "block";
    }
});
