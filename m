From: Jim Garlick <garlick@llnl.gov>
Subject: [PATCH] libext2fs memory leak in ext2fs_write_new_inode()
Date: Wed, 4 Apr 2007 17:21:05 -0700 (PDT)
Message-ID: <Pine.LNX.4.61.0704041717470.1374@webb>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-3.llnl.gov ([128.115.41.83]:64072 "EHLO
	nspiron-3.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbXDEAaq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Apr 2007 20:30:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following patch addresses a memory leak in libext2fs
that occurs when using ext2fs_write_new_inode() on a file system
configured with large inodes.

Signed-off-by: Jim Garlick <garlick@llnl.gov>

Index: e2fsprogs+chaos/lib/ext2fs/inode.c
===================================================================
--- e2fsprogs+chaos.orig/lib/ext2fs/inode.c
+++ e2fsprogs+chaos/lib/ext2fs/inode.c
@@ -752,6 +752,7 @@ errcode_t ext2fs_write_new_inode(ext2_fi
  	struct ext2_inode	*buf;
  	int 			size = EXT2_INODE_SIZE(fs->super);
  	struct ext2_inode_large	*large_inode;
+	errcode_t		rc;

  	if (size == sizeof(struct ext2_inode))
  		return ext2fs_write_inode_full(fs, ino, inode,
@@ -768,7 +769,9 @@ errcode_t ext2fs_write_new_inode(ext2_fi
  	large_inode->i_extra_isize = sizeof(struct ext2_inode_large) -
  		EXT2_GOOD_OLD_INODE_SIZE;

-	return ext2fs_write_inode_full(fs, ino, buf, size);
+	rc = ext2fs_write_inode_full(fs, ino, buf, size);
+	free(buf);
+	return rc;
  }
