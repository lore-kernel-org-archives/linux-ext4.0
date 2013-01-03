From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] resize2fs: fix 32-bit overflow issue which can
 corrupt 64-bit file systems
Date: Thu, 3 Jan 2013 12:16:35 -0500
Message-ID: <20130103171635.GA3089@thunk.org>
References: <1357222408-7310-1-git-send-email-tytso@mit.edu>
 <50E5AA43.2080200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41532 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab3ACRQj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jan 2013 12:16:39 -0500
Content-Disposition: inline
In-Reply-To: <50E5AA43.2080200@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 03, 2013 at 09:56:51AM -0600, Eric Sandeen wrote:
> 
> Yikes - seems like there are quite a few places where we need to
> audit this kind of thing

Fortunately a bunch of these only apply for 32-bit resizing (i..e,
involving the resize_inode or the 32-bit resize iocl).  The goal_blk
calculations just mean that we will be using a non-optimal block
number, which we should fix, but it's not catastrophic.

The check_block_uninit() function in lib/ext2fs/alloc.c could
defintely cause a problem if someone were to use the library to write
into a 64-bit file system via FUSE, e2tools, or debugfs, but it's
unlikely to cause a problem for mke2fs or e2fsck.  (It could
potentially cause a problem if e2fsck needed to freshly allocate some
new blocks for e.g., a missing lost+found directory, or during pass1b
processing and it allocates for the first time into an block group
with BLOCK_UNINIT, but it's not a high probability bug.) 

Regardless of how likely they are, I agree absolutely that we should
audit and fix all of these problems.

						- Ted
