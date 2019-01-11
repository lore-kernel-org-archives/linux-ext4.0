Return-Path: <SRS0=9YHU=PT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:40350 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728042AbfAKGLm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 11 Jan 2019 01:11:42 -0500
Subject: Re: [PATCH] jbd2: set freed flag while revoking a buffer which
 belongs to older transaction
To: Jan Kara <jack@suse.cz>
References: <1547100722-132243-1-git-send-email-yi.zhang@huawei.com>
 <20190110112023.GF15790@quack2.suse.cz>
CC: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <miaoxie@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <5b2cb7b3-1eff-21d2-cf12-ee844f54eda0@huawei.com>
Date: Fri, 11 Jan 2019 14:11:31 +0800
MIME-Version: 1.0
In-Reply-To: <20190110112023.GF15790@quack2.suse.cz>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2019/1/10 19:20, Jan Kara Wrote:
> On Thu 10-01-19 14:12:02, zhangyi (F) wrote:
>> Now, we capture a data corruption problem on ext4 while we're truncating
>> an extent index block. Imaging that if we are revoking a buffer which
>> has been journaled by the committing transaction, the buffer's jbddirty
>> flag will not be cleared in jbd2_journal_forget(), so the commit code
>> will set the buffer dirty flag again after refile the buffer.
>>
>> fsx                               kjournald2
>>                                   jbd2_journal_commit_transaction
>> jbd2_journal_revoke                commit phase 1~5...
>>  jbd2_journal_forget
>>    belongs to older transaction    commit phase 6
>>    jbddirty not clear               __jbd2_journal_refile_buffer
>>                                      __jbd2_journal_unfile_buffer
>>                                       test_clear_buffer_jbddirty
>>                                        mark_buffer_dirty
>>
>> Finally, if the freed extent index block was allocated again as data
>> block by some other files, it may corrupt the file data when writing
>> cached pages later, such as during umount time.
>>
>> This patch mark buffer as freed when it already belongs to the
>> committing transaction in jbd2_journal_forget(), so that commit code
>> knows it should clear dirty bits when it is done with the buffer.
>>
>> This problem can be reproduced by xfstests generic/455 easily with
>> seeds (3246 3247 3248 3249).
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> Cc: stable@vger.kernel.org
> 
> Thanks a lot for the analysis and the patch! I fully agree with your
> analysis however I think just setting buffer as freed isn't completely
> correct. The problem is following: The metadata buffer X has been modified
> by the commiting transaction - let's call it A. It has been freed in the
> currently running transaction B. Now jbd2_journal_forget() clears
> b_next_transaction and if you set buffer freed flag, X will not be added to
> the checkpoint list. So when transaction A finishes commit, it can get
> checkpointed (without writing out X) before transaction B commits. So if a
> crash occurs before B commits, we'd loose modification of X from
> transaction A and thus cause filesystem corruption.
> 
Thanks for your explanation! There are still two points I don't quite
understand.

I check all three cases of doing checkpoint. IIUC, both jbd2_journal_destroy()
and jbd2_journal_flush() wait the current running transaction B to complete
before doing checkpoint besides __jbd2_log_wait_for_space(). So I guess this is
the case that you mentioned of transaction A could be checkpointed before B
commits, am I right?

For another case, jbd2_update_log_tail() will be invoked after transaction B
complete, so the problem above also can't happen here, right?

> What rather needs to happen is the same thing that is done in
> journal_unmap_buffer() in this case: We set buffer freed flag and we also
> set b_next_transaction to the currently running transaction (B). This will
> prevent A from being checkpointed before B commits and thus avoids the
> problem above.
> 
Sorry, I don't get this point. I find that the difference between setting
b_next_transaction or not is just re-added the buffer X to the BJ_Reserved
list or not. How could we avoid the problem above.

BTW, I am thinking of a similar case. If we modify buffer X instead of
revork it in the transaction B, we also need to avoid transaction A from
being checkpointed before B commits, because current buffer X contains the
modified data (modified by B). So we should prevent writing it before
B commits, otherwise it will corrupt metadata. How do we handle this
situation now?

Thanks,
Yi.

>> ---
>>  fs/jbd2/transaction.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
>> index 4b51177..fcb65f2 100644
>> --- a/fs/jbd2/transaction.c
>> +++ b/fs/jbd2/transaction.c
>> @@ -1592,6 +1592,12 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
>>  			if (was_modified)
>>  				drop_reserve = 1;
>>  		}
>> +
>> +		/*
>> +		 * Mark buffer as freed so that commit code know it should
>> +		 * clear dirty bits when it is done with the buffer.
>> +		 */
>> +		set_buffer_freed(bh);
>>  	}
>>  
>>  not_jbd:
>> -- 
>> 2.7.4
>>
