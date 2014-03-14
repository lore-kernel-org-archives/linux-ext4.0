From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 17/49] libext2fs: fix 64bit overflow in
 ext2fs_block_alloc_stats_range
Date: Fri, 14 Mar 2014 09:35:47 -0400
Message-ID: <20140314133547.GL8282@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065546.30585.86235.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41365 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbaCNNfx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2014 09:35:53 -0400
Content-Disposition: inline
In-Reply-To: <20140311065546.30585.86235.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2014 at 11:55:46PM -0700, Darrick J. Wong wrote:
> In ext2fs_block_alloc_stats_range(), the quantity "-inuse * n" is
> calculated as a signed 32-bit quantity.  Unfortunately, gcc (4.6.3 on
> Ubuntu 12.04) doesn't sign-extend this quantity to fill the blk64_t
> parameter that ext2fs_free_blocks_count_add() wants, so the end result
> is that the superblock gets a ridiculously huge free block count.
> 
> Changing the declaration of 'n' to blk64_t seems to fix this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
