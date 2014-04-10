From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Data races in ext4
Date: Thu, 10 Apr 2014 18:09:37 -0400
Message-ID: <20140410220937.GC31614@thunk.org>
References: <53446306.7020005@mpi-sws.org>
 <20140409213340.GB15303@thunk.org>
 <5346BB86.50001@mpi-sws.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: Pedro Fonseca <pfonseca@mpi-sws.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52663 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbaDJWLS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2014 18:11:18 -0400
Content-Disposition: inline
In-Reply-To: <5346BB86.50001@mpi-sws.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thinking about this some more, you're right.  We should probably use a
spinlock to regulate access to the raw inode in
ext4_do_update_inode().  The main reason why we haven't noticed that
most of these fields don't change very often, and so in practice it's
not really problem.  The one that _is_ critical is i_disksize /
raw_inode->i_size, and that's supposed to be protected by i_data_sem.
(The reason why that one showed up in your analysis is because we did
screw up the locking in mpage_map_and_submit_extent.)

> Regarding the generic_fillattr() function, apart from the inconsistency
> between i_blocks/i_size, it looks like it can also cause wrong values to be
> returned because several of those fields are 64 bits. 

Well, it's actually a 32-bit seconds and 32-bit nanoseconds field.  So
we could theoretically get a torn value, but if the ns field is from a
previous update, the worst that could happen under those circumstances
is that two quick successive stat() commands could potentially result
in end up with an apparent "time moving backwards" in the nanoseconds
field.  If someone was constantly calling utimes(2) to modify the
mtime/atime at high rate, that might cause a more serious wrong value,
but that's an argument you should take up with the generic VFS folks
as to whether it's important enough that they would want to care about
it.

> >As for the rest, some are obviously false positives.  For example, if
> >you take a look at:
> >
> >Variable: journal->j_running_transaction	Addresses: c1138ca1 c1136b02 c1136ca9
> >c1136ca9 jbd2_get_transaction /linux-3.13.5/fs/jbd2/transaction.c:103
> >c1138ca1 jbd2_journal_commit_transaction /linux-3.13.5/fs/jbd2/commit.c:539
> >c1136b02 start_this_handle /linux-3.13.5/fs/jbd2/transaction.c:280
> >
> >It's obvious from the code path that start_this_handle() is extremely
> >careful to always revalidate j_running_transaction after either (a)
> >taking a read lock on the j_state_lock for the first time, or (b)
> >after dropping the read_lock and grabbing a write_lock on
> >j_state_lock, and if things have changed, it loops and tries again.
> You're right, start_this_handle() revalidates the value read so I also don't
> see harm in this race.

Well, I suppose technically it's a race, but in it was quite
deliberate, because the goal was to minimize pressure on the
j_state_lock.

> >There are a couple that require some closer examination; for some of
> >them, for example the two reported cases of ext4_isize_set() vs
> >ext4_isize(), having the stack trace would be really helpful.
> 
> Those two pairs of functions were actually also called from the
> ext4_do_update_inode() function:

OK, and I think this is ultimately caused by a screwup in how
mpage_map_and_submit_extent() which I mentioned earlier.

Thanks for your work,

					- Ted

P.S.  What did you use to generate these reports?  Is it something
that can be easily replicated by others?
