From: Surbhi Palande <csurbhi@gmail.com>
Subject: Re: [PATCH v2 1/7] Adding support to freeze and unfreeze a journal
Date: Tue, 10 Jan 2012 22:06:57 -0800
Message-ID: <CAMBkX3fMBUiQj1YRU90YzyoY0setFeRmJDff5+cu75BpfCM_ug@mail.gmail.com>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
	<1323367477-21685-2-git-send-email-kamal@canonical.com>
	<4F0C9D87.8010006@sandeen.net>
	<20120110213104.GI4516@quack.suse.cz>
	<CAMBkX3eVeKSmEzmYTe6Oe_D6kAMQTL5LYoi1-Axj7CcrM85Pow@mail.gmail.com>
	<20120111000448.GA16395@quack.suse.cz>
	<CAMBkX3e_jyTZ=i8D8_cza23Xygd+Gf5iACZ+hbo5TaYLrJPH-Q@mail.gmail.com>
	<CAMBkX3e8CKaDh7vdqAcTH1tnye4UusPZ_XjJdNVRZcaDqZnt2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Kamal Mostafa <kamal@canonical.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48443 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab2AKGG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jan 2012 01:06:59 -0500
Received: by bkvi17 with SMTP id i17so255662bkv.19
        for <linux-ext4@vger.kernel.org>; Tue, 10 Jan 2012 22:06:57 -0800 (PST)
In-Reply-To: <CAMBkX3e8CKaDh7vdqAcTH1tnye4UusPZ_XjJdNVRZcaDqZnt2g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(Resending one of the last cases, as the two task scenario got mixed! )

> Now following is the case where the writing
> process/jbd2_journal_start() calls read_lock() *before*
> jbd2_journal_lock_updates() are called by the freezing process.
>

        CPU1						                              CPU2
    Task1 (write operation)				                               Task2
tx	   read_lock(&journal->j_state_lock)	=09
tx+1							               jbd2_journal_lock_updates() (will be stuck
at the next instance...)
tx+3 	if(journal->j_barrier_count)		=09
write_lock(journal->j_state_lock) /* stuck here till Task1
relinquishes the lock*/
tx+4  handle started and associated with
        running transaction.
tx+5   read_unlock(&journal->j_state_lock)
tx+6							               jbd2_journal_lock_updates() succeeds
tx+7							               jbd2_journal_flush() /* This shall flush the
running transactions */
							                 /* There are no outstanding transcations. No
new ext4_journal_start() will succeed by this point */
> --------------------------------
> Thus:
>
> Though a racy transaction can really be started after SB_FREEZE_WRITE=
,
> either that transaction will be flushed by jbd2_journal_flush or it
> cannot be started at all because of the barrier count.
>
> So, I do not understand why the journaled writes should really have a
> race window after this patch is applied?
>

Regards,
Surbhi


On Tue, Jan 10, 2012 at 9:38 PM, Surbhi Palande <csurbhi@gmail.com> wro=
te:
> On second thoughts, I fail to see why there is still a race window
> after this patch.
>
> Here are the reasons why i fail to see how the data can be dirtied
> when all the operations involve a journal:
>
> ----------
> So here is the problem that we see
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CPU1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
CPU2
> =C2=A0 =C2=A0 =C2=A0 Task1 (write operation) =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0Task2
> ---------------------------------------------------------------------=
------------------
> t1 =C2=A0 =C2=A0 =C2=A0ext4_journal_start()
> t2 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_journal_start_sb()
> t3 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vfs_check_frozen =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0sb->frozen=3DSB_FREEZE_WRITE
> t4 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0jbd2_journal_start=
() =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
/* hence forth all processes calling
> vfs_check_frozen will wait */
>
> Now, our aim is to stop Task1 from dirtying the page cache ie in
> starting this transaction. However if it is successful in starting
> this transaction, then we want to make sure that this transaction is
> flushed out.
> Correct?
>
> (with the journal freeze patch applied)
> * Task1 is now executing the code of jbd2_journal_start(). Task2 is
> the freezing process.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CPU1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CPU2
> =C2=A0 =C2=A0 =C2=A0 Task1 (write operation) =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Task2
> t4 =C2=A0 =C2=A0 =C2=A0jbd2_journal_start()
> ...
> tx =C2=A0 =C2=A0 =C2=A0 =C2=A0 read_lock(&journal->j_state_lock)
>
> Now two things can happen at this point with respect to Task2:
> a) either journal->j_flags is set to JBD2_FROZEN already
> b) or it is not set.
>
>
> Lets look at both the cases:
> A) When journal->j_flags is set to JBD2_FROZEN already then
> jbd2_journal_start() will get stuck on the waitqueue as long as =C2=A0=
the
> journal->j_flags is JBD2_FROZEN. So we cannot create dirty data in
> this case.
>
> B) When journal->j_flags is not set to JBD2_ FROZEN then two more
> things could happen:
> Task2 has already finished the call to jbd2_journal_flush() by the
> time Task1 calls read_lock(). So now no new task (T1) should create
> any new dirty data as that will not get flushed out. So we really wan=
t
> to stop the jbd2_journal_start() from succeeding.
>
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CPU1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0CPU2
> =C2=A0 =C2=A0 =C2=A0 Task1 (write operation) =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Task2
> ---------------------------------------------------------------------=
-------------------------
> tx =C2=A0 =C2=A0 =C2=A0 =C2=A0 read_lock(&journal->j_state_lock)
> jbd2_journal_lock_updates() /*journal->j_barrier_count incremented -
> so non zero ! */
> tx+1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 jbd2_journal_flush()
> tx+2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 write_lock(&journal->j_state_=
lock);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* till the read_l=
ock is relinquished by
> task1 , we are stuck */
> tx+3 =C2=A0 =C2=A0if(journal->j_barrier_count)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0read_unlock(&j=
ournal->j_state_lock);
>
> =C2=A0 =C2=A0 =C2=A0 /* so we can set the journal->j_flags now as wri=
te_lock()
> succeeds here */
> tx+4 =C2=A0 =C2=A0 goto repeat
>
> The above case is where the writing process/jbd2_journal_start() call=
s
> read_lock() *after* jbd2_journal_lock_updates() are called by the
> freezing process and hence is protected by the j_barrier_count check.
> This transaction can definitely not start!
>
> Now following is the case where the writing
> process/jbd2_journal_start() calls read_lock() *before*
> jbd2_journal_lock_updates() are called by the freezing process.
>
> However, if Task1 already finished starting the transaction as follow=
s:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CPU1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CPU2
> =C2=A0 =C2=A0 =C2=A0 Task1 (write operation)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Task2
> ---------------------------------------------------------------------=
-----------------------------------------------------------------------=
-----------------
> tx =C2=A0 =C2=A0 =C2=A0 =C2=A0 read_lock(&journal->j_state_lock)
> tx+1
> jbd2_journal_lock_updates() (will be stuck at the next instance...)
> tx+3 =C2=A0 =C2=A0 =C2=A0 =C2=A0if(journal->j_barrier_count)
> write_lock(journal->j_state_lock)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* journal->j_barrier_count =
=3D 0, so we proceed here*/
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* stuck here till T=
ask1 relinquishes the lock*/
> tx+4 =C2=A0 =C2=A0 read_unlock(&journal->j_state_lock);
> tx+5 now start_this_handle() returns successfully
> =C2=A0 =C2=A0 =C2=A0and associates this handle with the running
> =C2=A0 =C2=A0 =C2=A0 =C2=A0transaction.
> tx+6
> jbd2_journal_lock_updates() succeeds
> tx+7
> jbd2_journal_flush() /* This shall flush the running transactions */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* There are no
> outstanding transcations. No new ext4_journal_start() will succeed by
> this =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0point*/
>
> --------------------------------
> Thus:
>
> Though a racy transaction can really be started after SB_FREEZE_WRITE=
,
> either that transaction will be flushed by jbd2_journal_flush or it
> cannot be started at all because of the barrier count.
>
> So, I do not understand why the journaled writes should really have a
> race window after this patch is applied?
>
> Thanks!
>
> Regards,
> Surbhi
>
>
>
>
>
>
>
> On Tue, Jan 10, 2012 at 4:13 PM, Surbhi Palande <csurbhi@gmail.com> w=
rote:
>> Hi Jan,
>>
>>>>
>>>>
>>>> If all the write operations were journaled, then this patch would =
not allow
>>>> ext4 filesystem to have any dirty data after its frozen.
>>>> (as journal_start() would block).
>>>>
>>>> =C2=A0I think the only one candidate that creates dirty data witho=
ut calling
>>>> ext4_journal_start() is mmapped?
>>> =C2=A0No, the problem is in any write path. The problem is with ope=
rations
>>> that happen during the phase when s_frozen =3D=3D SB_FREEZE_WRITE. =
These
>>> operations dirty the filesystem but running sync may easily miss th=
em.
>>> During this phase journal is not frozen so that does not help you i=
n any
>>> way.
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Honza
>>
>> Ok! No new transaction can really start after the journal is frozen.
>> But we can have dirty data after SB_FREEZE_WRITE and before
>> SB_FREEZE_TRANS.
>> I agree with you. However, can this be fixed by adding a
>> sync_filesystem() in freeze_super() after the sb->s_op->freeze_fs() =
is
>> over?
>>
>>
>> So then essentially, when freeze_super() returns, the page cache is =
clean?
>>
>> I do definitely agree that the fix is to add a lock for mutual
>> exclusion between freeze filesystem and writes to a frozen filesyste=
m.
>>
>> Thanks!
>>
>> Regards,
>> Surbhi.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
