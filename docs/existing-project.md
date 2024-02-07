# Installing on an Existing Project

It's also possible to use Symfony Docker with existing projects!

First, [download this skeleton](https://github.com/Dylvn/oro-docker). If you clone the Git repository, be sure to remove the `.git` directory to prevent conflicts with the `.git` directory already in your existing project.

Then, copy the Docker-related files from the skeleton to your existing project:

    cp -Rp oro-docker/. my-existing-project/

Enable the Docker support of Symfony Flex:

    composer config --json extra.symfony.docker 'true'

Double-check the changes, revert the changes that you don't want to keep:

    git diff

Build the Docker images:

- With PHP container:

        docker compose build -f compose.yaml -f compose.php.yaml --no-cache --pull

- Without PHP container:
    
      docker compose build --no-cache --pull

Start the project!

- With PHP container:
    
        docker compose up -f compose.yaml -f compose.php.yaml -d

- Without PHP container:

        docker compose up -d

Browse `https://localhost`, your Docker configuration is ready!

> [!NOTE]
> If you want to use the worker mode of FrankenPHP, make sure you required the `runtime/frankenphp-symfony` package.
