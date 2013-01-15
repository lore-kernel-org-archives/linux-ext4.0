From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] lib/ext2fs: Add ext2fs_symlink
Date: Tue, 15 Jan 2013 14:43:30 -0500
Message-ID: <20130115194330.GF17719@thunk.org>
References: <1357329660-28639-1-git-send-email-dvhart@infradead.org>
 <3fd850c4bf72f868b0d93bb0a5acced51fd25caa.1357329054.git.dvhart@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca, sgw@linux.intel.com,
	darrick.wong@oracle.com
To: Darren Hart <dvhart@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43565 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012Ab3AOTnm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 14:43:42 -0500
Content-Disposition: inline
In-Reply-To: <3fd850c4bf72f868b0d93bb0a5acced51fd25caa.1357329054.git.dvhart@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'll fix up the this patch before I commit it, but this is a perfect
exhibit about why I request that code submissions come with test
cases.  It turns out that there were a couple of problems with
ext2fs_symlink(), that showed up very quickly as soon as I started
writing a test case (where it's important to run e2fsck on the
resulting file system after creating the symlinks --- e2fsck is a
wonderful rep invariant checkers for ext[234] file systems. :-)

*) i_blocks must be set to 0 for fast symlinks
*) The last argument of ext2fs_inode_alloc_stats() indicates whether
   the new inode is a directory or not.  So when you cut and pasted
   the code from ext2fs_mkdir(), it needed to be changed.
*) Zeroing the entire block before setting the symlink in the case
   where it needs to use an external data block makes it a lot
   easier to write the regression test.

So here's the patch I needed to apply on top of your submission....

   	      	      	     	      	 - Ted

diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
index fb8b91b..da6e3a8 100644
--- a/lib/ext2fs/symlink.c
+++ b/lib/ext2fs/symlink.c
@@ -78,7 +78,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	memset(&inode, 0, sizeof(struct ext2_inode));
 	inode.i_mode = LINUX_S_IFLNK | 0777;
 	inode.i_uid = inode.i_gid = 0;
-	ext2fs_iblk_set(fs, &inode, 1);
+	ext2fs_iblk_set(fs, &inode, fastlink ? 0 : 1);
 	inode.i_links_count = 1;
 	inode.i_size = target_len;
 	/* The time fields are set by ext2fs_write_new_inode() */
@@ -88,6 +88,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 		strcpy((char *)&inode.i_block, target);
 	} else {
 		/* Slow symlinks, target stored in the first block */
+		memset(block_buf, 0, fs->blocksize);
 		strcpy(block_buf, target);
 		if (fs->super->s_feature_incompat &
 		   EXT3_FEATURE_INCOMPAT_EXTENTS) {
@@ -149,7 +150,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	 */
 	if (!fastlink)
 		ext2fs_block_alloc_stats2(fs, blk, +1);
-	ext2fs_inode_alloc_stats2(fs, ino, +1, 1);
+	ext2fs_inode_alloc_stats2(fs, ino, +1, 0);
 
 cleanup:
 	if (block_buf)
