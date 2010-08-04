From: Ted Ts'o <tytso@mit.edu>
Subject: Crash after umount'ing a disconnected disk (Re: extfs reliability)
Date: Wed, 4 Aug 2010 14:03:25 -0400
Message-ID: <20100804180325.GL9453@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Vladislav Bolkhovitin <vst@vlnb.net>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40125 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757039Ab0HDSD3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Aug 2010 14:03:29 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ping?

Have you had a chance to check out whether this patch solves the
problem you were complaining with respect to yanking out the last
iSCSI or FC link to a hard drive, and then umounting the disk
afterwards?

If you could try it out, I would really appreciate it.

       	     	    	   	 - Ted


On Thu, Jul 29, 2010 at 02:58:49PM -0400, Ted Ts'o wrote:
> OK, I've looked at your kernel messages, and it looks like the problem
> comes from this:
> 
> 	/* Debugging code just in case the in-memory inode orphan list
> 	 * isn't empty.  The on-disk one can be non-empty if we've
> 	 * detected an error and taken the fs readonly, but the
> 	 * in-memory list had better be clean by this point. */
> 	if (!list_empty(&sbi->s_orphan))
> 		dump_orphan_list(sb, sbi);
> 	J_ASSERT(list_empty(&sbi->s_orphan));   <====
> 
> This is a "should never happen situation", and we crash so we can
> figure out how we got there.  For production kernels, arguably it
> would probably be better to print a message and a WARN_ON(1), and then
> not force a crash from a BUG_ON (which is what J_ASSERT is defined to
> use).
> 
> Looking at your messages and the ext4_delete_inode() warning, I think
> I know what caused it.  Can you try this patch (attached below) and
> see if it fixes things for you?
> 
> > I already reported such issues some time ago, but my reports were
> > not too much welcomed, so I gave up. Anyway, anybody can easily do
> > my tests at any time.
> 
> My apologies.  I've gone through the linux-ext4 mailing list logs, and
> I can't find any mention of this problem from any username @vlnb.net.
> I'm not sure where you reported it, and I'm sorry we dropped your bug
> report.  All I can say is that we do the best that we can, and our
> team is relatively small and short-handed.
> 
> 							- Ted
> 
> From a190d0386e601d58db6d2a6cbf00dc1c17d02136 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Thu, 29 Jul 2010 14:54:48 -0400
> Subject: [PATCH] patch explicitly-drop-inode-from-orphan-list-on-ext4_delete_inode-failure
> 
> ---
>  fs/ext4/inode.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index a52d5af..533b607 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -221,6 +221,7 @@ void ext4_delete_inode(struct inode *inode)
>  				     "couldn't extend journal (err %d)", err);
>  		stop_handle:
>  			ext4_journal_stop(handle);
> +			ext4_orphan_del(NULL, inode);
>  			goto no_delete;
>  		}
>  	}
> -- 
> 1.7.0.4
> 
