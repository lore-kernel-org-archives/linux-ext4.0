From: Seiji Aguchi <seiji.aguchi@hds.com>
Subject: RE: [PATCH][RESEND]tracepoint: add
 drop_transaction/update_superblock_end to jbd2
Date: Mon, 6 Feb 2012 14:59:51 -0500
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2DAC58F1FB@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5839432C@USINDEVS01.corp.hds.com>
 <alpine.LFD.2.00.1201240806500.5204@dhcp-27-109.brq.redhat.com>
 <alpine.LFD.2.00.1201300719510.7517@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "dle-develop@lists.sourceforge.net"
	<dle-develop@lists.sourceforge.net>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"jack@suse.cz" <jack@suse.cz>,
	Satoru Moriya <satoru.moriya@hds.com>,
	"lczerner@redhat.com" <lczerner@redhat.com>
To: "tytso@mit.edu" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from usindpps03.hds.com ([207.126.252.16]:48729 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab2BFUCQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Feb 2012 15:02:16 -0500
In-Reply-To: <alpine.LFD.2.00.1201300719510.7517@dhcp-27-109.brq.redhat.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Ted,

I explain the reason why this patch is needed.
Tracepoints of drop_transaction and update_superblock are missing from jbd2 even though
They are in jbd.

When our customers migrate their file system from ext3 to ext4 and some issues happen in jbd2,
we may not diagnose it even though we could do it in ext3 system.

It seems like a regression for our customers.

This patch is important for us. 
Please give us some feedback.

Seiji

-----Original Message-----
From: Lukas Czerner [mailto:lczerner@redhat.com] 
Sent: Monday, January 30, 2012 1:21 AM
To: Lukas Czerner
Cc: Seiji Aguchi; tytso@mit.edu; dle-develop@lists.sourceforge.net; linux-ext4@vger.kernel.org; jack@suse.cz; Satoru Moriya
Subject: Re: [PATCH][RESEND]tracepoint: add drop_transaction/update_superblock_end to jbd2

On Tue, 24 Jan 2012, Lukas Czerner wrote:

> On Thu, 12 Jan 2012, Seiji Aguchi wrote:
> 
> > Hello Ted,
> > 
> > Please review this patch adding jbd2 tracepoints(and hopefully apply to your tree).
> > This has already been accepted by Lukas and Jan.
> > 
> > Seiji
> 
> Hi Ted,
> 
> can we get this thing in ? It has ACK and review so I do not thing 
> there is a reason to hold it back. Or do you have any problems with it ?
> 
> Thanks!
> -Lukas

Ping!

-Lukas

> 
> > 
> > ---
> > This patch adds trace_jbd2_drop_transaction and 
> > trace_jbd2_update_superblock_end because there are similar 
> > tracepoints in jbd and they are needed in jbd2 as well.
> > 
> > 
> >  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> >  Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> >  Acked-by: Jan Kara <jack@suse.cz>
> > 
> > ---
> >  fs/jbd2/checkpoint.c        |    2 ++
> >  fs/jbd2/journal.c           |    2 ++
> >  include/trace/events/jbd2.h |   28 ++++++++++++++++++++++++++++
> >  3 files changed, 32 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c index 
> > 16a698b..2bfd8b0 100644
> > --- a/fs/jbd2/checkpoint.c
> > +++ b/fs/jbd2/checkpoint.c
> > @@ -797,5 +797,7 @@ void __jbd2_journal_drop_transaction(journal_t *journal, transaction_t *transact
> >  	J_ASSERT(journal->j_committing_transaction != transaction);
> >  	J_ASSERT(journal->j_running_transaction != transaction);
> >  
> > +	trace_jbd2_drop_transaction(journal, transaction);
> > +
> >  	jbd_debug(1, "Dropping transaction %d, all done\n", 
> > transaction->t_tid);  } diff --git a/fs/jbd2/journal.c 
> > b/fs/jbd2/journal.c index f24df13..5953b3d 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -1185,6 +1185,8 @@ void jbd2_journal_update_superblock(journal_t *journal, int wait)
> >  	} else
> >  		write_dirty_buffer(bh, WRITE);
> >  
> > +	trace_jbd2_update_superblock_end(journal, wait);
> > +
> >  out:
> >  	/* If we have just flushed the log (by marking s_start==0), then
> >  	 * any future commit will have to be careful to update the diff 
> > --git a/include/trace/events/jbd2.h b/include/trace/events/jbd2.h 
> > index 7596441..ae59bc2 100644
> > --- a/include/trace/events/jbd2.h
> > +++ b/include/trace/events/jbd2.h
> > @@ -81,6 +81,13 @@ DEFINE_EVENT(jbd2_commit, jbd2_commit_logging,
> >  	TP_ARGS(journal, commit_transaction)  );
> >  
> > +DEFINE_EVENT(jbd2_commit, jbd2_drop_transaction,
> > +
> > +	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
> > +
> > +	TP_ARGS(journal, commit_transaction) );
> > +
> >  TRACE_EVENT(jbd2_end_commit,
> >  	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
> >  
> > @@ -229,6 +236,27 @@ TRACE_EVENT(jbd2_cleanup_journal_tail,
> >  		  __entry->block_nr, __entry->freed)  );
> >  
> > +TRACE_EVENT(jbd2_update_superblock_end,
> > +
> > +	TP_PROTO(journal_t *journal, int wait),
> > +
> > +	TP_ARGS(journal, wait),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(	dev_t,  dev			)
> > +		__field(	int,    wait			)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->dev		= journal->j_fs_dev->bd_dev;
> > +		__entry->wait		= wait;
> > +	),
> > +
> > +	TP_printk("dev %d,%d wait %d",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->wait)
> > +);
> > +
> >  #endif /* _TRACE_JBD2_H */
> >  
> >  /* This part must be outside protection */
> > 
> 
> 

-- 
