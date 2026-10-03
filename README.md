# Typst 中英双语简历模板

Typst [finely-crafted-cv](https://typst.app/universe/package/finely-crafted-cv/) 中英混排和多语言优化

## 项目结构

- `main.typ`：简历内容。
- `cv.typ`：对 `finely-crafted-cv` 的轻量封装及简历布局辅助函数。
- `utils.typ`：语言选择、双语内容和通用行内图标辅助函数。
- `Makefile`：统一构建和监听命令。

## 构建

安装 Typst 后运行：

```sh
make
```

持续监听并自动编译：

```sh
make watch
```

也可以直接调用 Typst：

```sh
typst compile main.typ output.pdf
typst compile --input lang=en main.typ output-en.pdf
```

默认生成中文版，传入 `--input lang=en` 可生成英文版。

## 文档结构

所有简历内容应放在 `main.typ` 中。一个最小文档结构如下：

```typst
#import "@preview/fontawesome:0.6.0": *
#import "utils.typ": *
#import "cv.typ": *

#show: resume-template.with(
  lang: current-lang,
  last-updated: datetime(year: 2026, month: 1, day: 1),
  name: "Your Name 姓名",
  tagline: t[Short professional summary.][简短的职业简介。],
  icon-contact-header: (
    (fa-envelope-square(), link("mailto:name@example.com", "name@example.com")),
    (fa-github(), link("https://github.com/example", "example")),
  ),
  body-font: "Noto Serif CJK SC",
  heading-font: ("Libertinus Serif", "Noto Serif CJK SC"),
)

#v(1em)
- #t[First line of professional highlights.][第一行职业亮点。]
- #t[Second line of professional highlights.][第二行职业亮点。]
- #t[Third line of professional highlights.][第三行职业亮点。]

= #fa-industry() #t[Experience][工作经历]

#company-heading("Example Company", start: "2024", end: t[Present][至今])[
  #job-heading(t[Software Engineer][软件工程师], location: t[City][城市])[
    - #t[Describe an outcome and its impact.][描述成果及其影响。]
  ]
]

= #fa-laptop-code() #t[Projects][项目]

#project-heading(
  "Example Project",
  "https://example.com",
  "Typst, Tooling",
  start: "2024",
)[
  - #t[Describe the project briefly.][简要描述项目。]
]

= #fa-building-columns() #t[Education][教育经历]

#school-heading(t[Example University][示例大学], start: "2020", end: "2024")[
  #t[B.S. in Example Major][示例专业学士] \
  _助教经历：2024秋 - 数据库原理（*优秀*）；2025春 - 操作系统；2025秋 - C语言程序设计导论_
]
```

`utils.typ` 提供以下辅助函数：

- `t[English][中文]`：编写普通双语内容。
- `tlink(url, English, 中文)`：为同一个 URL 提供双语标签。
- `tdict(...)` 和 `r(...)`：在较长的双语内容块中复用值。
- `t-value(English, 中文)`：在 `tdict` 中保存双语值。
- `inline-icon(icon, href: none)`：让图标与文字行内对齐，并可选添加链接。

完整示例见 `utils.typ` 顶部的注释。

## 中英混排字体建议

Typst 会优先使用字体元组中的第一个可用字体，并依次回退到后续字体。推荐使用以下衬线字体组合：

- **标题字体**：`"Libertinus Serif", "Noto Serif CJK SC"`
- **正文字体**：`Noto Serif CJK SC`
- **强调或斜体替代字体**：`"Libertinus Serif", "Kaiti SC"`
- **小型大写样式（`smallcaps`）字体**：`"Libertinus Serif", "STKaiti"`，注意 `smallcaps` 被默认用于姓名（`name`）因此需加入中文字体。

在 `main.typ` 中配置：

```typst
#show emph: it => {
  set text(font: ("Libertinus Serif", "Kaiti SC"), baseline: -0.8pt)
  it
}
#show smallcaps: set text(font: ("Libertinus Serif", "STKaiti"))
#show raw: set text(baseline: -0.6pt)

#show: resume-template.with(
  lang: current-lang,
  body-font: "Noto Serif CJK SC",
  heading-font: ("Libertinus Serif", "Noto Serif CJK SC"),
  // 其他简历字段……
)
```

不同操作系统中的字体名称可能不同。可以运行 `typst fonts` 查看可用字体，并将缺失的 CJK 字体替换为本机已安装的同类衬线字体或楷体。
