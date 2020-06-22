* Build the code:
```
cd sources ; mvn clean package ; cd ..
```

* Start the lab:
```
vagrant up
```

* Test the lab:
```
vagrant ssh frontend

kinit user1@EXAMPLE.COM

curl -v --negotiate -b cookies.txt -c cookies.txt -u : http://frontend:8080/test/local
```
