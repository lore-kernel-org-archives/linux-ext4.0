From: Surbhi Palande <csurbhi@gmail.com>
Subject: Re: [PATCH v2 1/7] Adding support to freeze and unfreeze a journal
Date: Tue, 10 Jan 2012 14:00:07 -0800
Message-ID: <CAMBkX3fxRKP-o-ccz7KaEZ-mvh_Q7xzB2=r42KEUOW2NPsjKfQ@mail.gmail.com>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
	<1323367477-21685-2-git-send-email-kamal@canonical.com>
	<4F0C9D87.8010006@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Kamal Mostafa <kamal@canonical.com>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Surbhi Palande <surbhi.palande@canonical.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36367 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab2AJWAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jan 2012 17:00:09 -0500
In-Reply-To: <4F0C9D87.8010006@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Hrm let me think through this a little more; we actually do:
>
> t16) ext4_journal_start()
> =C2=A0t17) ext4_journal_start_sb()
> =C2=A0 =C2=A0t18) handle =3D ext4_journal_current_handle();
> =C2=A0 =C2=A0t19) if (!handle) vfs_check_frozen()
> =C2=A0 =C2=A0t20) ... jbd2_journal_start()
>
> So actually we *do* block new handles, but let *existing* ones
> continue (see commits 6b0310fbf087ad6e9e3b8392adca97cd77184084
> and be4f27d324e8ddd57cc0d4d604fe85ee0425cba9)
>
> So your assertion that a new handle is started is incorrect
> in general, isn't it? =C2=A0So then does the fix seem necessary?
> Or, at least, in the fashion below - maybe we need to just make
> sure all started handles complete before the unlock_updates?
> Or am I missing something...?
>
> -Eric

This patch addresses the race that occurs between filesystem freeze
and jbd2_journal_start().

     Task1                                              Task2
t1) vfs_check_frozen()
t2) -------------------------------------------------------------------=
--
t3)                                                   filesystem is fro=
zen.
t4) jbd2_journal_start()

Without this patch a new handle can be started because of the race.
With this patch, no new journaled transaction can start after the
journal is frozen and hence no new journaled writes can be made.

Regards,
Surbhi



>
>>
>> BugLink: https://bugs.launchpad.net/bugs/897421
>> Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
>> Acked-by: Jan Kara <jack@suse.cz>
>> Reviewed-by: Andreas Dilger <adilger.kernel@dilger.ca>
>> Cc: Kamal Mostafa <kamal@canonical.com>
>> Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
>> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
>> ---
>> =C2=A0fs/jbd2/journal.c =C2=A0 =C2=A0 | =C2=A0 =C2=A01 +
>> =C2=A0fs/jbd2/transaction.c | =C2=A0 42 ++++++++++++++++++++++++++++=
++++++++++++++
>> =C2=A0include/linux/jbd2.h =C2=A0| =C2=A0 =C2=A07 +++++++
>> =C2=A03 files changed, 50 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index 0fa0123..f0170cc 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -894,6 +894,7 @@ static journal_t * journal_init_common (void)
>> =C2=A0 =C2=A0 =C2=A0 init_waitqueue_head(&journal->j_wait_checkpoint=
);
>> =C2=A0 =C2=A0 =C2=A0 init_waitqueue_head(&journal->j_wait_commit);
>> =C2=A0 =C2=A0 =C2=A0 init_waitqueue_head(&journal->j_wait_updates);
>> + =C2=A0 =C2=A0 init_waitqueue_head(&journal->j_wait_frozen);
>> =C2=A0 =C2=A0 =C2=A0 mutex_init(&journal->j_barrier);
>> =C2=A0 =C2=A0 =C2=A0 mutex_init(&journal->j_checkpoint_mutex);
>> =C2=A0 =C2=A0 =C2=A0 spin_lock_init(&journal->j_revoke_lock);
>> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
>> index a0e41a4..340ee35 100644
>> --- a/fs/jbd2/transaction.c
>> +++ b/fs/jbd2/transaction.c
>> @@ -173,6 +173,17 @@ repeat:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 journal->j_barrier_count =3D=3D 0);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto repeat;
>> =C2=A0 =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 /* Don't let a new handle start when a journal is fr=
ozen.
>> + =C2=A0 =C2=A0 =C2=A0* jbd2_journal_freeze calls jbd2_journal_unloc=
k_updates() only after
>> + =C2=A0 =C2=A0 =C2=A0* the j_flags indicate that the journal is fro=
zen. So if the
>> + =C2=A0 =C2=A0 =C2=A0* j_barrier_count is 0, then check if this was=
 made 0 by the freezing
>> + =C2=A0 =C2=A0 =C2=A0* process
>> + =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 if (journal->j_flags & JBD2_FROZEN) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 read_unlock(&journal->j_=
state_lock);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wait_event(journal->j_wa=
it_frozen, (journal->j_flags & JBD2_FROZEN));
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto repeat;
>> + =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 if (!journal->j_running_transaction) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 read_unlock(&journa=
l->j_state_lock);
>> @@ -492,6 +503,37 @@ int jbd2_journal_restart(handle_t *handle, int =
nblocks)
>> =C2=A0}
>> =C2=A0EXPORT_SYMBOL(jbd2_journal_restart);
>>
>> +int jbd2_journal_freeze(journal_t *journal)
>> +{
>> + =C2=A0 =C2=A0 int error =3D 0;
>> + =C2=A0 =C2=A0 /* Now we set up the journal barrier. */
>> + =C2=A0 =C2=A0 jbd2_journal_lock_updates(journal);
>> +
>> + =C2=A0 =C2=A0 /*
>> + =C2=A0 =C2=A0 =C2=A0* Don't clear the needs_recovery flag if we fa=
iled to flush
>> + =C2=A0 =C2=A0 =C2=A0* the journal.
>> + =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 error =3D jbd2_journal_flush(journal);
>> + =C2=A0 =C2=A0 if (error >=3D 0) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 write_lock(&journal->j_s=
tate_lock);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 journal->j_flags |=3D JB=
D2_FROZEN;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 write_unlock(&journal->j=
_state_lock);
>> + =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 jbd2_journal_unlock_updates(journal);
>> + =C2=A0 =C2=A0 return error;
>> +}
>> +EXPORT_SYMBOL(jbd2_journal_freeze);
>> +
>> +void jbd2_journal_thaw(journal_t * journal)
>> +{
>> + =C2=A0 =C2=A0 write_lock(&journal->j_state_lock);
>> + =C2=A0 =C2=A0 journal->j_flags &=3D ~JBD2_FROZEN;
>> + =C2=A0 =C2=A0 write_unlock(&journal->j_state_lock);
>> + =C2=A0 =C2=A0 wake_up(&journal->j_wait_frozen);
>> +}
>> +EXPORT_SYMBOL(jbd2_journal_thaw);
>> +
>> +
>> =C2=A0/**
>> =C2=A0 * void jbd2_journal_lock_updates () - establish a transaction=
 barrier.
>> =C2=A0 * @journal: =C2=A0Journal to establish a barrier on.
>> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
>> index 2092ea2..bfa0752 100644
>> --- a/include/linux/jbd2.h
>> +++ b/include/linux/jbd2.h
>> @@ -658,6 +658,7 @@ jbd2_time_diff(unsigned long start, unsigned lon=
g end)
>> =C2=A0 * @j_wait_checkpoint: =C2=A0Wait queue to trigger checkpointi=
ng
>> =C2=A0 * @j_wait_commit: Wait queue to trigger commit
>> =C2=A0 * @j_wait_updates: Wait queue to wait for updates to complete
>> + * @j_wait_frozen: Wait queue to wait for journal to thaw
>> =C2=A0 * @j_checkpoint_mutex: Mutex for locking against concurrent c=
heckpoints
>> =C2=A0 * @j_head: Journal head - identifies the first unused block i=
n the journal
>> =C2=A0 * @j_tail: Journal tail - identifies the oldest still-used bl=
ock in the
>> @@ -775,6 +776,9 @@ struct journal_s
>> =C2=A0 =C2=A0 =C2=A0 /* Wait queue to wait for updates to complete *=
/
>> =C2=A0 =C2=A0 =C2=A0 wait_queue_head_t =C2=A0 =C2=A0 =C2=A0 j_wait_u=
pdates;
>>
>> + =C2=A0 =C2=A0 /* Wait queue to wait for journal to thaw*/
>> + =C2=A0 =C2=A0 wait_queue_head_t =C2=A0 =C2=A0 =C2=A0 j_wait_frozen=
;
>> +
>> =C2=A0 =C2=A0 =C2=A0 /* Semaphore for locking against concurrent che=
ckpoints */
>> =C2=A0 =C2=A0 =C2=A0 struct mutex =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0j_checkpoint_mutex;
>>
>> @@ -953,6 +957,7 @@ struct journal_s
>> =C2=A0#define JBD2_ABORT_ON_SYNCDATA_ERR =C2=A0 0x040 =C2=A0 /* Abor=
t the journal on file
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0* data write error in ordered
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0* mode */
>> +#define JBD2_FROZEN =C2=A00x080 /* Journal thread frozen along with=
 filesystem */
>>
>> =C2=A0/*
>> =C2=A0 * Function declarations for the journaling transaction and bu=
ffer
>> @@ -1060,6 +1065,8 @@ extern void =C2=A0 =C2=A0 =C2=A0jbd2_journal_i=
nvalidatepage(journal_t *,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct page *, unsigned long);
>> =C2=A0extern int =C2=A0 =C2=A0jbd2_journal_try_to_free_buffers(journ=
al_t *, struct page *, gfp_t);
>> =C2=A0extern int =C2=A0 =C2=A0jbd2_journal_stop(handle_t *);
>> +extern int =C2=A0 =C2=A0jbd2_journal_freeze(journal_t *);
>> +extern void =C2=A0 jbd2_journal_thaw(journal_t *);
>> =C2=A0extern int =C2=A0 =C2=A0jbd2_journal_flush (journal_t *);
>> =C2=A0extern void =C2=A0 jbd2_journal_lock_updates (journal_t *);
>> =C2=A0extern void =C2=A0 jbd2_journal_unlock_updates (journal_t *);
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
