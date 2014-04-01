From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix premature freeing of partial clusters split
 across
Date: Tue, 1 Apr 2014 19:51:47 -0400
Message-ID: <20140401235147.GB21410@thunk.org>
References: <20140401233646.GA6549@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48742 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbaDAXwR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Apr 2014 19:52:17 -0400
Content-Disposition: inline
In-Reply-To: <20140401233646.GA6549@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 01, 2014 at 07:36:46PM -0400, Eric Whitney wrote:
> Xfstests generic/311 and shared/298 fail when run on a bigalloc file
> system.  Kernel error messages produced during the tests report that
> blocks to be freed are already on the to-be-freed list.  When e2fsck
> is run at the end of the tests, it typically reports bad i_blocks and
> bad free blocks counts.
> 
> The bug that causes these failures is located in ext4_ext_rm_leaf().
> Code at the end of the function frees a partial cluster if it's not
> shared with an extent remaining in the leaf.  However, if all the
> extents in the leaf have been removed, the code dereferences an
> invalid extent pointer (off the front of the leaf) when the check for
> sharing is made.  This generally has the effect of unconditionally
> freeing the partial cluster, which leads to the observed failures
> when the partial cluster is shared with the last extent in the next
> leaf.
> 
> Fix this by attempting to free the cluster only if extents remain in
> the leaf.  Any remaining partial cluster will be freed if possible
> when the next leaf is processed or when leaf removal is complete.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

I added a "Cc: stable@vger.kernel.org" for this patch.

Cheers,

	    	    	 			 - Ted
