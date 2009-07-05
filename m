From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 lockdep report re possible reclaim deadlock on jbd2_handle
Date: Sun, 5 Jul 2009 08:43:33 -0400
Message-ID: <20090705124333.GA6757@mit.edu>
References: <87prcgp19p.fsf@shaolin.home.digitalvampire.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Roland Dreier <roland@digitalvampire.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45928 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbZGEMoO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jul 2009 08:44:14 -0400
Content-Disposition: inline
In-Reply-To: <87prcgp19p.fsf@shaolin.home.digitalvampire.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 04, 2009 at 02:49:06PM -0700, Roland Dreier wrote:
> 
> I recently got the following lockdep warning on my laptop.  The kernel
> is Ubuntu's tree with Linus's git up to d960eea9 pulled it; I don't
> think there are any non-mainline ext4 changes involved, and the
> warning below does look valid on mainline.

Yeah, it looks valid.  And thanks.  This looks like it might be
related to a long-standing bug which has puzzled me a lot of other
people, Ubuntu Launchpad #330824:

	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/330824

> It does seem a little odd to me that no one else has seen this,
> since I thought quite a few people tested with lockdep enabled.  So
> maybe something is odd about my system or kernel config.  Anyway, I'm
> happy to try further tests and/or debugging patches.

The funny thing has been that many people using Ubuntu kernels haven't
been able to replicate it (myself and a number of Canonical kernel
people included), and people who *can* reproduce it report that it
goes away the moment they go use a stock mainline kernel ---
regardless of whether it's 2.6.28, 2.6.29, 2.6.30, or any number of
other -rc kernels.

The other funny thing is that if the lockdep warning you've reported
also explains Ubuntu Launchpad #330824, it doesn't make any sense,
since there the problem shows up when deleting a large number of
files, and in that case, we should be truncating the file down to zero
--- so (inode->i_size & (sb->s_blocksize - 1)) should be evaluating to
zero, and so ext4_block_truncate_page() shouldn't be getting called in
that case.

> As far as I can tell, lockdep is warning that jbd2_handle is usually
> acquired while doing reclaim -- which makes sense, as pushing dirty
> inodes out of memory is of course going to want to do fs transactions;

Actually, it's not that common that we would be pushing dirty inodes
out of memory during a reclaim, since normally the transaction is
assocated with the foreground kernel syscall that modified the inode
in the first place (i.e., chmod, rename, utimes, etc.).  And when an
inode gets deleted, the filesystem transaction either happens
immediately, as a result of the unlink call, or if there is a file
descriptor holding it open, in the close() system call that releases
the file descriptor.

What seems to be happening here is the ecryptfs is holding the file
open, because of the upper dentry reference.  So that's not a normal
thing, and maybe that's why most people haven't noticed the problem;
they're not doing enough with ecryptfs to trigger things.


How easily can you reproduce the lockdep warning?  Does this patch
(not tested; sorry, am in the Berkshires for the July 4th holiday)
make it go away?

					- Ted

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 60a26f3..9760ba0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3583,7 +3583,8 @@ int ext4_block_truncate_page(handle_t *handle,
 	struct page *page;
 	int err = 0;
 
-	page = grab_cache_page(mapping, from >> PAGE_CACHE_SHIFT);
+	page = find_or_create_page(mapping, from >> PAGE_CACHE_SHIFT,
+				   mapping_gfp_mask(mapping) & ~__GFP_FS);
 	if (!page)
 		return -EINVAL;
 
