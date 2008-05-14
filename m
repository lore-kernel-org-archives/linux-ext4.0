From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] jbd: ordered data integrity fix (rebased)
Date: Wed, 14 May 2008 15:10:07 +0200
Message-ID: <20080514131007.GD24363@duck.suse.cz>
References: <482A6E00.6080303@hitachi.com> <482A6F2B.3020605@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
	adilger@clusterfs.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Josef Bacik <jbacik@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	sugita <yumiko.sugita.yf@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:59869 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762679AbYENNKJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 May 2008 09:10:09 -0400
Content-Disposition: inline
In-Reply-To: <482A6F2B.3020605@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 14-05-08 13:48:43, Hidehiro Kawai wrote:
> Subject: [PATCH 2/4] jbd: ordered data integrity fix
> 
> In ordered mode, if a buffer being dirtied exists in the committing
> transaction, we write the buffer to the disk, move it from the
> committing transaction to the running transaction, then dirty it.
> But we don't have to remove the buffer from the committing
> transaction when the buffer couldn't be written out, otherwise it
> breaks the ordered mode rule.
  Hmm, could you elaborate a bit more what exactly is broken and how does
this help to fix it? Because even if we find EIO happened on data buffer,
we currently don't do anything else than just remove the buffer from the
transaction and abort the journal. And even if we later managed to write
the data buffer from other process before the journal is aborted, ordered
mode guarantees are satisfied - we only guarantee that too old data cannot
be seen, newer can be seen easily... Thanks.

								Honza

> 
> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> ---
>  fs/jbd/transaction.c |   16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.26-rc2/fs/jbd/transaction.c
> ===================================================================
> --- linux-2.6.26-rc2.orig/fs/jbd/transaction.c
> +++ linux-2.6.26-rc2/fs/jbd/transaction.c
> @@ -954,9 +954,10 @@ int journal_dirty_data(handle_t *handle,
>  	journal_t *journal = handle->h_transaction->t_journal;
>  	int need_brelse = 0;
>  	struct journal_head *jh;
> +	int ret = 0;
>  
>  	if (is_handle_aborted(handle))
> -		return 0;
> +		return ret;
>  
>  	jh = journal_add_journal_head(bh);
>  	JBUFFER_TRACE(jh, "entry");
> @@ -1067,7 +1068,16 @@ int journal_dirty_data(handle_t *handle,
>  				   time if it is redirtied */
>  			}
>  
> -			/* journal_clean_data_list() may have got there first */
> +			/*
> +			 * We shouldn't remove the buffer from the committing
> +			 * transaction if it has failed to be written.
> +			 * Otherwise, it breaks the ordered mode rule.
> +			 */
> +			if (unlikely(!buffer_uptodate(bh))) {
> +				ret = -EIO;
> +				goto no_journal;
> +			}
> +
>  			if (jh->b_transaction != NULL) {
>  				JBUFFER_TRACE(jh, "unfile from commit");
>  				__journal_temp_unlink_buffer(jh);
> @@ -1108,7 +1118,7 @@ no_journal:
>  	}
>  	JBUFFER_TRACE(jh, "exit");
>  	journal_put_journal_head(jh);
> -	return 0;
> +	return ret;
>  }
>  
>  /**
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
