From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] [RFC] jbd2: Add buffer triggers
Date: Mon, 6 Oct 2008 19:32:48 -0400
Message-ID: <20081006233248.GA9337@mit.edu>
References: <20080917232629.GB20752@mail.oracle.com> <20080929012527.GI8711@mit.edu> <20081004000336.GE11442@mit.edu> <20081006213754.GA26632@mail.oracle.com> <20081006214251.GB26632@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:40030 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757016AbYJFXcv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 19:32:51 -0400
Content-Disposition: inline
In-Reply-To: <20081006214251.GB26632@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 06, 2008 at 02:42:52PM -0700, Joel Becker wrote:
> On Mon, Oct 06, 2008 at 02:37:54PM -0700, Joel Becker wrote:
> > On Fri, Oct 03, 2008 at 08:03:36PM -0400, Theodore Tso wrote:
> > 	Now, I'm sure this is the buffer that's going to the journal, I
> > think you're saying that this buffer may not be what gets checkpointed.
> > So the correct checksum hits the journal, but then an invalid one gets
> > to the real location on disk.  Is that right?  If so, I need to figure
> > out where to calculate the checksum somewhere higher, as you say.
> 
> 	Ok, looking at your first email again, you're saying to move up
> to the "Check for escaping" section.  There we might checksum b_data
> before it's copied out.  This is, indeed, safe against the problem you
> mentioned.  I also think it's safe to checksum b_frozen_data if already
> set there, as that's a frozen for commit buffer.  Can I trust that
> checksumming b_data there will not be overwritten by another process
> doing journal_dirty_metadata() before we write out our buffer?  Can I
> trust that the b_frozen_data, if already copied, will be the buffer
> committed and checkpointed?  If so, I think that change works.

I'm not 100% sure.....  The other area that we should check very
closely is jbd2_journal_commit_transaction(); in some cases, if
jh->b_committed_data is NULL, the frozen data is thrown away (around
line 850 in transaction.c).  I *think* this happens if b_frozen_data
was only copied to escape the buffer, but I'm not certain; in any
case, there's a potential that in that case you might lose the
calculated checksum and the correct value wouldn't get written to the
final location on disk.  

There are parts of the jbd2 code which badly needs someone with time
to go through, grok it entirely and then write up how various bits and
pieces work.  Andrew Morton is right; Stephen Tweedie wrote some
*very* clever code, and part of the problem is probably no one can
understand some of the more subtle bits off the cuff, and few can
understand it only after spend a while wrapping their minds around how
it all works.  So I suspect one of is going to have take a deep dive
into the code, grok how the trifecta of b_committed_data,
b_frozen_data, and b_data interact, and which functions make what
assumptions, and then write up a lot of explanatory documentation....

Unfortunately, I'm not sure I'm going to have time for at least the
next couple of weeks.  Do you think you could take a crack at it?

						- Ted
