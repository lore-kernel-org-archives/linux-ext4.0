From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd/jbd2 :clean up journal_try_to_free_buffers
Date: Tue, 9 Jun 2009 15:36:04 +0200
Message-ID: <20090609133602.GA13755@atrey.karlin.mff.cuni.cz>
References: <6.0.0.20.2.20090604194409.071baf80@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35951 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZFINgD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Jun 2009 09:36:03 -0400
Content-Disposition: inline
In-Reply-To: <6.0.0.20.2.20090604194409.071baf80@172.19.0.2>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> I delete the following patch 
> "commit 3f31fddfa26b7594b44ff2b34f9a04ba409e0f91
> Author: Mingming Cao <cmm@us.ibm.com>
> Date:   Fri Jul 25 01:46:22 2008 -0700
> 
>     jbd: fix race between free buffer and commit transaction
> " 
> This patch is no longer needed because if race between freeing buffer
> and committing transaction functionality occurs and dio gets error,
> currently dio falls back to buffered IO by the following patch.
> 
> 	commit 6ccfa806a9cfbbf1cd43d5b6aa47ef2c0eb518fd
> 	Author: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
> 	Date:   Tue Sep 2 14:35:40 2008 -0700
> 
>    	VFS: fix dio write returning EIO when try_to_release_page fails 
> 
> Thanks.
> 
> Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
  OK, makes sence. At least it has an advantage that we don't have to
wait for a transaction commit in DIO path.

Acked-by: Jan Kara <jack@suse.cz>

								Honza
> 
> diff -Nrup linux-2.6.30-rc8.org/fs/jbd/transaction.c linux-2.6.30-rc8.ext3_4/fs/jbd/transaction.c
> --- linux-2.6.30-rc8.org/fs/jbd/transaction.c	2009-06-04 16:26:26.000000000 +0900
> +++ linux-2.6.30-rc8.ext3_4/fs/jbd/transaction.c	2009-06-04 19:14:53.000000000 +0900
> @@ -1686,35 +1686,6 @@ out:
>  	return;
>  }
>  
> -/*
> - * journal_try_to_free_buffers() could race with journal_commit_transaction()
> - * The latter might still hold the a count on buffers when inspecting
> - * them on t_syncdata_list or t_locked_list.
> - *
> - * journal_try_to_free_buffers() will call this function to
> - * wait for the current transaction to finish syncing data buffers, before
> - * tryinf to free that buffer.
> - *
> - * Called with journal->j_state_lock held.
> - */
> -static void journal_wait_for_transaction_sync_data(journal_t *journal)
> -{
> -	transaction_t *transaction = NULL;
> -	tid_t tid;
> -
> -	spin_lock(&journal->j_state_lock);
> -	transaction = journal->j_committing_transaction;
> -
> -	if (!transaction) {
> -		spin_unlock(&journal->j_state_lock);
> -		return;
> -	}
> -
> -	tid = transaction->t_tid;
> -	spin_unlock(&journal->j_state_lock);
> -	log_wait_commit(journal, tid);
> -}
> -
>  /**
>   * int journal_try_to_free_buffers() - try to free page buffers.
>   * @journal: journal for operation
> @@ -1786,25 +1757,6 @@ int journal_try_to_free_buffers(journal_
>  
>  	ret = try_to_free_buffers(page);
>  
> -	/*
> -	* There are a number of places where journal_try_to_free_buffers()
> -	* could race with journal_commit_transaction(), the later still
> -	* holds the reference to the buffers to free while processing them.
> -	* try_to_free_buffers() failed to free those buffers. Some of the
> -	* caller of releasepage() request page buffers to be dropped, otherwise
> -	* treat the fail-to-free as errors (such as generic_file_direct_IO())
> -	*
> -	* So, if the caller of try_to_release_page() wants the synchronous
> -	* behaviour(i.e make sure buffers are dropped upon return),
> -	* let's wait for the current transaction to finish flush of
> -	* dirty data buffers, then try to free those buffers again,
> -	* with the journal locked.
> -	*/
> -	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
> -		journal_wait_for_transaction_sync_data(journal);
> -		ret = try_to_free_buffers(page);
> -	}
> -
>  busy:
>  	return ret;
>  }
> diff -Nrup linux-2.6.30-rc8.org/fs/jbd2/transaction.c linux-2.6.30-rc8.ext3_4/fs/jbd2/transaction.c
> --- linux-2.6.30-rc8.org/fs/jbd2/transaction.c	2009-06-04 16:26:26.000000000 +0900
> +++ linux-2.6.30-rc8.ext3_4/fs/jbd2/transaction.c	2009-06-04 19:17:12.000000000 +0900
> @@ -1547,36 +1547,6 @@ out:
>  	return;
>  }
>  
> -/*
> - * jbd2_journal_try_to_free_buffers() could race with
> - * jbd2_journal_commit_transaction(). The later might still hold the
> - * reference count to the buffers when inspecting them on
> - * t_syncdata_list or t_locked_list.
> - *
> - * jbd2_journal_try_to_free_buffers() will call this function to
> - * wait for the current transaction to finish syncing data buffers, before
> - * try to free that buffer.
> - *
> - * Called with journal->j_state_lock hold.
> - */
> -static void jbd2_journal_wait_for_transaction_sync_data(journal_t *journal)
> -{
> -	transaction_t *transaction;
> -	tid_t tid;
> -
> -	spin_lock(&journal->j_state_lock);
> -	transaction = journal->j_committing_transaction;
> -
> -	if (!transaction) {
> -		spin_unlock(&journal->j_state_lock);
> -		return;
> -	}
> -
> -	tid = transaction->t_tid;
> -	spin_unlock(&journal->j_state_lock);
> -	jbd2_log_wait_commit(journal, tid);
> -}
> -
>  /**
>   * int jbd2_journal_try_to_free_buffers() - try to free page buffers.
>   * @journal: journal for operation
> @@ -1649,25 +1619,6 @@ int jbd2_journal_try_to_free_buffers(jou
>  
>  	ret = try_to_free_buffers(page);
>  
> -	/*
> -	* There are a number of places where jbd2_journal_try_to_free_buffers()
> -	* could race with jbd2_journal_commit_transaction(), the later still
> -	* holds the reference to the buffers to free while processing them.
> -	* try_to_free_buffers() failed to free those buffers. Some of the
> -	* caller of releasepage() request page buffers to be dropped, otherwise
> -	* treat the fail-to-free as errors (such as generic_file_direct_IO())
> -	*
> -	* So, if the caller of try_to_release_page() wants the synchronous
> -	* behaviour(i.e make sure buffers are dropped upon return),
> -	* let's wait for the current transaction to finish flush of
> -	* dirty data buffers, then try to free those buffers again,
> -	* with the journal locked.
> -	*/
> -	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
> -		jbd2_journal_wait_for_transaction_sync_data(journal);
> -		ret = try_to_free_buffers(page);
> -	}
> -
>  busy:
>  	return ret;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
