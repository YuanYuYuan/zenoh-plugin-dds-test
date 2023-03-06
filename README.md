# Zenoh Plugin DDS Testbed

## Build the image

```bash
docker-compose build
```


## Run the test

Terminal 1

Launch one core and 32 agents

```bash
docker-compose up --scale agent=32
```

Terminal 2

Check CPU & memory usage

```bash
docker stats
```

## Stop the test

```bash
docker-compose down
```
