From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/5] jbd2: Avoid unnecessary locking when buffer is
 already journaled
Date: Thu, 16 Apr 2015 12:46:19 +0200
Message-ID: <20150416104619.GA16510@quack.suse.cz>
References: <1427983100-29889-1-git-send-email-jack@suse.cz>
 <87a8ydfyk5.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>
To: Dmitry Monakhov <dmonlist@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49454 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757027AbbDPKqZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Apr 2015 06:46:25 -0400
Content-Disposition: inline
In-Reply-To: <87a8ydfyk5.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 12-04-15 14:09:14, Dmitry Monakhov wrote:
> 
> Jan Kara <jack@suse.cz> writes:
> 
> >   Hello,
> >
> >   this patch set improves do_get_write_access(), jbd2_journal_get_undo_access(),
> > and jbd2_journal_dirty_metadata() to be completely lockless in case buffer
> > is already part of an appropriate journalling list. First three patches
> > are independent small cleanups so they can go in right away I think.
> >
> > The other two patches *should* improve the situation for frequent bitmap
> > or inode table block updates. But frankly, I haven't been able to come up
> > with a load where I'd see significant contention on update of a single buffer
> > (or it's hidden by a larger lock). Similarly we could see improvements when
> > do_get_write_access() would be waiting for buffer lock because buffer is
> > being written out by checkpointing code. But again I wasn't able to hit this
> > reliably.
> One of most annoying performance issues was unpredictable latency of aio submission
> This is typical workload on chunk server (object storage, cloud storage,
> ceph) where one some tasks performs  aio/dio submission and other
> performs fsync(). Some times we got this io_submit->touch_mtime()->
> do_get_write_access() observes that jh->b_jlist == BJ_Shadow and wait
> for transaction commit. So aio-dio submission can block (even if file
> was previously allocated) for a long time(1-5sec) on ext3/4
> But this was fixed by 'lazytime' option
  Yeah, my patches don't really help this particular problem. They help the
case where buffer already is part of the running transaction but in your
case we need to move the buffer to the running transaction and that blocks
on buffer being under IO. There isn't much we can do to improve this (well,
we could unconditionally create a frozen buffer for journal IO which would
limit maximum latency but at the cost of memcpy for each journal write so
throughput would suffer in case of faster storage).

								Honza
> 
> #Simplified testcase
> #BAD workload which provoke endless fsync->commit_transaction
> while true; do 
>       xfs_io -c "pwrite -b 1M 1M 32M" \
> 	-f t{1,2,3,5,6,7,8,9,10};
>       xfs_io -c "pwrite -b 1M 1M 1M" -c \
> 	"fsync" -f -d t11
> 
> # Measure aio-dio latency
> [root@alice Z]# uname -a
> Linux alice.qa.sw.ru 4.0.0-rc7+ #13 SMP Sun Apr 12 00:34:51 MSK 2015
> x86_64 x86_64 x86_64 GNU/Linux
> [root@alice Z]# ioping -A  -C -D  -WWW t
> 4.0 KiB from t (ext4 /dev/sdb1): request=1 time=441 us
> ...
> 4.0 KiB from t (ext4 /dev/sdb1): request=12 time=393 us
> 4.0 KiB from t (ext4 /dev/sdb1): request=13 time=2.7 s <---- too long
> 4.0 KiB from t (ext4 /dev/sdb1): request=14 time=397 us
> 4.0 KiB from t (ext4 /dev/sdb1): request=15 time=398 us
> ^C
> --- t (ext4 /dev/sdb1) ioping statistics ---
> 15 requests completed in 17.2 s, 5 iops, 22.0 KiB/s
> min/avg/max/mdev = 384 us / 182.2 ms / 2.7 s / 679.1 ms
> >
> > Ted, you mentioned at Vault you had a setup where frequent
> > do_get_write_access() calls were contending in the revoke code. What was the
> > load exactly? These patches should improve that as well...
> >
> > 								Honza
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
