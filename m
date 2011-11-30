From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH]tracepoint: add drop_transaction/update_superblock_end
 to jbd2
Date: Wed, 30 Nov 2011 12:28:55 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1111301227200.4662@dhcp-27-109.brq.redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C57C90585@USINDEVS01.corp.hds.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"fweisbec@gmail.com" <fweisbec@gmail.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"jiayingz@google.com" <jiayingz@google.com>,
	"lczerner@redhat.com" <lczerner@redhat.com>,
	"dle-develop@lists.sourceforge.net"
	<dle-develop@lists.sourceforge.net>,
	Satoru Moriya <satoru.moriya@hds.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595Ab1K3L3R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Nov 2011 06:29:17 -0500
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C57C90585@USINDEVS01.corp.hds.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 29 Nov 2011, Seiji Aguchi wrote:

> Hi
> 
> This patch adds trace_jbd2_drop_transaction and trace_jbd2_update_superblock_end
> because there are similar tracepoints in jbd and they are needed in jbd2 as well.
> 
> Seiji

Looks good, thanks.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> 
>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> 
> ---
>  fs/jbd2/checkpoint.c        |    2 ++
>  fs/jbd2/journal.c           |    2 ++
>  include/trace/events/jbd2.h |   28 ++++++++++++++++++++++++++++
>  3 files changed, 32 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 16a698b..2bfd8b0 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -797,5 +797,7 @@ void __jbd2_journal_drop_transaction(journal_t *journal, transaction_t *transact
>  	J_ASSERT(journal->j_committing_transaction != transaction);
>  	J_ASSERT(journal->j_running_transaction != transaction);
>  
> +	trace_jbd2_drop_transaction(journal, transaction);
> +
>  	jbd_debug(1, "Dropping transaction %d, all done\n", transaction->t_tid);
>  }
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index f24df13..5953b3d 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1185,6 +1185,8 @@ void jbd2_journal_update_superblock(journal_t *journal, int wait)
>  	} else
>  		write_dirty_buffer(bh, WRITE);
>  
> +	trace_jbd2_update_superblock_end(journal, wait);
> +
>  out:
>  	/* If we have just flushed the log (by marking s_start==0), then
>  	 * any future commit will have to be careful to update the
> diff --git a/include/trace/events/jbd2.h b/include/trace/events/jbd2.h
> index 7596441..ae59bc2 100644
> --- a/include/trace/events/jbd2.h
> +++ b/include/trace/events/jbd2.h
> @@ -81,6 +81,13 @@ DEFINE_EVENT(jbd2_commit, jbd2_commit_logging,
>  	TP_ARGS(journal, commit_transaction)
>  );
>  
> +DEFINE_EVENT(jbd2_commit, jbd2_drop_transaction,
> +
> +	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
> +
> +	TP_ARGS(journal, commit_transaction)
> +);
> +
>  TRACE_EVENT(jbd2_end_commit,
>  	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
>  
> @@ -229,6 +236,27 @@ TRACE_EVENT(jbd2_cleanup_journal_tail,
>  		  __entry->block_nr, __entry->freed)
>  );
>  
> +TRACE_EVENT(jbd2_update_superblock_end,
> +
> +	TP_PROTO(journal_t *journal, int wait),
> +
> +	TP_ARGS(journal, wait),
> +
> +	TP_STRUCT__entry(
> +		__field(	dev_t,  dev			)
> +		__field(	int,    wait			)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->dev		= journal->j_fs_dev->bd_dev;
> +		__entry->wait		= wait;
> +	),
> +
> +	TP_printk("dev %d,%d wait %d",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->wait)
> +);
> +
>  #endif /* _TRACE_JBD2_H */
>  
>  /* This part must be outside protection */
> 

-- 
