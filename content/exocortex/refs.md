---
# An instance of the Portfolio widget.
# Documentation: https://wowchemy.com/docs/page-builder/
widget: portfolio

# This file represents a page section.
headless: true

# Order that this section appears on the page.
weight: 30

title: Reference Notes
subtitle: "These types of notes tend to much shorter. They either contain a summary/outline of a reference I find interesting or a collection of quotes from it. Sometimes they might simply include a link to another reference or concept."

content:
  # Page type to display. E.g. project.
  page_type: refs

  # Default filter index (e.g. 0 corresponds to the first `filter_button` instance below).
  filter_default: 0

  # Filter toolbar (optional).
  # Add or remove as many filters (`filter_button` instances) as you like.
  # To show all items, set `tag` to "*".
  # To filter by a specific tag, set `tag` to an existing tag name.
  # To remove the toolbar, delete the entire `filter_button` block.
  filter_button:
  - name: Spotlight
    tag: spotlight
  - name: All
    tag: '*'
  - name: Social Science
    tag: social-science
  - name: Computer Science
    tag: cs
  - name: MOOCs
    tag: mooc
  - name: Books
    tag: book
  - name: Papers
    tag: paper

design:
  # Choose how many columns the section has. Valid values: '1' or '2'.
  columns: '2'

  # Toggle between the various page layout types.
  #   1 = List
  #   2 = Compact
  #   3 = Card
  #   5 = Showcase
  view: 3

  # For Showcase view, flip alternate rows?
  flip_alt_rows: false
---
