From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] [RFC] jbd2: Add buffer triggers
Date: Wed, 8 Oct 2008 16:17:52 -0700
Message-ID: <20081008231752.GA5310@mail.oracle.com>
References: <20080917232629.GB20752@mail.oracle.com> <20080929012527.GI8711@mit.edu> <20081004000336.GE11442@mit.edu> <20081006213754.GA26632@mail.oracle.com> <20081006214251.GB26632@mail.oracle.com> <20081006233248.GA9337@mit.edu> <20081007010154.GE26632@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, ocfs2-devel@oss.oracle.com,
	linux-ext4@vger.kernel.org, mfasheh@suse.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:36208 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867AbYJHXSE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Oct 2008 19:18:04 -0400
Content-Disposition: inline
In-Reply-To: <20081007010154.GE26632@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 06, 2008 at 06:01:54PM -0700, Joel Becker wrote:
> On Mon, Oct 06, 2008 at 07:32:48PM -0400, Theodore Tso wrote:
> > On Mon, Oct 06, 2008 at 02:42:52PM -0700, Joel Becker wrote:
> > I'm not 100% sure.....  The other area that we should check very
> > closely is jbd2_journal_commit_transaction(); in some cases, if
> > jh->b_committed_data is NULL, the frozen data is thrown away (around
> > line 850 in transaction.c).  I *think* this happens if b_frozen_data
> > was only copied to escape the buffer, but I'm not certain; in any
> > case, there's a potential that in that case you might lose the
> > calculated checksum and the correct value wouldn't get written to the
> > final location on disk.  
<snip>
> 	Looking at the checkpoint part, though, I think we're not safe.
> The buffer is attached to the original transaction's checkpoint list
> after the commit.  This buffer has the un-checksummed b_data.  If the
> later transaction commits before the checkpoint happens, all is good.
> But if the buffer lazily writes to disk while the later transaction is
> still running, the original transaction could be considered "done",
> updating the journal superblock.  If we crash at that moment, we have a
> bad checksum on disk.

	I chatted with Mark some about this today.  He pointed out that,
logically, b_data can't be checkpointed until its data isn't in the
journal - it might be newer than the most recent transaction.  So I
looked in the checkpoint code to see where this is handled, and the
checkpoint code simply forces a commit new enough to encompass b_data
when it wants to put that block to disk.
	In other words, I think that the commit trigger is safe in all
circumstances once moved up in journal_commit_transaction().  I'll be
cooking that up shortly.

Joel

-- 

To spot the expert, pick the one who predicts the job will take the
longest and cost the most.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
