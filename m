From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [PATCH 1/4] ext4: release buffer when checksum failed
Date: Fri, 18 Jan 2013 16:01:11 +0800
Message-ID: <1358496074-6228-1-git-send-email-yan@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, "D. J. Wong" <darrick.wong@oracle.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:48627 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab3ARIB3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jan 2013 03:01:29 -0500
Received: from /spool/local
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Fri, 18 Jan 2013 17:57:29 +1000
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [9.190.235.152])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 541452CE804C
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2013 19:01:18 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r0I7nSIJ53674214
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2013 18:49:28 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r0I81GMA031858
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2013 19:01:17 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit b0336e8d (ext4: calculate and verify checksums of directory leaf
blocks) and commit dbe89444 (ext4: Calculate and verify checksums for
htree nodes) forget to release buffer when checksum failed, at some places.

Cc: D. J. Wong <darrick.wong@oracle.com>
Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/ext4/dir.c   |    1 +
 fs/ext4/namei.c |   12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 80a28b2..3882fbc 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -185,6 +185,7 @@ static int ext4_readdir(struct file *filp,
 					"at offset %llu",
 					(unsigned long long)filp->f_pos);
 			filp->f_pos += sb->s_blocksize - offset;
+			brelse(bh);
 			continue;
 		}
 		set_buffer_verified(bh);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 8990165..a445247 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -837,6 +837,7 @@ static int ext4_htree_next_block(struct inode *dir, __u32 hash,
 		    !ext4_dx_csum_verify(dir,
 					 (struct ext4_dir_entry *)bh->b_data)) {
 			ext4_warning(dir->i_sb, "Node failed checksum");
+			brelse(bh);
 			return -EIO;
 		}
 		set_buffer_verified(bh);
@@ -877,8 +878,11 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	}
 
 	if (!buffer_verified(bh) &&
-	    !ext4_dirent_csum_verify(dir, (struct ext4_dir_entry *)bh->b_data))
+			!ext4_dirent_csum_verify(dir,
+				(struct ext4_dir_entry *)bh->b_data)) {
+		brelse(bh);
 		return -EIO;
+	}
 	set_buffer_verified(bh);
 
 	de = (struct ext4_dir_entry_2 *) bh->b_data;
@@ -1929,8 +1933,10 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 		}
 		if (!buffer_verified(bh) &&
 		    !ext4_dirent_csum_verify(dir,
-				(struct ext4_dir_entry *)bh->b_data))
+				(struct ext4_dir_entry *)bh->b_data)) {
+			brelse(bh);
 			return -EIO;
+		}
 		set_buffer_verified(bh);
 		retval = add_dirent_to_buf(handle, dentry, inode, NULL, bh);
 		if (retval != -ENOSPC) {
@@ -2493,6 +2499,7 @@ static int empty_dir(struct inode *inode)
 			(struct ext4_dir_entry *)bh->b_data)) {
 		EXT4_ERROR_INODE(inode, "checksum error reading directory "
 				 "lblock 0");
+		brelse(bh);
 		return -EIO;
 	}
 	set_buffer_verified(bh);
@@ -2537,6 +2544,7 @@ static int empty_dir(struct inode *inode)
 					(struct ext4_dir_entry *)bh->b_data)) {
 				EXT4_ERROR_INODE(inode, "checksum error "
 						 "reading directory lblock 0");
+				brelse(bh);
 				return -EIO;
 			}
 			set_buffer_verified(bh);
-- 
1.7.9.5

