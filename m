From: tytso@mit.edu
Subject: Re: [Jfs-discussion] benchmark results
Date: Sat, 26 Dec 2009 14:19:16 -0500
Message-ID: <20091226191916.GI32757@thunk.org>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
 <19251.26403.762180.228181@tree.ty.sabi.co.uk>
 <20091224212756.GM21594@thunk.org>
 <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
 <20091225161453.GD32757@thunk.org>
 <20091225162238.GB19303@bitmover.com>
 <alpine.DEB.2.01.0912251042540.3483@bogon.housecafe.de>
 <4B36333B.3030600@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Kujau <lists@nerdbynature.de>,
	Larry McVoy <lm@bitmover.com>,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org,
	Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>,
	ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B36333B.3030600@hp.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Dec 26, 2009 at 11:00:59AM -0500, jim owens wrote:
> Christian Kujau wrote:
>  
> > I was using "sync" to make sure that the data "should" be on the disks 
> 
> Good, but not good enough for many tests... info sync
> 
> CONFORMING TO
>        POSIX.2
> 
> NOTES
>        On Linux, sync is only guaranteed to  schedule  the  dirty  blocks  for
>        writing;  it  can  actually take a short time before all the blocks are
>        finally written.
> 
> This is consistent with all the feels-like-unix OSes I have used.

Actually, Linux's sync does more than just schedule the writes; it has
for quite some time:

static void sync_filesystems(int wait)
{
	...
}

SYSCALL_DEFINE0(sync)
{
	wakeup_flusher_threads(0);
	sync_filesystems(0);
	sync_filesystems(1);
	if (unlikely(laptop_mode))
	   laptop_sync_completion();
	   return 0;
}

At least for ext3 and ext4, we will even do a device barrier operation
as a restult of a call to sb->s_op->sync_fs() --- which is called by
__sync_filesystem, which is called in turn by sync_filesystems().
This isn't done for all file systems, though, as near as I can tell.
(Ext2 at least doesn't.)

But for quite some time, under Linux the sync(2) system call will wait
for the blocks to be flushed out to HBA, although we currently don't
wait for the blocks to have been committed to the platters (at least
not for all file systems).   

Applications shouldn't depend on this, of course, since POSIX and
other legacy Unix systems don't guarantee this.  But in terms of
knowing what Linux does, the man page is a bit out of date.

Best regards,

					- Ted

