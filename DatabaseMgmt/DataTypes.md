# Data overview
Today's discussion will focus on grappling with data.

## A note on file extensions
Often, if you download a file, you will immediately understand what type of a file it is by its extension. File extensions in and of themselves don't serve any particular purpose other than convenience.

File extensions were created so that humans could keep track of which files on their workspace are scripts, which are binaries, etc.

## Common file extensions you'll see when working with data
In the following table, I list some of the most common file extensions. For a more complete list of almost every file extension imaginable (note: they missed Stata's `.do` and `.dta` formats), see [here](https://en.wikipedia.org/wiki/List_of_file_formats).

Another great discussion about file formats is [here](https://opendata.stackexchange.com/questions/1208/a-python-guide-for-open-data-file-formats) on stackexchange.

### Open file extensions

The following file extensions are not tied to a specific software program. In this sense they are "raw" and can be viewed in any sort of text editor.

| File extension                     | Description |
|------------------------------------|-------------|
| CSV                                | Comma separated values; data is in tabular form with column breaks marked by commas |
| TSV                                | Tab separated values; data is in tabular form with column breaks marked by tabs |
| DAT                                | Tab-delimited tabular data (ASCII file) |
| TXT                                | Plain text; not organized in any specific manner (though usually columns are delimited with tabs or commsa) |
| XML                                | eXtensible Markup Language; data is in text form with tags marking different fields |
| HTML                               | HyperText Markup Language; similar to XML; used for almost every webpage you view |
| [YAML](https://en.wikipedia.org/wiki/YAML) | YAML Ain't Markup Language; human readable version of XML |
| JSON                               | JavaScript Object Notation; similar to YAML in that it has a human readable element. YAML is technically a superset of JSON. |
| HDF                                | Hierarchical Data Format; bills itself as a "scientific data format" that can handle all types of data (tabular, text, images, etc.) |
| PDF                                | Portable Document Format; not a great way to store data, but there exists much data in PDF format. Good luck unpacking it! |
| TIFF, JPEG                         | These common image formats are used to store data in the form of images, or sometimes pictures of text data. There exist image processing libraries in almost every scientific programming language that can convert data in this format into more usable formats. |
| MP3, WAV                           | These common audio formats may be used to store data. For example, voice-to-text applications have some way of converting income audio (in some format) into data that the machine can comprehend. The same holds for MP4 and other video file formats (e.g. for video input to self-driving cars, etc.) |

### Proprietary file extensions

The following file extensions typically require additional software to read, edit, or convert to another format.

| File extension                     | Description |
|------------------------------------|-------------|
| DB                                 | A common file extension for tabular data for SQLite |
| SQLITE                             | Another common file extension for tabular data for SQLite |
| XLS, XLSX                          | Tab-delimited tabular data for Microsoft Excel |
| RDA, RDATA                         | Tabular file format for R |
| MAT                                | ... for Matlab |
| SAS7BDAT                           | ... for SAS |
| SAV                                | ... for SPSS |
| DTA                                | ... for Stata |

## Archiving & file compression
Because data can be big and bulky, it is often easier to store and share the data in compressed form.

| File extension                     | Description |
|------------------------------------|-------------|
| ZIP                                | The most common format for file compression |
| 7Z                                 | Alternative to ZIP; uses [7-Zip](http://www.7-zip.org/) software for compression |
| GZ                                 | Another alternative to ZIP (primarily used in Linux systems), using what's called `gzip` |
| TAR                                | So-called "tarball" which is a way to collect many files into one archive file. TAR stands for "Tape ARchive" |
| TAR.GZ; TGZ                        | A compressed version of a tarball (compression via `gzip`) |
| TAR.BZ2; .TB2; .TBZ; .TBZ2         | Compressed tarball (via `bzip2`) |

![Tarball vs. TGZ](../Graphics/Targzip.svg)
Image source: By Th0msn80 - Own work, CC BY 3.0, https://commons.wikimedia.org/w/index.php?curid=4316146

## Big Data file types
(e.g. whatever Hadoop and Spark use)


## Other file types that aren't data
There are many file types that don't correspond to readable data. For example, script files (e.g. `.R`, `.py`, `.jl`, `.sql`, `.do`, `.cpp`, `.f90`, ...) are text files with convenient extensions to help the user remember which programming language the code is in.

As a rule of thumb, if you don't recognize the extension of a file, it's best to inspect the file in a text editor (though pay attention to the size of the file as this can also help you discern whether it's code or data)
