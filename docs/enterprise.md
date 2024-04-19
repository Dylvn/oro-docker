# Using Enterprise Edition

The Enterprise Edition of Oro applications will need a few extra steps to work with Oro Docker.

As the entreprise edition need more dependencies (elasticsearch, rabbitmq, etc.), you will need to add the following services to the `compose.yaml` file.

## Update the `compose.yaml` and `compose.php.yaml` file

```yaml
# Exemple of the compose.yaml file for adding rabbitmq
# compose.yaml

services:
  rabbitmq:
    image: rabbitmq:3.8-management
    environment:
      RABBITMQ_DEFAULT_USER: user
      RABBITMQ_DEFAULT_PASS: password
    ports:
      - "5672"
      - "15672"
```

```yaml
# Don't forget to create an environment variable for the rabbitmq connection in the compose.php.yaml file
# compose.php.yaml

services:
    php:
        image: ${IMAGES_PREFIX:-}app-php
        restart: unless-stopped
        build:
            context: .
            target: frankenphp_dev
        environment:
            ORO_MQ_URL: amqp://${RABBITMQ_DEFAULT_USER:-oro_mq_user}:${RABBITMQ_DEFAULT_PASS:-oro_mq_pass}:{RABBITMQ_PORT:-5672}
```

## Download the enterprise edition packages

### Using the `auth.json` file

To make your container be able to download a private package, you will need to add your credentials to the `auth.json` file.

Make sure that this file is ignored by git by adding it to the `.gitignore` file.

Official documentation : [Authentication for privately hosted packages and repositories - Composer](https://getcomposer.org/doc/articles/authentication-for-private-packages.md)

### Alternative solutions

Alternatives solutions are explained in this blog post: [Securely Access Private Git Repositories and Composer Packages in Docker Builds](https://dunglas.dev/2022/08/securely-access-private-git-repositories-and-composer-packages-in-docker-builds/)

