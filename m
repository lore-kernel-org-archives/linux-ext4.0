From: Jan Kara <jack@suse.cz>
Subject: Re: Help on Implementation of EXT3 type Ordered Mode in EXT4
Date: Tue, 16 Feb 2010 14:10:39 +0100
Message-ID: <20100216131039.GB3153@quack.suse.cz>
References: <20100209160522.GE15318@atrey.karlin.mff.cuni.cz>
 <20100209174145.GU4494@thunk.org>
 <38f6fb7d1002102301x278c3ddt153f570dd1423074@mail.gmail.com>
 <38f6fb7d1002102332v3482ef49xb2afd5931c5eb2ad@mail.gmail.com>
 <20100211195624.GM739@thunk.org>
 <38f6fb7d1002111922i4ae6131w6b5cce79344efc63@mail.gmail.com>
 <20100212200726.GD5337@thunk.org>
 <38f6fb7d1002130043s54e61e74jcc3297aeeac294b0@mail.gmail.com>
 <20100215150021.GE3434@quack.suse.cz>
 <38f6fb7d1002160210x6dc86fb5o82825e7677c07994@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, linux-ext4@vger.kernel.org,
	Jiaying Zhang <jiayingz@google.com>
To: Kailas Joshi <kailas.joshi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:45709 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919Ab0BPNKa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Feb 2010 08:10:30 -0500
Content-Disposition: inline
In-Reply-To: <38f6fb7d1002160210x6dc86fb5o82825e7677c07994@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 16-02-10 15:40:22, Kailas Joshi wrote:
> On 15 February 2010 20:30, Jan Kara <jack@suse.cz> wrote:
> > On Sat 13-02-10 14:13:17, Kailas Joshi wrote:
> >> On 13 February 2010 01:37, =A0<tytso@mit.edu> wrote:
> >> > On Fri, Feb 12, 2010 at 08:52:15AM +0530, Kailas Joshi wrote:
> >> >> Sorry, I didn't understand why processes need to be suspended.
> >> >> In my scheme, I am issuing magic handle only after locking the =
current
> >> >> transaction. =A0AFAIK after the transaction is locked, it can r=
eceive the
> >> >> block journaling requests for already created handles(in our ca=
se, for
> >> >> already reserved journal space), and the new concurrent request=
s for
> >> >> journal_start() will go to the new current transaction. Since, =
the
> >> >> credits for locked transaction are fixed (by means of early
> >> >> reservations) we can know whether journal has enough space for =
the new
> >> >> journal_start(). So, as long as journal has enough space availa=
ble,
> >> >> new processes need now be stalled.
> >> >
> >> > But while you are modifying blocks that need to go into the jour=
nal
> >> > via the locked (old) transaction, it's not safe to start a new
> >> > transaction and start issuing handles against the new transactio=
n.
> >> >
> >> > Just to give one example, suppose we need to update the extent
> >> > allocation tree for an inode in the locked/committing transactio=
n as
> >> > the delayed allocation blocks are being resolved --- and in anot=
her
> >> > process, that inode is getting truncated or unlinked, which also=
 needs
> >> > to modify the extent allocation tree? =A0Hilarty ensues, unless =
you use
> >> > a block all attempts to create a new handle (practically speakin=
g, by
> >> > blocking all attempts to start a new transaction), until this ne=
w
> >> > delayed allocation resolution phase which you have proposed is
> >> > complete.
> >> Okay. So, basically process stalling is unavoidable as we cannot
> >> modify a buffer data in past transaction after it has been modifie=
d in
> >> current transaction.
> >> Can we restrict the scope for this blocking? Blocking on
> >> journal_start() will block all processes even though they are
> >> operating on mutually exclusive sets of metadata buffers. Can we
> >> restrict this blocking to allocation/deallocation paths by blockin=
g in
> >> get_write_access() on specific cases(some condition on buffer)? Th=
is
> >> way, since all files will use commit-time allocation, very few(syn=
c
> >> and direct-io mode) file operations will be stalled.
> > =A0I doubt blocking at buffer-level would be enough. I think that t=
he
> > journalling layer just does not have enough information for such de=
cisions.
> > It could be feasible to block on per-inode basis but you'd still ha=
ve to
> > give a good thought to modification of filesystem global structures=
 like
> > bitmaps, superblock, or inode blocks.
> Okay. So, blocking at buffer level will not be easy as global
> structures shared among inodes will need modifications(for example,
> changing access time for a file in inode block).
  Yes.

> One last doubt, while looking at the code, I saw that journal_start()
> always stalls all file operations while currently running transaction
> is in LOCKED state. Only when the current transaction moves to FLUSH,
> the new transaction is created and the stalled operations continue. I=
s
> this interpretation correct?
  Yes, it is correct.

> If yes, why this stalling does not have significant negative impact o=
n
> performance of file operations? Also, if it does not have, will
> stalling for delayed block allocation really have such significant
> negative impact?
  Actually, stalling on a transaction in LOCKED state does have a negat=
ive
impact on the filesystem performance. But it's hard to avoid it. The
transaction is in LOCKED state while we've decided it needs a commit bu=
t
there are still tasks which have handle to it and are adding new metada=
ta
buffers to it. So this transaction is effectively still running and we
cannot start a next transaction because then we'd have two running
transactions and the journalling logic isn't able to handle that.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
