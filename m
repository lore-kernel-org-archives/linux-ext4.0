From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3] Adding support to freeze and unfreeze a journal
Date: Wed, 11 May 2011 03:05:54 -0600
Message-ID: <93775CC9-ACDF-4AD4-96C3-F791679008EE@dilger.ca>
References: <4DC7F0E4.5070507@canonical.com> <1304952692-3858-1-git-send-email-surbhi.palande@canonical.com> <4DC806E9.1070806@redhat.com> <4DCA3583.7010904@canonical.com>
Mime-Version: 1.0 (iPhone Mail 8H7)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>, "jack@suse.cz" <jack@suse.cz>,
	"marco.stornelli@gmail.com" <marco.stornelli@gmail.com>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"toshi.okajima@jp.fujitsu.com" <toshi.okajima@jp.fujitsu.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"m.mizuma@jp.fujitsu.com" <m.mizuma@jp.fujitsu.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: "surbhi.palande@canonical.com" <surbhi.palande@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.resortinternet.net ([65.114.208.136]:60201 "EHLO
	smtp.resortinternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab1EKXuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 May 2011 19:50:55 -0400
In-Reply-To: <4DCA3583.7010904@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-05-11, at 1:06 AM, Surbhi Palande <surbhi.palande@canonical.com> wrote:

> On 05/09/2011 06:23 PM, Eric Sandeen wrote:
>> On 5/9/11 9:51 AM, Surbhi Palande wrote:
>>> The journal should be frozen when a F.S freezes. What this means is that till
>>> the F.S is thawed again, no new transactions should be accepted by the
>>> journal. When the F.S thaws, inturn it should thaw the journal and this should
>>> allow the journal to resume accepting new transactions.
>>> While the F.S has frozen the journal, the clients of journal on calling
>>> jbd2_journal_start() will sleep on a wait queue. Thawing the journal will wake
>>> up the sleeping clients and journalling can progress normally.
>> 
>> Can I ask how this was tested?
> 
> Yes! I did the following on an ext4 fs mount:
> 1. fsfreeze -f $MNT
> 2. dd if=/dev/zero of=$MNT/file count=10 bs=1024 &
> 3. sync
> 4. fsfreeze -u $MNT
> 
> If the dd blocks on the start_handle, then the page cache is clean and sync should have nothing to write and everything will work fine. But otherwise this should sequence should create a deadlock.

Sorry to ask the obvious question, but presumably this test fails without your patch?  It isn't clear from your comment that this is the case. 

> I have attempted to create a patch for xfs-test. Shall send it out as a reply to this email soon!
> 
> Warm Regards,
> Surbhi.
> 
> 
> 
>> 
>> Ideally anything you found useful for testing should probably be integrated
>> into the xfstests test suite so that we don't regresss in the future.
>> 
>> thanks,
>> -Eric
>> 
>>> Signed-off-by: Surbhi Palande<surbhi.palande@canonical.com>
>>> ---
>>> Changes since the last patch:
>>> * Changed to the shorter forms of expressions eg: x |= y
>>> * removed the unnecessary barrier
>>> 
>>>  fs/ext4/super.c       |   20 ++++++--------------
>>>  fs/jbd2/journal.c     |    1 +
>>>  fs/jbd2/transaction.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>>>  include/linux/jbd2.h  |   10 ++++++++++
>>>  4 files changed, 59 insertions(+), 14 deletions(-)
>>> 
>>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>>> index 8553dfb..796aa4c 100644
>>> --- a/fs/ext4/super.c
>>> +++ b/fs/ext4/super.c
>>> @@ -4179,23 +4179,15 @@ static int ext4_freeze(struct super_block *sb)
>>> 
>>>      journal = EXT4_SB(sb)->s_journal;
>>> 
>>> -    /* Now we set up the journal barrier. */
>>> -    jbd2_journal_lock_updates(journal);
>>> -
>>> +    error = jbd2_journal_freeze(journal);
>>>      /*
>>> -     * Don't clear the needs_recovery flag if we failed to flush
>>> +     * Don't clear the needs_recovery flag if we failed to freeze
>>>       * the journal.
>>>       */
>>> -    error = jbd2_journal_flush(journal);
>>> -    if (error<  0)
>>> -        goto out;
>>> -
>>> -    /* Journal blocked and flushed, clear needs_recovery flag. */
>>> -    EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
>>> -    error = ext4_commit_super(sb, 1);
>>> -out:
>>> -    /* we rely on s_frozen to stop further updates */
>>> -    jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
>>> +    if (error>= 0) {
>>> +        EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
>>> +        error = ext4_commit_super(sb, 1);
>>> +    }
>>>      return error;
>>>  }
>>> 
>>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>>> index e0ec3db..5e46333 100644
>>> --- a/fs/jbd2/journal.c
>>> +++ b/fs/jbd2/journal.c
>>> @@ -842,6 +842,7 @@ static journal_t * journal_init_common (void)
>>>      init_waitqueue_head(&journal->j_wait_checkpoint);
>>>      init_waitqueue_head(&journal->j_wait_commit);
>>>      init_waitqueue_head(&journal->j_wait_updates);
>>> +    init_waitqueue_head(&journal->j_wait_frozen);
>>>      mutex_init(&journal->j_barrier);
>>>      mutex_init(&journal->j_checkpoint_mutex);
>>>      spin_lock_init(&journal->j_revoke_lock);
>>> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
>>> index 05fa77a..b040293 100644
>>> --- a/fs/jbd2/transaction.c
>>> +++ b/fs/jbd2/transaction.c
>>> @@ -171,6 +171,17 @@ repeat:
>>>                  journal->j_barrier_count == 0);
>>>          goto repeat;
>>>      }
>>> +    /* dont let a new handle start when a journal is frozen.
>>> +     * jbd2_journal_freeze calls jbd2_journal_unlock_updates() only after
>>> +     * the jflags indicate that the journal is frozen. So if the
>>> +     * j_barrier_count is 0, then check if this was made 0 by the freezing
>>> +     * process
>>> +     */
>>> +    if (journal->j_flags&  JBD2_FROZEN) {
>>> +        read_unlock(&journal->j_state_lock);
>>> +        jbd2_check_frozen(journal);
>>> +        goto repeat;
>>> +    }
>>> 
>>>      if (!journal->j_running_transaction) {
>>>          read_unlock(&journal->j_state_lock);
>>> @@ -489,6 +500,37 @@ int jbd2_journal_restart(handle_t *handle, int nblocks)
>>>  }
>>>  EXPORT_SYMBOL(jbd2_journal_restart);
>>> 
>>> +int jbd2_journal_freeze(journal_t *journal)
>>> +{
>>> +    int error = 0;
>>> +    /* Now we set up the journal barrier. */
>>> +    jbd2_journal_lock_updates(journal);
>>> +
>>> +    /*
>>> +     * Don't clear the needs_recovery flag if we failed to flush
>>> +     * the journal.
>>> +     */
>>> +    error = jbd2_journal_flush(journal);
>>> +    if (error>= 0) {
>>> +        write_lock(&journal->j_state_lock);
>>> +        journal->j_flags |= JBD2_FROZEN;
>>> +        write_unlock(&journal->j_state_lock);
>>> +    }
>>> +    jbd2_journal_unlock_updates(journal);
>>> +    return error;
>>> +}
>>> +EXPORT_SYMBOL(jbd2_journal_freeze);
>>> +
>>> +void jbd2_journal_thaw(journal_t * journal)
>>> +{
>>> +    write_lock(&journal->j_state_lock);
>>> +    journal->j_flags&= ~JBD2_FROZEN;
>>> +    write_unlock(&journal->j_state_lock);
>>> +    wake_up(&journal->j_wait_frozen);
>>> +}
>>> +EXPORT_SYMBOL(jbd2_journal_thaw);
>>> +
>>> +
>>>  /**
>>>   * void jbd2_journal_lock_updates () - establish a transaction barrier.
>>>   * @journal:  Journal to establish a barrier on.
>>> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
>>> index a32dcae..c7885b2 100644
>>> --- a/include/linux/jbd2.h
>>> +++ b/include/linux/jbd2.h
>>> @@ -718,6 +718,7 @@ jbd2_time_diff(unsigned long start, unsigned long end)
>>>   * @j_wait_checkpoint:  Wait queue to trigger checkpointing
>>>   * @j_wait_commit: Wait queue to trigger commit
>>>   * @j_wait_updates: Wait queue to wait for updates to complete
>>> + * @j_wait_frozen: Wait queue to wait for journal to thaw
>>>   * @j_checkpoint_mutex: Mutex for locking against concurrent checkpoints
>>>   * @j_head: Journal head - identifies the first unused block in the journal
>>>   * @j_tail: Journal tail - identifies the oldest still-used block in the
>>> @@ -835,6 +836,9 @@ struct journal_s
>>>      /* Wait queue to wait for updates to complete */
>>>      wait_queue_head_t    j_wait_updates;
>>> 
>>> +    /* Wait queue to wait for journal to thaw*/
>>> +    wait_queue_head_t    j_wait_frozen;
>>> +
>>>      /* Semaphore for locking against concurrent checkpoints */
>>>      struct mutex        j_checkpoint_mutex;
>>> 
>>> @@ -1013,7 +1017,11 @@ struct journal_s
>>>  #define JBD2_ABORT_ON_SYNCDATA_ERR    0x040    /* Abort the journal on file
>>>                           * data write error in ordered
>>>                           * mode */
>>> +#define JBD2_FROZEN    0x080   /* Journal thread is frozen as the filesystem is frozen */
>>> +
>>> 
>>> +#define jbd2_check_frozen(journal)    \
>>> +        wait_event(journal->j_wait_frozen, (journal->j_flags&  JBD2_FROZEN))
>>>  /*
>>>   * Function declarations for the journaling transaction and buffer
>>>   * management
>>> @@ -1121,6 +1129,8 @@ extern void     jbd2_journal_invalidatepage(journal_t *,
>>>                  struct page *, unsigned long);
>>>  extern int     jbd2_journal_try_to_free_buffers(journal_t *, struct page *, gfp_t);
>>>  extern int     jbd2_journal_stop(handle_t *);
>>> +extern int     jbd2_journal_freeze(journal_t *);
>>> +extern void     jbd2_journal_thaw(journal_t *);
>>>  extern int     jbd2_journal_flush (journal_t *);
>>>  extern void     jbd2_journal_lock_updates (journal_t *);
>>>  extern void     jbd2_journal_unlock_updates (journal_t *);
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
