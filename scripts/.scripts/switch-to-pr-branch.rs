#!/usr/bin/env -S cargo +nightly -Zscript -q

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

    run_git(&["remote", "add", "pr", &new_url])
        .or_else(|_| run_git(&["remote", "set-url", "pr", &new_url]))
        .unwrap_or_else(|error| bail(&error));

    run_git(&["fetch", "pr"]).unwrap_or_else(|error| bail(&error));

    if branch == "main" || branch == "master" {
        println!(
            "branch name is {branch}, there are multiple branches with this name, not switching"
        );
        return;
    }

    let remote_branch = format!("pr/{branch}");
    run_git(&["switch", "--track", &remote_branch])
        .unwrap_or_else(|error| bail(&error));
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

    let repo_name = origin.rsplit('/').next().unwrap();
    let repo_name = repo_name.split_whitespace().next().unwrap();
    let repo_name = repo_name.trim_end_matches(".git");
    repo_name.to_owned()
}

fn bail(message: &str) -> ! {
    eprintln!("{message}");
    std::process::exit(1)
}

fn run_git(args: &[&str]) -> Result<(), String> {
    let command = format!("git {}", args.join(" "));
    println!("- SHELL: {command}");

    let status = Command::new("git")
        .args(args)
        .status()
        .map_err(|error| format!("failed to run `{command}`: {error}"))?;
    println!();

    if status.success() {
        Ok(())
    } else {
        Err(format!("❌ Command failed: {command}"))
    }
}
