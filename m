From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/4 v2] code clean up for dio fallocate handling
Date: Tue, 3 Nov 2009 21:20:46 -0500
Message-ID: <20091104022046.GH6510@mit.edu>
References: <1255050813.4931.192.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42263 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbZKDCUm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Nov 2009 21:20:42 -0500
Content-Disposition: inline
In-Reply-To: <1255050813.4931.192.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 08, 2009 at 06:13:33PM -0700, Mingming wrote:
> ext4: code clean up for dio fallocate handling
> 
> The ext4_debug() call in ext4_end_io_dio() (inode.c) has a
> should be moved after checking the io_end structure to be not a NULL pointer.
> 
> The comment above ext4_get_block_dio_write() ("Maximum
> number of blocks...") is a duplicate; the original and correct comment
> is above the #define DIO_MAX_BLOCKS up above.
> 
> The check for allocated > max_blocks in ext4_split_unwritten_extents()
> can be removed, since the code returns immediately once allocated blocks is
> less or equals to the requested blocks to convert.
> 
> Based on review comments from Curt Wohlgemuth.
> 
> Signed-off-by:	Mingming Cao <cmm@us.ibm.com>

The changes described last paragraph wasn't in the patch.  I assume it
was because patch #4 in this series changed:

	if (allocated <= max_blocks)

to:

	if (iblock == ee_block && allocated <= max_blocks)

I replaced the commit description with the following:


ext4: code clean up for dio fallocate handling

From: Mingming <cmm@us.ibm.com>

The ext4_debug() call in ext4_end_io_dio() should be moved after the
check to make sure that io_end is non-NULL.

The comment above ext4_get_block_dio_write() ("Maximum number of
blocks...") is a duplicate; the original and correct comment is above
the #define DIO_MAX_BLOCKS up above.

Based on review comments from Curt Wohlgemuth.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Added to the patch queue

						- Ted
