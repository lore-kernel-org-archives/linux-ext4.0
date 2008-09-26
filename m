From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] dynamic inodes
Date: Fri, 26 Sep 2008 18:26:32 -0400
Message-ID: <20080926222632.GE8903@mit.edu>
References: <48DA28B0.2020207@sun.com> <20080925223731.GM10950@webber.adilger.int> <20080926021132.GA11413@mit.edu> <20080926103322.GA10950@webber.adilger.int> <20080926143309.GC11413@mit.edu> <20080926201832.GG10950@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <bzzz@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:35969 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752227AbYIZW0f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Sep 2008 18:26:35 -0400
Content-Disposition: inline
In-Reply-To: <20080926201832.GG10950@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 26, 2008 at 02:18:32PM -0600, Andreas Dilger wrote:
> I agree that replicating a GDT inode is probably the easiest answer.
> IIRC this was proposed also in the past, before META_BG was implemented.
> To be honest, we should just deprecate META_BG at that time, I don't
> think it was every used by anything, and still isn't properly handled
> by the cross-product of filesystem features (online resize, others).

Meta_BG is I think relatively well supported now, actually.  More to
the point, the resize_inode feature doesn't work for filesystems with
more than 2**32 blocks, since indirect blocks don't work for such
filesystems.  The assumption had always been that we would use meta_bg
to support online-resize for > 2*32 block filesystem, once we had
implemented on-line resize support for it.

> How do inode numbers affect the GDT blocks?  Is it because high inode
> numbers would be in correspondingly high "groups" and resizing could
> be done "normally" without affecting the new GDT placement?

Yep.  So inode numbers between 1 and (num_bg*inodes_per_bg)+1 are
"natural" inodes, and inodes above that would have to be "dynamic"
inodes where the GDT would be found in an inode.

> I was going to object on the grounds that the GDT inodes will become too
> large and sparse, but for a "normal" ratio (8192 inodes/group) this
> only works out to be 32MB for the whole gdt to hit 2^32 inodes.

I'm not sure what you mean by "sparse".... the would be just as tighly
packed, but just starting at 2*32-1 and growing down.

> The other thing we should consider is the case where the inode ratio
> is too high, and it is limiting the growth of the filesystem due to
> 2^32 inode limit.  With a default inode ratio of 1 inode/8192 bytes,
> this hits 2^32 inodes at 262144 groups, or only 32TB...  We may need
> to also be able to add "inodeless groups" in such systems unless we
> also implement 2^64-bit inode numbers at the same time.

Yeah, good point.  The real fundamental question is whether we want to
try to support 2**64 inodes as a long-term goal.  Past a certain
point, we would have to have inodeless groups if we support 2**48
physical blocks, but only 2**32 inodes, with or without dynamic
inodes.

							- Ted

