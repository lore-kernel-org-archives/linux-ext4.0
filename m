From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 26/25] libext2fs: call get_alloc_block hook when
 allocating blocks
Date: Thu, 11 Sep 2014 18:05:52 -0400
Message-ID: <20140911220552.GB17990@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140911194153.GR10351@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52160 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbaIKWFy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 18:05:54 -0400
Content-Disposition: inline
In-Reply-To: <20140911194153.GR10351@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 12:41:53PM -0700, Darrick J. Wong wrote:
> If a libext2fs client has provided a get_alloc_block hook, we need to
> ensure that all code paths in the library use it to allocate blocks.

I noticed you didn't replace ext2fs_new_block[2] with
ext2fs_alloc_block[2] everywhere, because ext2fs_alloc_block[2]() does
extra work; specifically, it zeroes the newly allocated data block.
In the case of mkjournal.c, that would be disastrous from a
performance perspective, since we go to significant work to avoid
zeroing blocks one at a time.

But in other cases, when we create a symlink, expand a directory,
etc., we're still doing a double write (once in ext2fs_alloc_block,
and then a second time after ext2fs_alloc_block returns).

Hmm... I wonder if we can get away with changing ext2fs_new_block2(fs,
goal, bmap, ret_blk) so that if bmap is NULL, we change its behavior
so that (a) it tries to use the get_alloc_block() hook if it is present, and
(b) it will try to load the block bitmap if it is not already loaded,
instead of returning an error.

There are very few clients that are registering a get_alloc_block hook
today, and so it seems highly unlikely that this will cause problems.
What do you think?

						- Ted
