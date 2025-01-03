


### frontend 

```
$ docker run -d -p 80:80 -e CATALOGUE_HOST=catalogue-ip -e CATALOGUE_PORT=catalogue-port -e USER_HOST=user-host -e USER_PORT=user-port -e CART_HOST=cart-host -e CART_PORT=cart-port -e SHIPPING_HOST=shipping-host -e SHIPPING_PORT=shipping-port -e PAYMENT_HOST=payment-host -e PAYMENT_PORT=payment-port  public.ecr.aws/w2x3d9u7/roboshop-v3/frontend
```

###  catalogue
```
$ dnf install docker -y
$ docker run -d -p 8080:8080 -e MONGO=true -e MONGO_URL="mongodb://mongo-ip:27017/catalogue" public.ecr.aws/w2x3d9u7/roboshop-v3/catalogue
```

Catalogue requires master-data to be loaded.

```
$ docker run -e DB_TYPE=mongo -e APP_GIT_URL=https://github.com/stans-robot-project-v3/catalogue -e DB_HOST=mongo-ip -e SCHEMA_FILE=db/master-data.js public.ecr.aws/w2x3d9u7/roboshop-v3/schema-load
```

### user

```
$ dnf install docker -y
$ docker run -d -p 8080:8080 -e MONGO=true -e MONGO_URL="mongodb://mongo-ip:27017/users" -e REDIS_URL="redis://redis-ip:6379" public.ecr.aws/w2x3d9u7/roboshop-v3/user
```

### cart

```
$ dnf install docker -y
$ docker run -d -p 8080:8080 -e CATALOGUE_HOST=catalogue-ip -e CATALOGUE_PORT=8080 -e REDIS_HOST=redis-ip public.ecr.aws/w2x3d9u7/roboshop-v3/cart
```

### shipping

```
$ dnf install docker -y
$ docker run -d -p 8080:8080 -e CART_ENDPOINT=cart-ip:cart-port -e DB_HOST=mysql-ip public.ecr.aws/w2x3d9u7/roboshop-v3/shipping
```

Create App User in Database

```
$ docker run -e DB_TYPE=mysql -e APP_GIT_URL=https://github.com/stans-robot-project-v3/shipping -e DB_HOST=mysql-ip -e DB_USER=root -e DB_PASS=RoboShop@1 -e SCHEMA_FILE=db/app-user.sql public.ecr.aws/w2x3d9u7/roboshop-v3/schema-load
```
Create Schema

```
$ docker run -e DB_TYPE=mysql -e APP_GIT_URL=https://github.com/stans-robot-project-v3/shipping -e DB_HOST=mysql-ip -e DB_USER=root -e DB_PASS=RoboShop@1 -e SCHEMA_FILE=db/schema.sql public.ecr.aws/w2x3d9u7/roboshop-v3/schema-load
```

Create Master Data

```
$ docker run -e DB_TYPE=mysql -e APP_GIT_URL=https://github.com/stans-robot-project-v3/shipping -e DB_HOST=mysql-ip -e DB_USER=root -e DB_PASS=RoboShop@1 -e SCHEMA_FILE=db/master-data.sql public.ecr.aws/w2x3d9u7/roboshop-v3/schema-load
```

### Payment 

```
$ docker run -d -p 8080:8080 -e CART_HOST=cart-ip -e CART_PORT=8080 -e USER_HOST=user-ip -e USER_PORT=8080 -e AMQP_HOST=rabbitmq-ip -e AMQP_USER=roboshop -e AMQP_PASS=roboshop123 public.ecr.aws/w2x3d9u7/roboshop-v3/payment
``` 