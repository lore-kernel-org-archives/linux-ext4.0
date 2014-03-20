From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: kill i_version support for Hurd-castrated file systems
Date: Thu, 20 Mar 2014 00:34:11 -0400
Message-ID: <1395290051-25682-1-git-send-email-tytso@mit.edu>
References: <20140319202009.GA21361@jessie01>
Cc: 1o5g4r8o@gmail.com, 738758@bugs.debian.org,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43810 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbaCTEeZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2014 00:34:25 -0400
In-Reply-To: <20140319202009.GA21361@jessie01>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The Hurd file system uses uses the inode field which is now used for
i_version for its translator block.  This means that ext2 file systems
that are formatted for GNU Hurd can't be used to support NFSv4.  Given
that Hurd file systems don't support extents, and a huge number of
modern file system features, this is no great loss.

If we don't do this, the attempt to update the i_version field will
stomp over the translator block field, which will cause file system
corruption for Hurd file systems.  This can be replicated via:

mke2fs -t ext2 -o hurd /dev/vdc
mount -t ext4 /dev/vdc /vdc
touch /vdc/bug0000
umount /dev/vdc
e2fsck -f /dev/vdc

Addresses-Debian-Bug: #738758

Reported-By: Gabriele Giacone <1o5g4r8o@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7cc2455..ed2c13a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4168,11 +4168,14 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	EXT4_INODE_GET_XTIME(i_atime, inode, raw_inode);
 	EXT4_EINODE_GET_XTIME(i_crtime, ei, raw_inode);
 
-	inode->i_version = le32_to_cpu(raw_inode->i_disk_version);
-	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
-		if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi))
-			inode->i_version |=
-			(__u64)(le32_to_cpu(raw_inode->i_version_hi)) << 32;
+	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
+	    cpu_to_le32(EXT4_OS_HURD)) {
+		inode->i_version = le32_to_cpu(raw_inode->i_disk_version);
+		if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
+			if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi))
+				inode->i_version |=
+		    (__u64)(le32_to_cpu(raw_inode->i_version_hi)) << 32;
+		}
 	}
 
 	ret = 0;
@@ -4388,12 +4391,16 @@ static int ext4_do_update_inode(handle_t *handle,
 			raw_inode->i_block[block] = ei->i_data[block];
 	}
 
-	raw_inode->i_disk_version = cpu_to_le32(inode->i_version);
-	if (ei->i_extra_isize) {
-		if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi))
-			raw_inode->i_version_hi =
-			cpu_to_le32(inode->i_version >> 32);
-		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
+	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
+	    cpu_to_le32(EXT4_OS_HURD)) {
+		raw_inode->i_disk_version = cpu_to_le32(inode->i_version);
+		if (ei->i_extra_isize) {
+			if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi))
+				raw_inode->i_version_hi =
+					cpu_to_le32(inode->i_version >> 32);
+			raw_inode->i_extra_isize =
+				cpu_to_le16(ei->i_extra_isize);
+		}
 	}
 
 	ext4_inode_csum_set(inode, raw_inode, ei);
-- 
1.9.0

