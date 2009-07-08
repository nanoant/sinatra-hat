Sinatra Hat
===========
This is a set of extensions for *Sinatra* and relative gems such as *Sequel*, *Haml*, *GetText*.

It adds following functions to your *Sinatra* project:

 - Automatic translation using *GetText* or *Fast_Gettext* of *Haml* templates, and parser for `po` file generation
 - Several fixes for *Sequel*, *Rack*
 - Rack reloader for *Sinatra* and *GetText* translations
 - String permalinks and date extensions

Setup
=====
### 1. Install
    sudo gem install nanoant-sinatra-hat -s http://gems.github.com/

Or from source:

    git clone git://github.com/nanoant/sinatra-hat.git
    cd sinatra-hat && rake install

Author
======
[Adam Strzelecki](http://www.nanoant.com/)
ono@java.pl

Released under MIT license, see `MIT-LICENSE` for details.
