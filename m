From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: s_freeclusters_counter should not tranform
 to unit of block before assigning to "free_clusters" in
 ext4_has_free_cluste
Date: Sat, 24 Mar 2012 17:05:18 -0400
Message-ID: <20120324210518.GB5883@thunk.org>
References: <1331638698-14796-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: GRobin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60261 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab2CXVFV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Mar 2012 17:05:21 -0400
Content-Disposition: inline
In-Reply-To: <1331638698-14796-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 13, 2012 at 07:38:16PM +0800, Robin Dong wrote:
> Creating 4-byte files until ENOSPC in a delay-allocation and bigalloc ext4 fs and then sync it, the dmseg will report like:
> 
> 	[  482.154538] EXT4-fs (sdb6): delayed block allocation failed for inode 1664 at logical offset 0 with max blocks 1 with error -28
> 	[  482.154540] EXT4-fs (sdb6): This should not happen!! Data will be lost
> 
> The reason is ext4_has_free_clusters reporting wrong
> result. Actually, the unit of sbi->s_dirtyclusters_counter is block,
> so we should tranform it to cluster for argument "dirty_clusters",
> just like "free_clusters".

We have a bigger problem here, which is that this is not the only
place where s_dirty_clusters_counter is being used in units of
clusters.  (See ext4_claim_free_clusters, which when called by mballoc
is using units of clusters.)

We definitely have brokeness here, but this is not the whole story.
We need to take a step back here and decide whether the correct units
is clusters or blocks.  Ultimately I think it does need to be
clusters, because we can't just convert blocks and clusters by using
B2C; we could dirty 3 blocks, but if those 3 blocks span two 64-block
clusters, what's important is that we have to reserve space for 2
clusters.  We can't just calculate "3 >> 6" and assume that we can
reserve 0 clusters and be done with it!

This is one of the places where I think we need to solve things by
having a better data structure for tracking which pages have been
subject to delayed allocation, since if we touch another block in a
cluster where we've done a delayed allocation, we don't need to bump
s_dirtyclusters_counter.  However, if this is the first time we've
touched a block in a particular cluster, then we *do* need to bump
s_dirtyclusters_counter --- and if we need to search all of the pages
in the page cache to make this determination, it's going to be
painful....

					- Ted
