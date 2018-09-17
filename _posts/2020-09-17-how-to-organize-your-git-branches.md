---
title: How to organize your git branches
tags: git
permalink: /blog/how-to-organize-your-git-branches
---

I remember implementing git in my team. I think it was more than 6 years ago. At that time, [A successful git branching model](https://nvie.com/posts/a-successful-git-branching-model/) by [Vincent Driessen](https://twitter.com/nvie) was required reading if you wanted to learn how to work with git effectively. Since then, I've been following the "Git Flow" style. But, this past year, I've been influenced by many developers from the community, and started using git in different ways depending on the projects I was working on.

Before getting into the different branching styles, it's important to remember that, although many git clients treat slashes ("/") as a directory separator, there is no such thing as folders or directories in the git specification. You will see this implemented in many UI clients, but I never found it on console clients, or on websites like Github or GitLab.

That being said, Let's explore some ways of organizing branches, so you don't get lost in a sea of code.

# Gitflow
 
Although Gitflow doesn't mention branch folders, many devs use "Feature branches", "Hotfix branches" and "Release branches" and create folders accordingly.
So basically, a GitFlow organization would have these three folders:
* feature[s]
* hotfix[es]/fixes
* release[s]

As there is no public document talking about this, I've seen some working copies using those folders in plural and others in singular.

<img src="https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/git-branches/gitflow.png" width="450px">

# Gitflow with steroids

I found myself adding two more folders to my Gitflow repos:
 * Docs: For branches related to markdown or release documents.
 * Task: For branches which are neither features nor fixes. Such as, clean up scripts or refactors.

# BPMP (Branch-Push-Merge-Prune)

I’ve seen this a lot in many projects. The branch-push-merge-prune is the anti-folder method. I'm not saying that chaos is a way of organizing branches. People using this method like to have their working copy clean. They would just branch, push, create a pull request and then delete the branch (manually or via git fetch prune) as soon as the PR is merged.

<img src="https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/git-branches/bpmp.png" width="450px">

# Module-based

I found myself using what I call a "module-based" branching model on a big project where I got quite lost in a sea of features and fixes. So I started to create branches based on its modules. 

<img src="https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/git-branches/module-based.png" width="450px">

You could mix Gitflow with this module-based approach, something like "backoffice/billing/fixes/billing-values", but that may be too much.

# Version-based

I first saw [Meir](https://twitter.com/MeirBlachman) using this approach and I loved it. It’s great for projects like [Puppeteer-sharp](https://github.com/kblok/puppeteer-sharp) where the roadmap is clear.
In a version-based repo you create each branch inside a "vX.X" folder. What is cool about this is that it’s time-based, so it's easier to find branches and also it's super easy to delete old versions with this simple git command:

>git branch | grep -e "vX.X/" | xargs git branch -D

<img src="https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/git-branches/version-based.png" width="450px">

Again, this could be mixed with Gitflow folders, but...

# Ticket-based

If tickets numbers (tickets, issues or whatever you call them) are part of your team's language using a ticket-based system could be a perfect fit.
You could use a folder, such as "tickets/242" or "issues/242", or just simply call it "242".

<img src="https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/git-branches/tickets-based.png" width="450px">

# Emoji-based

If none of these systems is for you, you can follow [Nick's idea](https://twitter.com/Nick_Craver/status/1037841352053194752) and implement an Emoji-based system :)

<img src="https://raw.githubusercontent.com/kblok/kblok.github.io/master/img/git-branches/emoji-based.png" width="450px">

# Final words

Two final thoughts to close this post. First, if you work on a team where you normally checkout each other branches, e.g. for local testing, I'd recommend you share the style with your team.
And finally, clean your working copy frequently. This will help you find your branches quickly, and also speed up your local hit.

Don't stop coding!
