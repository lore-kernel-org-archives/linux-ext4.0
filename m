From: Thierry Reding <thierry.reding@avionic-design.de>
Subject: [PATCH] ext2: No longer export ext2_fs.h to user space
Date: Fri, 23 Mar 2012 10:27:36 +0100
Message-ID: <1332494856-31943-1-git-send-email-thierry.reding@avionic-design.de>
References: <20120322183135.GC4028@thunk.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Ted Ts'o <tytso@mit.edu>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Andreas Dilger <aedilger@gmail.com>, linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:58063 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2CWJ2W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Mar 2012 05:28:22 -0400
In-Reply-To: <20120322183135.GC4028@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since the on-disk format has been stable for quite some time, users
should either use the headers provided by libext2fs or keep a private
copy of this header. For the full discussion, see this thread:

	https://lkml.org/lkml/2012/3/21/516

While at it, this commit removes all __KERNEL__ guards, which are now
unnecessary.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Andreas Dilger <aedilger@gmail.com>
Cc: linux-ext4@vger.kernel.org
---
 include/linux/Kbuild    |    1 -
 include/linux/ext2_fs.h |   72 +++++++----------------------------------------
 2 files changed, 10 insertions(+), 63 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index a255553..1cb0704 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -120,7 +120,6 @@ header-y += errno.h
 header-y += errqueue.h
 header-y += ethtool.h
 header-y += eventpoll.h
-header-y += ext2_fs.h
 header-y += fadvise.h
 header-y += falloc.h
 header-y += fanotify.h
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index ce1b719..f28dba5 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -20,6 +20,8 @@
 #include <linux/magic.h>
 #include <linux/fs.h>
 
+#include <linux/ext2_fs_sb.h>
+
 /*
  * The second extended filesystem constants/structures
  */
@@ -66,18 +68,10 @@
 /* First non-reserved inode for old ext2 filesystems */
 #define EXT2_GOOD_OLD_FIRST_INO	11
 
-#ifdef __KERNEL__
-#include <linux/ext2_fs_sb.h>
 static inline struct ext2_sb_info *EXT2_SB(struct super_block *sb)
 {
 	return sb->s_fs_info;
 }
-#else
-/* Assume that user mode programs are passing in an ext2fs superblock, not
- * a kernel struct super_block.  This will allow us to call the feature-test
- * macros from user land. */
-#define EXT2_SB(sb)	(sb)
-#endif
 
 /*
  * Maximal count of links to a file
@@ -90,29 +84,12 @@ static inline struct ext2_sb_info *EXT2_SB(struct super_block *sb)
 #define EXT2_MIN_BLOCK_SIZE		1024
 #define	EXT2_MAX_BLOCK_SIZE		4096
 #define EXT2_MIN_BLOCK_LOG_SIZE		  10
-#ifdef __KERNEL__
-# define EXT2_BLOCK_SIZE(s)		((s)->s_blocksize)
-#else
-# define EXT2_BLOCK_SIZE(s)		(EXT2_MIN_BLOCK_SIZE << (s)->s_log_block_size)
-#endif
+#define EXT2_BLOCK_SIZE(s)		((s)->s_blocksize)
 #define	EXT2_ADDR_PER_BLOCK(s)		(EXT2_BLOCK_SIZE(s) / sizeof (__u32))
-#ifdef __KERNEL__
-# define EXT2_BLOCK_SIZE_BITS(s)	((s)->s_blocksize_bits)
-#else
-# define EXT2_BLOCK_SIZE_BITS(s)	((s)->s_log_block_size + 10)
-#endif
-#ifdef __KERNEL__
+#define EXT2_BLOCK_SIZE_BITS(s)		((s)->s_blocksize_bits)
 #define	EXT2_ADDR_PER_BLOCK_BITS(s)	(EXT2_SB(s)->s_addr_per_block_bits)
 #define EXT2_INODE_SIZE(s)		(EXT2_SB(s)->s_inode_size)
 #define EXT2_FIRST_INO(s)		(EXT2_SB(s)->s_first_ino)
-#else
-#define EXT2_INODE_SIZE(s)	(((s)->s_rev_level == EXT2_GOOD_OLD_REV) ? \
-				 EXT2_GOOD_OLD_INODE_SIZE : \
-				 (s)->s_inode_size)
-#define EXT2_FIRST_INO(s)	(((s)->s_rev_level == EXT2_GOOD_OLD_REV) ? \
-				 EXT2_GOOD_OLD_FIRST_INO : \
-				 (s)->s_first_ino)
-#endif
 
 /*
  * Macro-instructions used to manage fragments
@@ -120,13 +97,8 @@ static inline struct ext2_sb_info *EXT2_SB(struct super_block *sb)
 #define EXT2_MIN_FRAG_SIZE		1024
 #define	EXT2_MAX_FRAG_SIZE		4096
 #define EXT2_MIN_FRAG_LOG_SIZE		  10
-#ifdef __KERNEL__
-# define EXT2_FRAG_SIZE(s)		(EXT2_SB(s)->s_frag_size)
-# define EXT2_FRAGS_PER_BLOCK(s)	(EXT2_SB(s)->s_frags_per_block)
-#else
-# define EXT2_FRAG_SIZE(s)		(EXT2_MIN_FRAG_SIZE << (s)->s_log_frag_size)
-# define EXT2_FRAGS_PER_BLOCK(s)	(EXT2_BLOCK_SIZE(s) / EXT2_FRAG_SIZE(s))
-#endif
+#define EXT2_FRAG_SIZE(s)		(EXT2_SB(s)->s_frag_size)
+#define EXT2_FRAGS_PER_BLOCK(s)		(EXT2_SB(s)->s_frags_per_block)
 
 /*
  * Structure of a blocks group descriptor
@@ -146,16 +118,10 @@ struct ext2_group_desc
 /*
  * Macro-instructions used to manage group descriptors
  */
-#ifdef __KERNEL__
-# define EXT2_BLOCKS_PER_GROUP(s)	(EXT2_SB(s)->s_blocks_per_group)
-# define EXT2_DESC_PER_BLOCK(s)		(EXT2_SB(s)->s_desc_per_block)
-# define EXT2_INODES_PER_GROUP(s)	(EXT2_SB(s)->s_inodes_per_group)
-# define EXT2_DESC_PER_BLOCK_BITS(s)	(EXT2_SB(s)->s_desc_per_block_bits)
-#else
-# define EXT2_BLOCKS_PER_GROUP(s)	((s)->s_blocks_per_group)
-# define EXT2_DESC_PER_BLOCK(s)		(EXT2_BLOCK_SIZE(s) / sizeof (struct ext2_group_desc))
-# define EXT2_INODES_PER_GROUP(s)	((s)->s_inodes_per_group)
-#endif
+#define EXT2_BLOCKS_PER_GROUP(s)	(EXT2_SB(s)->s_blocks_per_group)
+#define EXT2_DESC_PER_BLOCK(s)		(EXT2_SB(s)->s_desc_per_block)
+#define EXT2_INODES_PER_GROUP(s)	(EXT2_SB(s)->s_inodes_per_group)
+#define EXT2_DESC_PER_BLOCK_BITS(s)	(EXT2_SB(s)->s_desc_per_block_bits)
 
 /*
  * Constants relative to the data blocks
@@ -296,7 +262,6 @@ struct ext2_inode {
 
 #define i_size_high	i_dir_acl
 
-#if defined(__KERNEL__) || defined(__linux__)
 #define i_reserved1	osd1.linux1.l_i_reserved1
 #define i_frag		osd2.linux2.l_i_frag
 #define i_fsize		osd2.linux2.l_i_fsize
@@ -305,23 +270,6 @@ struct ext2_inode {
 #define i_uid_high	osd2.linux2.l_i_uid_high
 #define i_gid_high	osd2.linux2.l_i_gid_high
 #define i_reserved2	osd2.linux2.l_i_reserved2
-#endif
-
-#ifdef	__hurd__
-#define i_translator	osd1.hurd1.h_i_translator
-#define i_frag		osd2.hurd2.h_i_frag
-#define i_fsize		osd2.hurd2.h_i_fsize
-#define i_uid_high	osd2.hurd2.h_i_uid_high
-#define i_gid_high	osd2.hurd2.h_i_gid_high
-#define i_author	osd2.hurd2.h_i_author
-#endif
