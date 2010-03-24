From: tytso@mit.edu
Subject: Re: [PATCH] ext4/super.c: Replace CONTIG_EXT{2,3}_FS by
 CONFIG_EXT{2,3}_FS
Date: Wed, 24 Mar 2010 12:12:01 -0400
Message-ID: <20100324161201.GG2159@thunk.org>
References: <2d0a357f1003240405x1178f0c6x188d30d1d311cb5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: sedat.dilek@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60879 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab0CXQMY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Mar 2010 12:12:24 -0400
Content-Disposition: inline
In-Reply-To: <2d0a357f1003240405x1178f0c6x188d30d1d311cb5@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for catching this!  This should fix it up...

       	   	    	   	       	   - Ted

ext4: Fix build error when EXT4_USE_FOR_EXT23 disabled

Fix a stupid type (CONTIG != CONFIG) and a stupid assumption that
ext3_fs_type would always be defined.

(The build failure could also happen when EXT4_USE_FOR_EXT23 is
enabled and ext3 is built as a module.)

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3d1a056..29c6875 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -71,7 +71,7 @@ static int ext4_freeze(struct super_block *sb);
 static int ext4_get_sb(struct file_system_type *fs_type, int flags,
 		       const char *dev_name, void *data, struct vfsmount *mnt);
 
-#if !defined(CONTIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
+#if !defined(CONFIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
 static struct file_system_type ext3_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "ext3",
@@ -79,6 +79,9 @@ static struct file_system_type ext3_fs_type = {
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
 };
+#define IS_EXT3_SB(sb) ((sb)->s_bdev->bd_holder == &ext3_fs_type)
+#else
+#define IS_EXT3_SB(sb) (0)
 #endif
 
 ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
@@ -2550,7 +2553,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 * enable delayed allocation by default
 	 * Use -o nodelalloc to turn it off
 	 */
-	if (sb->s_bdev->bd_holder != &ext3_fs_type)
+	if (!IS_EXT3_SB(sb))
 		set_opt(sbi->s_mount_opt, DELALLOC);
 
 	if (!parse_options((char *) data, sb, &journal_devnum,
@@ -4080,7 +4083,7 @@ static int ext4_get_sb(struct file_system_type *fs_type, int flags,
 	return get_sb_bdev(fs_type, flags, dev_name, data, ext4_fill_super,mnt);
 }
 
-#if !defined(CONTIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
+#if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
 static struct file_system_type ext2_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "ext2",
@@ -4107,7 +4110,7 @@ static inline void register_as_ext2(void) { }
 static inline void unregister_as_ext2(void) { }
 #endif
 
-#if !defined(CONTIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
+#if !defined(CONFIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
 static inline void register_as_ext3(void)
 {
 	int err = register_filesystem(&ext3_fs_type);
