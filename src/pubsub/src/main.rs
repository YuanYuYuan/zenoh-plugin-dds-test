use clap::Parser;
use futures::future;
use futures::future::join_all;
use futures::stream::StreamExt;
use r2r::QosProfile;

#[derive(Parser, Debug)]
struct Args {
    #[arg(short, long, default_value = "/pub")]
    pub_topic: String,
    #[arg(short, long, default_value = "/sub")]
    sub_topic: String,
    #[arg(short, long, default_value = "node")]
    node_name: String,
}

#[async_std::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let Args {
        pub_topic,
        sub_topic,
        node_name,
    } = Args::parse();

    let ctx = r2r::Context::create()?;
    let mut node = r2r::Node::create(ctx, "testnode", "")?;

    let duration = std::time::Duration::from_millis(500);
    let mut timer = node.create_wall_timer(duration)?;

    let qos = QosProfile::default().keep_all().reliable().transient_local();
    let sub = node.subscribe::<r2r::std_msgs::msg::String>(&sub_topic, qos.clone())?;

    let publisher =
        node.create_publisher::<r2r::std_msgs::msg::String>(&pub_topic, qos)?;

    let handle = async_std::task::spawn_blocking(move || loop {
        node.spin_once(std::time::Duration::from_millis(100));
    });

    let c_node_name = node_name.clone();
    let sub_task = async_std::task::spawn(async move {
        sub.for_each(|msg| {
            let data = msg.data;
            println!("[{c_node_name}]: received {data}");
            future::ready(())
        })
        .await;
    });

    let pub_task = async_std::task::spawn(async move {
        for idx in 0.. {
            timer.tick().await.unwrap();
            let msg = r2r::std_msgs::msg::String {
                data: format!("message {idx} from {node_name}"),
            };
            publisher.publish(&msg).unwrap();
        }
    });

    join_all([pub_task, sub_task]).await;
    handle.await;

    Ok(())
}
