From: Jan Kara <jack@suse.cz>
Subject: Re: Should we discard jbddirty bit if BH_Freed is set?
Date: Thu, 28 Jan 2010 13:53:55 +0100
Message-ID: <20100128125354.GA3124@quack.suse.cz>
References: <7bb361261001261832wb4f9ac2u96fdb6460aa45fa2@mail.gmail.com>
 <20100127122333.GA3149@quack.suse.cz>
 <7bb361261001271723n4fdad0e9l2171aa092baa0523@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: =?utf-8?B?5LiB5a6a5Y2O?= <dingdinghua85@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36671 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402Ab0A1Mxt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Jan 2010 07:53:49 -0500
Content-Disposition: inline
In-Reply-To: <7bb361261001271723n4fdad0e9l2171aa092baa0523@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Thu 28-01-10 09:23:43, =E4=B8=81=E5=AE=9A=E5=8D=8E wrote:
>     As you wrote, if T2!=3DT1, then T2 is committing transaction whil=
e T1
>     is running transaction, and if T1 complete commit, we don't care
>     about the content of buffers.  But there is a  prerequisite -->"T=
1
>     complete commit", if T1 start commit and another transaction T3
>     becomes the new running transaction, T3 may need to reuse T2 log
>     space and force checkpoint, and since we have clean the BH_dirty =
bit
>     of buffers after T2 commits, so T2 may be freed before T1 complet=
e
>     commit, and unfortunately, T1 doesn't complete commit, so after
>     replay, updates of T2 get lost, fs becomes inconsistent.
  Hmm, you are right. That could probably happen. It only hits ext3/4 i=
n
data=3Djournaled mode but the bug is there. But it's hard to fix it in =
a
reasonable way - if we would just leave the dirty bit set, we will have
aliasing problems - buffer B is attached to some page which used to be =
from
file F, so unmap_underlying_metadata will not find it because it looks =
only
into page cache the block device, not to the pagecaches of individual
files. So if we reallocate the block of B for some other file G before =
the
buffer B is checkpointed, we have two dirty buffers representing the sa=
me
block and thus data corruption can happen.
  Maybe we could handle them by setting b_next_transaction to the
transaction that deleted the buffer (in jbd2_journal_unmap_buffer) and
setting buffer freed like we do now. Commit code would handle freed
buffers like:
If b_next_transaction is set, file buffer to forget list of the next
transaction. If b_next_transaction isn't set, clear all dirty bits.
What do you think?

								Honza

> 2010/1/27 Jan Kara <jack@suse.cz>:
> >  Hi,
> >
> > On Wed 27-01-10 10:32:18, =E4=B8=81=E5=AE=9A=E5=8D=8E wrote:
> >>         I'm a little confused about BH_Freed bit. The only place i=
t is set
> >> is journal_unmap_buffer, which is called by jbd2_journal_invalidat=
epage when
> >> we want to truncate a file. Since jbd2_journal_invalidatepage is c=
alled
> >> outside of transaction, We can't make sure whether the "add to orp=
han"
> >> operation belongs to committing transaction or not,  so we can't t=
ouch the
> >> buffer belongs to committing transaction, instead BH_Freed bit is =
set to
> >> indicate that this buffer can be discarded in running transaction.=
 But i
> >> think we shouldn't clear BH_JBDdirty in jbd2_journal_commit_transa=
ction, as
> >> following codes does:
> >>                 /* A buffer which has been freed while still being
> >>                  * journaled by a previous transaction may end up =
still
> >>                  * being dirty here, but we want to avoid writing =
back
> >>                  * that buffer in the future now that the last use=
 has
> >>                  * been committed.  That's not only a performance =
gain,
> >>                  * it also stops aliasing problems if the buffer i=
s left
> >>                  * behind for writeback and gets reallocated for a=
nother
> >>                  * use in a different page. */
> >>                 if (buffer_freed(bh)) {
> >>                         clear_buffer_freed(bh);
> >>                         clear_buffer_jbddirty(bh);
> >>                 }
> >> Note that, *We can't make sure "current running transaction" can c=
omplete
> >> commit work.* If we clear BH_JBDdirty bit here, this buffer may be=
 freed
> >> here,  the log space of older transaction may be freed before the =
"current
> >> running transaction" complete commit work, and if this happends, f=
ilesystem
> >> will be inconsistent.
> >  Let me sketch the situation here:
> > The file F gets truncated. The inode is added to orphan list in som=
e
> > transaction T1, only then jbd2_journal_invalidatepage can be called=
=2E
> > As you wrote above, it can happen that jbd2_journal_invalidatepage =
on
> > buffer B runs when some transaction T2 containing B is being commit=
ted and
> > in that case we set BH_Freed.  If T2 !=3D T1 - i.e., T2 is being co=
mmitted
> > and T1 is the running transaction, note that we clear the dirty bit=
 only
> > when T2 is fully committed and we are processing forget list. So bu=
ffer has
> > been properly written to T2 and we just won't write it in the trans=
action
> > T1. And that is fine because as soon as transaction T1 finishes com=
mit, we
> > don't care about what happens with buffers of F because the fact th=
at F is
> > truncated is recorded and in case of crash we finish truncate durin=
g
> > journal replay. And if we crash before T1 finishes commit, we don't=
 care
> > about contents of T1 either. If T2 =3D=3D T1, the above reasoning a=
pplies as
> > well and the situation is even simpler.
> >
> >                                                                Honz=
a
> > --
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> >
>=20
>=20
>=20
> --=20
> =E4=B8=81=E5=AE=9A=E5=8D=8E
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
