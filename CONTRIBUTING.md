# Contributing

## Project management

This repository isn't designed to create a production-level application. Most of the scripts and manifests found here will be dedicated to different analyses or projects altogether. As such, we should try to maintain clear lines of separation in the directory structure so that we don't run into any issues, but can still collaborate productively.

Git is love, git is life (if you're designing software). Git and GitHub offer tons of powerful tools and tricks for creating and maintaining robust projects. Because this repository is purposed slightly differently, we should take project flow recommendations with a grain of salt. **Briefly**, I'm going to lay out the important things to know about how you should contribute to **this repository**. A more software developer-oriented guide for using GitHub effectively can be found **[here](https://guides.github.com/introduction/flow/)**.

## How to use this repository

### Adding files
  * If you're adding a new project or set of files to the repository, be sure to place them in a unique folder that doesn't interfere with anyone else's work. Use **descriptive names** for both **files AND folders**.

### Editing existing files
  * Make your changes as needed (on your computer) then **_add_** -> **_commit_** -> **_push_**. [GitHub Desktop](https://desktop.github.com/) makes this pretty easy and intuitive. Your changes should then be reflected on the branch of the repository that you pushed to.

### Branches
  * It's _probably_ fine that everything exists on just one branch, because we're not adding things to a single, cohesive application. But, if you're interested, you can create a new branch of the repository to test some things out in. This means you will be copying the project's entire directory structure into a separate directory within the Git repository. Importantly, unless you **merge** the two back together, which I highly don't recommend doing here, they will not have the same contents. Files updated in one branch will not be updated in another unless they are merged together.
  
## About Git and GitHub :octocat:

### GitHub Desktop vs. Git CLI
  * If you're used to using Git or the command line in general, by all means feel free to use your favorite terminal to push & pull to/from this repository.
  * If you'd prefer to take a more GUI-oriented approach, GitHub offers a **[desktop application](https://desktop.github.com/)** for both Windows and macOS users (not Linux, unfortunately). This allows you to easily add files/folders to the repository, commit your changes to your preferred branch, and push them to GitHub without ever having to touch a terminal.

### How Git (with GitHub) works
  * Git allows you to create repositories for your code that you can work out of as you build and develop all of the functionality that you want.
  * The beauty of version control is that a full history of the files and their states at the point of any given commit will exist as long as this repository does. Need to revert to the form your reconstruction script was in as of a commit you made 8 months ago? Easy.
  * Git doesn't require you to use an online (remote) repository, but it makes it easy to collaborate with others by doing so. In fact, the only real differences between a remote and local repository exist in the features that GitHub lets you use (Markdown rendering like this, for example, or .gitignore files).
  * The general process for adding a file or making a change is the same: **add, commit, push.** You will add your changes (create a new file or edit an existing one), **commit** the changes to stage them for addition to this remote repository with a log message, and **push** your changes here. **Changes should be well documented, with commit messages explicitly stating what was altered.**
  * You _can_ edit files online using GitHub's editing functionality, but that is **highly** discouraged unless the file is Markdown or something else that you'd actually benefit from editing in a browser.
  * If you'd like to read more about Git, [this page](https://git-scm.com/about) should have what you're looking for.

## Comments, Documentation and Formatting

If someone else is going to use your code in the future, **please format well and write decent comments.** Few things are worse than inheriting someone's project and having to parse through each line just to understand what the general purpose of their software is. Write **brief and descriptive** comments as often as you think would be necessary for someone else to be able to grasp your thought process **without having to ask you any questions**. Good formatting is another key to writing understandable code. Especially with MATLAB, matrix indices can often be hard to read. Be liberal with newlines and indentations if it helps improve the readability of your software.

## MATLAB Style Guide

[This document](./MATLAB_style.pdf) is available in the [root directory](https://github.com/acochran50/cchmc-cpir). Not a requirement, but could you imagine a world where everyone wrote MATLAB code by the same standards? Whoa.

</br>

***

</br>

## [GitHub Flow](https://guides.github.com/introduction/flow/)

While any workflow is possible with Git/GitHub and we're not necessarily using one, here is a brief synopsis the general contribution process as described by GitHub:

* **Creating a branch**
  * Features and new ideas should be in a separate branch that others can see, but that won't have any effects on the current working version of the project.
* **Adding commits**
  * Make some changes to the project in the new branch to flesh things out and work towards your new feature. Well-labeled commits make it easy for everyone else to see what you're working on, how you're working on it, and what your end goal might be.
  * Use **short, meaningful** commit messages.
* **Opening a pull request**
  * Light a signal fire so everyone knows you want to discuss what you're working on.
* **Reviewing changes with everyone**
  * Pull requests are for discussions. Make sure everyone's opinions have been heard before moving too far ahead with something that constitutes a major project decision.
* **Deploying and testing**
  * Use GitHub to deploy your new feature and run tests before throwing the change into the working project source. Let everyone review the pieces and parts of your code if they'd like to. This is a final quality control check before making a direct alteration to the code that users will run.
* **Merging**
  * Changes verified? Add them to the production-level code.
  * Pull requests will maintain a history of the changes made to everything.
