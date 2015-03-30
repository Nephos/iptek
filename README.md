# How to

## Program
The programm is an executable.

You can specify all the logins of your friends on arguments

You can also add -v and -d for more verbose / debug mode

To run it, try the first time ``gem install bundler && bundle install``


## Lib
This is also a library. You can use it via :

```ruby
ScrapIpTek.new(password, yourlogin, targetlogin).ips # array of string
ScrapIpTek.new(password, yourlogin, targetlogin).ip # string or null
```

## Documentation
``yard doc libIpTek.rb && firefox ./doc/index.html``

# Contributors
- poulet_a (Arthur Poulet)
