// Multilingual helpers
//
// Select the language with `--input lang=en`; Chinese (`zh`) is the default.
//
// Use `t` for ordinary bilingual content:
//   #t[English text][中文文本]
//
// Use `tlink` when a link keeps the same URL but has bilingual labels:
//   #tlink("https://example.com", "English label", "中文标签")
//
// Use `tdict` for values referenced multiple times inside a bilingual block.
// Read an entry with `r`; wrap bilingual entries with `t-value`:
//   #tdict((
//     repo: link("https://example.com", "repo"),
//     author: t-value("English name", "中文名"),
//   ))[English body: #r("repo"), #r("author")][中文正文：#r("repo")、#r("author")]
//
// `r` is only valid inside the corresponding `tdict` body.
//
// Use `inline-icon` to align an icon with surrounding text. Pass `href` to
// make the icon itself clickable:
//   #inline-icon(fa-code-pull-request())
//   #inline-icon(fa-github(), href: "https://github.com/example")

#let current-lang = sys.inputs.at("lang", default: "zh")
#let current-zh = current-lang == "zh"

// Bilingual text helper - use content blocks: t[English][中文]
#let t(en, zh_text) = if current-zh { zh_text } else { en }

#let t-value(en, zh_text) = (en: en, zh: zh_text)
#let tlink(url, en, zh_text) = t-value(link(url, en), link(url, zh_text))

#let tdict-stack = state("tdict-stack", ())

#let r(key) = context {
  let stack = tdict-stack.get()
  if stack.len() == 0 {
    panic("r used outside tdict: " + key)
  }

  let value = stack.last().at(key, default: none)
  if value == none {
    panic("missing tdict key: " + key)
  }

  if type(value) == dictionary and value.keys().contains("en") and value.keys().contains("zh") {
    if current-zh { value.zh } else { value.en }
  } else {
    value
  }
}

#let tdict(dict, en, zh_text) = {
  tdict-stack.update(stack => stack + (dict,))
  if current-zh { zh_text } else { en }
  tdict-stack.update(stack => stack.slice(0, stack.len() - 1))
}

#let inline-icon(icon, href: none) = {
  let icon = box(height: 0pt, move(dy: 0pt, scale(95%, reflow: true, icon)))
  if href == none { icon } else { box(height: 0pt, link(href, box(height: 1em, icon))) }
}
