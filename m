From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] ext4: check incompatible mount options when mounting ext2/3 [V2]
Date: Tue, 22 Jan 2013 11:07:58 -0500
Message-ID: <1358870878-7369-1-git-send-email-cmaiolino@redhat.com>
References: <1351798331-14456-1-git-send-email-cmaiolino@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab3AVQID (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2013 11:08:03 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0MG83IF001231
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jan 2013 11:08:03 -0500
Received: from localhost.localdomain.com (ovpn-113-20.phx2.redhat.com [10.3.113.20])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r0MG82IH009341
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jan 2013 11:08:02 -0500
In-Reply-To: <1351798331-14456-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This checks for incompatible mounting options when using ext4 module to mount
ext3 or ext2 filesystems.

Sets two new flags to group ext4 mount options that are incompatible with ext2
and ext3, and then add two functions -- check_ext2/3_incompat_mount() -- to
check and warn/fail mount, if any of these options are being used.

I believe, some options like those expecting an argument needs to be checked
during parsing time.

barrier mount, although it has a flag, when mounting an ext2fs, where barriers
are not supported (afaik), should also be checked during parse time, otherwise
the BARRIER mount flag will be set.

I didn't add all mount options I believe to need to raise a warning, just
those with a flag set on superblock, another flags should be added after a
discussion to reach a concensus of all ext2/3 options that should be rejected by
ext4 mount.

Changelog:
	V2 - Fail a mount instead of just warning

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/ext4/ext4.h  | 15 +++++++++++++++
 fs/ext4/super.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8462eb3..9478f1d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -995,6 +995,21 @@ struct ext4_inode_info {
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
index 3d4fb81..63c529e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -83,6 +83,8 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly);
 static void ext4_destroy_lazyinit_thread(void);
 static void ext4_unregister_li_request(struct super_block *sb);
 static void ext4_clear_request_list(void);
+static inline int check_ext3_incompat_mount(struct super_block *sb);
+static inline int check_ext2_incompat_mount(struct super_block *sb);
 
 #if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
 static struct file_system_type ext2_fs_type = {
@@ -3470,6 +3472,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 				 "to feature incompatibilities");
 			goto failed_mount;
 		}
+		ret = check_ext2_incompat_mount(sb);
 	}
 
 	if (IS_EXT3_SB(sb)) {
@@ -3481,8 +3484,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 				 "to feature incompatibilities");
 			goto failed_mount;
 		}
+		ret = check_ext3_incompat_mount(sb);
 	}
 
+	if (ret == -EPERM)
+		goto failed_mount;
+
 	/*
 	 * Check feature flags regardless of the revision level, since we
 	 * previously didn't change the revision level when setting the flags,
@@ -5194,6 +5201,30 @@ static inline int ext2_feature_set_ok(struct super_block *sb)
 		return 0;
 	return 1;
 }
+
+static inline int check_ext3_incompat_mount(struct super_block *sb)
+{
+	if (test_opt(sb, INCOMPAT_EXT3)) {
+		printk(KERN_WARNING
+			"EXT4-fs: Mount options incompatible with ext3\n");
+		return -EPERM;
+	}
+
+	return 0;
+
+}
+
+static inline int check_ext2_incompat_mount(struct super_block *sb)
+{
+	if (test_opt(sb, INCOMPAT_EXT2)) {
+		printk(KERN_WARNING
+			"EXT4-fs: Mount options incompatible with ext2\n");
+		return -EPERM;
+	}
+
+	return 0;
+}
+
 MODULE_ALIAS("ext2");
 #else
 static inline void register_as_ext2(void) { }
-- 
1.8.1

