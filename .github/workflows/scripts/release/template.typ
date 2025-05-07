#set page(width: 21cm, height: auto)

#import "data.typ": tcc-commit, project-repo, workflow-run-url, release-tag, github-actor


#let header = block[
  #align(center)[
    #text(font: "New Computer Modern", size: 14pt, weight: "bold")[
      DEPARTMENT OF DIVERSE DOUBLE-COMPILING
    ]
    #v(0.2cm)
    #text(font: "New Computer Modern", size: 10pt, fill: gray)[
      CONFIDENTIALITY LEVEL: PUBLIC RELEASE
    ]
    #v(1cm)
  ]
]

#let stamp = block[
  #rotate(15deg)[
    #rect(
      fill: none,
      stroke: red,
      inset: 0pt,
      radius: 4pt,
      width: 9cm,
      height: 2cm,
    )[
      #align(center)[
        #align(horizon)[
          #text(
            font: "New Computer Modern",
            size: 28pt,
            weight: "bold",
            fill: red
          )[APPROVED]
        ]
      ]
    ]
  ]
]
#align(center)[#header]

#align(left)[
  #text(font: "New Computer Modern", size: 12pt)[
    *Project Repo:* #project-repo \
    *Release Tag:* #release-tag \
    *Compiler:* tcc \
    *Compiler Commit:* #tcc-commit \
    *Workflow Run:* #link(workflow-run-url) \
    \

    *Description:* \
    tcc@#tcc-commit has successfully passed diverse double-compiling.
  ]
]

#v(2cm)

#stamp

#v(4cm)

#align(right)[
  #text(font: "New Computer Modern", size: 11pt)[
    Approved by: #github-actor
  ]
]