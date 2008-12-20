From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Massive filesystem corruption
Date: Sat, 20 Dec 2008 13:27:24 -0600
Message-ID: <494D471C.8030907@redhat.com>
References: <200812201914.43614.technoboy85@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Matteo Croce <technoboy85@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60035 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbYLTT1b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Dec 2008 14:27:31 -0500
In-Reply-To: <200812201914.43614.technoboy85@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Matteo Croce wrote:
> Hi,
> i've lost my ext4 partition with a 2.6.27 vanilla kernel:
> 
> root@ubuntu:~# mount -t ext4dev /dev/sda1 /mnt
> mount: wrong fs type, bad option, bad superblock on /dev/sda1,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so

What happened between the last successful mount and this failure?

> root@ubuntu:~# dmesg | tail -1
> [ 4874.514703] VFS: Can't find ext4 filesystem on dev sda1.

Was there anything before that?  (i.e. check tail -n 10?)

What does the beginning of the fs look like, maybe you can put the first
16k or so of a dd somewehre, or run it through hexdump -C, see if
something else stomped on this partition.

> root@ubuntu:~# e2fsck /dev/sda1
> e2fsck 1.41.3 (12-Oct-2008)
> e2fsck: Superblock invalid, trying backup blocks...
> /dev/sda1 was not cleanly unmounted, check forced.
> Pass 1: Checking inodes, blocks, and sizes
> Error1: Corrupt extent header on inode 107192
> Aborted (core dumped)
> root@ubuntu:~# gdb -q --args e2fsck /dev/sda1
> (gdb) run
> Starting program: /sbin/e2fsck /dev/sda1
> [Thread debugging using libthread_db enabled]
> e2fsck 1.41.3 (12-Oct-2008)
> /sbin/e2fsck: Superblock invalid, trying backup blocks...
> /dev/sda1 was not cleanly unmounted, check forced.
> Pass 1: Checking inodes, blocks, and sizes
> Error1: Corrupt extent header on inode 107192
> [New Thread 0xb7e46700 (LWP 12878)]
> 
> Program received signal SIGABRT, Aborted.

well, this was an explicit abort():

        if (pctx->errcode) {
                printf("Error1: %s on inode %u\n",
                        error_message(pctx->errcode), pctx->ino);
                abort();
        }

... I guess that error is not handled yet.

can you open the fs with debugfs, and try

debugfs> stat <107192>

and/or

debugfs> dump <107192> /some/path/to/dumpfile

and maybe we can see what's wrong with this inode.  If it's the only one
then perhaps it can be nuked w/ debugfs and fsck will continue.

-Eric
