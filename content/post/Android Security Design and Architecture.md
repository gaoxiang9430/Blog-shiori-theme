+++
date = "2017-01-02T21:45:10+08:00"
draft = true
title = "Android Security Design and Architecture"
tags = [ "Android", "Architecture", "blog" ]
+++

The android architecture consists of five main layers, including Android application, Android Framework, Dalvik virtual machine, user-space native code and Linux kernel. The first two layers are developed in java, and executed in Dalvik virtual machine(DVM). DVM is a register-based VM that interprets the Dalvik Executable(DEX) byte code format. In turn, DVM relies on the functionalities provided by a number of supporting native code libraries. The user-space native code components include system services such as DBus, networking services such as dhcpd, supporting libraries such as WebKit and OpenSSL. Android made numerous additions and changes to the linux kernel source tree such as Binder drivers and camera access, Wifi access and so on.

-------
#### Permission Model ####

Android operating system utilizes two separate, but cooperating permissions models. At the low level, the linux kernel enforces permission using user and group, which control the access to file entries as well as other specific resources. The Android runtime, by way of DalvikVM and framework enforces the second model. This model defines the app permission that limit the abilities of Android application. Some permission in the second model actually map directly to specific users and groups underlying operating system.
In the low level, each android app has a unique user ID. Actually, Android defines a map of names to unique identifiers known as Android ISs(AIDs) which map to both UID and GID. If a app get a permission such as locatio access, its UID will be added into the corresponding GID.

-------
#### Application Layer ####

Application are typically broken into two categories: pre-installed and user-installed. Pre-installed applications reside in the /system/app directory. Some of these may have elevated privileges or capabilities. User-installed app resides in /data/app directory.
Android uses public-key cryptography for several perposes. First, Android uses a special platform key to sign per-installed app. Applications signed in this key are special in that they can have system user privileges. Next, third-party application are signed with keys generated by individual developers. Android uses signature to prevent unauthorized app updates and control communication bewteen different apps.

--------
#### DVM ####

As a register-based machine, DVM has about 64000 virtual registers. These registers are simply designated memory location that simulate the register functionality of microprocessors. DVM is specially designed for the constraints imposed by an embedded system, such as low memory and processor speed. Therefore, DVM is designed with speed and efficiency in mind.
Similar to Java VM, the DVM interfaces with lower-level native code using Java Native Interface(JNI). This bit of functionality allows both calling from Dalvik code into native code and vice versa.
zygote is the first process started when an Android device boots. And this process is responsible for starting additional services and loading libraries used by the framework.

------
#### User-space Native Code ####
Native code, in operating system user-space, comprises a large portion of Android. This layer is comprised of two primary groups of components: libraries and core system services. Those libraries include SQLite, WebKit, FreeType and so on. As for the services, it ranges from those that initialize user-space such as init, to providing crucial debugging functionality, such as adbd and debuggerd.