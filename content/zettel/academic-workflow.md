+++
title = "Academic Workflow"
author = ["Linus Sehn"]
draft = false
subtitle = "An overview of my academic workflow"
summary = "This is how I digest and synthesise knowledge"
featured_image = "/img/academic-workflow.jpg"
tags = ["workflow", "academia", "exocortex"]
+++

Links >> [Note-taking]({{< relref "note-taking" >}}) | [Exocortex]({{< relref "exocortex" >}})


## Input {#input}

It all starts with something fascinating I read or hear about. Next, I will
either start a note of it directly in my exocortex and/or store the material as
a reference in [Zotero](https://www.zotero.org/) for later digestion. In order to not forget about all the
interesting things in this world, I will usually schedule a time at which I can
engage with the material.

At some later point, you have to answer the question of what to do with this
material. Am I happy just leaving it as a note in my exocortex? Or do I want to
write more extensively about it (i.e. in the form of a paper or a thesis). In
making this decision, the following rules by the Italian grandmaster of
intellectual endeavours, Umberto Eco, offer some clarity ([Eco 2015, 23](#org6e8c07f)).


### Eco's Four Rules for Choosing a Thesis Topic {#eco-s-four-rules-for-choosing-a-thesis-topic}

1.  _The topic should reflect your previous studies and experience_. In other
    words, do something that you care about and that pertains to your political
    or cultural experience.
2.  _The necessary sources should be materially accessible_. Is there material
    that I can conveniently access in order to research my chosen topic.
3.  _The necessary sources should be manageable_. Do you have the time, ability
    and experience to understand the sources.
4.  _You should have some experience with the methodological framework that you
    will use in the thesis_.


## System {#system}


### Zettelkasten {#zettelkasten}


#### Emacs `org-mode` {#emacs-org-mode}

<!--list-separator-->

-  `org-roam`

<!--list-separator-->

-  `org-roam-bibtex`


#### Zotero {#zotero}

<!--list-separator-->

-  Zotfile

<!--list-separator-->

-  BetterBibTex

    Add accessdate, url for BibTeX, from [here](https://retorque.re/zotero-better-bibtex/exporting/scripting/)

    ```javascript
    if (Translator.BetterBibTeX && item.itemType === 'webpage') {
        if (item.accessDate) {
          reference.add({ name: 'note', value: "(accessed " + item.accessDate.replace(/\s*T?\d+:\d+:\d+.*/, '') + ")" });
        }
        if (item.url) {
          reference.add({ name: 'howpublished', bibtex: "{\\url{" + reference.enc_verbatim({value: item.url}) + "}}" });
        }
      }
    ```


## Output {#output}


### Notes {#notes}


### Papers {#papers}


## Resources {#resources}


### Bibliography {#bibliography}

<a id="org6e8c07f"></a>Eco, Umberto. 2015. _How to Write a Thesis_. Cambridge, Massachusetts: MIT Press.
