## 1. Log ind på serveren

På din egen maskine:
```
ssh brugernavn@server-ip
```


## 2. Opdater serveren

Kør på serveren:
```
sudo apt update
sudo apt upgrade -y
```


## 3. Installer Docker

Kør:
```
curl -fsSL https://get.docker.com | sudo sh
```
Test at Docker virker:
```
docker --version
```
Du bør få noget i stil med:
```
Docker version 28.x.x
```
Test Docker:
```
docker run hello-world
```
Hvis du ser:
```
Hello from Docker!
```
så virker Docker.


## 4. Opret projektmappe

På serveren:
```
mkdir ~/php-env-test
cd ~/php-env-test
```
Kontrollér:
```
pwd
```
Du bør stå i:
```
/home/dit-brugernavn/php-env-test
```


## 5. Opret Dockerfile

Start editor:
```
nano Dockerfile
```
Indsæt hele Dockerfilen.

Gem:

**CTRL+X**

Svar:

**Y**

Tryk:

**Enter**

Kontrollér filen findes:
```
ls
```
Du bør se:
```
Dockerfile
```


## 6. Byg Docker-image

Kør:
```
docker build -t php-fpm-nginx-test .
```
Bemærk punktummet (.) til sidst.

Vent til du ser:
```
Successfully tagged php-fpm-nginx-test:latest
```
Kontrollér:
```
docker images
```
Du bør se:
```
php-fpm-nginx-test
```


## 7. Start containeren

Kør:
```
docker run -d \
--name php-fpm-nginx-test \
--restart unless-stopped \
-p 80:80 \
php-fpm-nginx-test
```
Forklaring:
```
-d                        = kør i baggrunden
--name                    = navn på container
--restart unless-stopped  = starter automatisk ved reboot
-p 80:80                  = server port 80 → container port 80
```


## 8. Kontrollér at containeren kører

Kør:
```
docker ps
```
Du bør se noget i stil med:
```
CONTAINER ID
IMAGE
STATUS
PORTS

xxxx
php-fpm-nginx-test
Up 5 seconds
0.0.0.0:80->80/tcp
```


## 9. Test lokalt på serveren

Kør:
```
curl localhost
```
Du bør få HTML tilbage.

Eller mere simpelt:
```
curl localhost | grep "PHP"
```
Forvent:
```
PHP-FPM OK
```


## 10. Hvis det ikke virker

Se container-log:
```
docker logs php-fpm-nginx-test
```
Se om containeren er stoppet:
```
docker ps -a
```


## 11. Test fra din egen computer

Peger domænet mod serveren:
```
http://domæne.tld
```
eller:
```
https://domæne.tld
```
Hvis HTTPS termineres korrekt foran serveren, vil du på siden kunne se:
```
X-Forwarded-Proto: https
```

## 12. Nyttige Docker-kommandoer

Stop:
```
docker stop php-fpm-nginx-test
```
Start igen:
```
docker start php-fpm-nginx-test
```
Genstart:
```
docker restart php-fpm-nginx-test
```
Slet:
```
docker rm -f php-fpm-nginx-test
```
Slet image:
```
docker rmi php-fpm-nginx-test
```
