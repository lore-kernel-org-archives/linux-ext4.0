From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH][RESEND]tracepoint: add
 drop_transaction/update_superblock_end to jbd2
Date: Thu, 12 Jan 2012 02:02:07 +0100
Message-ID: <20120112010207.GA6269@quack.suse.cz>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C58316AF9@USINDEVS01.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "jack@suse.cz" <jack@suse.cz>,
	"dle-develop@lists.sourceforge.net"
	<dle-develop@lists.sourceforge.net>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>,
	Satoru Moriya <satoru.moriya@hds.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab2ALBCJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jan 2012 20:02:09 -0500
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C58316AF9@USINDEVS01.corp.hds.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Seiji,

On Wed 11-01-12 19:10:40, Seiji Aguchi wrote:
> Please review this patch below (and hopefully apply to your tree).
> This has already been reviewed by Lukas.
  The patch looks OK to me so feel free to add
Acked-by: Jan Kara <jack@suse.cz>
  but JBD2 patches are usually merged by Ted Tso <tytso@mit.edu> since
he is an ext4 maintainer and so he carries most of changes that modify
JBD2.

								Honza

> ---
> This patch adds trace_jbd2_drop_transaction and 
> trace_jbd2_update_superblock_end because there are similar tracepoints in jbd and 
> they are needed in jbd2 as well.
> 
> 
>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
>  Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> 
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
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
