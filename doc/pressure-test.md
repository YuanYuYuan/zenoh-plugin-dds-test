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
sudo ping HOST2_IP -i 0 2>&1 | tee logs/ping/$(date +%F-%T).txt
```

Host 2

```bash
mkdir -p logs/ping
sudo ping HOST1_IP -i 0 2>&1 | tee logs/ping/$(date +%F-%T).txt
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

- Build pubsub test

```bash
cargo build --release --bin pubsub_pcd
```


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
    [2023-06-09T09:10:56.159Z] N1 received PCD #76 from N2 of 1048576 bytes sent at 2023-06-09T09:10:56.144Z
    [2023-06-09T09:10:56.651Z] N1 received PCD #77 from N2 of 1048576 bytes sent at 2023-06-09T09:10:56.644Z
    [2023-06-09T09:10:57.156Z] N1 received PCD #78 from N2 of 1048576 bytes sent at 2023-06-09T09:10:57.144Z
    [2023-06-09T09:10:57.650Z] N1 received PCD #79 from N2 of 1048576 bytes sent at 2023-06-09T09:10:57.644Z
    [2023-06-09T09:10:58.157Z] N1 received PCD #80 from N2 of 1048576 bytes sent at 2023-06-09T09:10:58.144Z
    ```

- N2

    ```bash
    [2023-06-09T09:11:09.748Z] N2 received PCD #111 from N1 of 1048576 bytes sent at 2023-06-09T09:11:09.736Z
    [2023-06-09T09:11:10.250Z] N2 received PCD #112 from N1 of 1048576 bytes sent at 2023-06-09T09:11:10.236Z
    [2023-06-09T09:11:10.742Z] N2 received PCD #113 from N1 of 1048576 bytes sent at 2023-06-09T09:11:10.736Z
    [2023-06-09T09:11:11.246Z] N2 received PCD #114 from N1 of 1048576 bytes sent at 2023-06-09T09:11:11.236Z
    [2023-06-09T09:11:11.745Z] N2 received PCD #115 from N1 of 1048576 bytes sent at 2023-06-09T09:11:11.736Z
    ```
