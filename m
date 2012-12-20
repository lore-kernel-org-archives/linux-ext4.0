From: Darren Hart <dvhart@infradead.org>
Subject: [PATCH RFC 0/3][RESEND] ext2fsprogs: Symlink support and doc fix
Date: Wed, 19 Dec 2012 18:49:20 -0800
Message-ID: <1355971763-2348-1-git-send-email-dvhart@infradead.org>
Cc: tytso@mit.edu, adilger@dilger.ca, sgw@linux.intel.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37468 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2LTCtf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Dec 2012 21:49:35 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As we appear to have agreed that adding symlink support to debugfs via a new
ext2fs_symlink() function in libext2fs was something that needed doing, I
thought I'd use this as a trial run for my first contribution to the ext2fsprogs
package before I continue working on the larger project of completing initial
directory support for mke2fs.

While I modeled this patch after existing code, their were some inconcsistencies
in the code examples I used that I'd welcome input on. In particular:

o Should the ext2fs_link() happen right after ext2fs_new_inode()? Or should it
  happen closer to the end of the operation? do_write() and ext2fs_mkdir()
  handle this differently.

o Is it necessary to allocate the first block and assign it to the inode or the
  extents? ext2fs_mkdir() does this, do_write() does not. I opted for the
  simpler of the two and it passes my initial simple tests.

o Should I pass "mode" to ext2fs_new_inode() even though it is ignored?

o Would it make sense to try once to expand_dir rather than bailing out of
  ext2fs_mkdir() and ext2fs_symlink() if the directory is full?

o What would we like the initial uid,gid,mode,*time values to be for
  files/directories/links/etc. created with libext2fs?

Finally, I made an attempt to follow the coding style I observed in the code,
but if I missed something, please let me know.

Thanks,

Darren Hart
Intel Open Source Technology Center

