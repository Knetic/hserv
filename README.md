hserv
====

[![Build Status](https://travis-ci.org/Knetic/hserv.svg?branch=master)](https://travis-ci.org/Knetic/hserv)

Stupidly simple HTTP serving of local files within a working directory.

What does it do?
====

In the working directory, serves all files over HTTP. That's it. If your file structure looks like this:

```
├── foo.txt
├── bar.json
├── README.md
└── src
    └── awesome
        └── awesome.go
```

Then a request to http://localhost/README.md will result in the actual contents of `README.md`. Similarly, a request to http://localhost/src/awesome/awesome.go will result in the actual contents of that file.

Why do this?
====

I sometimes need to work offline, and sometimes do frontend work. It's nice to be able to copy the results of my backend's responses, save them as files mimicking that API, and then do frontend work against them (even while offline). You can also serve your frontend files (styles, scripts, etc) right from your project directory.

And really, it's useful in any case where you have an HTTP interface that you want to "mock". Sure, you can do this with other stuff, but in my use cases it's nice to just have a file that i can modify and serve with no caching, no nginx, no weird apache configurations, i don't have to move any files, it jsut works.

It's not a startup looking for VC's, it's just useful.
