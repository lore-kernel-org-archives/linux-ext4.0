From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: kernel BUG at fs/ext4/inode.c:3709! (Re: open bugs found by
 fuzzing)
Date: Fri, 15 Jul 2016 15:49:33 -0400
Message-ID: <20160715194933.GE26465@thunk.org>
References: <5787FFBA.70406@oracle.com>
 <5788E787.106@oracle.com>
 <20160715172453.GA18010@thunk.org>
 <578923EF.1020305@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>,
	Ildar Muslukhov <ildarm@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>
To: Vegard Nossum <vegard.nossum@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46034 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbcGOTth (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Jul 2016 15:49:37 -0400
Content-Disposition: inline
In-Reply-To: <578923EF.1020305@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 15, 2016 at 07:57:03PM +0200, Vegard Nossum wrote:
> I thought all the inodes on the orphan list were completely unreachable,
> but that's obviously not true following your explanations (thanks!) and
> another peek at the cleanup function which only does the truncate in the
> first place if ->i_nlink is non-zero, I missed that earlier. I guess
> this comment confused me:
> 
> /* ext4_orphan_cleanup() walks a singly-linked list of inodes (starting at
>  * the superblock) which were deleted from all directories, but held open by
>  * a process at the time of a crash.

Yeah, that comment is **badly** (as well over a decade) out-of-date.
Sorry.  :-/

The problem is fixing this is messy.  The problem is if we just set
i_size without zeroing out the bytes between i_size and the end of the
page, we're asking for trouble.  For example, you could think that
it's enough to have ext4_readpage() care of doing the zeroing after
the block is read from disk and then decrypted, but what if the user
does a sparse write beyond i_size?

So either we allow truncate(2) to be non-atomic with respect to
crashes for encrypted files, or alternatively we would have to set a
flag in the inode indicating that the bytes between i_size and the end
of the page must be zeroed before the file can be modified in any way,
or before an attempted O_DIRECT read of the last block, and then when
we read the inode from diks into the inode cache, if the bit is set
and we have the encryption key (which we would need if we want to
modify the file), we could take zeroing the tail end of the file then.

Yulch.   Definitely a bit of a hack.  :-(

					- Ted

P.S. Fortunately, this is a very rare case in practice, so I doubt we
would have hit it in a while, but it's definitely something we need to
fix, one way or another.
