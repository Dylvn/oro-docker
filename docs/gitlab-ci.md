# Gitlab Continuous Integration

Here is a Gitlab CI template.
To use it, create a new `.gitlab-ci.yml` file at the root of your project. 
Copy/paste the content in the template section.

## The template

```yaml
image:
  name: docker:latest

services:
  - docker:dind

stages:
  - build
  - test

build-job:
  stage: build
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker compose -f compose.yaml -f compose.php.yaml build --pull
    - docker tag app-php $CI_REGISTRY_IMAGE/app-php:latest
    - docker push $CI_REGISTRY_IMAGE/app-php:latest
  when: manual

# The image should be pushed to the registry before running the tests
test-job:
  stage: test
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - IMAGES_PREFIX="$CI_REGISTRY_IMAGE/" docker compose -f compose.yaml -f compose.php.yaml up --wait --no-build
    - docker compose exec php php bin/console oro:install --env=test
    # Add your tests here
```
