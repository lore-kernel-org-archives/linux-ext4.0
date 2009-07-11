From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH V2] e2fsck: Improve consistency check of uninit block
	group
Date: Sat, 11 Jul 2009 16:02:45 -0400
Message-ID: <20090711200245.GC25844@mit.edu>
References: <4A557866.20604@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41488 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZGKUCy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jul 2009 16:02:54 -0400
Content-Disposition: inline
In-Reply-To: <4A557866.20604@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 09, 2009 at 01:56:06PM +0900, Kazuya Mio wrote:
> Hi,
> 
> I have addressed Ted's comments.
> (http://kerneltrap.org/mailarchive/linux-ext4/2009/7/3/6132903)

I fixed it up a bit before applying it.  It turns out we already had a
function specific to block bitmaps, ext2fs_test_block_bitmap_range()
which provides this functionality.  So I added the optimized version
of the generic bitmap test_range() function, and used it to speed up
ext2fs_test_block_bitmap_range().   This got placed into the maint branch.

The changes to e2fsck's pass5 has been checked into the 'master'
branch of e2fsprogs.

					- Ted
