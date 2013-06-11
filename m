From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 2/4] jbd2/log_wait_for_space: drop checkpoint mutex when waiting
Date: Mon, 10 Jun 2013 23:20:50 -0400
Message-ID: <CAP=VYLofXDGQ5Vjc9S-p1VyVmzYU1ZxcZn5=mDtLZZbtdv9Lig@mail.gmail.com>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
 <1370892723-30860-3-git-send-email-paul.gortmaker@windriver.com> <20130611023331.GB23966@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, linux-rt-users@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41874 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3FKDVW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Jun 2013 23:21:22 -0400
In-Reply-To: <20130611023331.GB23966@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 10, 2013 at 10:33 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Jun 10, 2013 at 03:32:01PM -0400, Paul Gortmaker wrote:
>>
>> What is interesting here, is that we call log_wait_commit, from
>> within wait_for_space, but we are still holding the checkpoint_mutex
>> as it surrounds mostly the whole of wait_for_space.  And then, as we
>> are waiting, journal_commit_transaction can run, and if the JBD2_FLUSHED
>> bit is set, then we will also try to take the same checkpoint_mutex.
>
>>                       } else if (tid) {
>> +                             /*
>> +                              * jbd2_journal_commit_transaction() may want
>> +                              * to take the checkpoint_mutex if JBD2_FLUSHED
>> +                              * is set.  So we need to temporarily drop it.
>> +                              */
>> +                             mutex_unlock(&journal->j_checkpoint_mutex);
>>                               jbd2_log_wait_commit(journal, tid);
>> +                             mutex_lock(&journal->j_checkpoint_mutex);
>>                       } else {
>>                               printk(KERN_ERR "%s: needed %d blocks and "
>>                                      "only had %d space available\n",
>
> After we execute the code in the else cause, we drop through to just
> before the bottom of the while loop, where we see:
>
>                 mutex_unlock(&journal->j_checkpoint_mutex);
>         }
>
> So it would be better to change things like this instead, so we don't
> end up grabbing and releasing the j_checkpoint_mutex unnecessarily:
>
>                         } else if (tid) {
> +                               /*
> +                                * jbd2_journal_commit_transaction() may want
> +                                * to take the checkpoint_mutex if JBD2_FLUSHED
> +                                * is set.  So we need to temporarily drop it.
> +                                */
> +                               mutex_unlock(&journal->j_checkpoint_mutex);
>                                 jbd2_log_wait_commit(journal, tid);
> +                               write_lock(&journal->j_state_lock);
> +                               continue;
>                         } else {
>                                 printk(KERN_ERR "%s: needed %d blocks and "
>                                        "only had %d space available\n",
>
> Could you try respinning the patch like this and testing the result?

Absolutely; will do that tomorrow and re-test on 3.10-rc5.

And I'll keep it in my preempt-rt testing queue too, as I keep
looking into that RT problem.

Thanks for reviewing and confirming it could be a real problem.

Paul.
--

>
> Thanks,
>
>                                                 - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
