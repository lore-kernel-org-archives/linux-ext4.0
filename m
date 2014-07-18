From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/24] debugfs: Only print the first 60 bytes from i_block
 on a fast symlink
Date: Fri, 18 Jul 2014 15:52:24 -0700
Message-ID: <20140718225224.31374.15186.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32930 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762720AbaGRWwf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:52:35 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we have an inline_data fast symlink, i_size can be larger than the
size of i_block.  In this case, debugfs prints off the end of the
buffer, so fix that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debugfs.c            |   15 ++++++++++-----
 tests/d_special_files/expect |    2 +-
 2 files changed, 11 insertions(+), 6 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 51f386b..5eecabe 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -783,11 +783,16 @@ void internal_dump_inode(FILE *out, const char *prefix,
 	}
 
 	if (LINUX_S_ISLNK(inode->i_mode) &&
-	    ext2fs_inode_data_blocks(current_fs,inode) == 0 &&
-	    !(inode->i_flags & EXT4_INLINE_DATA_FL))
-		fprintf(out, "%sFast_link_dest: %.*s\n", prefix,
-			(int) inode->i_size, (char *)inode->i_block);
-	else if (LINUX_S_ISBLK(inode->i_mode) || LINUX_S_ISCHR(inode->i_mode)) {
+	    ext2fs_inode_data_blocks(current_fs, inode) == 0 &&
+	    !(inode->i_flags & EXT4_INLINE_DATA_FL)) {
+		int sz = EXT2_I_SIZE(inode);
+
+		if (sz > sizeof(inode->i_block))
+			sz = sizeof(inode->i_block);
+		fprintf(out, "%sFast link dest: \"%.*s\"\n", prefix, sz,
+			(char *)inode->i_block);
+	} else if (LINUX_S_ISBLK(inode->i_mode) ||
+		   LINUX_S_ISCHR(inode->i_mode)) {
 		int major, minor;
 		const char *devnote;
 
diff --git a/tests/d_special_files/expect b/tests/d_special_files/expect
index 2b2dbfa..f729b0f 100644
--- a/tests/d_special_files/expect
+++ b/tests/d_special_files/expect
@@ -11,7 +11,7 @@ Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
 atime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
 mtime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
-Fast_link_dest: bar
+Fast link dest: "bar"
 Exit status is 0
 debugfs -R ''stat foo2'' -w test.img
 Inode: 13   Type: symlink    Mode:  0777   Flags: 0x0

