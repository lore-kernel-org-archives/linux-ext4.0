From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH] jbd2:Make journal transaction allocations come from its
 own cache.
Date: Thu, 9 Jun 2011 00:20:02 -0700
Message-ID: <BANLkTinb1tiyNsn1XQnZXjqtJ++tFDf+=w@mail.gmail.com>
References: <1307262510-16376-1-git-send-email-mkatiyar@gmail.com>
 <20110608164903.GG5361@quack.suse.cz> <BANLkTin4KYRZcmyiEeV2QL9PWOz3rVAhsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41418 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab1FIHUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Jun 2011 03:20:23 -0400
Received: by vxi39 with SMTP id 39so963894vxi.19
        for <linux-ext4@vger.kernel.org>; Thu, 09 Jun 2011 00:20:22 -0700 (PDT)
In-Reply-To: <BANLkTin4KYRZcmyiEeV2QL9PWOz3rVAhsQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 8, 2011 at 11:35 PM, Manish Katiyar <mkatiyar@gmail.com> wr=
ote:
> On Wed, Jun 8, 2011 at 9:49 AM, Jan Kara <jack@suse.cz> wrote:
>> On Sun 05-06-11 01:28:30, Manish Katiyar wrote:
>>> Add a cache for jbd2 journal transaction allocations. This also
>>> helps to leverage fault-injection framework to test various memory
>>> allocation failures in the jbd2 layer.
>>>
>>> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
>>> ---
>>> =A0fs/jbd2/checkpoint.c =A0| =A0 =A02 +-
>>> =A0fs/jbd2/commit.c =A0 =A0 =A0| =A0 =A02 +-
>>> =A0fs/jbd2/journal.c =A0 =A0 | =A0 25 +++++++++++++++++++++++++
>>> =A0fs/jbd2/transaction.c | =A0 =A07 ++++---
>>> =A0include/linux/jbd2.h =A0| =A0 21 +++++++++++++++++++++
>>> =A05 files changed, 52 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
>>> index 6a79fd0..6f554ce 100644
>>> --- a/fs/jbd2/checkpoint.c
>>> +++ b/fs/jbd2/checkpoint.c
>>> @@ -716,7 +716,7 @@ int __jbd2_journal_remove_checkpoint(struct jou=
rnal_head *jh)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 transaction->t_tid, stats);
>>>
>>> =A0 =A0 =A0 __jbd2_journal_drop_transaction(journal, transaction);
>>> - =A0 =A0 kfree(transaction);
>>> + =A0 =A0 jbd2_free_transaction(transaction);
>>>
>>> =A0 =A0 =A0 /* Just in case anybody was waiting for more transactio=
ns to be
>>> =A0 =A0 =A0 =A0 =A0 =A0 checkpointed... */
>>> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
>>> index 7f21cf3..8e33d84 100644
>>> --- a/fs/jbd2/commit.c
>>> +++ b/fs/jbd2/commit.c
>>> @@ -1037,7 +1037,7 @@ restart_loop:
>>> =A0 =A0 =A0 jbd_debug(1, "JBD: commit %d complete, head %d\n",
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 journal->j_commit_sequence, journal=
->j_tail_sequence);
>>> =A0 =A0 =A0 if (to_free)
>>> - =A0 =A0 =A0 =A0 =A0 =A0 kfree(commit_transaction);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 jbd2_free_transaction(commit_transaction)=
;
>>>
>>> =A0 =A0 =A0 wake_up(&journal->j_wait_done_commit);
>>> =A0}
>>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>>> index 9a78269..c0ec463 100644
>>> --- a/fs/jbd2/journal.c
>>> +++ b/fs/jbd2/journal.c
>>> @@ -95,6 +95,7 @@ EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
>>> =A0EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
>>> =A0EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
>>> =A0EXPORT_SYMBOL(jbd2_inode_cache);
>>> +EXPORT_SYMBOL(jbd2_transaction_cache);
>>>
>>> =A0static int journal_convert_superblock_v1(journal_t *, journal_su=
perblock_t *);
>>> =A0static void __journal_abort_soft (journal_t *journal, int errno)=
;
>>> @@ -2371,6 +2372,27 @@ static void jbd2_journal_destroy_handle_cach=
e(void)
>>>
>>> =A0}
>>>
>>> +struct kmem_cache *jbd2_transaction_cache;
>>> +
>>> +static int journal_init_transaction_cache(void)
>>> +{
>>> + =A0 =A0 J_ASSERT(jbd2_transaction_cache =3D=3D NULL);
>>> + =A0 =A0 jbd2_transaction_cache =3D kmem_cache_create("jbd2_transa=
ction",
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(transaction_t),
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A00, SLAB_TEMPORARY, NULL);
>> =A0Transactions are not really short-lived in the memory-management =
sense I
>> think. They usually live for seconds while I'd understand 'short-liv=
ed' to
>> mean a milisecond or less. So just drop this flag (it doesn't do any=
thing
>> these days anyway).
>>
>>> + =A0 =A0 if (jbd2_transaction_cache =3D=3D NULL) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_EMERG "JBD2: failed to create=
 transaction cache\n");
>>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>>> + =A0 =A0 }
>>> + =A0 =A0 return 0;
>>> +}
>>> +
>>> +static void jbd2_journal_destroy_transaction_cache(void)
>>> +{
>>> + =A0 =A0 if (jbd2_transaction_cache)
>> =A0How can this happen?
>
> Hi Jan,
>
> In start_this_handle() we can pass a NULL value here. Since we had
> kfree() earlier which could silently handle NULL, either I can check
> before calling or handle it here. To verify I removed the if conditio=
n
> and it immediately panic'd on boot.
>
> (gdb) do
> #20 start_this_handle (journal=3D0x17cd7c00, handle=3D0x1790e000,
> gfp_mask=3D80) at fs/jbd2/transaction.c:285
> 285 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_free_transaction(new_transaction);
> (gdb) l
> 280 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&transact=
ion->t_outstanding_credits),
> 281 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __jbd2_log_space_left=
(journal));
> 282 =A0 =A0 =A0 =A0 =A0 =A0 read_unlock(&journal->j_state_lock);
> 283
> 284 =A0 =A0 =A0 =A0 =A0 =A0 lock_map_acquire(&handle->h_lockdep_map);
> 285 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_free_transaction(new_transaction);
> 286
> 287 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> 288 =A0 =A0 }
> 289
> (gdb) p new_transaction
> $1 =3D (transaction_t *) 0x0
>
>
> I'll send a patch shortly with other comments incorporated.

Sorry, I misread your comment. You are right...this should never happen=
=2E

--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
