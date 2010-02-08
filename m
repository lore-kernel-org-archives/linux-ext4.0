From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 07/11] ext4: enlarge mount option field
Date: Mon, 08 Feb 2010 16:28:09 +0300
Message-ID: <1265635693-12182-8-git-send-email-dmonakhov@openvz.org>
References: <1265635693-12182-1-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-2-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-3-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-4-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-5-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-6-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-7-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:33218 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab0BHO23 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2010 09:28:29 -0500
Received: from localhost.localdomain ([unknown] [195.214.232.10])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KXI0097MZ0I9F10@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Mon, 08 Feb 2010 16:34:01 +0300 (MSK)
In-reply-to: <1265635693-12182-7-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently only one bit left in s_mount_opt. Let's
double size it for future purposes.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h      |   64 +++++++++++++++++++++++++-------------------------
 fs/ext4/ext4_jbd2.c |    2 +-
 fs/ext4/super.c     |    2 +-
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 67859fa..55f1034 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -412,7 +412,7 @@ struct ext4_new_group_data {
  *  Mount options
  */
 struct ext4_mount_options {
-	unsigned long s_mount_opt;
+	unsigned long long s_mount_opt;
 	uid_t s_resuid;
 	gid_t s_resgid;
 	unsigned long s_commit_interval;
@@ -730,36 +730,36 @@ struct ext4_inode_info {
 /*
  * Mount flags
  */
-#define EXT4_MOUNT_OLDALLOC		0x00002  /* Don't use the new Orlov allocator */
-#define EXT4_MOUNT_GRPID		0x00004	/* Create files with directory's group */
-#define EXT4_MOUNT_DEBUG		0x00008	/* Some debugging messages */
-#define EXT4_MOUNT_ERRORS_CONT		0x00010	/* Continue on errors */
-#define EXT4_MOUNT_ERRORS_RO		0x00020	/* Remount fs ro on errors */
-#define EXT4_MOUNT_ERRORS_PANIC		0x00040	/* Panic on errors */
-#define EXT4_MOUNT_MINIX_DF		0x00080	/* Mimics the Minix statfs */
-#define EXT4_MOUNT_NOLOAD		0x00100	/* Don't use existing journal*/
-#define EXT4_MOUNT_DATA_FLAGS		0x00C00	/* Mode for data writes: */
-#define EXT4_MOUNT_JOURNAL_DATA		0x00400	/* Write data to journal */
-#define EXT4_MOUNT_ORDERED_DATA		0x00800	/* Flush data before commit */
-#define EXT4_MOUNT_WRITEBACK_DATA	0x00C00	/* No data ordering */
-#define EXT4_MOUNT_UPDATE_JOURNAL	0x01000	/* Update the journal format */
-#define EXT4_MOUNT_NO_UID32		0x02000  /* Disable 32-bit UIDs */
-#define EXT4_MOUNT_XATTR_USER		0x04000	/* Extended user attributes */
-#define EXT4_MOUNT_POSIX_ACL		0x08000	/* POSIX Access Control Lists */
-#define EXT4_MOUNT_NO_AUTO_DA_ALLOC	0x10000	/* No auto delalloc mapping */
-#define EXT4_MOUNT_BARRIER		0x20000 /* Use block barriers */
-#define EXT4_MOUNT_NOBH			0x40000 /* No bufferheads */
-#define EXT4_MOUNT_QUOTA		0x80000 /* Some quota option set */
-#define EXT4_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
-#define EXT4_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
-#define EXT4_MOUNT_DIOREAD_NOLOCK	0x400000 /* Enable support for dio read nolocking */
-#define EXT4_MOUNT_JOURNAL_CHECKSUM	0x800000 /* Journal checksums */
-#define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
-#define EXT4_MOUNT_I_VERSION            0x2000000 /* i_version support */
-#define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
-#define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000 /* Abort on file data write */
-#define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000 /* Block validity checking */
-#define EXT4_MOUNT_DISCARD		0x40000000 /* Issue DISCARD requests */
+#define EXT4_MOUNT_OLDALLOC		0x00002LL    /* Don't use the new Orlov allocator */
+#define EXT4_MOUNT_GRPID		0x00004LL    /* Create files with directory's group */
+#define EXT4_MOUNT_DEBUG		0x00008LL    /* Some debugging messages */
+#define EXT4_MOUNT_ERRORS_CONT		0x00010LL    /* Continue on errors */
+#define EXT4_MOUNT_ERRORS_RO		0x00020LL    /* Remount fs ro on errors */
+#define EXT4_MOUNT_ERRORS_PANIC		0x00040LL    /* Panic on errors */
+#define EXT4_MOUNT_MINIX_DF		0x00080LL    /* Mimics the Minix statfs */
+#define EXT4_MOUNT_NOLOAD		0x00100LL    /* Don't use existing journal*/
+#define EXT4_MOUNT_DATA_FLAGS		0x00C00LL    /* Mode for data writes: */
+#define EXT4_MOUNT_JOURNAL_DATA		0x00400LL    /* Write data to journal */
+#define EXT4_MOUNT_ORDERED_DATA		0x00800LL    /* Flush data before commit */
+#define EXT4_MOUNT_WRITEBACK_DATA	0x00C00LL    /* No data ordering */
+#define EXT4_MOUNT_UPDATE_JOURNAL	0x01000LL    /* Update the journal format */
+#define EXT4_MOUNT_NO_UID32		0x02000LL    /* Disable 32-bit UIDs */
+#define EXT4_MOUNT_XATTR_USER		0x04000LL    /* Extended user attributes */
+#define EXT4_MOUNT_POSIX_ACL		0x08000LL    /* POSIX Access Control Lists */
+#define EXT4_MOUNT_NO_AUTO_DA_ALLOC	0x10000LL    /* No auto delalloc mapping */
+#define EXT4_MOUNT_BARRIER		0x20000LL    /* Use block barriers */
+#define EXT4_MOUNT_NOBH			0x40000LL    /* No bufferheads */
+#define EXT4_MOUNT_QUOTA		0x80000LL    /* Some quota option set */
+#define EXT4_MOUNT_USRQUOTA		0x100000LL   /* "old" user quota */
+#define EXT4_MOUNT_GRPQUOTA		0x200000LL   /* "old" group quota */
+#define EXT4_MOUNT_DIOREAD_NOLOCK	0x400000LL   /* Enable support for dio read nolocking */
+#define EXT4_MOUNT_JOURNAL_CHECKSUM	0x800000LL   /* Journal checksums */
+#define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000LL  /* Journal Async Commit */
+#define EXT4_MOUNT_I_VERSION            0x2000000LL  /* i_version support */
+#define EXT4_MOUNT_DELALLOC		0x8000000LL  /* Delalloc support */
+#define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000LL /* Abort on file data write */
+#define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000LL /* Block validity checking */
+#define EXT4_MOUNT_DISCARD		0x40000000LL /* Issue DISCARD requests */
 
 #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt
 #define set_opt(o, opt)			o |= EXT4_MOUNT_##opt
@@ -908,7 +908,7 @@ struct ext4_sb_info {
 	struct buffer_head * s_sbh;	/* Buffer containing the super block */
 	struct ext4_super_block *s_es;	/* Pointer to the super block in the buffer */
 	struct buffer_head **s_group_desc;
-	unsigned int s_mount_opt;
+	unsigned long long s_mount_opt;
 	unsigned int s_mount_flags;
 	ext4_fsblk_t s_sb_block;
 	uid_t s_resuid;
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index b57e5c7..36e1f98 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -58,7 +58,7 @@ int __ext4_forget(const char *where, handle_t *handle, int is_metadata,
 	BUFFER_TRACE(bh, "enter");
 
 	jbd_debug(4, "forgetting bh %p: is_metadata = %d, mode %o, "
-		  "data mode %x\n",
+		  "data mode %llx\n",
 		  bh, is_metadata, inode->i_mode,
 		  test_opt(inode->i_sb, DATA_FLAGS));
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 68a5915..93ba5e2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1720,7 +1720,7 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 	ext4_commit_super(sb, 1);
 	if (test_opt(sb, DEBUG))
 		printk(KERN_INFO "[EXT4 FS bs=%lu, gc=%u, "
-				"bpg=%lu, ipg=%lu, mo=%04x]\n",
+				"bpg=%lu, ipg=%lu, mo=%08llx]\n",
 			sb->s_blocksize,
 			sbi->s_groups_count,
 			EXT4_BLOCKS_PER_GROUP(sb),
-- 
1.6.3.3

