#import "@preview/finely-crafted-cv:0.3.0": company-heading, job-heading, resume

// adopted from: https://github.com/swaits-typst-packages/finely-crafted-cv/blob/main/src/constants.typ
#let SECTION_HEADING_SIZE = 0.7em
#let SECTION_HEADING_WEIGHT = "bold"
#let SECTION_HEADING_HRULE_STROKE = 0.75pt + black.lighten(25%)
#let SECTION_HEADING_SPACE_ABOVE = 1em
#let SECTION_HEADING_SPACE_BELOW = 0.5em

#let hrule(stroke: 1pt + black) = block(
  above: 0.5em,
  below: 0em,
  breakable: false,
  line(length: 100%, stroke: stroke),
)

#let resume-template(
  lang: none,
  last-updated: none,
  ..args,
) = {
  let body = args.pos().first()
  let name = args.named().at("name", default: none)

  show regex("Last updated: [A-Za-z]+ [0-9]+, [0-9]+"): [
    Last updated: #last-updated.display("[month repr:long] [day], [year]")
  ]

  if lang != none { set text(lang: lang) }
  show link: underline
  set list(spacing: 0.8em, marker: (text(font: "Arial")[•], [‣], [–]))

  show: resume.with(..args.named())

  set heading(numbering: none)
  show heading.where(level: 1): it => block(
    above: SECTION_HEADING_SPACE_ABOVE,
    below: SECTION_HEADING_SPACE_BELOW,
    breakable: false,
  )[
    #text(size: SECTION_HEADING_SIZE, weight: SECTION_HEADING_WEIGHT)[#upper(it.body)]
    #hrule(stroke: SECTION_HEADING_HRULE_STROKE)
  ]

  body
}

#let project-heading(name, url, keywords, ..args) = job-heading(
  [#link(url, name) #math.bar.v.double _ #keywords _],
  ..args,
)

#let school-heading(name, start: none, end: none, icon: none, aside: none, body) = {
  company-heading(name, start: start, end: end, icon: icon)[
    #if aside == none {
      body
    } else {
      grid(
        columns: (1fr, auto),
        column-gutter: 1em,
        align: (left + top, right + top),
        body, box(aside),
      )
    }
  ]
}
