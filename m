From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] ext4: check incompatible mount options when mounting ext2/3
Date: Thu,  1 Nov 2012 17:32:11 -0200
Message-ID: <1351798331-14456-1-git-send-email-cmaiolino@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933938Ab2KATcU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Nov 2012 15:32:20 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qA1JWKT4017553
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 1 Nov 2012 15:32:20 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-34.phx2.redhat.com [10.3.113.34])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id qA1JWI5U000880
	for <linux-ext4@vger.kernel.org>; Thu, 1 Nov 2012 15:32:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This checks for incompatible mounting options when using ext4 module to mount
ext3 or ext2 filesystems.

This first attempt sets two new flags to group ext4 mount options that are
incompatible with ext2 and ext3, and then add two functions
(check_ext2/3_incompat_mount()) to check and warning, if any of these
options are being used.

I believe, some options like those expecting an argument needs to be checked
during parsing time.

barrier mount, although it has a flag, when mounting an ext2fs, where barriers
are not supported (afaik), should also be checked during parse time, otherwise
the BARRIER mount flag will be set.

I have not added all mount options I believe need to raise a warning, just
those with a flag set on superblock, but I expect to generate a discussion here
about which mount options should be warned and get suggestions about how to deal
with argumented options (ex: commit= opt), to be included in a V2 of this patch.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/ext4/ext4.h  | 15 +++++++++++++++
 fs/ext4/super.c | 20 ++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3c20de1..f6f020b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -977,6 +977,21 @@ struct ext4_inode_info {
 #define EXT4_MOUNT2_EXPLICIT_DELALLOC	0x00000001 /* User explicitly
 						      specified delalloc */
 
+#define EXT4_MOUNT_INCOMPAT_EXT3	(EXT4_MOUNT_JOURNAL_CHECKSUM |		\
+					 EXT4_MOUNT_JOURNAL_ASYNC_COMMIT |	\
+					 EXT4_MOUNT_DELALLOC |			\
+					 EXT4_MOUNT_DISCARD |			\
+					 EXT4_MOUNT_BLOCK_VALIDITY |		\
+					 EXT4_MOUNT_DATA_ERR_ABORT |		\
+					 EXT4_MOUNT_DIOREAD_NOLOCK)
+
+#define EXT4_MOUNT_INCOMPAT_EXT2	(EXT4_MOUNT_INCOMPAT_EXT3 |		\
+					 EXT4_MOUNT_NOLOAD |			\
+					 EXT4_MOUNT_JOURNAL_DATA |		\
+					 EXT4_MOUNT_WRITEBACK_DATA |		\
+					 EXT4_MOUNT_UPDATE_JOURNAL |		\
+					 EXT4_MOUNT_ORDERED_DATA)
+
 #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
 						~EXT4_MOUNT_##opt
 #define set_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt |= \
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 80928f7..93f7a80 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -83,6 +83,8 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly);
 static void ext4_destroy_lazyinit_thread(void);
 static void ext4_unregister_li_request(struct super_block *sb);
 static void ext4_clear_request_list(void);
+static inline void check_ext3_incompat_mount(struct super_block *sb);
+static inline void check_ext2_incompat_mount(struct super_block *sb);
 
 #if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
 static struct file_system_type ext2_fs_type = {
@@ -3475,6 +3477,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 				 "to feature incompatibilities");
 			goto failed_mount;
 		}
+		check_ext2_incompat_mount(sb);
 	}
 
 	if (IS_EXT3_SB(sb)) {
@@ -3486,6 +3489,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 				 "to feature incompatibilities");
 			goto failed_mount;
 		}
+		check_ext3_incompat_mount(sb);
 	}
 
 	/*
@@ -5192,6 +5196,22 @@ static inline int ext2_feature_set_ok(struct super_block *sb)
 		return 0;
 	return 1;
 }
+
+static inline void check_ext3_incompat_mount(struct super_block *sb)
+{
+	if (test_opt(sb, INCOMPAT_EXT3))
+		printk(KERN_WARNING
+			"EXT4-fs: Mount options incompatible with ext3\n");
+
+}
+
+static inline void check_ext2_incompat_mount(struct super_block *sb)
+{
+	if (test_opt(sb, INCOMPAT_EXT2))
+		printk(KERN_WARNING
+			"EXT4-fs: Mount options incompatible with ext2\n");
+}
+
 MODULE_ALIAS("ext2");
 #else
 static inline void register_as_ext2(void) { }
-- 
1.7.11.7

