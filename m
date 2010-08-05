From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC v2] ext4: Don't send extra barrier during fsync if there
 are no dirty pages.
Date: Thu, 5 Aug 2010 12:40:08 -0400
Message-ID: <20100805164008.GH2901@thunk.org>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com>
 <1272934667.2544.3.camel@mingming-laptop>
 <4BE02C45.6010608@redhat.com>
 <1273002566.3755.10.camel@mingming-laptop>
 <20100629205102.GM15515@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36457 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab0HEQkM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Aug 2010 12:40:12 -0400
Content-Disposition: inline
In-Reply-To: <20100629205102.GM15515@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 29, 2010 at 01:51:02PM -0700, Darrick J. Wong wrote:
> 
> This second version of the patch uses the inode state flags and
> (suboptimally) also catches directio writes.  It might be a better
> idea to try to coordinate all the barrier requests across the whole
> filesystem, though that's a bit more difficult.

Hi Darrick,

When I looked at this patch more closely, and thought about it hard,
the fact that this helps the FFSB mail server benchmark surprised me,
and then I realized it's because it doesn't really accurately emulate
a mail server at all.  Or at least, not a MTA.  In a MTA, only one CPU
will touch a queue file, so there should never be a case of a double
fsync to a single file.  This is why I was thinking about a
coordinating barrier requests across the whole filesystem --- it helps
out in the case where you have all your CPU threads hammering
/var/spool/mqueue, or /var/spool/exim4/input, and where they are all
creating queue files, and calling fsync() in parallel.  This patch
won't help that case.

It will help the case of a MDA --- Mail Delivery Agent --- if you have
multiple e-mails all getting delivered at the same time into the same
/var/mail/<username> file, with an fsync() following after a mail
message is appended to the file.  This is a much rarer case, and I
can't think of any other workload where you will have multiple
processes racing against each other and fsync'ing the same inode.
Even in the MDA case, it's rare that you will have one mbox getting so
many deliveries that this case would be hit.

So while I was thinking about accepting this patch, I now find myself
hesitating.  There _is_ a minor race in the patch that I noticed,
which I'll point out below, but that's easily fixed.  The bigger issue
is it's not clear this patch will actually make a difference in the
real world.  I trying and failing to think of a real-life application
which is stupid enough to do back-to-back fsync commands, even if it's
because it has multiple threads all trying to write to the file and
fsync to it in an uncoordinated fashion.  It would be easily enough to
add instrumentation that would trigger a printk if the patch optimized
out a barrier --- and if someone can point out even one badly written
application --- whether it's mysql, postgresql, a GNOME or KDE
application, db2, Oracle, etc., I'd say sure.  But adding even a tiny
amount of extra complexity for something which is _only_ helpful for a
benchmark grates against my soul....

So if you can think of something, please point it out to me.  If it
would help ext4 users in real life, I'd be all for it.  But at this
point, I'm thinking that perhaps the real issue is that the mail
server benchmark isn't accurately reflecting a real life workload.

Am I missing something?

						- Ted

> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 592adf2..96625c3 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -130,8 +130,11 @@ int ext4_sync_file(struct file *file, int datasync)
>  			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL,
>  					NULL, BLKDEV_IFL_WAIT);
>  		ret = jbd2_log_wait_commit(journal, commit_tid);
> -	} else if (journal->j_flags & JBD2_BARRIER)
> +	} else if (journal->j_flags & JBD2_BARRIER &&
> +		   ext4_test_inode_state(inode, EXT4_STATE_DIRTY_DATA)) {
>  		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL,
>  			BLKDEV_IFL_WAIT);
> +		ext4_clear_inode_state(inode, EXT4_STATE_DIRTY_DATA);
> +	}
>  	return ret;

This is the minor race I was talking about; you should move the
ext4_clear_inode_state() call above blkdev_issue_flush().  If there is
a race, you want to fail safe, by accidentally issuing a second
barrier, instead of possibly skipping a barrier if a page gets dirtied
*after* the blkdev_issue_flush() has taken effect, but *before* we
have a chance to clear the EXT4_STATE_DIRTY_DATA flag.

BTW, my apologies for not looking at this sooner, and giving you this
feedback earlier.  This summer has been crazy busy, and I didn't have
time until the merge window provided a forcing function to look at
outstanding patches.
