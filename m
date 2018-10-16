Return-Path: <SRS0=eFe4=M4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:6422 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbeJPQlG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 16 Oct 2018 12:41:06 -0400
Subject: Re: jbd2_clear_buffer_revoked_flags() takes a long time
To: Jan Kara <jack@suse.cz>, "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
References: <d2e1ec1a-0d7d-1acb-6887-c55ac30e4a3a@intel.com>
 <20181010174934.GA19601@thunk.org> <20181011111223.GD9467@quack2.suse.cz>
 <a70df9c2-ef85-cc0a-4442-64c8c7b15ea5@intel.com>
From: Adrian Hunter <adrian.hunter@intel.com>
Message-ID: <478e7436-01c9-9501-f971-d8a8cf68dad9@intel.com>
Date: Tue, 16 Oct 2018 11:49:45 +0300
MIME-Version: 1.0
In-Reply-To: <a70df9c2-ef85-cc0a-4442-64c8c7b15ea5@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/10/18 3:38 PM, Adrian Hunter wrote:
> On 11/10/18 2:12 PM, Jan Kara wrote:
>> On Wed 10-10-18 13:49:34, Theodore Y. Ts'o wrote:
>>> On Wed, Oct 10, 2018 at 04:43:27PM +0300, Adrian Hunter wrote:
>>>> Hi
>>>>
>>>> I have a case on a v4.14 kernel where the EXT4 journal commit disables
>>>> preemption for 30ms due to jbd2_clear_buffer_revoked_flags().  That in turn
>>>> disables preemption on other CPUs as they come to spin waiting for the same
>>>> lock.  The side-effect of that is that it periodically blocks high priority
>>>> tasks from running.
>>>>
>>>> I see jbd2_clear_buffer_revoked_flags() iterating 32768 times calling
>>>> __find_get_block().
>>>>
>>>> Is there any way to make jbd2_clear_buffer_revoked_flags() take less time,
>>>> or move its work out from under write_lock(&journal->j_state_lock)?
>>> Hmm.... I'd have to look a bit more carefully and then run some tests,
>>> but I *think* we can drop the j_state_lock at the beginning of JBD2
>>> commit phase 1, and then grab it again right before we set
>>> commit_transaction->t_state to T_FLUSH.
>>>
>>> That should be safe because while the transaction state is T_LOCKED,
>>> we can't start any new handles, so there can't be any new blocks added
>>> to the revoke table.
>>>
>>> Can you give that a try and see whether that solves your priority
>>> inversion problem?
>> Agreed. Something like attached patch (compile-tested only)?
> 
> I have been testing a patch with the unlock/lock at slightly different
> positions, and it definitely helps.  The incidence of my problem drops from
> nearly every writeback, to a few an hour.  I haven't had time to find out
> what is causing the remaining cases yet - it may not be related to EXT4.  I
> should be able to test this patch tomorrow.

Thanks very much for the quick response and patch!

Tested-by: Adrian Hunter <adrian.hunter@intel.com>

With more stress I also found move_expired_inodes()
(wb_writeback->queue_io->move_expired_inodes) to take up to 16ms using
230,000 branches while under spin lock.  AFAICT we weren't hitting that in
practice so I am not following it up at this stage.

> 
>>
>> 								Honza
>>
>> -- Jan Kara <jack@suse.com> SUSE Labs, CR
>>
>>
>> 0001-jbd2-Avoid-long-hold-times-of-j_state_lock-while-com.patch
>>
>> >From 3627b5f30996504019cd84f326402fccbb9a298b Mon Sep 17 00:00:00 2001
>> From: Jan Kara <jack@suse.cz>
>> Date: Thu, 11 Oct 2018 13:04:44 +0200
>> Subject: [PATCH] jbd2: Avoid long hold times of j_state_lock while committing
>>  a transaction
>>
>> We can hold j_state_lock for writing at the beginning of
>> jbd2_journal_commit_transaction() for a rather long time (reportedly for
>> 30 ms) due cleaning revoke bits of all revoked buffers under it. The
>> handling of revoke tables as well as cleaning of t_reserved_list, and
>> checkpoint lists does not need j_state_lock for anything. Furthermore
>> the transaction is in T_LOCKED state and we waited for all outstanding
>> handles so nobody is going to be adding anything to the transaction.
>>
>> Just drop the lock for unnecessary operations.
>>
>> Reported-by: Adrian Hunter <adrian.hunter@intel.com>
>> Suggested-by: "Theodore Y. Ts'o" <tytso@mit.edu>
>> Signed-off-by: Jan Kara <jack@suse.cz>
>> ---
>>  fs/jbd2/commit.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
>> index 150cc030b4d7..356b75fa3101 100644
>> --- a/fs/jbd2/commit.c
>> +++ b/fs/jbd2/commit.c
>> @@ -422,6 +422,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>>  				       stats.run.rs_locked);
>>  	stats.run.rs_running = jbd2_time_diff(commit_transaction->t_start,
>>  					      stats.run.rs_locked);
>> +	write_unlock(&journal->j_state_lock);
>>  
>>  	spin_lock(&commit_transaction->t_handle_lock);
>>  	while (atomic_read(&commit_transaction->t_updates)) {
>> @@ -431,9 +432,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>>  					TASK_UNINTERRUPTIBLE);
>>  		if (atomic_read(&commit_transaction->t_updates)) {
>>  			spin_unlock(&commit_transaction->t_handle_lock);
>> -			write_unlock(&journal->j_state_lock);
>>  			schedule();
>> -			write_lock(&journal->j_state_lock);
>>  			spin_lock(&commit_transaction->t_handle_lock);
>>  		}
>>  		finish_wait(&journal->j_wait_updates, &wait);
>> @@ -505,6 +504,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>>  	atomic_sub(atomic_read(&journal->j_reserved_credits),
>>  		   &commit_transaction->t_outstanding_credits);
>>  
>> +	write_lock(&journal->j_state_lock);
>>  	trace_jbd2_commit_flushing(journal, commit_transaction);
>>  	stats.run.rs_flushing = jiffies;
>>  	stats.run.rs_locked = jbd2_time_diff(stats.run.rs_locked,
>> -- 2.16.4
>>
> 
> 
