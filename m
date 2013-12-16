From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 44/74] e2fsck: only release clusters when shortening a
 directory during a rehash
Date: Sun, 15 Dec 2013 23:55:40 -0500
Message-ID: <20131216045540.GG28536@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012312.30655.85205.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40371 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab3LPEzm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Dec 2013 23:55:42 -0500
Content-Disposition: inline
In-Reply-To: <20131211012312.30655.85205.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:23:12PM -0800, Darrick J. Wong wrote:
> When the rehash process is running on a bigalloc filesystem, it
> compresses all the directory entries and hash structures into the
> beginning of the directory file and then uses block_iterate3() to free
> the blocks off the end of the file.  It seems to call
> ext2fs_block_alloc_stats2() for every block in a cluster, which is
> unfortunate because this function allocates and frees entire clusters
> (and updates the summary counts accordingly).  In this case e2fsck
> writes out incorrect summary counts.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
