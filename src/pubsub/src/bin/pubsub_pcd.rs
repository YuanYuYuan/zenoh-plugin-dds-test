use clap::Parser;
use futures::future;
use futures::future::join_all;
use futures::stream::StreamExt;
use r2r::QosProfile;
use r2r::{sensor_msgs::msg::PointCloud2, std_msgs::msg::Header};
use r2r::{Clock, ClockType};
use chrono::SecondsFormat;

#[derive(Parser, Debug)]
struct Args {
    #[arg(short, long, default_value = "/pub")]
    pub_topic: String,
    #[arg(short, long, default_value = "/sub")]
    sub_topic: String,
    #[arg(short, long, default_value = "node")]
    node_name: String,
    #[arg(long, default_value = "64")]
    payload_size: usize,
}

fn into_rfc3339(nanoseconds: i64) -> String {
    use chrono::{DateTime, Duration, NaiveDateTime, Utc};
    let start_time = NaiveDateTime::from_timestamp_opt(0, 0).unwrap();
    let duration = Duration::nanoseconds(nanoseconds);
    let end_time = start_time + duration;
    let utc = DateTime::<Utc>::from_utc(end_time, Utc);
    utc.to_rfc3339_opts(SecondsFormat::Millis, true)
}


#[async_std::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let Args {
        pub_topic,
        sub_topic,
        node_name,
        payload_size,
    } = Args::parse();

    let ctx = r2r::Context::create()?;
    let mut node = r2r::Node::create(ctx, "testnode", "")?;

    let duration = std::time::Duration::from_millis(500);
    let mut timer = node.create_wall_timer(duration)?;

    let qos = QosProfile::default()
        .keep_all()
        .reliable()
        .transient_local();
    let sub = node.subscribe::<PointCloud2>(&sub_topic, qos.clone())?;

    let publisher = node.create_publisher::<PointCloud2>(&pub_topic, qos)?;

    let handle = async_std::task::spawn_blocking(move || loop {
        node.spin_once(std::time::Duration::from_millis(100));
    });

    let sub_task = async_std::task::spawn({
        let node_name = node_name.clone();
        async move {
            let mut clock = Clock::create(ClockType::RosTime).unwrap();
            sub.for_each(|msg| {
                let now = clock.get_now().unwrap().as_nanos();
                let stamp = msg.header.stamp.sec as u128 * 1_000_000_000 + msg.header.stamp.nanosec as u128;
                println!(
                    "[{}] {} received {} of {} bytes sent at {}",
                    into_rfc3339(now.try_into().unwrap()),
                    &node_name,
                    &msg.header.frame_id,
                    &msg.data.len(),
                    into_rfc3339(stamp.try_into().unwrap()),
                );
                future::ready(())
            })
            .await;
            anyhow::Ok(())
        }
    });

    let pub_task = async_std::task::spawn(async move {
        for idx in 0.. {
            timer.tick().await.unwrap();

            let mut clock = Clock::create(ClockType::RosTime)?;
            let time = clock.get_now()?;
            let time = Clock::to_builtin_time(&time);
            let header = Header {
                stamp: time,
                frame_id: format!("PCD #{idx} from {node_name}"),
            };

            let mut msg = PointCloud2::default();
            msg.header = header;
            msg.data = vec![0u8; payload_size];

            // let msg = r2r::std_msgs::msg::String {
            //     data: format!("message {idx} from {node_name}"),
            // };
            publisher.publish(&msg).unwrap();
        }
        Ok(())
    });

    join_all([pub_task, sub_task]).await;
    handle.await;

    Ok(())
}
