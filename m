From: Jan Kara <jack@suse.cz>
Subject: Re: Help on Implementation of EXT3 type Ordered Mode in EXT4
Date: Mon, 15 Feb 2010 16:00:22 +0100
Message-ID: <20100215150021.GE3434@quack.suse.cz>
References: <loom.20100204T064311-880@post.gmane.org>
 <20100209160522.GE15318@atrey.karlin.mff.cuni.cz>
 <20100209174145.GU4494@thunk.org>
 <38f6fb7d1002102301x278c3ddt153f570dd1423074@mail.gmail.com>
 <38f6fb7d1002102332v3482ef49xb2afd5931c5eb2ad@mail.gmail.com>
 <20100211195624.GM739@thunk.org>
 <38f6fb7d1002111922i4ae6131w6b5cce79344efc63@mail.gmail.com>
 <20100212200726.GD5337@thunk.org>
 <38f6fb7d1002130043s54e61e74jcc3297aeeac294b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Jiaying Zhang <jiayingz@google.com>
To: Kailas Joshi <kailas.joshi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34121 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab0BOPAN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Feb 2010 10:00:13 -0500
Content-Disposition: inline
In-Reply-To: <38f6fb7d1002130043s54e61e74jcc3297aeeac294b0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 13-02-10 14:13:17, Kailas Joshi wrote:
> On 13 February 2010 01:37,  <tytso@mit.edu> wrote:
> > On Fri, Feb 12, 2010 at 08:52:15AM +0530, Kailas Joshi wrote:
> >> Sorry, I didn't understand why processes need to be suspended.
> >> In my scheme, I am issuing magic handle only after locking the cur=
rent
> >> transaction. =A0AFAIK after the transaction is locked, it can rece=
ive the
> >> block journaling requests for already created handles(in our case,=
 for
> >> already reserved journal space), and the new concurrent requests f=
or
> >> journal_start() will go to the new current transaction. Since, the
> >> credits for locked transaction are fixed (by means of early
> >> reservations) we can know whether journal has enough space for the=
 new
> >> journal_start(). So, as long as journal has enough space available=
,
> >> new processes need now be stalled.
> >
> > But while you are modifying blocks that need to go into the journal
> > via the locked (old) transaction, it's not safe to start a new
> > transaction and start issuing handles against the new transaction.
> >
> > Just to give one example, suppose we need to update the extent
> > allocation tree for an inode in the locked/committing transaction a=
s
> > the delayed allocation blocks are being resolved --- and in another
> > process, that inode is getting truncated or unlinked, which also ne=
eds
> > to modify the extent allocation tree? =A0Hilarty ensues, unless you=
 use
> > a block all attempts to create a new handle (practically speaking, =
by
> > blocking all attempts to start a new transaction), until this new
> > delayed allocation resolution phase which you have proposed is
> > complete.
> Okay. So, basically process stalling is unavoidable as we cannot
> modify a buffer data in past transaction after it has been modified i=
n
> current transaction.
> Can we restrict the scope for this blocking? Blocking on
> journal_start() will block all processes even though they are
> operating on mutually exclusive sets of metadata buffers. Can we
> restrict this blocking to allocation/deallocation paths by blocking i=
n
> get_write_access() on specific cases(some condition on buffer)? This
> way, since all files will use commit-time allocation, very few(sync
> and direct-io mode) file operations will be stalled.
  I doubt blocking at buffer-level would be enough. I think that the
journalling layer just does not have enough information for such decisi=
ons.
It could be feasible to block on per-inode basis but you'd still have t=
o
give a good thought to modification of filesystem global structures lik=
e
bitmaps, superblock, or inode blocks.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
