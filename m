From: Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 003/152] jbd: fix commit of ordered data buffers
Date: Fri, 29 Sep 2006 12:20:26 -0700
Message-ID: <20060929122026.62ec29eb.akpm@osdl.org>
References: <200609260630.k8Q6UrvQ011999@shell0.pdx.osdl.net>
	<451C4DDE.60307@us.ibm.com>
	<20060929090253.GA17124@atrey.karlin.mff.cuni.cz>
	<1159546306.8780.2.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, torvalds@osdl.org, stable@kernel.org,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:12948 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1422657AbWI2TWU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Sep 2006 15:22:20 -0400
To: Badari Pulavarty <pbadari@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1159546306.8780.2.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 29 Sep 2006 09:11:46 -0700
Badari Pulavarty <pbadari@us.ibm.com> wrote:

> On Fri, 2006-09-29 at 11:02 +0200, Jan Kara wrote:
> ...
> > > >+		}
> > > >+		/* Someone already cleaned up the buffer? */
> > > >+		if (!buffer_jbd(bh)
> > > >+			|| jh->b_transaction != commit_transaction
> > > >+			|| jh->b_jlist != BJ_SyncData) {
> > > >+			jbd_unlock_bh_state(bh);
> > > >+			if (locked)
> > > >+				unlock_buffer(bh);
> > > >+			BUFFER_TRACE(bh, "already cleaned up");
> > > >+			put_bh(bh);
> > > >+			continue;
> >    ---> Here the buffer was refiled by someone else
> 
> I am little concerned about this particular code. We know that
> some one else will do the unfile/remove - but we will keep
> spinning on it till that happens. Isn't it ? Why don't we
> skip it and move to next one ?

That check looks OK to me.  Either

a) the buffer has been taken off the journal altogether or

b) it's been moved to the running transaction or

c) it's jounalled, it's ont he committing transaction but it's not on
   t_sync_datalist any more.

So it shouldn't be possible for that buffer to be on
commit_transaction->t_sync_datalist.

> We are seeing few following message while running tests and
> wondering if your patch is causing it ..
> 
> BUG: spinlock lockup on CPU#1, scp/30189, c00000000fb503d8 (Not tainted)
> Call Trace:
> [C000000018FDB320] [C0000000000102E0] .show_stack+0x68/0x1b0 (unreliable)
> [C000000018FDB3C0] [C0000000001734F4] ._raw_spin_lock+0x138/0x184
> [C000000018FDB460] [C00000000025AD24] ._spin_lock+0x10/0x24
> [C000000018FDB4E0] [D000000000172E14] .journal_dirty_data+0xa4/0x2c0 [jbd]
> [C000000018FDB580] [D000000000205BAC] .ext3_journal_dirty_data+0x28/0x70 [ext3]
> [C000000018FDB610] [D0000000002048BC] .walk_page_buffers+0xb0/0x134 [ext3]
> [C000000018FDB6D0] [D000000000208280] .ext3_ordered_commit_write+0x74/0x114 

Presumably j_list_lock got stuck.  What we really need to see here is
the backtrace from other CPUs.

gad, there have been so many all-CPU-backtrace patches over the years.

<optimistically cc's Ingo>

Ingo, do you think that's something which we shuld have in the spinlock
debugging code?  A trace to let us see which CPU is holding that lock,
and where from?  I guess if the other cpu is stuck in spin_lock_irqsave()
then we'll get stuck delivering the IPI, so it'd need to be async.


