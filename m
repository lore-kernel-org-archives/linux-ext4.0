From: Younger Liu <younger.liu@huawei.com>
Subject: Re: [PATCH] jbd2: invalidate handle if jbd2_journal_restart() fails
Date: Wed, 3 Jul 2013 20:22:20 +0800
Message-ID: <51D4177C.6020307@huawei.com>
References: <20130623173628.GC16620@thunk.org> <1372009468-11651-1-git-send-email-tytso@mit.edu> <51C965F2.3090704@huawei.com> <20130629234648.GA4560@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	<jbacik@fusionio.com>, Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:36098 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab3GCMWg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Jul 2013 08:22:36 -0400
In-Reply-To: <20130629234648.GA4560@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013/6/30 7:46, Theodore Ts'o wrote:
> On Tue, Jun 25, 2013 at 05:42:10PM +0800, Younger Liu wrote:
>> If jbd2__journal_restart fails, handle->h_transaction may be NULL.
>> So we should check handle->h_transaction before 
>> "journal = transaction->t_journal", Right?
> 
> Good point, yes.  Here's a new version of the patch which I have in my tree.
> 
>      	    	  	       	       	      - Ted
> 
>>From fd8d369f9ad921eb6dc5c56e87e4c6d6106bad56 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Sun, 23 Jun 2013 12:59:01 -0400
> Subject: [PATCH] jbd2: invalidate handle if jbd2_journal_restart() fails
> 
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
> ---
>  fs/jbd2/transaction.c | 74 ++++++++++++++++++++++++++++++---------------------
>  include/linux/jbd2.h  |  2 +-
>  2 files changed, 44 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 383b0fb..7aa9a32 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -368,6 +368,7 @@ repeat:
>  		  atomic_read(&transaction->t_outstanding_credits),
>  		  jbd2_log_space_left(journal));
>  	read_unlock(&journal->j_state_lock);
> +	current->journal_info = handle;
>  
>  	lock_map_acquire(&handle->h_lockdep_map);
>  	jbd2_journal_free_transaction(new_transaction);
> @@ -442,14 +443,11 @@ handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int rsv_blocks,
>  		handle->h_rsv_handle = rsv_handle;
>  	}
>  
> -	current->journal_info = handle;
> -
>  	err = start_this_handle(journal, handle, gfp_mask);
>  	if (err < 0) {
>  		if (handle->h_rsv_handle)
>  			jbd2_free_handle(handle->h_rsv_handle);
>  		jbd2_free_handle(handle);
> -		current->journal_info = NULL;
>  		return ERR_PTR(err);
>  	}
>  	handle->h_type = type;
> @@ -511,16 +509,13 @@ int jbd2_journal_start_reserved(handle_t *handle, unsigned int type,
>  	}
>  
>  	handle->h_journal = NULL;
> -	current->journal_info = handle;
>  	/*
>  	 * GFP_NOFS is here because callers are likely from writeback or
>  	 * similarly constrained call sites
>  	 */
>  	ret = start_this_handle(journal, handle, GFP_NOFS);
> -	if (ret < 0) {
> -		current->journal_info = NULL;
> +	if (ret < 0)
>  		jbd2_journal_free_reserved(handle);
> -	}
>  	handle->h_type = type;
>  	handle->h_line_no = line_no;
>  	return ret;
> @@ -550,20 +545,21 @@ EXPORT_SYMBOL(jbd2_journal_start_reserved);
>  int jbd2_journal_extend(handle_t *handle, int nblocks)
>  {
>  	transaction_t *transaction = handle->h_transaction;
> -	journal_t *journal = transaction->t_journal;
> +	journal_t *journal;
>  	int result;
>  	int wanted;
>  
> -	result = -EIO;
> +	WARN_ON(!transaction);
>  	if (is_handle_aborted(handle))
> -		goto out;
> +		return -EROFS;
> +	journal = transaction->t_journal;
>  
>  	result = 1;
>  
>  	read_lock(&journal->j_state_lock);
>  
>  	/* Don't extend a locked-down transaction! */
> -	if (handle->h_transaction->t_state != T_RUNNING) {
> +	if (transaction->t_state != T_RUNNING) {
>  		jbd_debug(3, "denied handle %p %d blocks: "
>  			  "transaction not running\n", handle, nblocks);
>  		goto error_out;
> @@ -589,7 +585,7 @@ int jbd2_journal_extend(handle_t *handle, int nblocks)
>  	}
>  
>  	trace_jbd2_handle_extend(journal->j_fs_dev->bd_dev,
> -				 handle->h_transaction->t_tid,
> +				 transaction->t_tid,
>  				 handle->h_type, handle->h_line_no,
>  				 handle->h_buffer_credits,
>  				 nblocks);
> @@ -603,7 +599,6 @@ unlock:
>  	spin_unlock(&transaction->t_handle_lock);
>  error_out:
>  	read_unlock(&journal->j_state_lock);
> -out:
>  	return result;
>  }
>  
> @@ -626,14 +621,16 @@ out:
>  int jbd2__journal_restart(handle_t *handle, int nblocks, gfp_t gfp_mask)
>  {
>  	transaction_t *transaction = handle->h_transaction;
> -	journal_t *journal = transaction->t_journal;
> +	journal_t *journal;
>  	tid_t		tid;
>  	int		need_to_start, ret;
>  
> +	WARN_ON(!transaction);
>  	/* If we've had an abort of any type, don't even think about
>  	 * actually doing the restart! */
>  	if (is_handle_aborted(handle))
>  		return 0;
> +	journal = transaction->t_journal;
>  
>  	/*
>  	 * First unlink the handle from its current transaction, and start the
> @@ -654,6 +651,8 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, gfp_t gfp_mask)
>  		wake_up(&journal->j_wait_updates);
>  	tid = transaction->t_tid;
>  	spin_unlock(&transaction->t_handle_lock);
> +	handle->h_transaction = NULL;
> +	current->journal_info = NULL;
>  
>  	jbd_debug(2, "restarting handle %p\n", handle);
>  	need_to_start = !tid_geq(journal->j_commit_request, tid);
> @@ -783,17 +782,16 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
>  			int force_copy)
>  {
>  	struct buffer_head *bh;
> -	transaction_t *transaction;
> +	transaction_t *transaction = handle->h_transaction;
>  	journal_t *journal;
>  	int error;
>  	char *frozen_buffer = NULL;
>  	int need_copy = 0;
>  	unsigned long start_lock, time_lock;
>  
> +	WARN_ON(!transaction);
>  	if (is_handle_aborted(handle))
>  		return -EROFS;
> -
> -	transaction = handle->h_transaction;
>  	journal = transaction->t_journal;
>  
>  	jbd_debug(5, "journal_head %p, force_copy %d\n", jh, force_copy);
> @@ -1052,14 +1050,16 @@ int jbd2_journal_get_write_access(handle_t *handle, struct buffer_head *bh)
>  int jbd2_journal_get_create_access(handle_t *handle, struct buffer_head *bh)
>  {
>  	transaction_t *transaction = handle->h_transaction;
> -	journal_t *journal = transaction->t_journal;
> +	journal_t *journal;
>  	struct journal_head *jh = jbd2_journal_add_journal_head(bh);
>  	int err;
>  
>  	jbd_debug(5, "journal_head %p\n", jh);
> +	WARN_ON(!transaction);
>  	err = -EROFS;
>  	if (is_handle_aborted(handle))
>  		goto out;
> +	journal = transaction->t_journal;
>  	err = 0;
>  
>  	JBUFFER_TRACE(jh, "entry");
> @@ -1265,12 +1265,14 @@ void jbd2_buffer_abort_trigger(struct journal_head *jh,
>  int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
>  {
>  	transaction_t *transaction = handle->h_transaction;
> -	journal_t *journal = transaction->t_journal;
> +	journal_t *journal;
>  	struct journal_head *jh;
>  	int ret = 0;
>  
> +	WARN_ON(!transaction);
>  	if (is_handle_aborted(handle))
> -		goto out;
> +		return -EROFS;
> +	journal = transaction->t_journal;
>  	jh = jbd2_journal_grab_journal_head(bh);
>  	if (!jh) {
>  		ret = -EUCLEAN;
> @@ -1364,7 +1366,7 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
>  
>  	JBUFFER_TRACE(jh, "file as BJ_Metadata");
>  	spin_lock(&journal->j_list_lock);
> -	__jbd2_journal_file_buffer(jh, handle->h_transaction, BJ_Metadata);
> +	__jbd2_journal_file_buffer(jh, transaction, BJ_Metadata);
>  	spin_unlock(&journal->j_list_lock);
>  out_unlock_bh:
>  	jbd_unlock_bh_state(bh);
> @@ -1395,12 +1397,17 @@ out:
>  int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
>  {
>  	transaction_t *transaction = handle->h_transaction;
> -	journal_t *journal = transaction->t_journal;
> +	journal_t *journal;
>  	struct journal_head *jh;
>  	int drop_reserve = 0;
>  	int err = 0;
>  	int was_modified = 0;
>  
> +	WARN_ON(!transaction);
> +	if (is_handle_aborted(handle))
> +		return -EROFS;
> +	journal = transaction->t_journal;
> +
>  	BUFFER_TRACE(bh, "entry");
>  
>  	jbd_lock_bh_state(bh);
> @@ -1427,7 +1434,7 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
>  	 */
>  	jh->b_modified = 0;
>  
> -	if (jh->b_transaction == handle->h_transaction) {
> +	if (jh->b_transaction == transaction) {
>  		J_ASSERT_JH(jh, !jh->b_frozen_data);
>  
>  		/* If we are forgetting a buffer which is already part
> @@ -1522,19 +1529,21 @@ drop:
>  int jbd2_journal_stop(handle_t *handle)
>  {
>  	transaction_t *transaction = handle->h_transaction;
> -	journal_t *journal = transaction->t_journal;
> -	int err, wait_for_commit = 0;
> +	journal_t *journal;
> +	int err = 0, wait_for_commit = 0;
>  	tid_t tid;
>  	pid_t pid;
>  
> +	if (!transaction)
> +		goto free_and_exit;
> +	journal = transaction->t_journal;
> +
>  	J_ASSERT(journal_current_handle() == handle);
>  
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
> @@ -1544,7 +1553,7 @@ int jbd2_journal_stop(handle_t *handle)
>  
>  	jbd_debug(4, "Handle %p going down\n", handle);
>  	trace_jbd2_handle_stats(journal->j_fs_dev->bd_dev,
> -				handle->h_transaction->t_tid,
> +				transaction->t_tid,
>  				handle->h_type, handle->h_line_no,
>  				jiffies - handle->h_start_jiffies,
>  				handle->h_sync, handle->h_requested_credits,
> @@ -1657,6 +1666,7 @@ int jbd2_journal_stop(handle_t *handle)
>  
>  	if (handle->h_rsv_handle)
>  		jbd2_journal_free_reserved(handle->h_rsv_handle);
> +free_and_exit:
>  	jbd2_free_handle(handle);
>  	return err;
>  }
> @@ -2362,10 +2372,12 @@ void jbd2_journal_refile_buffer(journal_t *journal, struct journal_head *jh)
>  int jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *jinode)
>  {
>  	transaction_t *transaction = handle->h_transaction;
> -	journal_t *journal = transaction->t_journal;
> +	journal_t *journal;
>  
> +	WARN_ON(!transaction);
>  	if (is_handle_aborted(handle))
> -		return -EIO;
> +		return -EROFS;
> +	journal = transaction->t_journal;
>  
>  	jbd_debug(4, "Adding inode %lu, tid:%d\n", jinode->i_vfs_inode->i_ino,
>  			transaction->t_tid);
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 0302f3f..d5b50a1 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1266,7 +1266,7 @@ static inline int is_journal_aborted(journal_t *journal)
>  
>  static inline int is_handle_aborted(handle_t *handle)
>  {
> -	if (handle->h_aborted)
> +	if (handle->h_aborted || !handle->h_transaction)
>  		return 1;
>  	return is_journal_aborted(handle->h_transaction->t_journal);
>  }
> 

Thanks for your patch.
I test the patch in ocfs2 file system,  the results look fine.

# mkfs.ocfs2 -b 4K -C 32K -T datafiles /dev/sdc
...(jounral size is 32M)
# mount.ocfs2 /dev/sdc /mnt/ocfs2/
# touch /mnt/ocfs2/1.vhd
# fallocate -o 0 -l 400G /mnt/ocfs2/1.vhd
fallocate: /mnt/ocfs2/1.vhd: fallocate failed: Cannot allocate memory
# tail -f /var/log/messages
Jul  3 19:40:58 linux-KooNDD kernel: [ 7302.646408] JBD: Ignoring recovery information on journal
Jul  3 19:40:58 linux-KooNDD kernel: [ 7302.667908] ocfs2: Mounting device (65,160) on (node 10, slot 0) with ordered data mode.
Jul  3 19:41:19 linux-KooNDD ovsdb-server: 00129|monitor|INFO|Monitor: send HEARTBEART_MESSGE again count = 71400
Jul  3 19:41:54 linux-KooNDD ovs-brcompatd: 00132|monitor|INFO|Monitor: send HEARTBEART_MESSGE again count = 73200
Jul  3 19:42:08 linux-KooNDD kernel: [ 7372.278591] JBD: fallocate wants too many credits (2051 > 2048)
Jul  3 19:42:08 linux-KooNDD kernel: [ 7372.278597] (fallocate,6438,0):__ocfs2_extend_allocation:709 ERROR: status = -12
Jul  3 19:42:08 linux-KooNDD kernel: [ 7372.278603] (fallocate,6438,0):ocfs2_allocate_unwritten_extents:1504 ERROR: status = -12
Jul  3 19:42:08 linux-KooNDD kernel: [ 7372.278607] (fallocate,6438,0):__ocfs2_change_file_space:1955 ERROR: status = -12
Jul  3 19:42:20 linux-KooNDD ovsdb-server: 00130|monitor|INFO|Monitor: send HEARTBEART_MESSGE again count = 72000
Jul  3 19:42:20 linux-KooNDD ovsdb-server: 00131|vlog|INFO|opened log file /var/log/openvswitch//ovsdb-server.log
^C

If fallocate wants too many journal space, it would issue a kernel warning.

# cat test.sh
start=0
end=500
while [ ${start} -le ${end} ]
do
        echo ${start}
        touch /mnt/ocfs2/${start}.vhd
        fallocate -o 0 -l ${start}G /mnt/ocfs2/${start}.vhd
        ls -l /mnt/ocfs2/
        du -h /mnt/ocfs2/
        rm /mnt/ocfs2/${start}.vhd
        sleep 2
        start=$((${start}+5))
done
#sh test.sh

the results are fine too.

Tested-by: Younger Liu <younger.liu@oracle.com>

					-- Younger




