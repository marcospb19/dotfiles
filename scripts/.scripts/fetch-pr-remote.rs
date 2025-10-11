use std::{env::args, process::Command};

fn main() {
    let Some(input) = args().nth(1) else {
        bail("missing input argument in the format `user:branch`");
    };

    let input = input.split(':').collect::<Vec<&str>>();
    if input.len() != 2 {
        bail("malformed input, expected format `user:branch`");
    }
    let user = input[0];
    let branch = input[1];

    let repo_name = get_repo_name();
    let new_url = format!("git@github.com:{user}/{repo_name}.git");
    println!("New `pr` remote URL: {new_url}");
    println!();

    run_git(&["remote", "set-url", "pr", &new_url]);
    run_git(&["fetch", "pr"]);

    if branch == "main" || branch == "master" {
        println!(
            "branch name is {branch}, there are multiple branches with this name, not switching"
        );
        return;
    }

    run_git(&["switch", branch]);
}

fn get_repo_name() -> String {
    let output = Command::new("git")
        .args(["remote", "-v"])
        .output()
        .expect("Failed to execute git command");

    if !output.status.success() {
        bail("`git remote -v` failed, not in a repository??");
    }

    let remote_output = String::from_utf8_lossy(&output.stdout).to_string();

    let previous_pr_fetch_remote = remote_output
        .lines()
        .filter(|line| line.starts_with("pr"))
        .filter(|line| line.ends_with("(fetch)"))
        .next();

    if let Some(previous) = previous_pr_fetch_remote {
        let previous = previous.split_whitespace().nth(1).unwrap().trim();
        println!("Old `pr` remote URL: {previous}");
    }

    let origin_remote = remote_output
        .lines()
        .filter(|line| line.starts_with("origin"))
        .filter(|line| line.ends_with("(fetch)"))
        .next();

    let Some(origin) = origin_remote else {
        bail("origin remote not set, is this repository valid?");
    };

    let repo_name = origin.split('/').nth(1).unwrap();
    let repo_name = repo_name.split_whitespace().next().unwrap();
    let repo_name = repo_name.trim_end_matches(".git");
    repo_name.to_owned()
}

fn bail(message: &str) -> ! {
    eprintln!("{message}");
    std::process::exit(1)
}

fn run_git(args: &[&str]) {
    println!("- SHELL: git {}", args.join(" "));

    let Ok(status) = Command::new("git").args(args).status() else {
        bail("failed to run command.");
    };

    if !status.success() {
        eprintln!("❌ Command failed: git {}", args.join(" "));
    }
    println!();
}
