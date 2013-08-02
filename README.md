Dantalion
=========

Mass documentation, indexing, and categorization.

What madness is this?
---------------------

In the process of attempting to document hundreds of scripts through a wiki, I began to get very tired of the formatting and noticed that I was essentially doing the same thing repeatedly. Even worse, I had to make sure to update it every time I changed the script in any way. Why can't the scripts just document themselves?

### Enter Dantalion

Dantalion uses the comments in the code, formatted with MarkDown, to generate documentation files. It then generates an index of all documented files and categorizes them via type and other factors that can be defined. 

### Where does it work?

The current version documents both BASH-like and Ruby code using hash markings for comments. I intend to add modules for other languages as I go along in its creation.

### Why not RDOC?

You see, I wondered that myself a bit. I come from a design and web background, making RDOCs output not all that appealing. I wanted more control over it, and I wanted to be able to document ANYTHING.

### What are you planning to add?

I intend to add quite a few things to the first copy that will post soon:

* Syntax Highlighting
* Multi-Language Support
* GUI Generation 

### ...did you just list GUI generation?

Indeed I did. For some people, these are a requirement. I, myself, see it as a bit far fetched, but if it improves productivity of non-cl peoples it's worth pursuing. I've always gotten complaints that it didn't generate to a form or it wasn't web-accessible or any other number of things.

Perhaps I should clarify what I mean by GUI generation. You've already written all the code to make the thing run, good. Why rewrite it into a GUI or a Rails app? The basic logic is there, you're just adding a wrapper to it essentially. We can abstract that.

GUIs are simple enough in an engine like shoes. By using the usage documented in the script it becomes a simple matter of generating text fields or filling drop lists with a pre-gen list from a specified data file. You've already done that work by now, it's just adding hooks to deliver the goods.

As for Rails? I don't see why that needs to be any different. A well written library can be ported to an MVC layout with conventional logic, and utilities into the controllers and models to work with it.

### So what gave you the idea?

If a human can do it with enough time, a computer plus a human can do it faster. Why waste time doing something that you've already done, or writing for multiple platforms when the essence is the same? I, like some programmers, don't like repeating myself if possible. I like to find ways to shorten work time and improve efficiency. This is a product of that desire.

### Can I help?

Plug away my friend, the more the merrier!
