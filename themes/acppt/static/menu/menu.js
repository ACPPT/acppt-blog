function createNavbar() {
    /* Create the navbar node and fill it with the logo and elements */
    const navbarWrapper = document.createElement("details");
    navbarWrapper.id = "navbar-wrapper";
    navbarWrapper.open = true;
    /* Hamburger menu */
    const hamburgerSummary = document.createElement("summary");
    hamburgerSummary.id = "hamburger";
    const hamburgerIcon = document.createElement("div");
    hamburgerIcon.id = "hamburger-icon";
    const hamburgerIconLines = document.createElement("span");
    hamburgerIconLines.id = "hamburger-icon-lines";
    hamburgerIcon.appendChild(hamburgerIconLines); 
    hamburgerSummary.appendChild(hamburgerIcon);
    navbarWrapper.appendChild(hamburgerSummary);
    /* Navbar */
    const navbar = document.createElement("nav");
    navbar.id = "navbar";
    navbarWrapper.appendChild(navbar);
    /* Logo */
    const logo = document.createElement("div");
    logo.id = "logo-wrapper";
    const logoLink = document.createElement("a");
    logoLink.id = "logo-link";
    logoLink.href = NAVBAR.logo.href;
    const logoImg = document.createElement("img");
    logoImg.id = "logo-img";
    logoImg.src = NAVBAR.logo.src;
    logoImg.alt = NAVBAR.logo.alt;
    logoLink.appendChild(logoImg);
    logo.appendChild(logoLink);
    navbar.appendChild(logo);
    /* Elements */
    const elements = document.createElement("div");
    elements.id = "menu-wrapper";
    const elementsList = document.createElement("ul");
    elementsList.id = "menu-list";
    NAVBAR.elements.forEach(element => {
        const elementItem = document.createElement("li");
        if (!element.subElements) {
            const elementLink = document.createElement("a");
            elementLink.href = element.href;
            elementLink.textContent = element.label;
            elementItem.appendChild(elementLink);
        } else {
            const details = document.createElement("details");
            const summary = document.createElement("summary");
            summary.textContent = element.label;
            const subElementsList = document.createElement("ul");
            element.subElements.forEach(subElement => {
                const subElementItem = document.createElement("li");
                const subElementLink = document.createElement("a");
                subElementLink.href = subElement.href;
                subElementLink.textContent = subElement.label;
                subElementItem.appendChild(subElementLink);
                subElementsList.appendChild(subElementItem);
            });
            details.appendChild(summary);
            details.appendChild(subElementsList);
            elementItem.appendChild(details);
        }
        elementsList.appendChild(elementItem);
    });
    elements.appendChild(elementsList);
    navbar.appendChild(elements);
    return navbarWrapper;
}

/* Close details when clicking outside of it */
function closeDetailsOnClick() {
    const navbarWrapper = document.getElementById("navbar-wrapper");
    // Subelements
    const subelementsDetails = navbarWrapper.querySelectorAll("details");
    subelementsDetails.forEach(detail => {
        if (detail.hasAttribute("open")) {
            detail.removeAttribute("open");
        }
    });
    // Hamburger menu when width is lower than 950px
    if (window.innerWidth <= 950 && navbarWrapper.hasAttribute("open")) {
        navbarWrapper.removeAttribute("open");
    }
}
document.addEventListener("click", closeDetailsOnClick);

/* Close menu when width is lower than 950px */
function toggleMenuResponsively() {
    console.log("Window width: " + window.innerWidth);
    const navbarWrapper = document.getElementById("navbar-wrapper");
    if (window.innerWidth <= 950) {
        navbarWrapper.removeAttribute("open");
    } else {
        navbarWrapper.setAttribute("open", "true");
    }
}
window.addEventListener("resize", toggleMenuResponsively);

/* Append the navbar to the body when the page is loaded */
document.addEventListener("DOMContentLoaded", () => {
    if (!NAVBAR) {
        console.error("No NAVBAR data found");
        return;
    }
    const navbar = createNavbar();
    const header = document.getElementById("header");
    header.appendChild(navbar);
    toggleMenuResponsively();
});
