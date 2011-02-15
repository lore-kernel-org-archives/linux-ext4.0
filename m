From: Aditya Kali <adityakali@google.com>
Subject: [PATCH] e2fsprogs: reserving code points for new ext4 quota feature
Date: Mon, 14 Feb 2011 17:07:11 -0800
Message-ID: <AANLkTik3Ff7jokEL47uaLphwAP9hcd_16-eb3P8Cvagf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:34638 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1BOBHf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Feb 2011 20:07:35 -0500
Received: from kpbe13.cbf.corp.google.com (kpbe13.cbf.corp.google.com [172.25.105.77])
	by smtp-out.google.com with ESMTP id p1F17XTx012292
	for <linux-ext4@vger.kernel.org>; Mon, 14 Feb 2011 17:07:33 -0800
Received: from pwj10 (pwj10.prod.google.com [10.241.219.74])
	by kpbe13.cbf.corp.google.com with ESMTP id p1F17V02028596
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 14 Feb 2011 17:07:32 -0800
Received: by pwj10 with SMTP id 10so1149913pwj.30
        for <linux-ext4@vger.kernel.org>; Mon, 14 Feb 2011 17:07:31 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds support for detecting the new 'quota' feature in ext4.
The patch reserves code points for usr and group quota inodes and also
for the feature flag EXT4_FEATURE_RO_COMPAT_QUOTA.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 debugfs/set_fields.c        |    2 ++
 lib/blkid/probe.h           |    1 +
 lib/e2p/feature.c           |    2 ++
 lib/e2p/ls.c                |    4 ++++
 lib/ext2fs/ext2_fs.h        |    8 +++++++-
 lib/ext2fs/tst_super_size.c |    2 ++
 6 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 1f4c501..a54f3e1 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -141,6 +141,8 @@ static struct field_set_info super_fields[] = {
 	  parse_uint },
 	{ "snapshot_list", &set_sb.s_snapshot_list, 4, parse_uint },
 	{ "mount_opts",  &set_sb.s_mount_opts, 64, parse_string },
+	{ "usr_quota_inum", &set_sb.s_usr_quota_inum, 4, parse_uint },
+	{ "grp_quota_inum", &set_sb.s_grp_quota_inum, 4, parse_uint },
 	{ 0, 0, 0, 0 }
 };

diff --git a/lib/blkid/probe.h b/lib/blkid/probe.h
index 37fc9c0..37e80ef 100644
--- a/lib/blkid/probe.h
+++ b/lib/blkid/probe.h
@@ -109,6 +109,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
 #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
+#define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100

 /* for s_feature_incompat */
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index c7f8a35..9324199 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -55,6 +55,8 @@ static struct feature feature_list[] = {
 			"dir_nlink" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE,
 			"extra_isize" },
+	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_QUOTA,
+			"quota" },

 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_COMPRESSION,
 			"compression" },
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index d76902b..235832f 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -394,6 +394,10 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 		fprintf(f, "Last error block #:       %llu\n",
 			sb->s_last_error_block);
 	}
+	fprintf(f, "User quota inode:         %u\n",
+			sb->s_usr_quota_inum);
+	fprintf(f, "Group quota inode:        %u\n",
+			sb->s_grp_quota_inum);
 }

 void list_super (struct ext2_super_block * s)
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index fee3919..74f5a2f 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -52,6 +52,9 @@
 #define EXT2_JOURNAL_INO	 8	/* Journal inode */
 #define EXT2_EXCLUDE_INO	 9	/* The "exclude" inode, for snapshots */

+#define EXT4_USR_QUOTA_INO	 3	/* User quota inode */
+#define EXT4_GRP_QUOTA_INO	 4	/* Group quota inode */
+
 /* First non-reserved inode for old ext2 filesystems */
 #define EXT2_GOOD_OLD_FIRST_INO	11

@@ -617,7 +620,9 @@ struct ext2_super_block {
 	__u8	s_last_error_func[32];	/* function where the error happened */
 #define EXT4_S_ERR_END ext4_offsetof(struct ext2_super_block, s_mount_opts)
 	__u8	s_mount_opts[64];
-	__u32   s_reserved[112];        /* Padding to the end of the block */
+	__u32	s_usr_quota_inum;
+	__u32	s_grp_quota_inum;
+	__u32   s_reserved[110];        /* Padding to the end of the block */
 };

 #define EXT4_S_ERR_LEN (EXT4_S_ERR_END - EXT4_S_ERR_START)
@@ -675,6 +680,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
 #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT	0x0080
+#define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100

 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
index eb9114f..a3a5b44 100644
--- a/lib/ext2fs/tst_super_size.c
+++ b/lib/ext2fs/tst_super_size.c
@@ -123,6 +123,8 @@ void check_superblock_fields()
 	check_field(s_last_error_block);
 	check_field(s_last_error_func);
 	check_field(s_mount_opts);
+	check_field(s_usr_quota_inum);
+	check_field(s_grp_quota_inum);
 	check_field(s_reserved);
 	printf("Ending offset is %d\n\n", cur_offset);
 #endif
-- 
1.7.3.1
