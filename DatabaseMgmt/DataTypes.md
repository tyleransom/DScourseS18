# Data overview
Today's discussion will focus on grappling with data.

## 1. A note on file extensions
Often, if you download a file, you will immediately understand what type of a file it is by its extension. File extensions in and of themselves don't serve any particular purpose other than convenience.

File extensions were created so that humans could keep track of which files on their workspace are scripts, which are binaries, etc.

### 1.1 Why is the file format important?
File formats matter because they may need to match the environment you're working in. If you use the wrong file format, it may cause your computations to run slower than otherwise. To the extent that the environment you're working in requires a specific file format, then using the correct format is essential.

## 2. Common file extensions you'll see when working with data
In the following table, I list some of the most common file extensions. For a more complete list of almost every file extension imaginable (note: they missed Stata's `.do` and `.dta` formats), see [here](https://en.wikipedia.org/wiki/List_of_file_formats).

Another great discussion about file formats is [here](https://opendata.stackexchange.com/questions/1208/a-python-guide-for-open-data-file-formats) on stackexchange.

### 2.1 Open-format file extensions

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

#### 2.1.1 Examples of CSV, TSV, XML, YAML, and JSON files:

**A possible JSON representation describing a person** ([source](https://en.wikipedia.org/wiki/JSON#Example))
```JSON
{
  "firstName": "John",
  "lastName": "Smith",
  "isAlive": true,
  "age": 27,
  "address": {
    "streetAddress": "21 2nd Street",
    "city": "New York",
    "state": "NY",
    "postalCode": "10021-3100"
  },
  "phoneNumbers": [
    {
      "type": "home",
      "number": "212 555-1234"
    },
    {
      "type": "office",
      "number": "646 555-4567"
    },
    {
      "type": "mobile",
      "number": "123 456-7890"
    }
  ],
  "children": [],
  "spouse": null
}
```

**The same example as above, but in XML:** ([source](https://en.wikipedia.org/wiki/JSON#Example))
```XML
<person>
  <firstName>John</firstName>
  <lastName>Smith</lastName>
  <age>25</age>
  <address>
    <streetAddress>21 2nd Street</streetAddress>
    <city>New York</city>
    <state>NY</state>
    <postalCode>10021</postalCode>
  </address>
  <phoneNumber>
    <type>home</type>
    <number>212 555-1234</number>
  </phoneNumber>
  <phoneNumber>
    <type>fax</type>
    <number>646 555-4567</number>
  </phoneNumber>
  <gender>
    <type>male</type>
  </gender>
</person>
```

**The same example, but in YAML:** ([source](https://en.wikipedia.org/wiki/JSON#Example))
```YAML
firstName: John
lastName: Smith
age: 25
address: 
  streetAddress: 21 2nd Street
  city: New York
  state: NY
  postalCode: '10021'
phoneNumber: 
- type: home
  number: 212 555-1234
- type: fax
  number: 646 555-4567
gender: 
  type: male
```
Note that the JSON code above is also valid YAML; YAML simply has an alternative syntax that makes it more human-readable.

### 2.2. Proprietary file extensions

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

## 3. Archiving & file compression
Because data can be big and bulky, it is often easier to store and share the data in compressed form.

| File extension                     | Description |
|------------------------------------|-------------|
| ZIP                                | The most common format for file compression |
| Z                                  | Alternative to ZIP; uses a slightly different format for compression |
| 7Z                                 | Alternative to ZIP; uses [7-Zip](http://www.7-zip.org/) software for compression |
| GZ                                 | Another alternative to ZIP (primarily used in Linux systems), using what's called `gzip` |
| TAR                                | So-called "tarball" which is a way to collect many files into one archive file. TAR stands for "Tape ARchive" |
| TAR.GZ; TGZ                        | A compressed version of a tarball (compression via `gzip`) |
| TAR.BZ2; .TB2; .TBZ; .TBZ2         | Compressed tarball (via `bzip2`) |

![Tarball vs. TGZ](../Graphics/Targzip.svg)
Image source: By Th0msn80 - Own work, CC BY 3.0, https://commons.wikimedia.org/w/index.php?curid=4316146

## 4. Other file types that aren't data
There are many file types that don't correspond to readable data. For example, script files (e.g. `.R`, `.py`, `.jl`, `.sql`, `.do`, `.cpp`, `.f90`, ...) are text files with convenient extensions to help the user remember which programming language the code is in.

As a rule of thumb, if you don't recognize the extension of a file, it's best to inspect the file in a text editor (though pay attention to the size of the file as this can also help you discern whether it's code or data)

# General Types of Data
When you think of data, you probably think of rows and columns, like a matrix or a spreadsheet. But it turns out there are other ways to store data, and you should know their similarities and differences to tabular data.

## 5. Dictionaries (a.k.a. Hash tables)
A dictionary is a list that contains `keys` and `values`. Each key points to one value. While this may seem like an odd way to store data, it turns out that there are many, many applications in which this is the most efficient way to store things.

We won't get into the nitty gritty details of dictionaries, but they are the workhorse of computer science, and you should at least know what they are and how they differ from tabular data. In fact, dictionaries are often used to store multiple arrays in one file (e.g. in Matlab and other languages where the system can store multiple arrays at once).

The capability to manipulate hash tables is included in almost every major scientific programming language (although it is quite clunky in R ... this is why R is not considered to be a "general purpose programming language" by some people).

![Dictionaries](../Graphics/Hash_table_3_1_1_0_1_0_0_SP.svg)
Image source: By Jorge Stolfi - Own work, CC BY-SA 3.0, https://commons.wikimedia.org/w/index.php?curid=6471238 

The Julia code for constructing the dictionary above is
```Julia
mydictionary = Dict("John Smith"=>"521-1234", "Lisa Smith"=>"521-8976", "Sandra Dee"=>"521-9655")
```

## 6. Big Data file types
Big Data file systems like Hadoop and Spark often use the same file types as R, SQL, Python, and Julia. That is, `CSV` and `TSV` files are the workhorse. Because of the nature of distributed file systems (which we will discuss in much greater detail next time), it is often the case that JSON and XML are not good choices because they can't be broken up across machines. (Note: there is a distinction between JSON files and JSON records; see the second link at the bottom of this document for further details.)

### 6.1 Sequence
Sequence files are dictionaries that have been optimized for Hadoop and friends. The advantage to taking the dictionary approach is that the files can easily be coupled and decoupled.

### 6.2 Avro
Avro is an evolved version of Sequence---it contains more capability to store complex objects natively

### 6.3 Parquet
Parquet is a format that allows Hadoop and friends to partition the data column-wise (rather than row-wise).

Other formats in this vein are RC (Record Columnar) and ORC (Optimized Record Columnar).

# Useful Links

* [A beginner's guide to Hadoop storage formats](https://blog.matthewrathbone.com/2016/09/01/a-beginners-guide-to-hadoop-storage-formats.html)
* [Hadoop File Formats: It's not just CSV anymore](https://community.hds.com/community/products-and-solutions/pentaho/blog/2017/11/07/hadoop-file-formats-its-not-just-csv-anymore)
