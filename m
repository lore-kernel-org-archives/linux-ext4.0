From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] ext4 bugfixes
Date: Thu, 24 Jul 2008 16:03:16 -0400
Message-ID: <20080724200316.GA11862@infradead.org>
References: <E1KIbeO-0001yQ-N4@closure.thunk.org> <20080715043718.GA30017@infradead.org> <20080715124652.GB16704@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53877 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbYGXUDu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jul 2008 16:03:50 -0400
Content-Disposition: inline
In-Reply-To: <20080715124652.GB16704@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 15, 2008 at 08:46:52AM -0400, Theodore Tso wrote:
> On Tue, Jul 15, 2008 at 12:37:18AM -0400, Christoph Hellwig wrote:
> > And for this one I haven't even heard back on my review comments.  None
> > of them is a merge blocker so it's not critical, but I find it quite odd
> > that the pull request is coming before even replying to the review
> > comments.
> 
> Can you resend your e-mail, please?  I can't seem to find it in my
> inbox.  Thanks!!

It was just a paragraph in the mail also commenting on the previously
core parts:

> Also the code still deals with the !buffer_mapped and no buffers on page
> cases all over which isn't needed anymore with ->page_mkwrite
> implemented.
> Similarly the !get_block case in mpage_da_writepages doesn't make any
> sense - it's never used and if people would want to use
> generic_writepages they could trivially just call it directly.

I've got a comment from Jan that the no buffers case can still happen,
so that can be removed.

Any chance you could also look into the kerneldoc comments for the newly
exported fs/mpage.c routines as commented on the updated patch?
