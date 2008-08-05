From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH] jbd: abort instead of waiting for nonexistent transactions
Date: Tue, 5 Aug 2008 01:41:40 +0100
Message-ID: <e9e943910808041741q4e95a96cu11dbe28cbf481c41@mail.gmail.com>
References: <1217893895-29165-1-git-send-email-duaneg@dghda.com>
	 <20080804170346.613238b8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, sct@redhat.com,
	linux-ext4@vger.kernel.org, "Sami Liedes" <sliedes@cc.hut.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:48274 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843AbYHEAll (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2008 20:41:41 -0400
Received: by mu-out-0910.google.com with SMTP id w8so3794794mue.1
        for <linux-ext4@vger.kernel.org>; Mon, 04 Aug 2008 17:41:40 -0700 (PDT)
In-Reply-To: <20080804170346.613238b8.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/8/5 Andrew Morton <akpm@linux-foundation.org>:
> On Tue,  5 Aug 2008 00:51:34 +0100 "Duane Griffin" <duaneg@dghda.com> wrote:
>
>> The __log_wait_for_space function sits in a loop checkpointing transactions
>> until there is sufficient space free in the journal. However, if there are
>> no transactions to be processed (e.g. because the free space calculation is
>> wrong due to a corrupted filesystem) it will never progress.
>>
>> Check for space being required when no transactions are outstanding and
>> abort the journal instead of endlessly looping.
>>
>> This patch fixes the bug reported by Sami Liedes at:
>> http://bugzilla.kernel.org/show_bug.cgi?id=10976
>>
>> Signed-off-by: Duane Griffin <duaneg@dghda.com>
>> Tested-by: Sami Liedes <sliedes@cc.hut.fi>
>> ---
>> diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
>> index a5432bb..9fac177 100644
>> --- a/fs/jbd/checkpoint.c
>> +++ b/fs/jbd/checkpoint.c
>> @@ -126,14 +126,29 @@ void __log_wait_for_space(journal_t *journal)
>>
>>               /*
>>                * Test again, another process may have checkpointed while we
>> -              * were waiting for the checkpoint lock
>> +              * were waiting for the checkpoint lock. If there are no
>> +              * outstanding transactions there is nothing to checkpoint and
>> +              * we can't make progress. Abort the journal in this case.
>>                */
>>               spin_lock(&journal->j_state_lock);
>> +             spin_lock(&journal->j_list_lock);
>>               nblocks = jbd_space_needed(journal);
>>               if (__log_space_left(journal) < nblocks) {
>> +                     int chkpt = journal->j_checkpoint_transactions != NULL;
>> +
>> +                     spin_unlock(&journal->j_list_lock);
>>                       spin_unlock(&journal->j_state_lock);
>> -                     log_do_checkpoint(journal);
>> +                     if (chkpt) {
>> +                             log_do_checkpoint(journal);
>> +                     } else {
>> +                             printk(KERN_ERR "%s: no transactions\n",
>> +                                    __func__);
>> +                             journal_abort(journal, 0);
>> +                     }
>> +
>>                       spin_lock(&journal->j_state_lock);
>> +             } else {
>> +                     spin_unlock(&journal->j_list_lock);
>>               }
>>               mutex_unlock(&journal->j_checkpoint_mutex);
>>       }
>
> I don't expect that the additional taking of j_list_lock in here does
> anything useful.
>
> Plus..  after j_list_lock has been dropped, new transactions could
> theoretically appear at journal->j_checkpoint_transactions, so we
> _could_ reclaim more journal space.  But a) that probably couldn't
> happen due to ->j_state_lock and lots of other things and b) it's
> hopelessly theoretical even if it _could_ happen, methinks.  Just
> sayin'..

Fair enough. I was just trying to be extra careful in taking the lock,
so I'm happy to drop it if you think it is safe. It will simplify the
patch significantly.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
