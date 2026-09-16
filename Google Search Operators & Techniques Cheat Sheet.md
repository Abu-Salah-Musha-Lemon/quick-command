# Google Search Operators & Techniques Cheat Sheet

 > A practical reference for narrowing Google searches, finding documents, searching specific websites, and combining multiple search operators.

---

 ## 1\. Exact Phrase

 Search for an exact sequence of words.

```
"machine learning tutorial"
```

 Useful for:

 - Exact names
- Titles
- Quotes
- Specific phrases

---

 ## 2\. Exclude a Word

 Use `-` to remove unwanted results.

```
python programming -snake
```

 Multiple exclusions:

```
python programming -snake -django
```

---

 ## 3\. OR Search

 Search for either term.

```
laptop OR notebook
```

 Multiple alternatives:

```
"machine learning" OR "artificial intelligence" OR "deep learning"
```

---

 ## 4\. Group Search Terms

 Use parentheses to group alternatives.

```
(football OR soccer) "World Cup"
```

 Another example:

```
("machine learning" OR "deep learning") tutorial
```

---

 # Website Searching

 ## 5\. Search One Website

```
site:example.com cybersecurity
```

 Example:

```
site:bbc.com climate change
```

---

 ## 6\. Search a Specific Domain

```
site:gov.bd passport
```

 Examples:

```
site:edu "computer science"
site:gov "tax"
site:org "annual report"
```

---

 ## 7\. Search Multiple Websites

```
site:example.com OR site:example.org "research"
```

---

 ## 8\. Search a Website for a Specific File Type

```
site:example.com filetype:pdf
```

 Example:

```
site:gov.bd filetype:pdf "annual report"
```

---

 # File Searching

 ## 9\. PDF Files

```
filetype:pdf "machine learning"
```

---

 ## 10\. PowerPoint Files

```
filetype:pptx "marketing strategy"
```

---

 ## 11\. Word Documents

```
filetype:docx "project proposal"
```

---

 ## 12\. Excel Files

```
filetype:xlsx "sales report"
```

---

 ## 13\. CSV Files

```
filetype:csv "population data"
```

---

 ## 14\. Text Files

```
filetype:txt "configuration"
```

---

 ## 15\. Search Multiple File Types

```
filetype:pdf OR filetype:pptx "artificial intelligence"
```

---

 # Google Drive & Google Services

 ## 16\. Google Drive

```
site:drive.google.com "research"
```

---

 ## 17\. Google Docs

```
site:docs.google.com "project proposal"
```

---

 ## 18\. Google Sheets

```
site:sheets.google.com "sales report"
```

---

 ## 19\. Google Slides

```
site:slides.google.com "marketing"
```

 > Only publicly accessible/indexed content can normally appear in Google Search. These operators do not bypass private files or access controls.

---

 # Page Title Searching

 ## 20\. Search in Page Titles

```
intitle:"machine learning"
```

---

 ## 21\. Title + File Type

```
intitle:"annual report" filetype:pdf
```

---

 ## 22\. Title + Website

```
site:example.com intitle:"annual report"
```

---

 ## 23\. Multiple Title Terms

```
intitle:research intitle:report
```

---

 # URL Searching

 ## 24\. Search for a Word in URLs

```
inurl:blog
```

---

 ## 25\. Search URLs for a Specific Topic

```
inurl:research "artificial intelligence"
```

---

 ## 26\. Combine URL + Website

```
site:example.com inurl:blog cybersecurity
```

---

 ## 27\. Find Download Pages

```
inurl:download filetype:pdf
```

---

 ## 28\. Find Documentation Pages

```
inurl:docs programming
```

---

 # Text Searching

 ## 29\. Search for Text on a Page

```
intext:"artificial intelligence"
```

---

 ## 30\. Search Text + Website

```
site:example.com intext:"privacy policy"
```

---

 ## 31\. Search Link/Anchor Text

```
inanchor:"download"
```

 > Availability and behavior of `inanchor:` can vary, so treat it as a less dependable operator than `site:` or `filetype:`.

---

 # Number & Price Searching

 ## 32\. Number Range

```
laptop 500..1000
```

---

 ## 33\. Price Range

```
laptop $500..$1000
```

---

 ## 34\. Year Range

```
"artificial intelligence" 2020..2026
```

---

 ## 35\. Specific Number

```
"population" 170000000
```

---

 # Location Searching

 ## 36\. Search Near a Location

```
restaurants near Dhaka
```

---

 ## 37\. Search a Specific City

```
software companies in Dhaka
```

---

 ## 38\. Search a Specific Country

```
universities in Bangladesh
```

---

 # Social & Community Searching

 ## 39\. Search Reddit

```
site:reddit.com "best programming language"
```

---

 ## 40\. Search Reddit for a Topic

```
site:reddit.com/r/programming "Python"
```

---

 ## 41\. Search YouTube

```
site:youtube.com "Excel tutorial"
```

---

 ## 42\. Search GitHub

```
site:github.com "machine learning"
```

---

 ## 43\. Search LinkedIn

```
site:linkedin.com/in "software engineer"
```

---

 ## 44\. Search Wikipedia

```
site:wikipedia.org "Bangladesh"
```

---

 # Research Searching

 ## 45\. Research Papers

```
"machine learning" "research paper"
```

---

 ## 46\. PDF Research Papers

```
filetype:pdf "machine learning" "research"
```

---

 ## 47\. Research From a Specific Organization

```
site:example.org filetype:pdf "research"
```

---

 ## 48\. Academic Material

```
site:edu filetype:pdf "computer science"
```

---

 ## 49\. Government Reports

```
site:gov filetype:pdf "annual report"
```

---

 ## 50\. Government Material in Bangladesh

```
site:gov.bd filetype:pdf "report"
```

---

 # Combining Operators

 The real power comes from combining operators.

 ## 51\. Website + PDF + Phrase

```
site:example.com filetype:pdf "annual report"
```

---

 ## 52\. Website + Title + PDF

```
site:example.com intitle:"annual report" filetype:pdf
```

---

 ## 53\. URL + PDF

```
inurl:download filetype:pdf
```

---

 ## 54\. Website + URL + PDF

```
site:example.com inurl:download filetype:pdf
```

---

 ## 55\. Website + Title + Keyword

```
site:example.com intitle:research "artificial intelligence"
```

---

 ## 56\. Exact Phrase + Exclusion

```
"machine learning tutorial" -youtube
```

---

 ## 57\. Multiple Alternatives + Website

```
site:example.com ("AI" OR "artificial intelligence" OR "machine learning")
```

---

 ## 58\. Multiple Alternatives + File Type

```
filetype:pdf ("AI" OR "machine learning") tutorial
```

---

 # Wildcards

 ## 59\. Wildcard `*`

```
"best * for beginners"
```

 The `*` can represent unknown words.

 Another example:

```
"how to * in Python"
```

 > Wildcards are useful in some phrase searches, but Google does not treat `*` as a general-purpose regex wildcard.

---

 # Special Searches

 ## 60\. Definitions

```
define:photosynthesis
```

 Google may provide a definition directly.

---

 ## 61\. Calculations

```
250 * 45
```

---

 ## 62\. Unit Conversion

```
10 km in miles
```

---

 ## 63\. Currency Conversion

```
100 USD to BDT
```

---

 ## 64\. Weather

```
weather Dhaka
```

---

 ## 65\. Time

```
time Tokyo
```

---

 ## 66\. Maps/Places

```
restaurants near Dhaka
```

---

 # Search by File Extension

 Useful examples:

```
filetype:pdf
filetype:doc
filetype:docx
filetype:ppt
filetype:pptx
filetype:xls
filetype:xlsx
filetype:csv
filetype:txt
```

 Example:

```
filetype:xlsx "financial data"
```

---

 # Useful Search Templates

 ## 67\. Find Public Reports

```
site:example.com filetype:pdf intitle:report
```

---

 ## 68\. Find Presentations

```
site:example.com filetype:pptx presentation
```

---

 ## 69\. Find Research Documents

```
filetype:pdf "research" "machine learning"
```

---

 ## 70\. Find Documentation

```
site:example.com inurl:docs "API"
```

---

 ## 71\. Find Tutorials

```
site:example.com intitle:tutorial "Python"
```

---

 ## 72\. Find News on a Specific Site

```
site:example.com news "artificial intelligence"
```

---

 ## 73\. Find a Specific Topic Without a Website

```
"artificial intelligence" filetype:pdf -advertisement
```

---

 # Powerful Search Formula

 A useful general formula is:

```
site:DOMAIN filetype:TYPE intitle:"TITLE" "KEYWORD" -EXCLUDE
```

 Example:

```
site:example.com filetype:pdf intitle:"annual report" "2025" -advertisement
```

---

 # Google Search Tips

 ## 74\. Use More Specific Keywords

 Instead of:

```
computer
```

 Try:

```
computer networking tutorial for beginners pdf
```

---

 ## 75\. Remove Noise

```
python tutorial -youtube -wikipedia
```

---

 ## 76\. Search Exact Names

```
"University of Dhaka"
```

---

 ## 77\. Search Exact Document Titles

```
"World Development Report"
```

---

 ## 78\. Combine Concepts

```
"machine learning" healthcare filetype:pdf
```

---

 ## 79\. Search a Site First, Then Narrow It

 Start:

```
site:example.com cybersecurity
```

 Then:

```
site:example.com cybersecurity filetype:pdf
```

 Then:

```
site:example.com cybersecurity filetype:pdf intitle:report
```

---

 # Quick Reference Table

 | Operator | Purpose | Example |
| --- | --- | --- |
| `" "` | Exact phrase | `"machine learning"` |
| `-` | Exclude | `python -snake` |
| `OR` | Alternatives | `car OR automobile` |
| `( )` | Group terms | `(AI OR ML) tutorial` |
| `site:` | Specific website/domain | `site:gov.bd` |
| `filetype:` | Specific file type | `filetype:pdf` |
| `intitle:` | Search title | `intitle:research` |
| `inurl:` | Search URL | `inurl:blog` |
| `intext:` | Search page text | `intext:"privacy policy"` |
| `inanchor:` | Search link text | `inanchor:download` |
| `..` | Number range | `2020..2026` |
| `*` | Wildcard | `"best * tutorial"` |
| `define:` | Definition | `define:algorithm` |

---

 # Important Limitations

 Google search operators are **filters, not access-control bypasses**.

 They cannot legitimately give you access to:

 - Private Google Drive files
- Password-protected documents
- Restricted websites
- Non-public databases
- Accounts or private information
- Files that Google has not indexed

 Also, Google may change or discontinue operators over time. Operators such as `site:`, `filetype:`, `intitle:`, `inurl:`, quotation marks, `-`, `OR`, and number ranges are generally more useful than relying on older operators.

---

 # Best General-Purpose Searches

```
site:example.com "keyword"
```

```
site:example.com filetype:pdf "keyword"
```

```
site:example.com intitle:"keyword"
```

```
site:example.com inurl:keyword
```

```
filetype:pdf "keyword" -unwanted
```

```
("keyword1" OR "keyword2") filetype:pdf
```

```
site:example.com filetype:pdf intitle:"report" "2025"
```
