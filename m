From: Matteo Croce <technoboy85@gmail.com>
Subject: Re: Massive filesystem corruption
Date: Sun, 21 Dec 2008 03:05:49 +0100
Message-ID: <200812210305.49271.technoboy85@gmail.com>
References: <200812201914.43614.technoboy85@gmail.com> <494D471C.8030907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out26.alice.it ([85.33.2.26]:4566 "EHLO
	smtp-out26.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYLUCQT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Dec 2008 21:16:19 -0500
In-Reply-To: <494D471C.8030907@redhat.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Saturday 20 December 2008 20:27:24 Eric Sandeen wrote:
> Matteo Croce wrote:
> > Hi,
> > i've lost my ext4 partition with a 2.6.27 vanilla kernel:
> >
> > root@ubuntu:~# mount -t ext4dev /dev/sda1 /mnt
> > mount: wrong fs type, bad option, bad superblock on /dev/sda1,
> >        missing codepage or helper program, or other error
> >        In some cases useful info is found in syslog - try
> >        dmesg | tail  or so
>
> What happened between the last successful mount and this failure?

A system freeze (mouse hanged etc.)

> > root@ubuntu:~# dmesg | tail -1
> > [ 4874.514703] VFS: Can't find ext4 filesystem on dev sda1.
>
> Was there anything before that?  (i.e. check tail -n 10?)

Nothing relevant, usb loading and other drivers..

> What does the beginning of the fs look like, maybe you can put the first
> 16k or so of a dd somewehre, or run it through hexdump -C, see if
> something else stomped on this partition.

I'll check it

> > root@ubuntu:~# e2fsck /dev/sda1
> > e2fsck 1.41.3 (12-Oct-2008)
> > e2fsck: Superblock invalid, trying backup blocks...
> > /dev/sda1 was not cleanly unmounted, check forced.
> > Pass 1: Checking inodes, blocks, and sizes
> > Error1: Corrupt extent header on inode 107192
> > Aborted (core dumped)
> > root@ubuntu:~# gdb -q --args e2fsck /dev/sda1
> > (gdb) run
> > Starting program: /sbin/e2fsck /dev/sda1
> > [Thread debugging using libthread_db enabled]
> > e2fsck 1.41.3 (12-Oct-2008)
> > /sbin/e2fsck: Superblock invalid, trying backup blocks...
> > /dev/sda1 was not cleanly unmounted, check forced.
> > Pass 1: Checking inodes, blocks, and sizes
> > Error1: Corrupt extent header on inode 107192
> > [New Thread 0xb7e46700 (LWP 12878)]
> >
> > Program received signal SIGABRT, Aborted.
>
> well, this was an explicit abort():
>
>         if (pctx->errcode) {
>                 printf("Error1: %s on inode %u\n",
>                         error_message(pctx->errcode), pctx->ino);
>                 abort();
>         }
>
> ... I guess that error is not handled yet.
>
> can you open the fs with debugfs, and try
>
> debugfs> stat <107192>
>
> and/or
>
> debugfs> dump <107192> /some/path/to/dumpfile
>
> and maybe we can see what's wrong with this inode.  If it's the only one
> then perhaps it can be nuked w/ debugfs and fsck will continue.
>
> -Eric

debugfs is new to me, have you some docs for me to read?
