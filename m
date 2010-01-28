From: =?GB2312?B?tqG2qLuq?= <dingdinghua85@gmail.com>
Subject: Re: Should we discard jbddirty bit if BH_Freed is set?
Date: Thu, 28 Jan 2010 09:23:43 +0800
Message-ID: <7bb361261001271723n4fdad0e9l2171aa092baa0523@mail.gmail.com>
References: <7bb361261001261832wb4f9ac2u96fdb6460aa45fa2@mail.gmail.com>
	 <20100127122333.GA3149@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f186.google.com ([209.85.223.186]:64508 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab0A1BXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Jan 2010 20:23:44 -0500
Received: by iwn16 with SMTP id 16so211743iwn.5
        for <linux-ext4@vger.kernel.org>; Wed, 27 Jan 2010 17:23:43 -0800 (PST)
In-Reply-To: <20100127122333.GA3149@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
    As you wrote, if T2!=3DT1, then T2 is committing transaction while
T1 is running transaction,
and if T1 complete commit, we don't care about the content of buffers.
But there is a  prerequisite
-->"T1 complete commit", if T1 start commit and another transaction T3
becomes the new running
transaction, T3 may need to reuse T2 log space and force checkpoint,
and since we have clean
the BH_dirty bit of buffers after T2 commits, so T2 may be freed
before T1 complete commit, and
unfortunately, T1 doesn't complete commit, so after replay, updates of
T2 get lost, fs becomes
inconsistent.

2010/1/27 Jan Kara <jack@suse.cz>:
>  Hi,
>
> On Wed 27-01-10 10:32:18, =B6=A1=B6=A8=BB=AA wrote:
>>         I'm a little confused about BH_Freed bit. The only place it =
is set
>> is journal_unmap_buffer, which is called by jbd2_journal_invalidatep=
age when
>> we want to truncate a file. Since jbd2_journal_invalidatepage is cal=
led
>> outside of transaction, We can't make sure whether the "add to orpha=
n"
>> operation belongs to committing transaction or not,  so we can't tou=
ch the
>> buffer belongs to committing transaction, instead BH_Freed bit is se=
t to
>> indicate that this buffer can be discarded in running transaction. B=
ut i
>> think we shouldn't clear BH_JBDdirty in jbd2_journal_commit_transact=
ion, as
>> following codes does:
>>                 /* A buffer which has been freed while still being
>>                  * journaled by a previous transaction may end up st=
ill
>>                  * being dirty here, but we want to avoid writing ba=
ck
>>                  * that buffer in the future now that the last use h=
as
>>                  * been committed.  That's not only a performance ga=
in,
>>                  * it also stops aliasing problems if the buffer is =
left
>>                  * behind for writeback and gets reallocated for ano=
ther
>>                  * use in a different page. */
>>                 if (buffer_freed(bh)) {
>>                         clear_buffer_freed(bh);
>>                         clear_buffer_jbddirty(bh);
>>                 }
>> Note that, *We can't make sure "current running transaction" can com=
plete
>> commit work.* If we clear BH_JBDdirty bit here, this buffer may be f=
reed
>> here,  the log space of older transaction may be freed before the "c=
urrent
>> running transaction" complete commit work, and if this happends, fil=
esystem
>> will be inconsistent.
>  Let me sketch the situation here:
> The file F gets truncated. The inode is added to orphan list in some
> transaction T1, only then jbd2_journal_invalidatepage can be called.
> As you wrote above, it can happen that jbd2_journal_invalidatepage on
> buffer B runs when some transaction T2 containing B is being committe=
d and
> in that case we set BH_Freed.  If T2 !=3D T1 - i.e., T2 is being comm=
itted
> and T1 is the running transaction, note that we clear the dirty bit o=
nly
> when T2 is fully committed and we are processing forget list. So buff=
er has
> been properly written to T2 and we just won't write it in the transac=
tion
> T1. And that is fine because as soon as transaction T1 finishes commi=
t, we
> don't care about what happens with buffers of F because the fact that=
 F is
> truncated is recorded and in case of crash we finish truncate during
> journal replay. And if we crash before T1 finishes commit, we don't c=
are
> about contents of T1 either. If T2 =3D=3D T1, the above reasoning app=
lies as
> well and the situation is even simpler.
>
>                                                                Honza
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
