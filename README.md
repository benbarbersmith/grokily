Grokily
=======

A RESTful API to help you conjugate Norwegian Bokmål verbs.

Installation
------------

Install Sinatra from rubygems:

    $ gem install sinatra

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

You can see a list of supported verbs for any given language at:

    http://localhost:4567/norsk/verbs
    http://localhost:4567/norsk/verbs.json

You can see a list of available tenses for any given language at: 

    http://localhost:4567/norsk/tenses
    http://localhost:4567/norsk/tenses.json

Tenses can be specified using English or Norsk. 

Once you've picked a language, verb and tense, you can ask Grokily to
conjugate it. To do so, start with `http://localhost:4567/norsk/` followed
by the verb infinitive and the tense. For example, you could try:

    http://localhost:4567/norsk/be/presens

    http://localhost:4567/norsk/begynne/futurum

    http://localhost:4567/norsk/arbeide/imperative

    http://localhost:4567/norsk/glede/present

As before, you can append `.json` to any of the aforementioned URLs to get
a JSON response rather than plain text. 

Roadmap
-------

At present, available tenses are:

* `present` / `presens`

In due course, the API will be extended to include additional tenses:

* `past` / `fortid`
* `future` / `futurum`
* `imperative` / `viktig`
* `present-participle` / `presens-partisipp`
* `past-participle` / `fortid-partisipp`
* `present-perfect` / `presens-perfekt`
* `past-perfect` / `fortid-perfekt`
* `passive` / `passiv`
* `present-passive` / `presens-passiv`
* `conditional` / `betinget` 
* `stem` / `demme`

Improvements? Ideas?
--------------------

This API is primarily intended to help me hone my Ruby skills and learn
a little more Norwegian. But if you have a specific feature request or if
you found a bug, please [give me a shout](web@benjaminasmith.com). And of
course, please feel free to fork the code or the data and send a pull
request with improvements.

Skål!
