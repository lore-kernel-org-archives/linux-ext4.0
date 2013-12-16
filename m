From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 42/74] libext2fs: only punch complete clusters
Date: Sun, 15 Dec 2013 23:52:59 -0500
Message-ID: <20131216045259.GE28536@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012259.30655.62502.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40361 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab3LPExE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Dec 2013 23:53:04 -0500
Content-Disposition: inline
In-Reply-To: <20131211012259.30655.62502.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:22:59PM -0800, Darrick J. Wong wrote:
> When bigalloc is enabled, using ext2fs_block_alloc_stats2() to free
> any block in a cluster has the effect of freeing the entire cluster.
> This is problematic if a caller instructs us to punch, say, blocks
> 12-15 of a 16-block cluster, because blocks 0-11 now point to a "free"
> cluster.
> 
> The naive way to solve this problem is to see if any of the other
> blocks in this logical cluster map to a physical cluster.  If so, then
> we know that the cluster is still in use and it mustn't be freed.
> Otherwise, we are punching the last mapped block in this cluster, so
> we can free the cluster.
> 
> The implementation given only does the rigorous checks for the partial
> clusters at the beginning and end of the punching range.
> 
> v2: Refactor the block free code into a separate helper function that
> should be more efficient.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
