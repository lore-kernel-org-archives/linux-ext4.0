From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC] jbd: don't wake kjournald unnecessarily
Date: Wed, 19 Dec 2012 10:37:25 -0500
Message-ID: <20121219153725.GD7795@thunk.org>
References: <50D0A1FD.7040203@redhat.com>
 <20121219012710.GF5987@quack.suse.cz>
 <20121219020526.GG5987@quack.suse.cz>
 <50D12FC3.6090209@redhat.com>
 <20121219081334.GB20163@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39350 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab2LSPhb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Dec 2012 10:37:31 -0500
Content-Disposition: inline
In-Reply-To: <20121219081334.GB20163@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 19, 2012 at 09:13:34AM +0100, Jan Kara wrote:
> > I was wondering if, since the tid_g*() functions only work if the
> > distance is half the unsigned int space, we can force a commit at some
> > point if j_transaction_sequence has gotten too far ahead?  I'm not sure
> > where or if that could be done...
>
>   I don't quiete understand. If someone stores tid = transaction->t_tid and
> in two weeks calls log_start_commit(tid), I don't see how any forcing of
> commits could solve that tid may now look ahead of the log...

Actually, what we can do is the reverse.  Right now when we modify an
inode, we stash the tid to indicate "we need to commit to at least
this tid".  The problem comes if we haven't modified the inode for a
long time, but then later when we issue an fsync for that inode, it's
after a tid wrap, so we trigger the warning.

What we could do is in cases were we aren't touching the inode note if
the tid value is obviously out of date, and set it to some value which
is one less than the current tid.  This avoids the wrap, and in cases
where we are releasing the inode and nothing else is left, it's a safe
thing to do.

The downside is that doing this would incur locking overhead, and it's
not clear it's worth it.  Now that we understand what's going on,
nothing bad is happening when the warning is triggered, so we could
just remove it.

If we use a 64-bit in-memory tid, that would help avoid cases where
the tid has wrapped and we get unlucky and hit the 1 in 2**32 case
where we trigger a commit where one is not needed.  Given that the
cost of an extra commit with probably 1 in 2**32 is pretty low, it's
probably not worth the overhead of using a 64-bit tid, though....

      	  	      	      - Ted
