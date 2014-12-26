From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Bug#773795: fsck.ext2: memory corruption
Date: Thu, 25 Dec 2014 23:31:08 -0500
Message-ID: <20141226043108.GA24553@thunk.org>
References: <20141223115114.GA1647@jwilk.net>
 <20141224214517.GA29088@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jakub Wilk <jwilk@debian.org>, 773795@bugs.debian.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43101 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbaLZEbV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Dec 2014 23:31:21 -0500
Content-Disposition: inline
In-Reply-To: <20141224214517.GA29088@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've checked the following fix into the e2fsprogs git repository.
Thanks again for reporting the bug.

     	     	 	       	    	- Ted

commit 13f450addb3c9624987e62e9978e793d874c060d
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Dec 25 23:18:32 2014 -0500

    libext2fs: add sanity check for an invalid itable_used value in inode scan code
    
    If the number of unused inodes is greater than number of inodes a
    block group, this can cause an e2fsck -n run of the file system to
    crash.
    
    We should add more checks to e2fsck to detect this case directly, but
    this will at least protect progams (tune2fs, dump, etc.) which use the
    inode_scan abstraction from crashing on an invalid file system.
    
    Addresses-Debian-Bug: #773795
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 573a8fa..a2f2ecd 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -150,8 +150,11 @@ errcode_t ext2fs_open_inode_scan(ext2_filsys fs, int buffer_blocks,
 	scan->blocks_left = scan->fs->inode_blocks_per_group;
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
-		scan->inodes_left -=
-			ext2fs_bg_itable_unused(fs, scan->current_group);
+		__u32 unused = ext2fs_bg_itable_unused(fs, scan->current_group);
+		if (scan->inodes_left > unused)
+			scan->inodes_left -= unused;
+		else
+			scan->inodes_left = 0;
 		scan->blocks_left =
 			(scan->inodes_left +
 			 (fs->blocksize / scan->inode_size - 1)) *
@@ -243,8 +246,11 @@ static errcode_t get_next_blockgroup(ext2_inode_scan scan)
 	scan->blocks_left = fs->inode_blocks_per_group;
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
-		scan->inodes_left -=
-			ext2fs_bg_itable_unused(fs, scan->current_group);
+		__u32 unused = ext2fs_bg_itable_unused(fs, scan->current_group);
+		if (scan->inodes_left > unused)
+			scan->inodes_left -= unused;
+		else
+			scan->inodes_left = 0;
 		scan->blocks_left =
 			(scan->inodes_left +
 			 (fs->blocksize / scan->inode_size - 1)) *
