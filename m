From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] e2fsprogs: fix resize2fs moving inodes with inline xattrs
Date: Thu, 28 Feb 2008 13:24:17 -0600
Message-ID: <47C70A61.4080302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762634AbYB1TYT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Feb 2008 14:24:19 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m1SJOIaB030958
	for <linux-ext4@vger.kernel.org>; Thu, 28 Feb 2008 14:24:18 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1SJOIma018374
	for <linux-ext4@vger.kernel.org>; Thu, 28 Feb 2008 14:24:18 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1SJOHZW006173
	for <linux-ext4@vger.kernel.org>; Thu, 28 Feb 2008 14:24:17 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Addresses RH Bug 434893: resizing leads to missing xattrs

inode_scan_and_fix() in resize2fs needs to do read/write
of the full inode to be sure it gets all data from larger
(>128 byte) inodes.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs-1.40.6/resize/resize2fs.c
===================================================================
--- e2fsprogs-1.40.6.orig/resize/resize2fs.c
+++ e2fsprogs-1.40.6/resize/resize2fs.c
@@ -1109,13 +1109,15 @@ static errcode_t inode_scan_and_fix(ext2
 {
 	struct process_block_struct	pb;
 	ext2_ino_t		ino, new_inode;
-	struct ext2_inode 	inode;
+	struct ext2_inode 	inode, *buf = NULL;
+	struct ext2_inode_large	*large_inode;
 	ext2_inode_scan 	scan = NULL;
 	errcode_t		retval;
 	int			group;
 	char			*block_buf = 0;
 	ext2_ino_t		start_to_move;
 	blk_t			orig_size, new_block;
+	int			inode_size;
 	
 	if ((rfs->old_fs->group_desc_count <=
 	     rfs->new_fs->group_desc_count) &&
@@ -1155,6 +1157,12 @@ static errcode_t inode_scan_and_fix(ext2
 	pb.inode = &inode;
 	pb.error = 0;
 	new_inode = EXT2_FIRST_INODE(rfs->new_fs->super);
+	inode_size = EXT2_INODE_SIZE(rfs->new_fs->super);
+	buf = malloc(inode_size);
+	if (!buf) {
+		retval = ENOMEM;
+		goto errout;
+	}
 	/*
 	 * First, copy all of the inodes that need to be moved
 	 * elsewhere in the inode table
@@ -1213,13 +1221,19 @@ static errcode_t inode_scan_and_fix(ext2
 			}
 		}
 		ext2fs_mark_inode_bitmap(rfs->new_fs->inode_map, new_inode);
+		memcpy(buf, &inode, sizeof(struct ext2_inode));
+		large_inode = (struct ext2_inode_large *)buf;
+		large_inode->i_extra_isize = sizeof(struct ext2_inode_large) -
+			EXT2_GOOD_OLD_INODE_SIZE;
 		if (pb.changed) {
 			/* Get the new version of the inode */
-			retval = ext2fs_read_inode(rfs->old_fs, ino, &inode);
+			retval = ext2fs_read_inode_full(rfs->old_fs, ino,
+						buf, inode_size);
 			if (retval) goto errout;
 		}
 		inode.i_ctime = time(0);
-		retval = ext2fs_write_inode(rfs->old_fs, new_inode, &inode);
+		retval = ext2fs_write_inode_full(rfs->old_fs, new_inode,
+						buf, inode_size);
 		if (retval) goto errout;
 
 		group = (new_inode-1) / EXT2_INODES_PER_GROUP(rfs->new_fs->super);
@@ -1249,6 +1263,8 @@ errout:
 		ext2fs_close_inode_scan(scan);
 	if (block_buf)
 		ext2fs_free_mem(&block_buf);
+	if (buf)
+		free(buf);
 	return retval;
 }
 

