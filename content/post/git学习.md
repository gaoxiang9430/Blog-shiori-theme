+++
date = "2016-05-11T21:45:10+08:00"
draft = true
title = "Git学习记录"
tags = [ "git", "blog" ]
+++


Git是目前世界上最先进的分布式版本控制系统（没有之一）。在linux系统发展之初，世界各地的志愿者把代码通过diff的方式发给linus，然后由linus通过手工的方式进行整合，这种方式效率低，且易发生错误。当时世界上有些免费的版本控制系统（CSV，SVN），但是这些系统是集中式的，且必须联网才能使用。后来linus花了两周时间用c写了一个分布式的版本管理系统，这就是Git。
Git与其他分布式系统的区别主要是他为分布式的。在传统的集中式版本控制系统中，版本库存放于中央服务器，在修改代码的时候首先从服务器下载最新版本。干完活之后在推送给服务器，因此这个过程需要联网的支持。可是当网络不好的时候，就会导致工作效率很差。在分布式的版本系统中，没有所谓的中央服务器，每个人的电脑上有个完整的版本库，这样就可以在不联网的状态下工作了。在多人协作的时候，每个人将自己修改的代码推送给所有的团队成员。当然为了管理的方便，也可以设置一个服务器，用于方便团队成员交换意见。在分布式管理的模式下也可以避免服务器的崩溃而导致所有文件的丢失，增加了系统的健壮性。

-----
### git的安装 ###
可以通过sudo apt-get install git直接安装，也可以下载源码，然后./config, make, sudo make install来执行安装。安装完成后通过

```
$ git config --global user.name "Your Name"
$ git config --global user.email "email@example.com"
```

来对其进行设置。这表示这台机器上的所有仓库都会使用这个设置。

----
### 创建版本库 ###
创建一个目录，然后git init就会在该目录下创建一个.git文件，用来跟踪和管理版本库。在创建版本库之后就可以向该版本库中添加文件了，
```git add (file or directory)```  #将新文件添加到stage（暂存区）中
```git commit -m "here is commit information"```  #将stage中的文件提交到版本库。
```git status ```查看当前版本库的状态，是否有修改后未提交的文件
```git log ```查看提交历史
```git reset --hard (commit id)``` 回退到之前的版本
```git rm test.txt ; git commit -m "rm file"```从git版本库中删除文件

---
### git远程仓库 ###
我们可以首先在github上注册一个帐号，由github来充当项目服务器的角色，不过github上的代码都是公开的。为了防止他人想你的github胡乱提交，你首先需要在github中加入你自己的ssh公钥。公钥的生成方式：
ssh-keygen -t rsa -C "youremail@example.com"
在用户主目录里找到.ssh目录，里面有id_rsa和id_rsa.pub两个文件，这两个就是SSH Key的秘钥对，id_rsa是私钥，id_rsa.pub是公钥.将公钥添加到github中，就可以通过本台PC向github提交代码了。我们首先在github上创建一个repository，在本地库中运行
```$ git remote add origin git@github.com:GaoShawn/gittest.git``` 建立一个远程库origin，指向git@github.com:GaoShawn/gittest.git;
```$ git push -u origin master ```将本地库中的分支（文件）上传到远程库中，我们第一次推送master分支时，加上了-u参数，Git不但会把本地的master分支内容推送的远程新的master分支，还会把本地的master分支和远程的master分支关联起来，在以后的推送或者拉取时就可以简化命令。
在之后，文件发生了修改并提交本地库之后只需要运行$ git push origin master就可以上传远程库了

---
### git分支管理 ###
git分支是在当前的工作区间的主分支上分离出来的，一般可以在分支上工作，当工作达到某个阶段或完成的时候在合并到主分支中。
查看分支：```git branch```
创建分支：```git branch <name>```
切换分支：```git checkout <name>```
创建+切换分支：```git checkout -b <name>```
合并某分支到当前分支：```git merge <name>```
切换分支：```git checkout master```
删除分支：```git branch -d <name>```
保存当前分支内容并创建新的分支的过程： git stash:保存当前分支 git stach list：显示保存的分支的状态 git stash apply恢复一个分支的内容 git stach drop删除保存的分支

----
### 多人协作 ###
多人协作的时候一般在dev分支或feature分支上操作，可以使用命令git checkout -b dev origin/dev 建立当前分支与远程库dev分支的映射关系
```git pull origin dev```来获取远程的dev分支

----
### 标签管理 ###
发布一个版本时，我们通常先在版本库中打一个标签，这样，就唯一确定了打标签时刻的版本。将来无论什么时候，取某个标签的版本，就是把那个打标签的时刻的历史版本取出来。所以，标签也是版本库的一个快照。
创建标签： ```git tag v0.0``` 默认为HEAD，也可以指定一个commit id；
显示标签： ```git tag```
创建标签时添加版本信息： g```it tag -a v0.1 -m "version 0.1 released" commitId```
将本地标签推送到远程： ```git push origin v1.0``` 或者使用 ```git push origin --tags```将本地所有的未同步的标签推送到远程




