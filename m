From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 not currently doing (much) multi-block allocation?
Date: Sun, 15 Feb 2009 08:36:18 -0500
Message-ID: <20090215133618.GE10706@mini-me.lan>
References: <20090215053206.GA4803@mini-me.lan> <20090215110528.GE22585@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41138 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbZBONgh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Feb 2009 08:36:37 -0500
Content-Disposition: inline
In-Reply-To: <20090215110528.GE22585@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 15, 2009 at 04:35:28PM +0530, Aneesh Kumar K.V wrote:
> Here is how it works. During writepages we loop through the dirty pages
> and build largest contiguous block extent (mpage_add_bh_to_extent). Then we call
> mpage_da_map_blocks. mpage_da_map_blocks does the mutli block request.
> Once we have the blocks allocated we map these blocks to the pages. And
> then we writeback one page at a time using writepage callback.

mpage_da_map_blocks() calls mpd->get_block, which is set to
ext4_da_get_block_write(), which allocates a single block at a time
(max_blocks is set to bh->b_size >> inode->i_blkbits).

Put another way, where is the call to ext4_get_blocks_wrap() which
does the multi-block request?  I don't see it...

						- Ted
