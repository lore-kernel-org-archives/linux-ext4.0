From: Jan Kara <jack@suse.cz>
Subject: Re: next-20090310: ext4 hangs
Date: Wed, 25 Mar 2009 17:15:56 +0100
Message-ID: <20090325161556.GP23439@duck.suse.cz>
References: <a4423d670903100517y42f342d4pd73c4c36f5c64dd7@mail.gmail.com> <20090310124658.GE8840@mit.edu> <a4423d670903100718w1a532143he767782ae598d0fb@mail.gmail.com> <20090310154745.GF23075@mit.edu> <a4423d670903110907o7041f4eof92278835aa0c71c@mail.gmail.com> <20090325151122.GA14881@atrey.karlin.mff.cuni.cz> <20090325151516.GB14881@atrey.karlin.mff.cuni.cz> <a4423d670903250818n512b1c67ja1b38db6d09ac7c@mail.gmail.com> <20090325152234.GN23439@duck.suse.cz> <a4423d670903250829w5e9304a7rce24f4220379620f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48624 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbZCYQP7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Mar 2009 12:15:59 -0400
Content-Disposition: inline
In-Reply-To: <a4423d670903250829w5e9304a7rce24f4220379620f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 25-03-09 18:29:10, Alexander Beregalov wrote:
> 2009/3/25 Jan Kara <jack@suse.cz>:
> > On Wed 25-03-09 18:18:43, Alexander Beregalov wrote:
> >> 2009/3/25 Jan Kara <jack@suse.cz>:
> >> >> > So, I think I need to try it on 2.6.29-rc7 again.
> >> >> =A0 I've looked into this. Obviously, what's happenning is that=
 we delete
> >> >> an inode and jbd2_journal_release_jbd_inode() finds inode is ju=
st under
> >> >> writeout in transaction commit and thus it waits. But it gets n=
ever woken
> >> >> up and because it has a handle from the transaction, every one =
eventually
> >> >> blocks on waiting for a transaction to finish.
> >> >> =A0 But I don't really see how that can happen. The code is rea=
lly
> >> >> straightforward and everything happens under j_list_lock... Str=
ange.
> >> > =A0BTW: Is the system SMP?
> >> No, it is UP system.
> > =A0Even stranger. And do you have CONFIG_PREEMPT set?
> >
> >> The bug exists even in 2.6.29, I posted it with a new topic.
> > =A0OK, I've sort-of expected this.
>=20
> CONFIG_PREEMPT_RCU=3Dy
> CONFIG_PREEMPT_RCU_TRACE=3Dy
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=3Dy
> CONFIG_DEBUG_PREEMPT=3Dy
> # CONFIG_PREEMPT_TRACER is not set
>=20
> config is attached.
  Thanks for the data. I still don't see how the wakeup can get lost. T=
he
process even cannot be preempted when we are in the section protected b=
y
j_list_lock... Can you send me a disassembly of functions
jbd2_journal_release_jbd_inode() and journal_submit_data_buffers() so t=
hat
I can see whether the compiler has not reordered something unexpectedly=
?
Thanks.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
