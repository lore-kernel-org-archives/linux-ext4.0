From: Younger Liu <younger.liu@huawei.com>
Subject: Re: [PATCH] jbd2: invalidate handle if jbd2_journal_restart() fails
Date: Tue, 25 Jun 2013 17:42:10 +0800
Message-ID: <51C965F2.3090704@huawei.com>
References: <20130623173628.GC16620@thunk.org> <1372009468-11651-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	<jbacik@fusionio.com>, Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:42155 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab3FYJmP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Jun 2013 05:42:15 -0400
In-Reply-To: <1372009468-11651-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013/6/24 1:44, Theodore Ts'o wrote:
> If jbd2_journal_restart() fails the handle will have been disconnected
> from the current transaction.  In this situation, the handle must not
> be used for for any jbd2 function other than jbd2_journal_stop().
> Enforce this with by treating a handle which has a NULL transaction
> pointer as an aborted handle, and issue a kernel warning if
> jbd2_journal_extent(), jbd2_journal_get_write_access(),
> jbd2_journal_dirty_metadata(), etc. is called with an invalid handle.
> 
> This commit also fixes a bug where jbd2_journal_stop() would trip over
> a kernel jbd2 assertion check when trying to free an invalid handle.
> 
> Also move the responsibility of setting current->journal_info to
> start_this_handle(), simplifying the three users of this function.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Reported-by: Younger Liu <younger.liu@huawei.com>
> Cc: Jan Kara <jack@suse.cz>
Hi Ted,
There is a mistake in this patch.
Please see my comments below.
> ---
>  fs/jbd2/transaction.c | 27 ++++++++++++++++-----------
>  include/linux/jbd2.h  |  2 +-
>  2 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 7391456..8ac8306 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
...
> @@ -1523,18 +1525,19 @@ int jbd2_journal_stop(handle_t *handle)
>  {
>  	transaction_t *transaction = handle->h_transaction;
>  	journal_t *journal = transaction->t_journal;
> -	int err, wait_for_commit = 0;
> +	int err = 0, wait_for_commit = 0;
>  	tid_t tid;
>  	pid_t pid;
>  
> +	if (!handle->h_transaction)
> +		goto free_and_exit;
> +
>  	J_ASSERT(journal_current_handle() == handle);
>  
If jbd2__journal_restart fails, handle->h_transaction may be NULL.
So we should check handle->h_transaction before 
"journal = transaction->t_journal", Right?
How about the following?

    transaction_t *transaction = handle->h_transaction;
    journal_t *journal = NULL;
    int err = 0, wait_for_commit = 0;
    tid_t tid;
    pid_t pid;

    if (!handle->h_transaction)
        goto free_and_exit;

    journal = transaction->t_journal;
    J_ASSERT(journal_current_handle() == handle);

We should check this in other functions too,such as 
jbd2_journal_extend(), jbd2_journal_get_create_access(),
jbd2_journal_dirty_metadata(),jbd2_journal_file_inode(),
jbd2__journal_restart(), etc. 

>  	if (is_handle_aborted(handle))
>  		err = -EIO;
> -	else {
> +	else
>  		J_ASSERT(atomic_read(&transaction->t_updates) > 0);
> -		err = 0;
> -	}
>  
>  	if (--handle->h_ref > 0) {
>  		jbd_debug(4, "h_ref %d -> %d\n", handle->h_ref + 1,
> @@ -1657,6 +1660,7 @@ int jbd2_journal_stop(handle_t *handle)
>  
>  	if (handle->h_rsv_handle)
>  		jbd2_journal_free_reserved(handle->h_rsv_handle);
> +free_and_exit:
>  	jbd2_free_handle(handle);
>  	return err;
>  }
> @@ -2364,6 +2368,7 @@ int jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *jinode)
>  	transaction_t *transaction = handle->h_transaction;
>  	journal_t *journal = transaction->t_journal;
>  
> +	WARN_ON(!handle->h_transaction);
>  	if (is_handle_aborted(handle))
>  		return -EIO;
>  
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 5f3c094..1891112 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1295,7 +1295,7 @@ static inline int is_journal_aborted(journal_t *journal)
>  
>  static inline int is_handle_aborted(handle_t *handle)
>  {
> -	if (handle->h_aborted)
> +	if (handle->h_aborted || !handle->h_transaction)
>  		return 1;
>  	return is_journal_aborted(handle->h_transaction->t_journal);
>  }
> 

