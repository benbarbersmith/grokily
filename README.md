Grokily
=======

A minimalist web application to help you conjugate Norwegian Bokmål verbs.

Installation
------------

Install dependencies using bundler:

    $ bundle install 

That's the only dependency you need; after that, just grab a copy of the souce
and run the application.

    $ ruby lib/grokily.rb 

By default, Sinatra will run grokily on port 4567 on your local machine.

Usage
-----

Assuming that you're running on the default host and port, all URLs start
with `http://localhost:4567/`.

You can see a list of availabe languages at:

    http://localhost:4567/languages
    http://localhost:4567/languages.json

You can see a list of supported verbs for any given language (using Norsk
as an example) at:

    http://localhost:4567/norsk/verbs
    http://localhost:4567/norsk/verbs.json

You can see a list of available tenses for any given language (using Norsk
as an example) at: 

    http://localhost:4567/norsk/tenses
    http://localhost:4567/norsk/tenses.json

Tenses can be specified using English tense names or those of the target
language.

You can see a list of available subject for any given language (using Norsk
as an example) at:

    http://localhost:4567/norsk/subjects
    http://localhost:4567/norsk/subjects.json

Once you've picked a language, verb and tense, you can ask Grokily to
conjugate it. To do so, start with `http://localhost:4567/norsk/` followed
by the infinitive, the tense and (optionally) a subject. For example, you
could try:

    http://localhost:4567/norsk/be/presens

    http://localhost:4567/norsk/begynne/futurum/jeg

    http://localhost:4567/norsk/arbeide/imperative

    http://localhost:4567/norsk/glede/present/det

As before, you can append `.json` to any of the aforementioned URLs to get
a JSON response rather than plain text. 

Roadmap
-------

At present, available tenses are:

* `present` / `presens`
* `past` / `fortid`
* `future` / `futurum`
* `stem` / `demme`
* `imperative` / `viktig`

In due course, the API will be extended to include additional tenses:

* `present-perfect` / `presens-perfekt`
* `past-perfect` / `fortid-perfekt`
* `future-perfect` / `futurum-perfekt`

Improvements? Ideas?
--------------------

This API is primarily intended to help me hone my Ruby skills and learn
a little more Norwegian. But if you have a specific feature request or if
you found a bug, please [give me a shout](web@benjaminasmith.com). And of
course, please feel free to fork the code or the data and send a pull
request with improvements.

Skål!
