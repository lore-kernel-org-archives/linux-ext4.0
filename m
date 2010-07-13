From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] align flags for FS_*_FL and EXT4_*_FL
Date: Mon, 12 Jul 2010 18:20:30 -0600
Message-ID: <7A1887BD-F5E9-43A5-8C47-1BDE5E8FA423@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: multipart/mixed; boundary=Apple-Mail-51-25519976
Cc: Theodore Tso <tytso@mit.edu>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:16907 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab0GMAUd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Jul 2010 20:20:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail-51-25519976
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Attached is a trivial patch to align the flags defined as EXT4_*_FL with =
those defined as FS_*_FL.  So far they all line up, and hopefully we can =
keep it that way.

Cheers, Andreas





--Apple-Mail-51-25519976
Content-Disposition: attachment;
	filename=ext4-flags.diff
Content-Type: application/octet-stream;
	name="ext4-flags.diff"
Content-Transfer-Encoding: 7bit

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bf938cf..b0ae12e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -290,6 +290,7 @@ struct flex_groups {
 #define EXT4_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
 #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
 #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
+#define EXT4_DIRECTIO_FL		0x00100000 /* Use direct i/o */
 #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
 #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 44f35ae..463f1cc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -350,11 +350,14 @@ struct inodes_stat_t {
 #define FS_NOTAIL_FL			0x00008000 /* file tail should not be merged */
 #define FS_DIRSYNC_FL			0x00010000 /* dirsync behaviour (directories only) */
 #define FS_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
+#define FS_HUGE_FILE_FL			0x00040000 /* File larger than 16TB */
 #define FS_EXTENT_FL			0x00080000 /* Extents */
 #define FS_DIRECTIO_FL			0x00100000 /* Use direct i/o */
+#define FS_EA_INODE_FL			0x00200000 /* Inode used for large EA */
+#define FS_EOFBLOCKS_FL			0x00400000 /* Blocks allocated beyond EOF */
 #define FS_RESERVED_FL			0x80000000 /* reserved for ext2 lib */
 
-#define FS_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
+#define FS_FL_USER_VISIBLE		0x0053DFFF /* User visible flags */
 #define FS_FL_USER_MODIFIABLE		0x000380FF /* User modifiable flags */
 
 

--Apple-Mail-51-25519976--
