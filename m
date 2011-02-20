From: Ted Ts'o <tytso@mit.edu>
Subject: Re: fsck performance.
Date: Sun, 20 Feb 2011 12:09:31 -0500
Message-ID: <20110220170931.GB3017@thunk.org>
References: <20110220090656.GA11402@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40348 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab1BTRJd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Feb 2011 12:09:33 -0500
Content-Disposition: inline
In-Reply-To: <20110220090656.GA11402@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 20, 2011 at 10:06:56AM +0100, Rogier Wolff wrote:
> Debian apparently recently pointed that to the new release squeeze, so
> I got upgraded. I went from kernel 2.6.26 to 2.6.32. After about a day
> my system rebooted without my consent. So now it's running 2.6.32.
> 
> Since then I'm getting kernel-oops-lookalikes that start with:
> [71664.306573] swapper: page allocation failure. order:5, mode:0x4020

That's a warning which has been suppressed in newer kernels.  Ext4
falls back to vmalloc() if kmalloc() fails, and sometime in the early
2.6.3x kernels the kernel started warning on huge kmalloc failures,
without having a way of suppressing those errors.  That's a cosmetic
issue which has been fixed.  (It should only be happening at when an
ext4 file system is being mounted, right?)

> Anyway, upon boot into the new kernel ext3 printed abunch of these: 
> [    5.212119] ext3_orphan_cleanup: deleting unreferenced inode 1335743

That's normal if you didn't cleanly umount the file system before
reporting, and there were files that were still open, but deleted at
the time of the crash.

> A few hours later, my storage partition was marked read-only and the
> backups started failing.
> 
> kern.log.1.gz:Feb 18 05:39:53 driepoot kernel: [10328.424778] 
>   EXT3-fs error (device md3): ext3_lookup: deleted inode referenced: 277447722

That's not normal.  :-)

> fcntl64(6, F_SETLKW, {type=F_WRLCK, whence=SEEK_SET, start=164, len=1}) = 0
> fcntl64(6, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=164, len=1}) = 0
>
> So, my question is: Are these fcntl calls neccesary? 
> As far as I know locking is neccesary if another process might be 
> handling the same data. Here is is doing this with the cache 
> files: 
> 
> lrwx------ 1 root root 64 Feb 20 09:28 5 -> 
>        /var/cache/e2fsck/123a1cfe-2455-4646-aa32-87492ed1ac97-icount-ayxVou
> lrwx------ 1 root root 64 Feb 20 09:28 6 -> 
>        /var/cache/e2fsck/123a1cfe-2455-4646-aa32-87492ed1ac97-dirinfo-rBBTtb

Ah, you're using tdb.  Tdb can be really slow.  It's been on my todo
list to replace tdb with something else, but I haven't gotten around
to it.

No, it shouldn't be necessary given that e2fsck is the only user of
the tdb files.  I'll need to look at trying to remove them, but I'm
not sure that would really improve the speed.

						- Ted
