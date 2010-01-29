From: =?GB2312?B?tqG2qLuq?= <dingdinghua85@gmail.com>
Subject: Re: Should we discard jbddirty bit if BH_Freed is set?
Date: Fri, 29 Jan 2010 09:43:38 +0800
Message-ID: <7bb361261001281743h1ba743a4iada7f7cce5975eb3@mail.gmail.com>
References: <7bb361261001261832wb4f9ac2u96fdb6460aa45fa2@mail.gmail.com>
	 <20100127122333.GA3149@quack.suse.cz>
	 <7bb361261001271723n4fdad0e9l2171aa092baa0523@mail.gmail.com>
	 <20100128125354.GA3124@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f172.google.com ([209.85.223.172]:37166 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab0A2Bnj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Jan 2010 20:43:39 -0500
Received: by iwn2 with SMTP id 2so767980iwn.19
        for <linux-ext4@vger.kernel.org>; Thu, 28 Jan 2010 17:43:38 -0800 (PST)
In-Reply-To: <20100128125354.GA3124@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
    I think what we need to do is to distinguish the buffers which can
be discarded after
this transaction commits and which we must wait until the next transact=
ion
commits, and as you wrote, set b_next_transaction to running
transaction and file them
into t_forget list is a good way.

2010/1/28 Jan Kara <jack@suse.cz>:
>  Hi,
>
> On Thu 28-01-10 09:23:43, =B6=A1=B6=A8=BB=AA wrote:
>>     As you wrote, if T2!=3DT1, then T2 is committing transaction whi=
le T1
>>     is running transaction, and if T1 complete commit, we don't care
>>     about the content of buffers.  But there is a  prerequisite -->"=
T1
>>     complete commit", if T1 start commit and another transaction T3
>>     becomes the new running transaction, T3 may need to reuse T2 log
>>     space and force checkpoint, and since we have clean the BH_dirty=
 bit
>>     of buffers after T2 commits, so T2 may be freed before T1 comple=
te
>>     commit, and unfortunately, T1 doesn't complete commit, so after
>>     replay, updates of T2 get lost, fs becomes inconsistent.
>  Hmm, you are right. That could probably happen. It only hits ext3/4 =
in
> data=3Djournaled mode but the bug is there. But it's hard to fix it i=
n a
> reasonable way - if we would just leave the dirty bit set, we will ha=
ve
> aliasing problems - buffer B is attached to some page which used to b=
e from
> file F, so unmap_underlying_metadata will not find it because it look=
s only
> into page cache the block device, not to the pagecaches of individual
> files. So if we reallocate the block of B for some other file G befor=
e the
> buffer B is checkpointed, we have two dirty buffers representing the =
same
> block and thus data corruption can happen.
>  Maybe we could handle them by setting b_next_transaction to the
> transaction that deleted the buffer (in jbd2_journal_unmap_buffer) an=
d
> setting buffer freed like we do now. Commit code would handle freed
> buffers like:
> If b_next_transaction is set, file buffer to forget list of the next
> transaction. If b_next_transaction isn't set, clear all dirty bits.
> What do you think?
>
>                                                                Honza
>
>> 2010/1/27 Jan Kara <jack@suse.cz>:
>> >  Hi,
>> >
>> > On Wed 27-01-10 10:32:18, =B6=A1=B6=A8=BB=AA wrote:
>> >>         I'm a little confused about BH_Freed bit. The only place =
it is set
>> >> is journal_unmap_buffer, which is called by jbd2_journal_invalida=
tepage when
>> >> we want to truncate a file. Since jbd2_journal_invalidatepage is =
called
>> >> outside of transaction, We can't make sure whether the "add to or=
phan"
>> >> operation belongs to committing transaction or not,  so we can't =
touch the
>> >> buffer belongs to committing transaction, instead BH_Freed bit is=
 set to
>> >> indicate that this buffer can be discarded in running transaction=
=2E But i
>> >> think we shouldn't clear BH_JBDdirty in jbd2_journal_commit_trans=
action, as
>> >> following codes does:
>> >>                 /* A buffer which has been freed while still bein=
g
>> >>                  * journaled by a previous transaction may end up=
 still
>> >>                  * being dirty here, but we want to avoid writing=
 back
>> >>                  * that buffer in the future now that the last us=
e has
>> >>                  * been committed.  That's not only a performance=
 gain,
>> >>                  * it also stops aliasing problems if the buffer =
is left
>> >>                  * behind for writeback and gets reallocated for =
another
>> >>                  * use in a different page. */
>> >>                 if (buffer_freed(bh)) {
>> >>                         clear_buffer_freed(bh);
>> >>                         clear_buffer_jbddirty(bh);
>> >>                 }
>> >> Note that, *We can't make sure "current running transaction" can =
complete
>> >> commit work.* If we clear BH_JBDdirty bit here, this buffer may b=
e freed
>> >> here,  the log space of older transaction may be freed before the=
 "current
>> >> running transaction" complete commit work, and if this happends, =
filesystem
>> >> will be inconsistent.
>> >  Let me sketch the situation here:
>> > The file F gets truncated. The inode is added to orphan list in so=
me
>> > transaction T1, only then jbd2_journal_invalidatepage can be calle=
d.
>> > As you wrote above, it can happen that jbd2_journal_invalidatepage=
 on
>> > buffer B runs when some transaction T2 containing B is being commi=
tted and
>> > in that case we set BH_Freed.  If T2 !=3D T1 - i.e., T2 is being c=
ommitted
>> > and T1 is the running transaction, note that we clear the dirty bi=
t only
>> > when T2 is fully committed and we are processing forget list. So b=
uffer has
>> > been properly written to T2 and we just won't write it in the tran=
saction
>> > T1. And that is fine because as soon as transaction T1 finishes co=
mmit, we
>> > don't care about what happens with buffers of F because the fact t=
hat F is
>> > truncated is recorded and in case of crash we finish truncate duri=
ng
>> > journal replay. And if we crash before T1 finishes commit, we don'=
t care
>> > about contents of T1 either. If T2 =3D=3D T1, the above reasoning =
applies as
>> > well and the situation is even simpler.
>> >
>> >                                                                Hon=
za
>> > --
>> > Jan Kara <jack@suse.cz>
>> > SUSE Labs, CR
>> >
>>
>>
>>
>> --
>> =B6=A1=B6=A8=BB=AA
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>



--=20
=B6=A1=B6=A8=BB=AA
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
