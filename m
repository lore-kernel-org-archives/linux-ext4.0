Return-Path: <SRS0=yRHK=OD=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:50488 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728450AbeKXO1f (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 24 Nov 2018 09:27:35 -0500
Subject: Re: [PATCH] ext4: fix deadlock while checkpoint thread waits commit
 thread to finish
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
References: <20181114114935.5250-1-xiaoguang.wang@linux.alibaba.com>
 <20181122123601.GO9840@quack2.suse.cz>
 <7f9dab38-26f8-6fd8-299e-30d711ee61b8@linux.alibaba.com>
 <20181123111515.GA31877@quack2.suse.cz>
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <a3df7058-713d-a7d3-1e7b-4b8afaab24db@linux.alibaba.com>
Date: Sat, 24 Nov 2018 11:40:41 +0800
MIME-Version: 1.0
In-Reply-To: <20181123111515.GA31877@quack2.suse.cz>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Fri 23-11-18 10:45:20, Xiaoguang Wang wrote:
>> hi,
>>
>>> On Wed 14-11-18 19:49:35, Xiaoguang Wang wrote:
>>>> This issue was found when I tried to put checkpoint work in a separate thread,
>>>> the deadlock below happened:
>>>>            Thread1                                |   Thread2
>>>> __jbd2_log_wait_for_space                       |
>>>> jbd2_log_do_checkpoint (hold j_checkpoint_mutex)|
>>>>     if (jh->b_transaction != NULL)                |
>>>>       ...                                         |
>>>>       jbd2_log_start_commit(journal, tid);        |jbd2_update_log_tail
>>>>                                                   |  will lock j_checkpoint_mutex,
>>>>                                                   |  but will be blocked here.
>>>>                                                   |
>>>>       jbd2_log_wait_commit(journal, tid);         |
>>>>       wait_event(journal->j_wait_done_commit,     |
>>>>        !tid_gt(tid, journal->j_commit_sequence)); |
>>>>        ...                                        |wake_up(j_wait_done_commit)
>>>>     }                                             |
>>>>
>>>> then deadlock occurs, Thread1 will never be waken up.
>>>>
>>>> To fix this issue, drop j_checkpoint_mutex in jbd2_log_do_checkpoint()
>>>> when we are going to wait for transaction commit.
>>>>
>>>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>>
>>> Thanks for the patch! One comment below...
>>>
>>>> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
>>>> index 26f8d7e46462..e728844f2f0e 100644
>>>> --- a/fs/jbd2/checkpoint.c
>>>> +++ b/fs/jbd2/checkpoint.c
>>>> @@ -113,7 +113,7 @@ void __jbd2_log_wait_for_space(journal_t *journal)
>>>>    	nblocks = jbd2_space_needed(journal);
>>>>    	while (jbd2_log_space_left(journal) < nblocks) {
>>>>    		write_unlock(&journal->j_state_lock);
>>>> -		mutex_lock(&journal->j_checkpoint_mutex);
>>>> +		mutex_lock_io(&journal->j_checkpoint_mutex);
>>>>    		/*
>>>>    		 * Test again, another process may have checkpointed while we
>>>> @@ -241,8 +241,8 @@ int jbd2_log_do_checkpoint(journal_t *journal)
>>>>    	 * done (maybe it's a new transaction, but it fell at the same
>>>>    	 * address).
>>>>    	 */
>>>> -	if (journal->j_checkpoint_transactions != transaction ||
>>>> -	    transaction->t_tid != this_tid)
>>>> +	if (journal->j_checkpoint_transactions == NULL ||
>>>> +	    journal->j_checkpoint_transactions->t_tid != this_tid)
>>>>    		goto out;
>>>
>>> Why did you change this? As far as I can tell there's no difference and the
>>> previous condition makes it more obvious that we are still looking at the
>>> same transaction.
>> In this patch, we may drop j_checkpoint_mutex, then another thread may acquire
>> this lock, do checkpoint work and freed current transaction, "transaction->t_tid"
>> will cause an invalid pointer dereference.
> 
> That is exactly the reason why we check:
> 
> if (journal->j_checkpoint_transactions != transaction || ...
> 
> So if this test is false and so transaction->t_tid != this_tid gets
> evaluated we are sure that j_checkpoint_transactions actually still points
> to our transaction.
I just realize that "journal->j_checkpoint_transactions != transaction" returns false, we
can make sure that transaction is valid, thanks. I'll send a patch v2 soon.

Regards,
Xiaoguang Wang
> 
> 								Honza
> 
