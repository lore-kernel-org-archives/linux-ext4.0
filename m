From: Dave Chinner <david@fromorbit.com>
Subject: Re: [4.7-rc4] WARNING: CPU: 10 PID: 3359 at fs/inode.c:280
 drop_nlink+0x3e/0x50
Date: Sun, 10 Jul 2016 10:14:16 +1000
Message-ID: <20160710001416.GA1922@dastard>
References: <20160704234633.GE27480@dastard>
 <20160705044524.GE15193@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:36099 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756858AbcGJAVR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Jul 2016 20:21:17 -0400
Content-Disposition: inline
In-Reply-To: <20160705044524.GE15193@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 05, 2016 at 12:45:24AM -0400, Theodore Ts'o wrote:
> On Tue, Jul 05, 2016 at 09:46:33AM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > I just got this warning on boot from a test VM running an ext3
> > root filesystem:
> > 
> > [   14.874951] ------------[ cut here ]------------
> > [   14.876447] WARNING: CPU: 10 PID: 3359 at fs/inode.c:280 drop_nlink+0x3e/0x50
> > [   14.878520] Modules linked in:
> > [   14.880065] CPU: 10 PID: 3359 Comm: mv Not tainted 4.7.0-rc4-dgc+ #821
> > [   14.883062] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
> > [   14.886648]  0000000000000000 ffff8800bad63c90 ffffffff817f1321 0000000000000000
> > [   14.888942]  0000000000000000 ffff8800bad63cd0 ffffffff810b3531 000001183750906c
> > [   14.891613]  ffff8800bb3095b0 ffff8800bad63d48 ffff88033750906c 0000000000000000
> > [   14.893635] Call Trace:
> > [   14.894096]  [<ffffffff817f1321>] dump_stack+0x63/0x82
> > [   14.895387]  [<ffffffff810b3531>] __warn+0xd1/0xf0
> > [   14.896709]  [<ffffffff810b361d>] warn_slowpath_null+0x1d/0x20
> > [   14.898421]  [<ffffffff8121339e>] drop_nlink+0x3e/0x50
> > [   14.899737]  [<ffffffff812d7d7b>] ext4_dec_count.isra.26+0x1b/0x30
> > [   14.901360]  [<ffffffff812dd8a2>] ext4_rename+0x4d2/0x880
> > [   14.903025]  [<ffffffff8177bde8>] ? security_capable+0x48/0x60
> > [   14.904524]  [<ffffffff812ddc6d>] ext4_rename2+0x1d/0x30
> > [   14.905833]  [<ffffffff8120676d>] vfs_rename+0x5fd/0x900
> > [   14.907163]  [<ffffffff81209738>] SyS_rename+0x398/0x3b0
> > [   14.908496]  [<ffffffff81e3c2f2>] entry_SYSCALL_64_fastpath+0x1a/0xa4
> > [   14.910251] ---[ end trace b59a7c09fe84eaba ]---
> 
> Thanks for the report.  I'm pretty sure what happened is that the file
> system was corrupted,

Filesystem checked clean, both before and after, so you're initial
assumption is wrong.

> but ext4_rename() does't have a check to make
> sure i_links_count of the destination inode is non-zero (and to call
> ext4_error() to flag the fs corruption if it is zero).  Specifically,
> I suspect what happened is that there was a file with two hard links,
> but a i_link_count of 1.  Both links were in the dentry cache, and
> then the first link got deleted, leaving the second link still in the
> dentry cache, but with a link count of 0.

Or, more likely,  a dentry cache lookup bug. There was one
introduced in 4.7-rc1 with the parallel lookup code and fixed in
4.7-rc6 that could result in this happening. Funnily enough, XFS hit
this same lookup bug, too, but with different symptoms (triggered
corruption warnings in unlink processing) so it wasn't immiedately
obvious that they had the same root cause.

> How the file system got corrupted is of course a different question,
> but I assume it happened when the VM was forcibly terminated
> beforehand.  How is the root device configured in terms of qemu device
> cacheing?  I don't think we have any corruption after crash problems
> at this point (at least I haven't noticed any of the dm-flaky tests
> failing recently), so my first suspicion is would be how qemu is
> configured 

So, to top off the incorrect assumption, your first suspicion is a
newbie mistake? Really, Ted?

The VM uses "cache="none", which means the responsibility for
correct flushing of the device belongs with the guest OS filesystem,
not qemu. Hence data loss or filesystem corruption on guest crash or
host qemu process kill is a guest OS bug, not a qemu issue....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
