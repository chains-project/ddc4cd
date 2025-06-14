#set page("a4")
#set page(margin: (top: 1cm))
#set page(margin: (bottom: 0cm))
#set text(font: "Inria Sans")
#import "data.typ": tcc-commit, project-repo, workflow-run-url, release-tag, github-actor, github-attestation

#show link: it => underline(text(fill: blue)[#it])

#let text-header = block[
  #align(left)[
    #text(size: 14pt, weight: "bold")[
      MINISTRY OF SOFTWARE SUPPLY CHAIN SECURITY
    ]
    #v(0.2cm)
    #text(size: 10pt, fill: gray)[
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
#grid(
  columns: (70%, 15%, 15%),
  column-gutter: 20pt,
  [],
  align(horizon)[#image("KTH_logo_RGB_bla.svg")],
  align(horizon)[#image("chains-sticker001.png")],
  [#text-header],
)


#align(left)[
  #text(size: 12pt)[
    *Description:* \
    We, the Ministry of Software Supply Chain Security, attest that the specified tcc commit has successfully passed diverse double-compiling by the _ddc4cd_ workflow.\
    \
    *Date:* #datetime.today().display()\
    *Project Repo:* #project-repo \
    *Release Tag:* #link("https://github.com/chains-project/tcc-hardened/releases/tag/"+release-tag)[#release-tag] \
    *Compiler:* tcc \
    *Compiler Commit:* #link("https://repo.or.cz/tinycc.git/commit/"+tcc-commit)[#tcc-commit.slice(0, count: 8)] \
    *Workflow Run:* #link(workflow-run-url)[#workflow-run-url.slice(-11)] \
    *Attestation: * #link("https://github.com/chains-project/tcc-hardened/attestations/"+github-attestation)[#github-attestation]
  ]
]

#v(2cm)

#stamp

#v(4cm)
#grid(
  columns: (1fr, 1fr),
  // left col
  [
    #align(left)[
      #text(size: 16pt)[
    //Signature: 

    #[#stack(
      image("signature.png"),
      move(
        dy: -87pt,
        line(length: 100%, stroke: 0.5pt)
      )
    )]  
  ]]
  ],
  // right col
  [#align(right)[
    #text(size: 11pt)[ \ \ \ \ \ \ \ \ \
    Approved by: #link("https://github.com/"+github-actor)[#github-actor]
    ]
  ]]
)
