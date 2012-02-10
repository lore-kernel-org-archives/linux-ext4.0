From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: s_dirtyclusters_counter should tranform to unit
 of cluster before assigning to "dirty_clusters" in
 ext4_has_free_clusters()
Date: Thu, 9 Feb 2012 21:55:26 -0500
Message-ID: <20120210025526.GB21496@thunk.org>
References: <1328066270-4461-1-git-send-email-hao.bigrat@gmail.com>
 <CAFZ0FUUNRrSa0RvqXcmp_JoZpefDd5pSyx=5LCz5jwDUhUd=_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48280 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758083Ab2BJCz3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Feb 2012 21:55:29 -0500
Content-Disposition: inline
In-Reply-To: <CAFZ0FUUNRrSa0RvqXcmp_JoZpefDd5pSyx=5LCz5jwDUhUd=_w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 02, 2012 at 03:48:49PM +0800, Robin Dong wrote:
> 
> The reason is ext4_has_free_clusters reporting wrong
> result. Actually, the unit of argument "dirty_clusters" is block, so
> we should tranform the sbi->s_dirtyclusters_counter to block , just
> like "free_clusters".

I've been looking at the the delayed allocation reservation code, and
I think it's a lot more confused that this.  Some places we are
playing with fields as if they are clusters, and some times as if they
are blocks, and I've definitely found places where we're not handling
quota correctly with bigalloc (ext4_map_blocks is calling
ext4_da_update_reserve_space() with a value which is clearly in units
of blocks, but we are treating that vale as if it is clusters, etc.)

So I think the problem is a lot larger than what you pointed out, and
we shouldn't fix it just by throwing in an EXT4_C2B call.  If
s_dirtyclusters_counter should be denominated in blocks, then we need
to rename it.  And there there's this comment which made me wince:

   	   * Note that in case of bigalloc, i_reserved_meta_blocks,
	   * i_reserved_data_blocks, etc. refer to number of clusters.

Argh, no.  If something is denominated in clusters, then it should be
appropriately named as such.

Actually, I think the problem is a lot bigger than this, and it's a
conceptual one.  When we try writing to a block which does not have a
mapping, and bigalloc is enabled, there are three cases:

1) This is the first time the cluster has ever been written to; hence,
even though we are dirtying a block, we need to reserve room for the
entire cluster.

2) While the block has not been mapped (and so the data on disk is
uninitialized) the cluster has indeed been allocated, so we don't need
to reserve any additional room for the block.

3) One or more blocks in the cluster have already been written to via
delayed allocation, but the cluster itself has not been selected
(allocated) yet.  But since the space for the entire cluster was
reserved when the first block in the cluster was dirtied (case #1), we
don't need to reserve any more space.

We aren't handling these cases correctly today, since we don't have
this logic here.  These cases don't matter if you're only using
fallocate() and direct I/O, but if you are using buffered writes and
delayed allocation, they obviously matter a huge amount.

And I don't think we're handling it correctly.   Argh...

      	    	  		    		 - Ted
