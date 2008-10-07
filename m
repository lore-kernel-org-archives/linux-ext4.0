From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] [RFC] jbd2: Add buffer triggers
Date: Mon, 6 Oct 2008 18:01:54 -0700
Message-ID: <20081007010154.GE26632@mail.oracle.com>
References: <20080917232629.GB20752@mail.oracle.com> <20080929012527.GI8711@mit.edu> <20081004000336.GE11442@mit.edu> <20081006213754.GA26632@mail.oracle.com> <20081006214251.GB26632@mail.oracle.com> <20081006233248.GA9337@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org,
	mfasheh@suse.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:29619 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759828AbYJGBD3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 21:03:29 -0400
Content-Disposition: inline
In-Reply-To: <20081006233248.GA9337@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 06, 2008 at 07:32:48PM -0400, Theodore Tso wrote:
> On Mon, Oct 06, 2008 at 02:42:52PM -0700, Joel Becker wrote:
> I'm not 100% sure.....  The other area that we should check very
> closely is jbd2_journal_commit_transaction(); in some cases, if
> jh->b_committed_data is NULL, the frozen data is thrown away (around
> line 850 in transaction.c).  I *think* this happens if b_frozen_data
> was only copied to escape the buffer, but I'm not certain; in any
> case, there's a potential that in that case you might lose the
> calculated checksum and the correct value wouldn't get written to the
> final location on disk.  

	I remember looking at this before.  Basically, if there is a
later transaction also using this buffer, b_frozen_data has this
transaction's version of said buffer.  We've now written that to the
journal.  b_committed_data exists for get_undo_access().  We've just
committed the buffer, so we know that we no longer need to worry about
the undo access.  If we have both, it's a new undo access, and it needs
b_frozen_data moved into b_committed_data.
	How does this affect our checksum?  This all actually falls out
from the fact that jbd skips checkpointing for buffers that are part of
a later transaction.
	If this buffer is only part of the currently committing
transaction, write_metadata_buffer() will have our trigger (from here on
in the place you suggest, not where I put it) modify b_data directly.
It may get copied to b_frozen_data for escaping, but that b_data will go
out with the checkpoint.  Thus, we have a valid checksum on both the
committed buffer and the checkpointed buffer.
	If the buffer is part of a later transaction as well,
write_metadata_buffer() will have our trigger fire on b_frozen_data.
This will put the checksum in the journal, but not modify b_data.
In a healthy system, the later transaction will eventually commit, and
it will put a good checksum in b_data, finally checkpointing that value.
ocfs2 will force this process via journal_flush() before it lets other
nodes look at the disk.
	Looking at the checkpoint part, though, I think we're not safe.
The buffer is attached to the original transaction's checkpoint list
after the commit.  This buffer has the un-checksummed b_data.  If the
later transaction commits before the checkpoint happens, all is good.
But if the buffer lazily writes to disk while the later transaction is
still running, the original transaction could be considered "done",
updating the journal superblock.  If we crash at that moment, we have a
bad checksum on disk.
	I suppose we could trigger on a checkpointed buffer going out?

Joel

-- 

Life's Little Instruction Book #222

	"Think twice before burdening a friend with a secret."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
