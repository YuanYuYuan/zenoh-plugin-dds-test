## Network Environment Pressure Test

Assuming that we have two hosts connected through a local network,
and we want to check if the network between them is robust.
We can do the following several tests.


### Preparation

- Install the docker. Check [here](https://github.com/yuanyuyuan/zenoh-plugin-dds-test/#installation).
- Build the testing docker
    ```bash
    docker compose build dev-network-host
    ```
- Run the docker
    ```bash
    docker compose run dev-network-host
    ```
---

:warning: **The following manipulation are inside the docker containers on each host and assumed that the working directory is _/home/user/workspace/zenoh-plugin-dds-test/src/pubsub_**


### Ping

> The default sudo password is user

Host 1

```bash
mkdir -p logs/ping
sudo ping HOST2_IP -t 0 2>&1 | tee logs/ping/$(date +%F-%T).txt
```

Host 2

```bash
mkdir -p logs/ping
sudo ping HOST1_IP -t 0 2>&1 | tee logs/ping/$(date +%F-%T).txt
```

### Iperf3

1. Host 1 as the server

    Host 1

    ```bash
    mkdir -p logs/iperf3
    iperf -s -p 5202 2>&1 | tee logs/iperf3/$(date +%F-%T).txt
    ```

    Host 2

    ```bash
    mkdir -p logs/iperf3
    iperf3 -c HOST1_IP -p 5202 -P 8 -t 0 2>&1 | tee logs/iperf3/$(date +%F-%T).txt
    ```

2. Host 2 as the server

    Host 2

    ```bash
    mkdir -p logs/iperf3
    iperf -s -p 5203 2>&1 | tee logs/iperf3/$(date +%F-%T).txt
    ```

    Host 1

    ```bash
    mkdir -p logs/iperf3
    iperf3 -c HOST2_IP -p 5203 -P 8 -t 0 2>&1 | tee logs/iperf3/$(date +%F-%T).txt
    ```

### Zenoh-bridge-dds

Host 1

1. ROS Node

    ```bash
    mkdir -p logs/N1
    ./scripts/N1.sh 2>&1 | tee logs/N1/$(date +%F-%T).txt
    ```

2. Modify /home/user/workspace/zenoh-plugin-dds-test/configs/zenoh/agent.json5

```json5
  listen: {
    endpoints: [
      "tcp/HOST1_IP:7447",
    ]
  },
```

3. Zenoh bridge

    ```bash
    mkdir -p logs/bridge1
    ./scripts/bridge1.sh 2>&1 | tee logs/bridge1/$(date +%F-%T).txt
    ```

Host 2

1. ROS Node

    ```bash
    mkdir -p logs/N2
    ./scripts/N2.sh 2>&1 | tee logs/N2/$(date +%F-%T).txt
    ```

2. Modify /home/user/workspace/zenoh-plugin-dds-test/configs/zenoh/agent.json5

```json5
  connect: {
    endpoints: [
      "tcp/HOST1_IP:7447",
    ]
  },
```

3. Zenoh bridge

    ```bash
    mkdir -p logs/bridge2
    ./scripts/bridge2.sh 2>&1 | tee logs/bridge2/$(date +%F-%T).txt
    ```

Successful results

- N1

    ```bash
    [N1]: received message 447 from N2
    [N1]: received message 448 from N2
    [N1]: received message 449 from N2
    [N1]: received message 450 from N2
    [N1]: received message 451 from N2
    ```

- N2

    ```bash
    [N2]: received message 450 from N1
    [N2]: received message 451 from N1
    [N2]: received message 452 from N1
    [N2]: received message 453 from N1
    [N2]: received message 454 from N1
    ```
