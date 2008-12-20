From: Matteo Croce <technoboy85@gmail.com>
Subject: Massive filesystem corruption
Date: Sat, 20 Dec 2008 19:14:43 +0100
Message-ID: <200812201914.43614.technoboy85@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:13126 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbYLTSOu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Dec 2008 13:14:50 -0500
Received: by ey-out-2122.google.com with SMTP id 22so141576eye.37
        for <linux-ext4@vger.kernel.org>; Sat, 20 Dec 2008 10:14:48 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
i've lost my ext4 partition with a 2.6.27 vanilla kernel:

root@ubuntu:~# mount -t ext4dev /dev/sda1 /mnt
mount: wrong fs type, bad option, bad superblock on /dev/sda1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

root@ubuntu:~# dmesg | tail -1
[ 4874.514703] VFS: Can't find ext4 filesystem on dev sda1.
root@ubuntu:~# e2fsck /dev/sda1
e2fsck 1.41.3 (12-Oct-2008)
e2fsck: Superblock invalid, trying backup blocks...
/dev/sda1 was not cleanly unmounted, check forced.
Pass 1: Checking inodes, blocks, and sizes
Error1: Corrupt extent header on inode 107192
Aborted (core dumped)
root@ubuntu:~# gdb -q --args e2fsck /dev/sda1
(gdb) run
Starting program: /sbin/e2fsck /dev/sda1
[Thread debugging using libthread_db enabled]
e2fsck 1.41.3 (12-Oct-2008)
/sbin/e2fsck: Superblock invalid, trying backup blocks...
/dev/sda1 was not cleanly unmounted, check forced.
Pass 1: Checking inodes, blocks, and sizes
Error1: Corrupt extent header on inode 107192
[New Thread 0xb7e46700 (LWP 12878)]

Program received signal SIGABRT, Aborted.
[Switching to Thread 0xb7e46700 (LWP 12878)]
0xb8031430 in __kernel_vsyscall ()
(gdb) backtrace
#0  0xb8031430 in __kernel_vsyscall ()
#1  0xb7e8c880 in raise () from /lib/tls/i686/cmov/libc.so.6
#2  0xb7e8e248 in abort () from /lib/tls/i686/cmov/libc.so.6
#3  0x0805397b in scan_extent_node (ctx=0x9193038, pctx=0xbf830d7c, 
pb=0xbf830c5c, start_block=0, ehandle=0x91b8170) at 
/build/buildd/e2fsprogs-1.41.3/e2fsck/pass1.c:1700
#4  0x08054c02 in check_blocks (ctx=0x9193038, pctx=0xbf830d7c, 
block_buf=0x91acff0 "\225\"\005") at 
/build/buildd/e2fsprogs-1.41.3/e2fsck/pass1.c:1773
#5  0x080565ca in e2fsck_pass1 (ctx=0x9193038) at 
/build/buildd/e2fsprogs-1.41.3/e2fsck/pass1.c:1030
#6  0x08050063 in e2fsck_run (ctx=0x9193038) at 
/build/buildd/e2fsprogs-1.41.3/e2fsck/e2fsck.c:215
#7  0x0804e4b8 in main (argc=Cannot access memory at address 0x324e
) at /build/buildd/e2fsprogs-1.41.3/e2fsck/unix.c:1278
(gdb)

please if you know how can I read, fix or debug it answer in a reasonable time,
i need that disk space and i'll format it in a few days
