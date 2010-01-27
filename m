From: Jan Kara <jack@suse.cz>
Subject: Re: Should we discard jbddirty bit if BH_Freed is set?
Date: Wed, 27 Jan 2010 13:23:34 +0100
Message-ID: <20100127122333.GA3149@quack.suse.cz>
References: <7bb361261001261832wb4f9ac2u96fdb6460aa45fa2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: =?utf-8?B?5LiB5a6a5Y2O?= <dingdinghua85@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab0A0MX1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jan 2010 07:23:27 -0500
Content-Disposition: inline
In-Reply-To: <7bb361261001261832wb4f9ac2u96fdb6460aa45fa2@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Wed 27-01-10 10:32:18, =E4=B8=81=E5=AE=9A=E5=8D=8E wrote:
>         I'm a little confused about BH_Freed bit. The only place it i=
s set
> is journal_unmap_buffer, which is called by jbd2_journal_invalidatepa=
ge when
> we want to truncate a file. Since jbd2_journal_invalidatepage is call=
ed
> outside of transaction, We can't make sure whether the "add to orphan=
"
> operation belongs to committing transaction or not,  so we can't touc=
h the
> buffer belongs to committing transaction, instead BH_Freed bit is set=
 to
> indicate that this buffer can be discarded in running transaction. Bu=
t i
> think we shouldn't clear BH_JBDdirty in jbd2_journal_commit_transacti=
on, as
> following codes does:
>                 /* A buffer which has been freed while still being
>                  * journaled by a previous transaction may end up sti=
ll
>                  * being dirty here, but we want to avoid writing bac=
k
>                  * that buffer in the future now that the last use ha=
s
>                  * been committed.  That's not only a performance gai=
n,
>                  * it also stops aliasing problems if the buffer is l=
eft
>                  * behind for writeback and gets reallocated for anot=
her
>                  * use in a different page. */
>                 if (buffer_freed(bh)) {
>                         clear_buffer_freed(bh);
>                         clear_buffer_jbddirty(bh);
>                 }
> Note that, *We can't make sure "current running transaction" can comp=
lete
> commit work.* If we clear BH_JBDdirty bit here, this buffer may be fr=
eed
> here,  the log space of older transaction may be freed before the "cu=
rrent
> running transaction" complete commit work, and if this happends, file=
system
> will be inconsistent.
  Let me sketch the situation here:
The file F gets truncated. The inode is added to orphan list in some
transaction T1, only then jbd2_journal_invalidatepage can be called.=20
As you wrote above, it can happen that jbd2_journal_invalidatepage on
buffer B runs when some transaction T2 containing B is being committed =
and
in that case we set BH_Freed.  If T2 !=3D T1 - i.e., T2 is being commit=
ted
and T1 is the running transaction, note that we clear the dirty bit onl=
y
when T2 is fully committed and we are processing forget list. So buffer=
 has
been properly written to T2 and we just won't write it in the transacti=
on
T1. And that is fine because as soon as transaction T1 finishes commit,=
 we
don't care about what happens with buffers of F because the fact that F=
 is
truncated is recorded and in case of crash we finish truncate during
journal replay. And if we crash before T1 finishes commit, we don't car=
e
about contents of T1 either. If T2 =3D=3D T1, the above reasoning appli=
es as
well and the situation is even simpler.
=20
								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
