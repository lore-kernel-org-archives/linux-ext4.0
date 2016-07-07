From: Kamran Khan <krkhan@inspirated.com>
Subject: Cannot umount ext4 fs, no user-space procs using the fs, lsof points
 to jbd2
Date: Thu, 7 Jul 2016 16:38:39 -0700
Message-ID: <CAN0j2-cmXW3wNmjDaKxD9Xd5O+rgyxGevjhFYquiTx92CBRT7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33853 "EHLO
	mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbcGGXil (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jul 2016 19:38:41 -0400
Received: by mail-it0-f66.google.com with SMTP id u186so72957ita.1
        for <linux-ext4@vger.kernel.org>; Thu, 07 Jul 2016 16:38:40 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I am unmounting an ext4 filesystem (Ubuntu 16.04), fuser shows that no
user-space processes are holding a handle to it:

> root@kakhan-ubuntu:/# fuser -vm /oldroot
>                      USER        PID ACCESS COMMAND
> /oldroot:            root     kernel mount /oldroot

lsof gives this:

> root@kakhan-ubuntu:/# lsof | grep sda
> jbd2/sda1  368                  root  cwd       DIR               0,20      340          2 /
> jbd2/sda1  368                  root  rtd       DIR               0,20      340          2 /
> jbd2/sda1  368                  root  txt   unknown                                        /proc/368/exe

If I look into /proc/../mounts I see lots of kernel specific processes
which have /dev/sda1 listed in their mounts:

> root@kakhan-ubuntu:/# find /proc -name mounts | xargs grep /dev/sda1
> /proc/mounts:/dev/sda1 /oldroot ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
> /proc/1/task/1/mounts:/dev/sda1 /oldroot ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
> /proc/1/mounts:/dev/sda1 /oldroot ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
> /proc/2/task/2/mounts:/dev/sda1 /oldroot ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
> /proc/2/mounts:/dev/sda1 /oldroot ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
> /proc/3/task/3/mounts:/dev/sda1 /oldroot ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
> /proc/3/mounts:/dev/sda1 /oldroot ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
> /proc/5/task/5/mounts:/dev/sda1 /oldroot ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
> /proc/5/mounts:/dev/sda1 /oldroot ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
> /proc/7/task/7/mounts:/dev/sda1 /oldroot ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
> # and whole bunch of others ...)

I am unable to unmount the filesystem:

> root@kakhan-ubuntu:/# umount /oldroot
> umount: /oldroot: target is busy
>         (In some cases useful info about processes that
>          use the device is found by lsof(8) or fuser(1).)

Can anyone please provide some pointers on how should I proceed with
unmounting the filesystem?

(Context: I copied binaries into a tmpfs and did a pivot_root to it,
i.e., the opposite of what happens from initramfs during boot. I
killed all the userspace processes holding a handle to the oldroot.
This issue is different than the one I faced a couple of months ago
during the same exercise on CentOS [1], where systemd-udevd needed a
restart to release the handle to the old filesystem. In this case
there's no userspace procs accessing the mountpoint.)

[1] http://permalink.gmane.org/gmane.comp.file-systems.ext4/53314

-- 
Kamran.

http://inspirated.com/
