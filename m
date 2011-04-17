From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: register ext2 and ext3 alias after ext4
Date: Sat, 16 Apr 2011 22:01:41 -0400
Message-ID: <20110417020141.GB3806@thunk.org>
References: <4DA48AF4.5080803@teksavvy.com>
 <20110413004938.GE3682@thunk.org>
 <4DA5ADA6.5060301@teksavvy.com>
 <5A35771F-49B6-491E-B012-DBE68907E382@mit.edu>
 <ext4-masq@mdm.bga.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mark Lord <kernel@teksavvy.com>, ricwheeler@gmail.com,
	linux-ext4@vger.kernel.org
To: Milton Miller <miltonm@bga.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46021 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab1DQCBq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Apr 2011 22:01:46 -0400
Content-Disposition: inline
In-Reply-To: <ext4-masq@mdm.bga.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 14, 2011 at 10:30:07AM -0500, Milton Miller wrote:
> The intent of CONFIG_EXT4_USE_FOR_EXT23 is to provide an alias so
> that the ext4 module is sufficient even if user space calls out ext2.
> However, it currently registers the alias names before registering ext4.
> This means they show up first in /proc/filesystems and ext3 and ext4
> formatted file systems show up in the mount list as ext4.

Note this is only true for the root file system.

> 
> Register the filesystem aliases after ext4 so they show as ext4 until the
> filesystems is filtered.  This will avoid users or tools configuring a
> kernel with just ext2 and wondering why there system broke.  Also register
> in the same order as listed in fs/Makefile.
> 
> Signed-off-by: Milton Miller <miltonm@bga.com>

This is actually the better way to fix Mark's complaint, as it
provides the correct behaviour if someone tries explicitly mounting an
ext4 file system via "mount -t ext2 /dev/sda".  It also provides a
better explanation of what happens when CONFIG_EXT4_USE_EXT23 is
enabled and ext2 and ext3 are deconfigured, and the user has an ext2
or ext3 root file system.  Now they will something like this:

EXT4-fs (sda): mounting ext2 file system using the ext4 subsystem
EXT4-fs (sda): mounted filesystem without journal. Opts: (null)

which makes clearer what is going on.

							- Ted

>From 5a5baedb6306edb9effc86add73e9522e2a70532 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sat, 16 Apr 2011 21:31:57 -0400
Subject: [PATCH] ext4: check for ext[23] file system features when mounting as ext[23]

Provide better emulation for ext[23] mode by enforcing that the file
system does not have any unsupported file system features as defined
by ext[23] when emulating the ext[23] file system driver when
CONFIG_EXT4_USE_FOR_EXT23 is defined.

This causes the file system type information in /proc/mounts to be
correct for the automatically mounted root file system.  This also
means that "mount -t ext2 /dev/sda /mnt" will fail if /dev/sda
contains an ext3 or ext4 file system, just as one would expect if the
original ext2 file system driver were in use.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h  |   15 +++++++++++
 fs/ext4/super.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 79 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4daaf2b..076c5d2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1351,6 +1351,21 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400 /* EA in inode */
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000 /* data in dirent */
 
+#define EXT2_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
+#define EXT2_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
+					 EXT4_FEATURE_INCOMPAT_META_BG)
+#define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
+					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
+					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR)
+
+#define EXT3_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
+#define EXT3_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
+					 EXT4_FEATURE_INCOMPAT_RECOVER| \
+					 EXT4_FEATURE_INCOMPAT_META_BG)
+#define EXT3_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
+					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
+					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR)
+
 #define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
 					 EXT4_FEATURE_INCOMPAT_RECOVER| \
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8553dfb..bb2d660 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -75,11 +75,27 @@ static void ext4_write_super(struct super_block *sb);
 static int ext4_freeze(struct super_block *sb);
 static struct dentry *ext4_mount(struct file_system_type *fs_type, int flags,
 		       const char *dev_name, void *data);
+static inline int ext2_feature_set_ok(struct super_block *sb);
+static inline int ext3_feature_set_ok(struct super_block *sb);
 static int ext4_feature_set_ok(struct super_block *sb, int readonly);
 static void ext4_destroy_lazyinit_thread(void);
 static void ext4_unregister_li_request(struct super_block *sb);
 static void ext4_clear_request_list(void);
 
+#if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
+static struct file_system_type ext2_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "ext2",
+	.mount		= ext4_mount,
+	.kill_sb	= kill_block_super,
+	.fs_flags	= FS_REQUIRES_DEV,
+};
+#define IS_EXT2_SB(sb) ((sb)->s_bdev->bd_holder == &ext2_fs_type)
+#else
+#define IS_EXT2_SB(sb) (0)
+#endif
+
+
 #if !defined(CONFIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
 static struct file_system_type ext3_fs_type = {
 	.owner		= THIS_MODULE,
@@ -3187,6 +3203,28 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		       "feature flags set on rev 0 fs, "
 		       "running e2fsck is recommended");
 
+	if (IS_EXT2_SB(sb)) {
+		if (ext2_feature_set_ok(sb))
+			ext4_msg(sb, KERN_INFO, "mounting ext2 file system "
+				 "using the ext4 subsystem");
+		else {
+			ext4_msg(sb, KERN_ERR, "couldn't mount as ext2 due "
+				 "to feature incompatibilities");
+			goto failed_mount;
+		}
+	}
+
+	if (IS_EXT3_SB(sb)) {
+		if (ext3_feature_set_ok(sb))
+			ext4_msg(sb, KERN_INFO, "mounting ext3 file system "
+				 "using the ext4 subsystem");
+		else {
+			ext4_msg(sb, KERN_ERR, "couldn't mount as ext3 due "
+				 "to feature incompatibilities");
+			goto failed_mount;
+		}
+	}
+
 	/*
 	 * Check feature flags regardless of the revision level, since we
 	 * previously didn't change the revision level when setting the flags,
@@ -4772,14 +4810,6 @@ static struct dentry *ext4_mount(struct file_system_type *fs_type, int flags,
 }
 
 #if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
-static struct file_system_type ext2_fs_type = {
-	.owner		= THIS_MODULE,
-	.name		= "ext2",
-	.mount		= ext4_mount,
-	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
-};
-
 static inline void register_as_ext2(void)
 {
 	int err = register_filesystem(&ext2_fs_type);
@@ -4792,10 +4822,22 @@ static inline void unregister_as_ext2(void)
 {
 	unregister_filesystem(&ext2_fs_type);
 }
+
+static inline int ext2_feature_set_ok(struct super_block *sb)
+{
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, ~EXT2_FEATURE_INCOMPAT_SUPP))
+		return 0;
+	if (sb->s_flags & MS_RDONLY)
+		return 1;
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, ~EXT2_FEATURE_RO_COMPAT_SUPP))
+		return 0;
+	return 1;
+}
 MODULE_ALIAS("ext2");
 #else
 static inline void register_as_ext2(void) { }
 static inline void unregister_as_ext2(void) { }
+static inline int ext2_feature_set_ok(struct super_block *sb) { return 0; }
 #endif
 
 #if !defined(CONFIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
@@ -4811,10 +4853,24 @@ static inline void unregister_as_ext3(void)
 {
 	unregister_filesystem(&ext3_fs_type);
 }
+
+static inline int ext3_feature_set_ok(struct super_block *sb)
+{
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, ~EXT3_FEATURE_INCOMPAT_SUPP))
+		return 0;
+	if (!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL))
+		return 0;
+	if (sb->s_flags & MS_RDONLY)
+		return 1;
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, ~EXT3_FEATURE_RO_COMPAT_SUPP))
+		return 0;
+	return 1;
+}
 MODULE_ALIAS("ext3");
 #else
 static inline void register_as_ext3(void) { }
 static inline void unregister_as_ext3(void) { }
+static inline int ext3_feature_set_ok(struct super_block *sb) { return 0; }
 #endif
 
 static struct file_system_type ext4_fs_type = {
-- 
1.7.3.1

