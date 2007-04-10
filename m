From: Jim Garlick <garlick@llnl.gov>
Subject: [PATCH] e2fsprogs - e2fsck pass1c does extra work if root dir has
 shared blocks
Date: Tue, 10 Apr 2007 15:39:56 -0700 (PDT)
Message-ID: <Pine.LNX.4.61.0704101538020.31519@webb>
References: <Pine.LNX.4.61.0704101344050.29750@webb>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-1.llnl.gov ([128.115.41.81]:41189 "EHLO
	nspiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030715AbXDJWkM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Apr 2007 18:40:12 -0400
In-Reply-To: <Pine.LNX.4.61.0704101344050.29750@webb>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted,

Another small bug I think: if the root directory contains shared 
blocks, e2fsck pass1c search_dirent_proc() will be looking for 
one more containing directory than it will ever find, and thus 
loses an opportunity to terminate early.

Signed-off-by: Jim Garlick <garlick@llnl.gov>

Index: e2fsprogs+chaos/e2fsck/pass1b.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/pass1b.c
+++ e2fsprogs+chaos/e2fsck/pass1b.c
@@ -96,6 +96,7 @@ static void pass1c(e2fsck_t ctx, char *b
  static void pass1d(e2fsck_t ctx, char *block_buf);

  static int dup_inode_count = 0;
+static int dup_inode_founddir = 0;

  static dict_t blk_dict, ino_dict;

@@ -146,7 +147,12 @@ static void add_dupe(e2fsck_t ctx, ext2_
  	else {
  		di = (struct dup_inode *) e2fsck_allocate_memory(ctx,
  			 sizeof(struct dup_inode), "duplicate inode header");
-		di->dir = (ino == EXT2_ROOT_INO) ? EXT2_ROOT_INO : 0 ;
+		if (ino == EXT2_ROOT_INO) {
+			di->dir = EXT2_ROOT_INO;
+			dup_inode_founddir++;
+		} else
+			di->dir = 0;
+
  		di->num_dupblocks = 0;
  		di->block_list = 0;
  		di->inode = *inode;
@@ -396,7 +402,7 @@ static void pass1c(e2fsck_t ctx, char *b
  	 * Search through all directories to translate inodes to names
  	 * (by searching for the containing directory for that inode.)
  	 */
-	sd.count = dup_inode_count;
+	sd.count = dup_inode_count - dup_inode_founddir;
  	sd.first_inode = EXT2_FIRST_INODE(fs->super);
  	sd.max_inode = fs->super->s_inodes_count;
  	ext2fs_dblist_dir_iterate(fs->dblist, 0, block_buf,
