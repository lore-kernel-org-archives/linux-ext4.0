From: Andreas Dilger <adilger@sun.com>
Subject: Re: + jbd-strictly-check-for-write-errors-on-data-buffers.patch	added
 to -mm tree
Date: Tue, 03 Jun 2008 21:53:37 -0600
Message-ID: <20080604035337.GS2961@webber.adilger.int>
References: <200806032236.m53MaNpB023385@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: hidehiro.kawai.ez@hitachi.com, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:33461 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbYFDDxl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 23:53:41 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m543rehM029164
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 20:53:40 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1X006016O72A00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 03 Jun 2008 20:53:40 -0700 (PDT)
In-reply-to: <200806032236.m53MaNpB023385@imap1.linux-foundation.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 03, 2008  15:36 -0700, Andrew Morton wrote:
> ------------------------------------------------------
> Subject: jbd: strictly check for write errors on data buffers
> From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> 
> In ordered mode, we should abort journaling when an I/O error has occurred
> on a file data buffer in the committing transaction.  But there can be
> data buffers which are not checked for error:
> 
>   (a) the buffer which has already been written out by pdflush
>   (b) the buffer which has been unlocked before scanned in the
>       t_locked_list loop
> 
> This patch adds missing error checks and aborts journaling
> appropriately.

Should we actually abort the journal for file data write errors?

It appears journal_submit_data_buffers() is only for file data
(BJ_SyncData) and not any metadata (BJ_Metadata).  In data=ordered
mode there is no risk to the filesystem integrity.

> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitacih.com>
> Acked-by: Jan Kara <jack@suse.cz>
> Cc: <linux-ext4@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/jbd/commit.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff -puN fs/jbd/commit.c~jbd-strictly-check-for-write-errors-on-data-buffers fs/jbd/commit.c
> --- a/fs/jbd/commit.c~jbd-strictly-check-for-write-errors-on-data-buffers
> +++ a/fs/jbd/commit.c
> @@ -172,7 +172,7 @@ static void journal_do_submit_data(struc
>  /*
>   *  Submit all the data buffers to disk
>   */
> -static void journal_submit_data_buffers(journal_t *journal,
> +static int journal_submit_data_buffers(journal_t *journal,
>  				transaction_t *commit_transaction)
>  {
>  	struct journal_head *jh;
> @@ -180,6 +180,7 @@ static void journal_submit_data_buffers(
>  	int locked;
>  	int bufs = 0;
>  	struct buffer_head **wbuf = journal->j_wbuf;
> +	int err = 0;
>  
>  	/*
>  	 * Whenever we unlock the journal and sleep, things can get added
> @@ -253,6 +254,8 @@ write_out_data:
>  			put_bh(bh);
>  		} else {
>  			BUFFER_TRACE(bh, "writeout complete: unfile");
> +			if (unlikely(!buffer_uptodate(bh)))
> +				err = -EIO;
>  			__journal_unfile_buffer(jh);
>  			jbd_unlock_bh_state(bh);
>  			if (locked)
> @@ -271,6 +274,8 @@ write_out_data:
>  	}
>  	spin_unlock(&journal->j_list_lock);
>  	journal_do_submit_data(wbuf, bufs);
> +
> +	return err;
>  }
>  
>  /*
> @@ -410,8 +415,7 @@ void journal_commit_transaction(journal_
>  	 * Now start flushing things to disk, in the order they appear
>  	 * on the transaction lists.  Data blocks go first.
>  	 */
> -	err = 0;
> -	journal_submit_data_buffers(journal, commit_transaction);
> +	err = journal_submit_data_buffers(journal, commit_transaction);
>  
>  	/*
>  	 * Wait for all previously submitted IO to complete.
> @@ -426,10 +430,10 @@ void journal_commit_transaction(journal_
>  		if (buffer_locked(bh)) {
>  			spin_unlock(&journal->j_list_lock);
>  			wait_on_buffer(bh);
> -			if (unlikely(!buffer_uptodate(bh)))
> -				err = -EIO;
>  			spin_lock(&journal->j_list_lock);
>  		}
> +		if (unlikely(!buffer_uptodate(bh)))
> +			err = -EIO;
>  		if (!inverted_lock(journal, bh)) {
>  			put_bh(bh);
>  			spin_lock(&journal->j_list_lock);
> _
> 
> Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are
> 
> jbd-strictly-check-for-write-errors-on-data-buffers.patch
> jbd-ordered-data-integrity-fix.patch
> jbd-abort-when-failed-to-log-metadata-buffers.patch
> jbd-fix-error-handling-for-checkpoint-io.patch
> ext3-abort-ext3-if-the-journal-has-aborted.patch
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

