From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix xfstest generic/299 block validity failures
Date: Wed, 12 Feb 2014 10:44:03 -0500
Message-ID: <20140212154403.GB14520@thunk.org>
References: <20140210200414.GA2155@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57078 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaBLPoH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Feb 2014 10:44:07 -0500
Content-Disposition: inline
In-Reply-To: <20140210200414.GA2155@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 10, 2014 at 03:04:14PM -0500, Eric Whitney wrote:
> Commit a115f749c1 (ext4: remove wait for unwritten extent conversion from
> ext4_truncate) exposed a bug in ext4_ext_handle_uninitialized_extents().
> It can be triggered by xfstest generic/299 when run on a test file
> system created without a journal.  This test continuously fallocates and
> truncates files to which random dio/aio writes are simultaneously
> performed by a separate process.  The test completes successfully, but
> if the test filesystem is mounted with the block_validity option, a
> warning message stating that a logical block has been mapped to an
> illegal physical block is posted in the kernel log.
> 
> The bug occurs when an extent is being converted to the written state
> by ext4_end_io_dio() and ext4_ext_handle_uninitialized_extents()
> discovers a mapping for an existing uninitialized extent. Although it
> sets EXT4_MAP_MAPPED in map->m_flags, it fails to set map->m_pblk to
> the discovered physical block number.  Because map->m_pblk is not
> otherwise initialized or set by this function or its callers, its
> uninitialized value is returned to ext4_map_blocks(), where it is
> stored as a bogus mapping in the extent status tree.
> 
> Since map->m_pblk can accidentally contain illegal values that are
> larger than the physical size of the file system,  calls to
> check_block_validity() in ext4_map_blocks() that are enabled if the
> block_validity mount option is used can fail, resulting in the logged
> warning message.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Applied, many thanks!!  I've marked this with:

Cc: stable@vger.kernel.org  # 3.11+

						- Ted
