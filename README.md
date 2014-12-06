Spree Api Auth
============

Spree's Rest API add authentication API.

    $ /api/users/sign_up
    $ /api/users/sign_in

Example
=======

    $ curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d ' {"user":{"email":"camelmasa@gmail.com", "password":"camelmasa", "password_confirmation":"camelmasa"}}' http://localhost:3000/api/users/sign_up
    $ curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d ' {"user":{"email":"camelmasa@gmail.com", "password":"camelmasa"}}' http://localhost:3000/api/users/sign_in

Testing
-------

Coding now.

Copyright (c) 2012 Masahiro Saito, released under the New BSD License

Updated to support Spree v2.4.1 by Sanad Liaquat (sanadhussain@gmail.com)
