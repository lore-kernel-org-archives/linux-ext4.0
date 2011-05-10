From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] jbd2: Fix the wrong calculation of t_max_wait in update_t_max_wait.
Date: Tue, 10 May 2011 16:52:56 -0500
Message-ID: <4DC9B3B8.2040505@redhat.com>
References: <1305024499-8826-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab1EJVxE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 May 2011 17:53:04 -0400
In-Reply-To: <1305024499-8826-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/10/11 5:48 AM, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> t_max_wait is added in commit 8e85fb3f to indicate how long we
> were waiting for new transaction to start. In commit 6d0bf005,
> it is moved to another function named update_t_max_wait to
> avoid a build warning. But the wrong thing is that the original
> 'ts' is initialized in the start of function start_this_handle
> and we can calculate t_max_wait in the right way. while with
> this change, ts is initialized within the function and t_max_wait
> can never be calculated right.
> 
> This patch moves the initialization of ts to the original beginning
> of start_this_handle and pass it to function update_t_max_wait so
> that it can be calculated right and the build warning is avoided also.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Makes sense.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/jbd2/transaction.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 05fa77a..85a055e 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -82,7 +82,7 @@ jbd2_get_transaction(journal_t *journal, transaction_t *transaction)
>   */
>  
>  /*
> - * Update transiaction's maximum wait time, if debugging is enabled.
> + * Update transaction's maximum wait time, if debugging is enabled.
>   *
>   * In order for t_max_wait to be reliable, it must be protected by a
>   * lock.  But doing so will mean that start_this_handle() can not be
> @@ -91,11 +91,10 @@ jbd2_get_transaction(journal_t *journal, transaction_t *transaction)
>   * means that maximum wait time reported by the jbd2_run_stats
>   * tracepoint will always be zero.
>   */
> -static inline void update_t_max_wait(transaction_t *transaction)
> +static inline void update_t_max_wait(transaction_t *transaction,
> +				     unsigned long ts)
>  {
>  #ifdef CONFIG_JBD2_DEBUG
> -	unsigned long ts = jiffies;
> -
>  	if (jbd2_journal_enable_debug &&
>  	    time_after(transaction->t_start, ts)) {
>  		ts = jbd2_time_diff(ts, transaction->t_start);
> @@ -121,6 +120,7 @@ static int start_this_handle(journal_t *journal, handle_t *handle,
>  	tid_t		tid;
>  	int		needed, need_to_start;
>  	int		nblocks = handle->h_buffer_credits;
> +	unsigned long ts = jiffies;
>  
>  	if (nblocks > journal->j_max_transaction_buffers) {
>  		printk(KERN_ERR "JBD: %s wants too many credits (%d > %d)\n",
> @@ -271,7 +271,7 @@ repeat:
>  	/* OK, account for the buffers that this operation expects to
>  	 * use and add the handle to the running transaction. 
>  	 */
> -	update_t_max_wait(transaction);
> +	update_t_max_wait(transaction, ts);
>  	handle->h_transaction = transaction;
>  	atomic_inc(&transaction->t_updates);
>  	atomic_inc(&transaction->t_handle_count);

