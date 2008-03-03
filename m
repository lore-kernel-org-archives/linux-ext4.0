From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] resize2fs vs. large inodes, take 2
Date: Mon, 03 Mar 2008 14:40:15 -0600
Message-ID: <47CC622F.8030900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbYCCUkS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Mar 2008 15:40:18 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m23KeHRV008472
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 15:40:17 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m23KeG4G019256
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 15:40:16 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m23KeFvj002983
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 15:40:15 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

large inodes with both fast symlinks and in-inode selinux attrs
were not surviving moves via resize2fs.

Somehow I missed that there was an ext2fs_get_next_inode_full... 
I think the below fix is correct, on top of my previous patch
(and what is in e2fsprogs-1.40.7...)

But I don't mind a review ;)

Thanks,
-Eric

------------------- changelog ----------------------

Use ext2fs_get_next_inode_full() in resize2fs; previous attempt
was not properly handling all cases, and was incorrectly setting
i_extra_isize.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs-1.40.7/resize/resize2fs.c
===================================================================
--- e2fsprogs-1.40.7.orig/resize/resize2fs.c
+++ e2fsprogs-1.40.7/resize/resize2fs.c
@@ -1168,11 +1168,12 @@ static errcode_t inode_scan_and_fix(ext2
 	 * elsewhere in the inode table
 	 */
 	while (1) {
-		retval = ext2fs_get_next_inode(scan, &ino, &inode);
+		retval = ext2fs_get_next_inode_full(scan, &ino, buf, inode_size);
 		if (retval) goto errout;
 		if (!ino)
 			break;
 
+		memcpy(&inode, buf, sizeof(struct ext2_inode));
 		if (inode.i_links_count == 0 && ino != EXT2_RESIZE_INO)
 			continue; /* inode not in use */
 
@@ -1221,10 +1222,7 @@ static errcode_t inode_scan_and_fix(ext2
 			}
 		}
 		ext2fs_mark_inode_bitmap(rfs->new_fs->inode_map, new_inode);
-		memcpy(buf, &inode, sizeof(struct ext2_inode));
 		large_inode = (struct ext2_inode_large *)buf;
-		large_inode->i_extra_isize = sizeof(struct ext2_inode_large) -
-			EXT2_GOOD_OLD_INODE_SIZE;
 		if (pb.changed) {
 			/* Get the new version of the inode */
 			retval = ext2fs_read_inode_full(rfs->old_fs, ino,

