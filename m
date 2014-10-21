From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: A very similar crash on ext2
Date: Mon, 20 Oct 2014 17:28:32 -0700
Message-ID: <20141021002832.GC13081@birch.djwong.org>
References: <20141005001239.GD27150@sli.dy.fi>
 <20141007205643.GF27150@sli.dy.fi>
 <20141009201541.GG27150@sli.dy.fi>
 <20141009204913.GA9620@birch.djwong.org>
 <20141009212802.GH27150@sli.dy.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Sami Liedes <sami.liedes@iki.fi>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26963 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaJUA2u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Oct 2014 20:28:50 -0400
Content-Disposition: inline
In-Reply-To: <20141009212802.GH27150@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 10, 2014 at 12:28:02AM +0300, Sami Liedes wrote:
> On Thu, Oct 09, 2014 at 01:49:13PM -0700, Darrick J. Wong wrote:
> > Yeah.  There's a directory that's linked twice (inode 195).  The subsequent FS
> > walk loads the inode into memory twice (== i_count > 2).  When you delete
> > everything on the FS, the inode gets put on the in-memory orphan list but for
> > whatever reason doesn't seem to get released via iput or something.  This means
> > it's still on the orphan list at umount time, which triggers the BUG.  Worse
> > yet, i_nlink is now 0...
> > 
> > ...not clear what the appropriate course of action is here.  The FS is corrupt
> > and we need to scrape the mess off the machine.  I guess you could -EIO earlier
> > when you notice i_count > i_nlink?
> 
> I don't know if this is exactly the same bug, but I'm also seeing a
> similar crash on ext2 which also bisected to this exact same commit
> (908790fa3b). The symptoms are a bit different, though; first a VFS
> warning about busy inodes after unmount, then shortly after that a
> crash.

ext4 spits up that crash message on umount because it thinks the orphan list is
messed up... but seems to avoid blowing up.

ext2 doesn't know what an orphan list is, so it goes straight to
the VFS warning and then blows up later, probably because it tries to do
something with the (now torn down) ext2 sb.

<shrug> I had a patch that would detect rmdir of multiply linked dirs, but I
think we ought to catch that sooner, if possible.

--D

> Pristine fs: http://www.niksula.hut.fi/~sliedes/ext2/testimg.ext2.bz2
> 
> Broken fs: http://www.niksula.hut.fi/~sliedes/ext2/testimg.ext2.449.min.bz2
> 
> Diff:
> 
> --- /dev/fd/63  2014-10-10 00:20:59.562913594 +0300
> +++ /dev/fd/62  2014-10-10 00:20:59.562913594 +0300
> @@ -9785,6 +9785,8 @@
>  0080a8f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 80  |................|
>  0080a900  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
>  *
> +0080ac20  ff ff ff ff ff ff ff ff  ff ff ff fd ff ff ff ff  |................|
> +0080ac30  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
>  0080ac40  ff ff 01 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>  0080ac50  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>  *
> 
> Backtrace:
> 
> [    1.422976] VFS: Busy inodes after unmount of vdb. Self-destruct in 5 seconds.  Have a nice day...
> [    1.857020] BUG: unable to handle kernel NULL pointer dereference at 0000000000000197
> [    1.858178] IP: [<ffffffff810a0859>] __lock_acquire.isra.31+0x199/0xd70
> [    1.859047] PGD 633a067 PUD 5171067 PMD 0
> [    1.859524] Oops: 0002 [#1] SMP
> [    1.859842] CPU: 0 PID: 59 Comm: kworker/u2:1 Not tainted 3.16.0+ #94
> [    1.860068] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.860068] Workqueue: writeback bdi_writeback_workfn (flush-254:16)
> [    1.860068] task: ffff8800060f2060 ti: ffff880006104000 task.ti: ffff880006104000
> [    1.860068] RIP: 0010:[<ffffffff810a0859>]  [<ffffffff810a0859>] __lock_acquire.isra.31+0x199/0xd70
> [    1.860068] RSP: 0018:ffff880006107b28  EFLAGS: 00010086
> [    1.860068] RAX: 0000000000000000 RBX: ffff8800060f2060 RCX: 0000000000000001
> [    1.860068] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8800051cb0c8
> [    1.860068] RBP: ffff880006107b90 R08: 0000000000000000 R09: 0000000000000000
> [    1.860068] R10: ffff8800051cb0c8 R11: 0000000000000003 R12: 0000000000000001
> [    1.860068] R13: 0000000000000001 R14: ffffffffffffffff R15: 0000000000000000
> [    1.860068] FS:  0000000000000000(0000) GS:ffff880007c00000(0000) knlGS:0000000000000000
> [    1.860068] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    1.860068] CR2: 0000000000000197 CR3: 000000000517c000 CR4: 00000000000006b0
> [    1.860068] Stack:
> [    1.860068]  ffff880006107b88 ffff8800060f2770 ffffffff81170027 0000000000000096
> [    1.860068]  0000000000000000 0000000000000000 ffff8800060f2770 000000000000003d
> [    1.860068]  0000000000000286 0000000000000000 0000000000000001 0000000000000001
> [    1.860068] Call Trace:
> [    1.860068]  [<ffffffff81170027>] ? SyS_sysfs+0xf7/0x1e0
> [    1.860068]  [<ffffffff810a1c46>] lock_acquire+0x96/0x130
> [    1.860068]  [<ffffffff81152aaf>] ? grab_super_passive+0x3f/0x90
> [    1.860068]  [<ffffffff8109e079>] down_read_trylock+0x59/0x60
> [    1.860068]  [<ffffffff81152aaf>] ? grab_super_passive+0x3f/0x90
> [    1.860068]  [<ffffffff81152aaf>] grab_super_passive+0x3f/0x90
> [    1.860068]  [<ffffffff8117c837>] __writeback_inodes_wb+0x57/0xd0
> [    1.860068]  [<ffffffff8117caeb>] wb_writeback+0x23b/0x320
> [    1.860068]  [<ffffffff8117ceed>] bdi_writeback_workfn+0x1cd/0x470
> [    1.860068]  [<ffffffff8107bf90>] process_one_work+0x1c0/0x580
> [    1.860068]  [<ffffffff8107bf27>] ? process_one_work+0x157/0x580
> [    1.860068]  [<ffffffff8107c3b3>] worker_thread+0x63/0x540
> [    1.860068]  [<ffffffff8107c350>] ? process_one_work+0x580/0x580
> [    1.860068]  [<ffffffff81081b81>] kthread+0xf1/0x110
> [    1.860068]  [<ffffffff81081a90>] ? __kthread_parkme+0x70/0x70
> [    1.860068]  [<ffffffff81850f2c>] ret_from_fork+0x7c/0xb0
> [    1.860068]  [<ffffffff81081a90>] ? __kthread_parkme+0x70/0x70
> [    1.860068] Code: 0b 00 00 48 c7 c7 25 cd c8 81 31 c0 e8 31 4a fc ff eb a7 0f 1f 80 00 00 00 00 44 89 f8 4d 8b 74 c2 08 4d 85 f6 0f 84 c2 fe ff ff <3e> 41 ff 86 98 01 00 00 8b 05 f1 57 96 01 44 8b bb 90 06 00 00
> [    1.860068] RIP  [<ffffffff810a0859>] __lock_acquire.isra.31+0x199/0xd70
> [    1.860068]  RSP <ffff880006107b28>
> [    1.860068] CR2: 0000000000000197
> [    1.860068] ---[ end trace 3d3d835bcb59d5fe ]---
> [    1.860068] Kernel panic - not syncing: Fatal exception
> [    1.860068] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
> [    1.860068] Rebooting in 1 seconds..
> 
> 	Sami
> 
> 
> > > 
> > > # first bad commit: [908790fa3b779d37365e6b28e3aa0f6e833020c3] dcache: d_splice_alias mustn't create directory aliases
> > > 
> > > commit 908790fa3b779d37365e6b28e3aa0f6e833020c3
> > > Author: J. Bruce Fields <bfields@redhat.com>
> > > Date:   Mon Feb 17 17:58:42 2014 -0500
> > > 
> > >     dcache: d_splice_alias mustn't create directory aliases
> > > 
> > >     Currently if d_splice_alias finds a directory with an alias that is not
> > >     IS_ROOT or not DCACHE_DISCONNECTED, it creates a duplicate directory.
> > > 
> > >     Duplicate directory dentries are unacceptable; it is better just to
> > >     error out.
> > > 
> > >     (In the case of a local filesystem the most likely case is filesystem
> > >     corruption: for example, perhaps two directories point to the same child
> > >     directory, and the other parent has already been found and cached.)
> > > 
> > >     Note that distributed filesystems may encounter this case in normal
> > >     operation if a remote host moves a directory to a location different
> > >     from the one we last cached in the dcache.  For that reason, such
> > >     filesystems should instead use d_materialise_unique, which tries to move
> > >     the old directory alias to the right place instead of erroring out.
> > > 
> > >     Signed-off-by: J. Bruce Fields <bfields@redhat.com>
> > >     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > > 
> > > -- 
> > > 
> > > 	Sami
> > 
> > 


