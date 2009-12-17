From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH]  ext4: journalled quota seed-up
Date: Thu, 17 Dec 2009 13:07:24 +0300
Message-ID: <871vitzzfn.fsf@openvz.org>
References: <0KUR00I4YVKZG820@mail.2ka.mipt.ru>
 <1261012534-15634-1-git-send-email-dmonakhov@openvz.org>
 <87vdg6mljk.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:47606 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965070AbZLQKHc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Dec 2009 05:07:32 -0500
In-reply-to: <87vdg6mljk.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> Dmitry Monakhov <dmonakhov@openvz.org> writes:
>
> Sorry forgot to add linux-ext4@vger.kernel.org list to CC



>>  Currently each quota modification result in write_dquot()
>>  and later dquot_commit().  This means what each quota modification
>>  function must wait for dqio_mutex. Which is *huge* performance
>>  penalty on big SMP systems.
performance results:
simple tests-case: pwrite(,,40960,0); ftruncate(,0) in a loop
measured value: ops/ms == loops per msecond
mount: with journaled quota, and nodelalloc in order to force
curspace modification for each operation.
Seems it will be reasonable to prepare same patch for ext3.
| write-truncate | w/o quot | w jquot | w jquot mk_drt patch |
|   nodelalloc   |          |         |                      |
|     NR tasks 1 |     20.4 |    14.5 |                14.83 |
|                |     20.3 |    14.7 |                 14.7 |
|                |     20.4 |    14.8 |                 14.8 |
|                |          |         |                      |
|              4 |      6.1 |    4.76 |                  6.3 |
|                |      6.3 |     5.1 |                  6.1 |
|                |      6.5 |     4.8 |                  6.3 |
|                |          |         |                      |
|              8 |     3.75 |    2.59 |                 3.34 |
|                |      4.0 |     2.6 |                 3.44 |
|                |     3.76 |    2.63 |                 3.47 |
>>  ASAIU The core idea of this implementation
>>  is to guarantee that each quota modification will be written to journal
>>  atomically. But in fact this is not always true, because dquot may be
>>  changed after dquot modification, but before it was committed to disk.
>>
>>  | Task 1                           | Task 2                      |
>>  | alloc_space(nr)                  |                             |
>>  | ->spin_lock(dq_data_lock)        |                             |
>>  | ->curspace += nr                 |                             |
>>  | ->spin_unlock(dq_data_lock)      |                             |
>>  | ->mark_dirty()                   | free_space(nr)              |
>>  | -->write_dquot()                 | ->spin_lock(dq_data_lock)   |
>>  | --->dquot_commit()               | ->curspace -= nr            |
>>  | ---->commit_dqblk()              | ->spin_unlock(dq_data_lock) |
>>  | ----->spin_lock(dq_data_lock)    |                             |
>>  | ----->mem2disk_dqblk(ddq, dquot) | <<< Copy updated value      |
>>  | ----->spin_unlock(dq_data_lock)  |                             |
>>  | ----->quota_write()              |                             |
>> Quota corruption not happens only because quota modification caller
>> started journal already. And ext3/4 allow only one running quota
>> at a time. Let's exploit this fact and avoid writing quota each time.
>> Act similar to dirty_for_io in general write_back path in page-cache.
>> If we have found what other task already started on copy and write the
>> dquot then we skip actual quota_write stage. And let that task do the job.
>> Side effect: Task which skip real quota_write() will not get an error
>> (if any). But this is not big deal because:
>>  1) Any error has global consequences (RO_remount, err_print, etc).
>>  2) Real IO is differed till the journall_commit.
>>
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>>  fs/ext4/super.c          |   37 ++++++++++++++++++++++++++++++-------
>>  fs/quota/dquot.c         |   16 +++++++++++++---
>>  include/linux/quotaops.h |    1 +
>>  3 files changed, 44 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 3929091..164217e 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -3777,14 +3777,37 @@ static int ext4_release_dquot(struct dquot *dquot)
>>  
>>  static int ext4_mark_dquot_dirty(struct dquot *dquot)
>>  {
>> -	/* Are we journaling quotas? */
>> -	if (EXT4_SB(dquot->dq_sb)->s_qf_names[USRQUOTA] ||
>> -	    EXT4_SB(dquot->dq_sb)->s_qf_names[GRPQUOTA]) {
>> -		dquot_mark_dquot_dirty(dquot);
>> -		return ext4_write_dquot(dquot);
>> -	} else {
>> +	int ret, err;
>> +	handle_t *handle;
>> +	struct inode *inode;
>> +
>> +	/* Are we not journaling quotas? */
>> +	if (!EXT4_SB(dquot->dq_sb)->s_qf_names[USRQUOTA] &&
>> +	    !EXT4_SB(dquot->dq_sb)->s_qf_names[GRPQUOTA])
>>  		return dquot_mark_dquot_dirty(dquot);
>> -	}
>> +
>> +	/* journaling quotas case */
>> +	inode = dquot_to_inode(dquot);
>> +	handle = ext4_journal_start(inode,
>> +				EXT4_QUOTA_TRANS_BLOCKS(dquot->dq_sb));
>> +	if (IS_ERR(handle))
>> +		return PTR_ERR(handle);
>> +	if (!__dquot_mark_dquot_dirty(dquot))
>> +		ret = dquot_commit(dquot);
>> +	else
>> +		/*
>> +		 * Dquot was already dirty. This means that other task already
>> +		 * started a transaction but not clear dirty bit yet (see
>> +		 * dquot_commit). Since the only one running transaction is
>> +		 * possible at a time. Then that task belongs to the same
>> +		 * transaction. We don'n have to actually write dquot changes
>> +		 * because that task will write it for for us.
>> +		 */
>> +		ret = 0;
>> +	err = ext4_journal_stop(handle);
>> +	if (!ret)
>> +		ret = err;
>> +	return ret;
>>  }
>>  
>>  static int ext4_write_info(struct super_block *sb, int type)
>> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
>> index 6979224..e03eea0 100644
>> --- a/fs/quota/dquot.c
>> +++ b/fs/quota/dquot.c
>> @@ -311,14 +311,24 @@ static inline int mark_dquot_dirty(struct dquot *dquot)
>>  {
>>  	return dquot->dq_sb->dq_op->mark_dirty(dquot);
>>  }
>> -
>> -int dquot_mark_dquot_dirty(struct dquot *dquot)
>> +/* mark dquot dirty in atomic meaner, and return old dirty state */
>> +int __dquot_mark_dquot_dirty(struct dquot *dquot)
>>  {
>> +	int ret = 1;
>>  	spin_lock(&dq_list_lock);
>> -	if (!test_and_set_bit(DQ_MOD_B, &dquot->dq_flags))
>> +	if (!test_and_set_bit(DQ_MOD_B, &dquot->dq_flags)) {
>>  		list_add(&dquot->dq_dirty, &sb_dqopt(dquot->dq_sb)->
>>  				info[dquot->dq_type].dqi_dirty_list);
>> +		ret = 0;
>> +	}
>>  	spin_unlock(&dq_list_lock);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(__dquot_mark_dquot_dirty);
>> +
>> +int dquot_mark_dquot_dirty(struct dquot *dquot)
>> +{
>> +	__dquot_mark_dquot_dirty(dquot);
>>  	return 0;
>>  }
>>  EXPORT_SYMBOL(dquot_mark_dquot_dirty);
>> diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
>> index ae7ef25..c950f7d 100644
>> --- a/include/linux/quotaops.h
>> +++ b/include/linux/quotaops.h
>> @@ -56,6 +56,7 @@ int dquot_commit(struct dquot *dquot);
>>  int dquot_acquire(struct dquot *dquot);
>>  int dquot_release(struct dquot *dquot);
>>  int dquot_commit_info(struct super_block *sb, int type);
>> +int __dquot_mark_dquot_dirty(struct dquot *dquot);
>>  int dquot_mark_dquot_dirty(struct dquot *dquot);
>>  
>>  int vfs_quota_on(struct super_block *sb, int type, int format_id,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
