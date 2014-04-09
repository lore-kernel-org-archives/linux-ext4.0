From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Data races in ext4
Date: Wed, 9 Apr 2014 17:33:40 -0400
Message-ID: <20140409213340.GB15303@thunk.org>
References: <53446306.7020005@mpi-sws.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: Pedro Fonseca <pfonseca@mpi-sws.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52234 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933717AbaDIVdw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Apr 2014 17:33:52 -0400
Content-Disposition: inline
In-Reply-To: <53446306.7020005@mpi-sws.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 08, 2014 at 10:58:46PM +0200, Pedro Fonseca wrote:
> Bellow I'm listing the data races summary, including the variable name, IP
> addresses, function names and source code files/line numbers. In addition,
> the pastbin links include snippets of the code at those locations and also
> include examples of racing pairs of instructions (which can be useful when
> there are more than two instructions racing). Several of the races reported
> affect either the function generic_fillattr() or the function
> ext4_do_update_inode(), so I'm grouping them bellow to simplify the
> analysis. Feel free to ask for more information in case it's needed.

The ones relating to ext4_do_update_inode() and generic_fillattr()
look fine to me.  Basically the first may happen if there are two
CPU's simultaneously trying to update the on-disk data structure for
an inode from the in-memory data structure, and that's not a problem
since the in-memory data structure is always authoratative.  The
second happens if someone tries to stat(2) an inode while some inode
field is getting updated.  Most of the inode field updates will be for
things like mtime and atime updates, or a chown or chmod, where a
single field is getting updated, and that's not a problem since there
is no guarantee which version of the inode information you'll get when
you call stat(2) while the inode is getting modified out from under
you.  It is possible that the userspace might see the i_blocks and
i_size be out of sync, but I really can't bring myself to care about
that.


As for the rest, some are obviously false positives.  For example, if
you take a look at:

Variable: journal->j_running_transaction	Addresses: c1138ca1 c1136b02 c1136ca9
c1136ca9 jbd2_get_transaction /linux-3.13.5/fs/jbd2/transaction.c:103
c1138ca1 jbd2_journal_commit_transaction /linux-3.13.5/fs/jbd2/commit.c:539
c1136b02 start_this_handle /linux-3.13.5/fs/jbd2/transaction.c:280

It's obvious from the code path that start_this_handle() is extremely
careful to always revalidate j_running_transaction after either (a)
taking a read lock on the j_state_lock for the first time, or (b)
after dropping the read_lock and grabbing a write_lock on
j_state_lock, and if things have changed, it loops and tries again.


There are a couple that require some closer examination; for some of
them, for example the two reported cases of ext4_isize_set() vs
ext4_isize(), having the stack trace would be really helpful.

Cheers,

						- Ted
