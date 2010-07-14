From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] jbd2: Fix I/O hang in jbd2_journal_release_jbd_inode
Date: Wed, 14 Jul 2010 11:39:34 -0500
Message-ID: <4C3DE846.4070007@linux.vnet.ibm.com>
References: <201007141456.o6EEuFe9004519@d01av03.pok.ibm.com> <4C3DE684.2040202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, cmm@linux.vnet.ibm.com,
	pmac@au1.ibm.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53889 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab0GNQjg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jul 2010 12:39:36 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o6EGNV2C014332
	for <linux-ext4@vger.kernel.org>; Wed, 14 Jul 2010 12:23:31 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o6EGdZVl062638
	for <linux-ext4@vger.kernel.org>; Wed, 14 Jul 2010 12:39:35 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o6EGdYuY029417
	for <linux-ext4@vger.kernel.org>; Wed, 14 Jul 2010 12:39:35 -0400
In-Reply-To: <4C3DE684.2040202@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/14/2010 11:32 AM, Eric Sandeen wrote:
> Brian King wrote:
>> I've been debugging a hang in jbd2_journal_release_jbd_inode
>> which is being seen on Power 6 systems quite a lot. When we get
>> in the hung state, all I/O to the disk in question gets blocked
>> where we stay indefinitely. Looking at the task list, I can see
>> we are stuck in jbd2_journal_release_jbd_inode waiting on a
>> wake up. I added some debug code to detect this scenario and
>> dump additional data if we were stuck in jbd2_journal_release_jbd_inode
>> for longer than 30 minutes. When it hit, I was able to see that
>> i_flags was 0, suggesting we missed the wake up.
>>
>> This patch changes i_flags to be an unsigned long, uses bit operators
> 
> Did you happen to try just changing the jinode i_flags to be an unsigned long?
> The current unsigned int seems to be the wrong thing to use with
> bit_waitqueue() and friends, does that change alone fix it?

I am testing a patch without the added barriers, but don't have too much
runtime on it yet. I'll spin a kernel with just the unsigned long change
and see how that holds up.

Thanks,

Brian

> 
> -Eric
> 
>> to access it, and adds barriers around the accesses. Prior to applying
>> this patch, we were regularly hitting this hang on numerous systems
>> in our test environment. After applying the patch, the hangs no longer
>> occur. Its still not clear to me why the j_list_lock doesn't protect us
>> in this path. It also appears a hang very similar to this was seen
>> in the past and then was no longer recreatable:
>>
>> http://forum.soft32.com/linux/20090310-ext4-hangs-ftopict478916.html
>>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>> ---
>>
>>  fs/jbd2/commit.c     |   14 ++++++++++----
>>  fs/jbd2/journal.c    |    5 ++++-
>>  include/linux/jbd2.h |    2 +-
>>  3 files changed, 15 insertions(+), 6 deletions(-)
>>
>> diff -puN include/linux/jbd2.h~jbd2_ji_commit_barrier_patch include/linux/jbd2.h
>> --- linux-2.6/include/linux/jbd2.h~jbd2_ji_commit_barrier_patch	2010-07-07 09:01:12.000000000 -0500
>> +++ linux-2.6-bjking1/include/linux/jbd2.h	2010-07-07 09:01:12.000000000 -0500
>> @@ -395,7 +395,7 @@ struct jbd2_inode {
>>  	struct inode *i_vfs_inode;
>>  
>>  	/* Flags of inode [j_list_lock] */
>> -	unsigned int i_flags;
>> +	unsigned long i_flags;
>>  };
>>  
>>  struct jbd2_revoke_table_s;
>> diff -puN fs/jbd2/commit.c~jbd2_ji_commit_barrier_patch fs/jbd2/commit.c
>> --- linux-2.6/fs/jbd2/commit.c~jbd2_ji_commit_barrier_patch	2010-07-07 09:01:12.000000000 -0500
>> +++ linux-2.6-bjking1/fs/jbd2/commit.c	2010-07-07 09:01:12.000000000 -0500
>> @@ -26,7 +26,9 @@
>>  #include <linux/backing-dev.h>
>>  #include <linux/bio.h>
>>  #include <linux/blkdev.h>
>> +#include <linux/bitops.h>
>>  #include <trace/events/jbd2.h>
>> +#include <asm/system.h>
>>  
>>  /*
>>   * Default IO end handler for temporary BJ_IO buffer_heads.
>> @@ -245,7 +247,7 @@ static int journal_submit_data_buffers(j
>>  	spin_lock(&journal->j_list_lock);
>>  	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
>>  		mapping = jinode->i_vfs_inode->i_mapping;
>> -		jinode->i_flags |= JI_COMMIT_RUNNING;
>> +		set_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
>>  		spin_unlock(&journal->j_list_lock);
>>  		/*
>>  		 * submit the inode data buffers. We use writepage
>> @@ -260,7 +262,9 @@ static int journal_submit_data_buffers(j
>>  		spin_lock(&journal->j_list_lock);
>>  		J_ASSERT(jinode->i_transaction == commit_transaction);
>>  		commit_transaction->t_flushed_data_blocks = 1;
>> -		jinode->i_flags &= ~JI_COMMIT_RUNNING;
>> +		smp_mb__before_clear_bit();
>> +		clear_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
>> +		smp_mb__before_clear_bit();
>>  		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
>>  	}
>>  	spin_unlock(&journal->j_list_lock);
>> @@ -281,7 +285,7 @@ static int journal_finish_inode_data_buf
>>  	/* For locking, see the comment in journal_submit_data_buffers() */
>>  	spin_lock(&journal->j_list_lock);
>>  	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
>> -		jinode->i_flags |= JI_COMMIT_RUNNING;
>> +		set_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
>>  		spin_unlock(&journal->j_list_lock);
>>  		err = filemap_fdatawait(jinode->i_vfs_inode->i_mapping);
>>  		if (err) {
>> @@ -297,7 +301,9 @@ static int journal_finish_inode_data_buf
>>  				ret = err;
>>  		}
>>  		spin_lock(&journal->j_list_lock);
>> -		jinode->i_flags &= ~JI_COMMIT_RUNNING;
>> +		smp_mb__before_clear_bit();
>> +		clear_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
>> +		smp_mb__before_clear_bit();
>>  		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
>>  	}
>>  
>> diff -puN fs/jbd2/journal.c~jbd2_ji_commit_barrier_patch fs/jbd2/journal.c
>> --- linux-2.6/fs/jbd2/journal.c~jbd2_ji_commit_barrier_patch	2010-07-07 09:01:12.000000000 -0500
>> +++ linux-2.6-bjking1/fs/jbd2/journal.c	2010-07-07 09:01:12.000000000 -0500
>> @@ -41,12 +41,14 @@
>>  #include <linux/hash.h>
>>  #include <linux/log2.h>
>>  #include <linux/vmalloc.h>
>> +#include <linux/bitops.h>
>>  
>>  #define CREATE_TRACE_POINTS
>>  #include <trace/events/jbd2.h>
>>  
>>  #include <asm/uaccess.h>
>>  #include <asm/page.h>
>> +#include <asm/system.h>
>>  
>>  EXPORT_SYMBOL(jbd2_journal_start);
>>  EXPORT_SYMBOL(jbd2_journal_restart);
>> @@ -2209,9 +2211,10 @@ void jbd2_journal_release_jbd_inode(jour
>>  restart:
>>  	spin_lock(&journal->j_list_lock);
>>  	/* Is commit writing out inode - we have to wait */
>> -	if (jinode->i_flags & JI_COMMIT_RUNNING) {
>> +	if (test_bit(__JI_COMMIT_RUNNING, &jinode->i_flags)) {
>>  		wait_queue_head_t *wq;
>>  		DEFINE_WAIT_BIT(wait, &jinode->i_flags, __JI_COMMIT_RUNNING);
>> +		smp_mb();
>>  		wq = bit_waitqueue(&jinode->i_flags, __JI_COMMIT_RUNNING);
>>  		prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
>>  		spin_unlock(&journal->j_list_lock);
>> _
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


