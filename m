From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] allow in-inode EAs on ext4 root inode
Date: Tue, 29 Jan 2008 14:42:25 -0600
Message-ID: <479F8FB1.6010608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Theodore Tso <tytso@mit.edu>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbYA2Umu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jan 2008 15:42:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext3 root inode was treated specially with respect 
to in-inode extended attributes, for reasons detailed 
in the removed comment below.  The first mkfs-created
inodes would not get extra_i_size or the EXT3_STATE_XATTR 
flag set in ext3_read_inode, which disallowed reading or 
setting in-inode EAs on the root.

However, in ext4, ext4_mark_inode_dirty calls 
ext4_expand_extra_isize for all inodes; once this is done 
EAs may be placed in the root ext4 inode body.

But for reasons above, it won't be found after a reboot.

testcase:

setfattr -n user.name -v value mntpt/
setfattr -n user.name2 -v value2 mntpt/
umount mntpt/; remount mntpt/
getfattr -d mntpt/

name2/value2 has gone missing; debugfs shows it in the
inode body, but it is not found there by getattr.

The following fixes it up; newer mkfs appears to properly
zero the inodes, so this workaround isn't needed for ext4.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: linux-2.6.24-rc6-mm1/fs/ext4/inode.c
===================================================================
--- linux-2.6.24-rc6-mm1.orig/fs/ext4/inode.c
+++ linux-2.6.24-rc6-mm1/fs/ext4/inode.c
@@ -2750,13 +2750,7 @@ void ext4_read_inode(struct inode * inod
 		ei->i_data[block] = raw_inode->i_block[block];
 	INIT_LIST_HEAD(&ei->i_orphan);
 
-	if (inode->i_ino >= EXT4_FIRST_INO(inode->i_sb) + 1 &&
-	    EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
-		/*
-		 * When mke2fs creates big inodes it does not zero out
-		 * the unused bytes above EXT4_GOOD_OLD_INODE_SIZE,
-		 * so ignore those first few inodes.
-		 */
+	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
 		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
 		if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
 		    EXT4_INODE_SIZE(inode->i_sb)) {
