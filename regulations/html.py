import os
import shutil
import subprocess

import re
import sys
import traceback


MAX_LANG_WIDTH = 20


def md2html(filename):

  return subprocess.check_output([
    "pandoc",
    "--from", "markdown",
    "--to", "html",
    "--ascii",  # UTF-8 causes trouble, so we encode straight to HTML-escaped unicode.
    filename
  ])


class html():

  def __init__(self, language, buildDir, pdfName, isTranslation=False, verbose=False):

    print "%s Generating HTML in %s" % (("[" + language + "]").ljust(MAX_LANG_WIDTH + 2), buildDir)
    sys.stdout.flush()

    self.language = language
    self.isTranslation = isTranslation
    self.docs_folder = "translations/" + language if self.isTranslation else "wca-regulations"
    self.build_folder = buildDir
    self.pdf_name = pdfName
    self.verbose = verbose

    regulations_text = md2html(self.docs_folder + "/wca-regulations.md")
    guidelines_text = md2html(self.docs_folder + "/wca-guidelines.md")

    version = subprocess.check_output([
      "git", "rev-parse", "--short", "HEAD"
    ], cwd=self.docs_folder).strip()

    regulations_text, guidelines_text = self.process_html({
      "git_hash": version,
      "regs_text": regulations_text,
      "guides_text": guidelines_text,
      "regs_url": "./",
      "guides_url": "guidelines.html"
    })

    self.write_page("WCA Regulations", self.build_folder, "/index.html", regulations_text)
    self.write_page("WCA Guidelines", self.build_folder, "/guidelines.html", guidelines_text)

    if not self.isTranslation:
      self.pages()

  def write_page(self, title, path, filename, text):

    if not os.path.isdir(path):
      os.makedirs(path)

    with open(path + "/" + filename, "w") as f:
      f.write("<%% provide(:title, %s) %%>\n" % repr(title))
      f.write('<div class="container">')
      f.write(text)
      f.write('</div>')

  def pages(self):

    self.write_page("WCA Regulations History", os.path.join(self.build_folder, "history"), "index.html", md2html("pages/history.md"))
    self.write_page("WCA Scrambles", os.path.join(self.build_folder, "scrambles"), "index.html", md2html("pages/scrambles.md"))
    self.write_page("WCA Translations", os.path.join(self.build_folder, "translations"), "index.html", md2html("pages/translations.md"))
    self.write_page("WCA Regulations/Guidelines Process", self.build_folder, "process.html", md2html("pages/process.md"))

  #
  #
  #
  #
  #
  #
  #
  #
  #
  #
  #
  #
  # TODO: Replace the code below with clean code (BeautifulSoup?).
  #
  #

  ANY = -1

  # Replacement functions

  def replaceRegs(self, expected, rgxMatch, rgxReplace):

      (self.regsText, num) = re.subn(rgxMatch, rgxReplace, self.regsText)
      if (expected != self.ANY and num not in expected):
          print >> sys.stderr, "Expected", expected, "replacements for Regulations, there were", num
          print >> sys.stderr, "Matching: ", rgxMatch
          print >> sys.stderr, "Replacing: ", rgxReplace
          traceback.print_stack()
          exit(-1)
      if self.verbose:
        print "Regulations: [" + str(num) + "]", rgxMatch, "\nRegulations:  ->", rgxReplace
      return num

  def replaceGuides(self, expected, rgxMatch, rgxReplace):

      (self.guidesText, num) = re.subn(rgxMatch, rgxReplace, self.guidesText)
      if (expected != self.ANY and num not in expected):
          print >> sys.stderr, "Expected", expected, "replacements for Guidelines, there were", num
          print >> sys.stderr, "Matching: ", rgxMatch
          print >> sys.stderr, "Replacing: ", rgxReplace
          traceback.print_stack()
          exit(-1)
      if self.verbose:
        print "Guidelines:  [" + str(num) + "]", rgxMatch, "\nGuidelines:   ->", rgxReplace
      return num

  def replaceBothWithDifferent(self, expectedReg, expectedGuide, rgxMatch, rgxReplaceRegs, rgxReplaceGuides):
      numRegs = self.replaceRegs(expectedReg, rgxMatch, rgxReplaceRegs)
      numGuides = self.replaceGuides(expectedGuide, rgxMatch, rgxReplaceGuides)
      return (numRegs, numGuides)

  def replaceBothWithSame(self, expectedReg, expectedGuide, rgxMatch, rgxReplace):
      return self.replaceBothWithDifferent(expectedReg, expectedGuide, rgxMatch, rgxReplace, rgxReplace)

  def hyperLinkReplace(self, expectedReg, expectedGuide, linkMatch, linkReplace, textReplace):
      res = self.replaceBothWithSame(expectedReg, expectedGuide,
                                     r'<a href="' + linkMatch + r'">([^<]*)</a>',
                                     r'<a href="' + linkReplace + r'">' + textReplace + r'</a>'
                                     )
      return res

  def process_html(self, args):

    # Script parameters

    regsURL = "./"
    guidesURL = "guidelines.html"

    includeTitleLogo = False

    ## Sanity checks
    numRegsArticles = [19]
    numGuidesArticles = [17, 18]

    # Arguments

    gitHash = args["git_hash"]

    self.regsText = args["regs_text"]
    self.guidesText = args["guides_text"]
    regsURL = args["regs_url"]
    guidesURL = args["guides_url"]

    # Match/Replace constants

    regOrGuide2Slots = r'([A-Za-z0-9]+)' + r'(\+*)'

    # Article Lists

    # \1: Article "number" (or letter) [example: B]
    # \2: new anchor name part [example: blindfolded]
    # \3: old anchor name [example: blindfoldedsolving]
    # \4: Article name, may be translated [example: Article B]
    # \5: Title [example: Blindfolded Solving]
    articleMatch = r'<h2[^>]*><article-([^>]*)><([^>]*)><([^>]*)> ([^\:<]*)((\: )|(&#65306;))([^<]*)</h2>'

    allRegsArticles = re.findall(articleMatch, self.regsText)
    allGuidesArticles = re.findall(articleMatch, self.guidesText)

    def makeTOC(articles):
        return "<ul id=\"table_of_contents\">\n" + "".join([
            "<li>" + name + colon + "<a href=\"#article-" + num + "-" + new + "\">" + title + "</a></li>\n"
            for (num, new, old, name, colon, _generic, _jp, title)
            in articles
        ]) + "</ul>\n"

    ## Table of Contents
    regsTOC = makeTOC(allRegsArticles)
    self.replaceRegs([1], r'<table-of-contents>', regsTOC)

    guidesTOC = makeTOC(allGuidesArticles)
    self.replaceGuides([1], r'<table-of-contents>', guidesTOC)

    ## Article Numbering. We want to
      # Support old links with the old meh anchor names.
      # Support linking using just the number/letter (useful if you have to generate a link from a reference automatically, but don't have the name of the article).
      # Encourage a new format with the article number *and* better anchor names.
    self.replaceBothWithSame(numRegsArticles, numGuidesArticles,
                             articleMatch,
                             r'<span id="\1"></span><span id="\3"></span><h2 id="article-\1-\2"> <a href="#article-\1-\2">\4</a>\5\8</h2>'
                             )

    # Numbering

    regOrGuideLiMatch = r'<li>' + regOrGuide2Slots + r'\)'
    regOrGuideLiReplace = r'<li id="\1\2"><a href="#\1\2">\1\2</a>)'

    matchLabel1Slot = r'\[([^\]]+)\]'

    ## Numbering/links in the Regulations
    self.replaceRegs(self.ANY,
                     regOrGuideLiMatch,
                     regOrGuideLiReplace
                     )
    ## Numbering/links in the Guidelines for ones that don't correspond to a Regulation.
    self.replaceGuides(self.ANY,
                       regOrGuideLiMatch + r' \[SEPARATE\]' + matchLabel1Slot,
                       regOrGuideLiReplace + r' <span class="SEPARATE \3 label">\3</span>'
                       )
    ## Numbering/links in the Guidelines for ones that *do* correspond to a Regulation.
    self.replaceGuides(self.ANY,
                       regOrGuideLiMatch + r' ' + matchLabel1Slot,
                       regOrGuideLiReplace + r' <span class="\3 label linked"><a href="' + regsURL + r'#\1">\3</a></span>'
                       )
    ## Explanation labels
    self.replaceGuides(self.ANY,
                       r'<label>' + matchLabel1Slot,
                       r'<span class="example \1 label label-default">\1</span>'
                       )

    # PDF

    self.hyperLinkReplace([1], [0], r'link:pdf', self.pdf_name, r'\1')

    # Hyperlinks

    self.hyperLinkReplace(self.ANY, self.ANY, r'regulations:article:' + regOrGuide2Slots, regsURL + r'#\1\2', r'\3')
    self.hyperLinkReplace([0], self.ANY, r'guidelines:article:' + regOrGuide2Slots, guidesURL + r'#\1\2', r'\3')

    self.hyperLinkReplace(self.ANY, self.ANY, r'regulations:regulation:' + regOrGuide2Slots, regsURL + r'#\1\2', r'\3')
    self.hyperLinkReplace([0], self.ANY, r'guidelines:guideline:' + regOrGuide2Slots, guidesURL + r'#\1\2', r'\3')

    self.hyperLinkReplace(self.ANY, self.ANY, r'regulations:top', regsURL, r'\1')
    self.hyperLinkReplace(self.ANY, self.ANY, r'guidelines:top', guidesURL, r'\1')

    self.hyperLinkReplace([1], [0], r'regulations:contents', regsURL + r'#contents', r'\1')
    self.hyperLinkReplace([0], [1], r'guidelines:contents', guidesURL + r'#contents', r'\1')

    # Title
    wcaTitleLogoSource = r'World Cube Association<br>'
    if includeTitleLogo:
        wcaTitleLogoSource = r'<center><img src="WCA_logo_with_text.svg" alt="World Cube Association" class="logo_with_text"></center>\n'
    wcaTitleLogoSource = "" # Included in the header now.

    self.replaceRegs([1],
                     r'<h1[^>]*><wca-title>([^<]*)</h1>',
                     r'<h1>' + wcaTitleLogoSource + r'\1</h1>'
                     )

    self.replaceGuides([1],
                       r'<h1[^>]*><wca-title>([^<]*)</h1>',
                       r'<h1>' + wcaTitleLogoSource + r'\1</h1>'
                       )

    # Version
    gitLink = r''
    if (gitHash != ""):
        repo = "https://github.com/cubing/wca-regulations-translations" if self.isTranslation else "https://github.com/cubing/wca-regulations"
        gitBranch = "master" if self.isTranslation else "official"
        gitPathSuffix = "/" + self.language if self.isTranslation else ""
        gitIdentifier = "wca-regulations-translations" if self.isTranslation else "official"
        gitLink = '[<code><a href="%s/tree/%s%s">%s</a>:<a href="%s/commits/%s">%s</a></code>]' % (repo, gitBranch, gitPathSuffix, gitIdentifier, repo, gitHash, gitHash)

    self.replaceBothWithSame([1], [1],
                             r'<p><version>([^<]*)</p>',
                             r'<div class="version">\1<br>' + gitLink + r'</div>'
                             )

    # Write files back out.

    return self.regsText, self.guidesText
