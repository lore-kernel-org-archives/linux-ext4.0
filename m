From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] resize2fs vs. large inodes, take 3
Date: Mon, 03 Mar 2008 21:19:22 -0600
Message-ID: <47CCBFBA.7040305@redhat.com>
References: <47CC622F.8030900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbYCDDTZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Mar 2008 22:19:25 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m243JO1i019032
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 22:19:24 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m243JNf3027347
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 22:19:23 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m243JMei017800
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 22:19:23 -0500
In-Reply-To: <47CC622F.8030900@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(further livecd-creation testing found more problems; this patch
seems cleaner, survives livecd creations w/o any corruption, and
passes regression tests.  Comments welcome of course.  Should apply
on top of e2fsprogs-1.40.7, still).

-----------------

Use ext2fs_get_next_inode_full() in resize2fs and clean up large
inode handling; previous attempt was not properly handling all cases, 
and was incorrectly setting i_extra_isize.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs-1.40.7/resize/resize2fs.c
===================================================================
--- e2fsprogs-1.40.7.orig/resize/resize2fs.c
+++ e2fsprogs-1.40.7/resize/resize2fs.c
@@ -1109,8 +1109,7 @@ static errcode_t inode_scan_and_fix(ext2
 {
 	struct process_block_struct	pb;
 	ext2_ino_t		ino, new_inode;
-	struct ext2_inode 	inode, *buf = NULL;
-	struct ext2_inode_large	*large_inode;
+	struct ext2_inode 	*inode = NULL;
 	ext2_inode_scan 	scan = NULL;
 	errcode_t		retval;
 	int			group;
@@ -1154,12 +1153,12 @@ static errcode_t inode_scan_and_fix(ext2
 	}
 	ext2fs_set_inode_callback(scan, progress_callback, (void *) rfs);
 	pb.rfs = rfs;
-	pb.inode = &inode;
+	pb.inode = inode;
 	pb.error = 0;
 	new_inode = EXT2_FIRST_INODE(rfs->new_fs->super);
 	inode_size = EXT2_INODE_SIZE(rfs->new_fs->super);
-	buf = malloc(inode_size);
-	if (!buf) {
+	inode = malloc(inode_size);
+	if (!inode) {
 		retval = ENOMEM;
 		goto errout;
 	}
@@ -1168,29 +1167,29 @@ static errcode_t inode_scan_and_fix(ext2
 	 * elsewhere in the inode table
 	 */
 	while (1) {
-		retval = ext2fs_get_next_inode(scan, &ino, &inode);
+		retval = ext2fs_get_next_inode_full(scan, &ino, inode, inode_size);
 		if (retval) goto errout;
 		if (!ino)
 			break;
 
-		if (inode.i_links_count == 0 && ino != EXT2_RESIZE_INO)
+		if (inode->i_links_count == 0 && ino != EXT2_RESIZE_INO)
 			continue; /* inode not in use */
 
-		pb.is_dir = LINUX_S_ISDIR(inode.i_mode);
+		pb.is_dir = LINUX_S_ISDIR(inode->i_mode);
 		pb.changed = 0;
 
-		if (inode.i_file_acl && rfs->bmap) {
+		if (inode->i_file_acl && rfs->bmap) {
 			new_block = ext2fs_extent_translate(rfs->bmap, 
-							    inode.i_file_acl);
+							    inode->i_file_acl);
 			if (new_block) {
-				inode.i_file_acl = new_block;
-				retval = ext2fs_write_inode(rfs->old_fs, 
-							    ino, &inode);
+				inode->i_file_acl = new_block;
+				retval = ext2fs_write_inode_full(rfs->old_fs, 
+							    ino, inode, inode_size);
 				if (retval) goto errout;
 			}
 		}
 		
-		if (ext2fs_inode_has_valid_blocks(&inode) &&
+		if (ext2fs_inode_has_valid_blocks(inode) &&
 		    (rfs->bmap || pb.is_dir)) {
 			pb.ino = ino;
 			retval = ext2fs_block_iterate2(rfs->old_fs,
@@ -1221,23 +1220,19 @@ static errcode_t inode_scan_and_fix(ext2
 			}
 		}
 		ext2fs_mark_inode_bitmap(rfs->new_fs->inode_map, new_inode);
-		memcpy(buf, &inode, sizeof(struct ext2_inode));
-		large_inode = (struct ext2_inode_large *)buf;
-		large_inode->i_extra_isize = sizeof(struct ext2_inode_large) -
-			EXT2_GOOD_OLD_INODE_SIZE;
 		if (pb.changed) {
 			/* Get the new version of the inode */
 			retval = ext2fs_read_inode_full(rfs->old_fs, ino,
-						buf, inode_size);
+						inode, inode_size);
 			if (retval) goto errout;
 		}
-		inode.i_ctime = time(0);
+		inode->i_ctime = time(0);
 		retval = ext2fs_write_inode_full(rfs->old_fs, new_inode,
-						buf, inode_size);
+						inode, inode_size);
 		if (retval) goto errout;
 
 		group = (new_inode-1) / EXT2_INODES_PER_GROUP(rfs->new_fs->super);
-		if (LINUX_S_ISDIR(inode.i_mode))
+		if (LINUX_S_ISDIR(inode->i_mode))
 			rfs->new_fs->group_desc[group].bg_used_dirs_count++;
 		
 #ifdef RESIZE2FS_DEBUG
@@ -1263,8 +1258,8 @@ errout:
 		ext2fs_close_inode_scan(scan);
 	if (block_buf)
 		ext2fs_free_mem(&block_buf);
-	if (buf)
-		free(buf);
+	if (inode)
+		free(inode);
 	return retval;
 }
 

