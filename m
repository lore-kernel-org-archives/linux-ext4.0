From: "Tummala, Sahitya" <stummala@codeaurora.org>
Subject: Re: [PATCH] jbd2: Fix use after free in kjournald2()
Date: Wed, 1 Feb 2017 09:52:41 +0530
Message-ID: <5c4bcc82-386a-a8b1-a752-42ec89446df4@codeaurora.org>
References: <1485873537-32514-1-git-send-email-stummala@codeaurora.org>
 <20170131155155.GC15249@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55470 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750784AbdBAEWr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jan 2017 23:22:47 -0500
In-Reply-To: <20170131155155.GC15249@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 1/31/2017 9:21 PM, Jan Kara wrote:
> On Tue 31-01-17 20:08:57, Sahitya Tummala wrote:
>> Below is the synchronization issue between unmount and kjournald2
>> contexts, which results into use after free issue in kjournald2().
>> Fix this issue by using journal->j_state_lock to synchronize the
>> wait_event() done in journal_kill_thread() and the wake_up() done
>> in kjournald2().
>>
>> TASK 1:
>> umount cmd:
>>     |--jbd2_journal_destroy() {
>>         |--journal_kill_thread() {
>>              write_lock(&journal->j_state_lock);
>> 	    journal->j_flags |= JBD2_UNMOUNT;
>> 	    ...
>> 	    write_unlock(&journal->j_state_lock);
>> 	    wake_up(&journal->j_wait_commit);	   TASK 2 wakes up here:
>> 	    					   kjournald2() {
>> 						     ...
>> 						     checks JBD2_UNMOUNT flag and calls goto end-loop;
>> 						     ...
>> 						     end_loop:
>> 						       write_unlock(&journal->j_state_lock);
>> 						       journal->j_task = NULL; --> If this thread gets
>> 						       pre-empted here, then TASK 1 wait_event will
>> 						       exit even before this thread is completely
>> 						       done.
>> 	    wait_event(journal->j_wait_done_commit, journal->j_task == NULL);
>> 	    ...
>> 	    write_lock(&journal->j_state_lock);
>> 	    write_unlock(&journal->j_state_lock);
>> 	  }
>>         |--kfree(journal);
>>       }
>> }
>> 						       wake_up(&journal->j_wait_done_commit); --> this step
>> 						       now results into use after free issue.
>> 						   }
>>
>> Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
> Yeah, what you write looks possible (although rather unlikely). Thanks for
> catching this. One small nit below:
Yes, it was observed only once and is very hard to reproduce.
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index a097048..f5cd3c0 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -278,9 +278,11 @@ static int kjournald2(void *arg)
>>   end_loop:
>>   	write_unlock(&journal->j_state_lock);
>>   	del_timer_sync(&journal->j_commit_timer);
>> +	write_lock(&journal->j_state_lock);
> There's no good reason to do del_timer_sync() outside of j_state_lock. This
> is not performance critical code and commit_timeout is trivial and cannot
> block on anything. So just keep j_state_lock locked upto the place where
> you unlock it now...
>
Sure, I will update the patch.
> 								Honza
>>   	journal->j_task = NULL;
>>   	wake_up(&journal->j_wait_done_commit);
>>   	jbd_debug(1, "Journal thread exiting.\n");
>> +	write_unlock(&journal->j_state_lock);
>>   	return 0;
>>   }
>>   
>> -- 
>> Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc.
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
>>
>>

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
