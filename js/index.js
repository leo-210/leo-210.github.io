const allLanguages = ["en", "fr"]
const flags = ["🇬🇧", "🇫🇷"]
let currentLanguage = "en"

function changeTheme() {
  document.body.classList.toggle("dark-mode");
}

function switchLanguage(language) {
  $("body [lang]").hide()
  $(`body [lang=${language}]`).show()

  document.documentElement.setAttribute("lang", language);
}

function onLangSwitchClick() {
  let next = allLanguages.indexOf(currentLanguage) + 1
  if (next >= allLanguages.length) next = 0

  currentLanguage = allLanguages[next]
  $(".lang-switch").text(flags[next])

  switchLanguage(currentLanguage)
}

$(document).ready(function () {
  switchLanguage("en")
})