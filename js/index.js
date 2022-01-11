const allLanguages = ["en", "fr"]
const flags = ["🇬🇧", "🇫🇷"]
let currentLanguage = "en"

function changeTheme() {
  document.body.classList.toggle("dark-mode");
  Cookies.set(
    "darkmode",
    document.body.classList.contains("dark-mode").toString(),
    {
      expires: 7
    }
  )
}

function switchLanguage(language) {
  $("body [lang]").hide()
  $(`body [lang=${language}]`).show()
  Cookies.set("lang", language, { expires: 7 })
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
  const lang = Cookies.get("lang")
  if (lang && allLanguages.includes(lang)) {
    switchLanguage(lang)
    currentLanguage = lang
    $(".lang-switch").text(flags[allLanguages.indexOf(currentLanguage)])
  } else {
    switchLanguage("en")
    Cookies.set("lang", "en", { expires: 7 })
  }

  if (Cookies.get("darkmode") !== "false") {
    document.body.classList.add("dark-mode")
  } else {
    document.body.classList.remove("dark-mode")
  }
})