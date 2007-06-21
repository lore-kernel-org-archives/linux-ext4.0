From: Valerie Clement <valerie.clement@bull.net>
Subject: [RFC][PATCH 11/11][take 2] 48-bit block number for ACL in e2fsprogs
Date: Thu, 21 Jun 2007 17:49:22 +0200
Message-ID: <467A9E02.5030701@bull.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050204090707040503050606"
To: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37148 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbXFUPzr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 11:55:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------050204090707040503050606
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

This patch is intended to contain the changes to support 48-bit block
numbers for ACL. For now, it only contains modifications in the inode
structure. It has to be completed.

Andreas proposed to rename i_file_acl to i_file_ea
and i_file_acl_high to i_file_ea_hi.

  ext2_fs.h |   10 ++++++----
  swapfs.c  |    6 ++++--
  2 files changed, 10 insertions(+), 6 deletions(-)



--------------050204090707040503050606
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="11-handle-i_file_acl_high-in-inode"
Content-Disposition: inline;
 filename="11-handle-i_file_acl_high-in-inode"

Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/ext2_fs.h	2007-06-21 13:16:47.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2_fs.h	2007-06-21 13:16:49.000000000 +0200
@@ -336,7 +336,7 @@ struct ext2_inode {
 	union {
 		struct {
 			__u16	l_i_blocks_hi;
-			__u16	i_pad1;
+			__u16	l_i_file_acl_high;
 			__u16	l_i_uid_high;	/* these 2 fields    */
 			__u16	l_i_gid_high;	/* were reserved2[0] */
 			__u32	l_i_reserved2;
@@ -352,7 +352,7 @@ struct ext2_inode {
 		struct {
 			__u8	m_i_frag;	/* Fragment number */
 			__u8	m_i_fsize;	/* Fragment size */
-			__u16	m_pad1;
+			__u16	m_i_file_acl_high;
 			__u32	m_i_reserved2[2];
 		} masix2;
 	} osd2;				/* OS dependent 2 */
@@ -392,7 +392,7 @@ struct ext2_inode_large {
 	union {
 		struct {
 			__u16	l_i_blocks_hi;
-			__u16	i_pad1;
+			__u16	l_i_file_acl_high;
 			__u16	l_i_uid_high;	/* these 2 fields    */
 			__u16	l_i_gid_high;	/* were reserved2[0] */
 			__u32	l_i_reserved2;
@@ -408,7 +408,7 @@ struct ext2_inode_large {
 		struct {
 			__u8	m_i_frag;	/* Fragment number */
 			__u8	m_i_fsize;	/* Fragment size */
-			__u16	m_pad1;
+			__u16	m_i_file_acl_high;
 			__u32	m_i_reserved2[2];
 		} masix2;
 	} osd2;				/* OS dependent 2 */
@@ -427,6 +427,7 @@ struct ext2_inode_large {
 #define i_reserved1	osd1.linux1.l_i_reserved1
 #define i_frag		osd2.linux2.l_i_frag
 #define i_fsize		osd2.linux2.l_i_fsize
+#define i_file_acl_high	osd2.linux2.l_i_file_acl_high
 #define i_uid_low	i_uid
 #define i_gid_low	i_gid
 #define i_uid_high	osd2.linux2.l_i_uid_high
@@ -449,6 +450,7 @@ struct ext2_inode_large {
 #define i_reserved1	osd1.masix1.m_i_reserved1
 #define i_frag		osd2.masix2.m_i_frag
 #define i_fsize		osd2.masix2.m_i_fsize
+#define i_file_acl_high	osd2.masix2.m_i_file_acl_high
 #define i_reserved2	osd2.masix2.m_i_reserved2
 
 #endif  /* __masix__ */
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/swapfs.c	2007-06-21 13:15:39.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/swapfs.c	2007-06-21 13:16:49.000000000 +0200
@@ -211,7 +211,8 @@ void ext2fs_swap_inode_full(ext2_filsys 
 			ext2fs_swab32(f->osd1.linux1.l_i_version);
 		t->osd2.linux2.l_i_blocks_hi = 
 			ext2fs_swab16(f->osd2.linux2.l_i_blocks_hi);
-		t->osd2.linux2.i_pad1 = ext2fs_swab16(f->osd2.linux2.i_pad1);
+		t->osd2.linux2.l_i_file_acl_high =
+			ext2fs_swab16(f->osd2.linux2.l_i_file_acl_high);
 		t->osd2.linux2.l_i_uid_high =
 		  ext2fs_swab16 (f->osd2.linux2.l_i_uid_high);
 		t->osd2.linux2.l_i_gid_high =
@@ -238,7 +239,8 @@ void ext2fs_swap_inode_full(ext2_filsys 
 			ext2fs_swab32(f->osd1.masix1.m_i_reserved1);
 		t->osd2.masix2.m_i_frag = f->osd2.masix2.m_i_frag;
 		t->osd2.masix2.m_i_fsize = f->osd2.masix2.m_i_fsize;
-		t->osd2.masix2.m_pad1 = ext2fs_swab16(f->osd2.masix2.m_pad1);
+		t->osd2.masix2.m_i_file_acl_high =
+			ext2fs_swab16(f->osd2.masix2.m_i_file_acl_high);
 		t->osd2.masix2.m_i_reserved2[0] =
 			ext2fs_swab32(f->osd2.masix2.m_i_reserved2[0]);
 		t->osd2.masix2.m_i_reserved2[1] =

--------------050204090707040503050606--
