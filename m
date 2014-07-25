From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/24] e2fsck: force all block allocations to use
 block_found_map
Date: Thu, 24 Jul 2014 22:18:53 -0400
Message-ID: <20140725021853.GC1865@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225341.31374.29415.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55621 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757371AbaGYCS5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jul 2014 22:18:57 -0400
Content-Disposition: inline
In-Reply-To: <20140718225341.31374.29415.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:53:41PM -0700, Darrick J. Wong wrote:
> During the later passes of efsck, we sometimes need to allocate and
> map blocks into a file.  This can happen either by fsck directly
> calling new_block() or indirectly by the library calling new_block
> because it needs to allocate a block for lower level metadata (bmap2()
> with BMAP_SET; block_iterate3() with BLOCK_CHANGED).
> 
> We need to force new_block to allocate blocks from the found block
> map, because the FS block map could be inaccurate for various reasons:
> the map is wrong, there are missing blocks, the checksum failed, etc.
> 
> Therefore, any time fsck does something that could to allocate blocks,
> we need to intercept allocation requests so that they're sourced from
> the found block map.  Remove the previous code that swapped bitmap
> pointers as this is now unneeded.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
