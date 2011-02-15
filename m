From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH] e2fsprogs: reserving code points for new ext4 quota feature
Date: Tue, 15 Feb 2011 11:54:16 -0800
Message-ID: <AANLkTimsXW82EgB5Fq2Bwc77RYny_DmSPWwgHvQmNKPM@mail.gmail.com>
References: <AANLkTik3Ff7jokEL47uaLphwAP9hcd_16-eb3P8Cvagf@mail.gmail.com>
 <BD2A37BD-B970-4520-A8AB-589249C96755@dilger.ca> <20110215170713.GF4255@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:25915 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1BOTyl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Feb 2011 14:54:41 -0500
Received: from hpaq5.eem.corp.google.com (hpaq5.eem.corp.google.com [172.25.149.5])
	by smtp-out.google.com with ESMTP id p1FJsejA030738
	for <linux-ext4@vger.kernel.org>; Tue, 15 Feb 2011 11:54:40 -0800
Received: from pwj5 (pwj5.prod.google.com [10.241.219.69])
	by hpaq5.eem.corp.google.com with ESMTP id p1FJsbpc026771
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 15 Feb 2011 11:54:38 -0800
Received: by pwj5 with SMTP id 5so205545pwj.15
        for <linux-ext4@vger.kernel.org>; Tue, 15 Feb 2011 11:54:37 -0800 (PST)
In-Reply-To: <20110215170713.GF4255@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for your feedback. I have made the suggested changes.

--
Aditya
--

This patch adds support for detecting the new 'quota' feature in ext4.
The patch reserves code points for usr and group quota inodes and also
for the feature flag EXT4_FEATURE_RO_COMPAT_QUOTA.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 debugfs/set_fields.c        |    2 ++
 e2fsck/message.c            |    4 ++--
 ext2ed/inode_com.c          |    6 ------
 lib/blkid/probe.h           |    1 +
 lib/e2p/feature.c           |    2 ++
 lib/e2p/ls.c                |    4 ++++
 lib/ext2fs/ext2_fs.h        |    9 ++++++---
 lib/ext2fs/swapfs.c         |    2 ++
 lib/ext2fs/tst_super_size.c |    2 ++
 9 files changed, 21 insertions(+), 11 deletions(-)

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

diff --git a/e2fsck/message.c b/e2fsck/message.c
index 8b09ce8..a5f8947 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -151,8 +151,8 @@ static const char *special_inode_name[] =
 	N_("<The NULL inode>"),			/* 0 */
 	N_("<The bad blocks inode>"),		/* 1 */
 	"/",					/* 2 */
-	N_("<The ACL index inode>"),		/* 3 */
-	N_("<The ACL data inode>"),		/* 4 */
+	N_("<The user quota inode>"),		/* 3 */
+	N_("<The group quota inode>"),		/* 4 */
 	N_("<The boot loader inode>"),		/* 5 */
 	N_("<The undelete directory inode>"),	/* 6 */
 	N_("<The group descriptor inode>"),	/* 7 */
diff --git a/ext2ed/inode_com.c b/ext2ed/inode_com.c
index 843286c..cf7083d 100644
--- a/ext2ed/inode_com.c
+++ b/ext2ed/inode_com.c
@@ -222,12 +222,6 @@ void type_ext2_inode___show (char *command_line)
 			case EXT2_ROOT_INO:
 				wprintw (show_win,"Root inode - ");
 				break;
-			case EXT2_ACL_IDX_INO:
-				wprintw (show_win,"ACL index inode - ");
-				break;
-			case EXT2_ACL_DATA_INO:
-				wprintw (show_win,"ACL data inode - ");
-				break;
 			case EXT2_BOOT_LOADER_INO:
 				wprintw (show_win,"Boot loader inode - ");
 				break;
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
index fee3919..65f5591 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -44,8 +44,8 @@
  */
 #define EXT2_BAD_INO		 1	/* Bad blocks inode */
 #define EXT2_ROOT_INO		 2	/* Root inode */
-#define EXT2_ACL_IDX_INO	 3	/* ACL inode */
-#define EXT2_ACL_DATA_INO	 4	/* ACL inode */
+#define EXT4_USR_QUOTA_INO	 3	/* User quota inode */
+#define EXT4_GRP_QUOTA_INO	 4	/* Group quota inode */
 #define EXT2_BOOT_LOADER_INO	 5	/* Boot loader inode */
 #define EXT2_UNDEL_DIR_INO	 6	/* Undelete directory inode */
 #define EXT2_RESIZE_INO		 7	/* Reserved group descriptors inode */
@@ -617,7 +617,9 @@ struct ext2_super_block {
 	__u8	s_last_error_func[32];	/* function where the error happened */
 #define EXT4_S_ERR_END ext4_offsetof(struct ext2_super_block, s_mount_opts)
 	__u8	s_mount_opts[64];
-	__u32   s_reserved[112];        /* Padding to the end of the block */
+	__u32	s_usr_quota_inum;	/* inode number of user quota file */
+	__u32	s_grp_quota_inum;	/* inode number of group quota file */
+	__u32   s_reserved[110];        /* Padding to the end of the block */
 };

 #define EXT4_S_ERR_LEN (EXT4_S_ERR_END - EXT4_S_ERR_START)
@@ -675,6 +677,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
 #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT	0x0080
+#define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100

 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index de7585c..19128a7 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -76,6 +76,8 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 	sb->s_snapshot_r_blocks_count =
 		ext2fs_swab64(sb->s_snapshot_r_blocks_count);
 	sb->s_snapshot_list = ext2fs_swab32(sb->s_snapshot_list);
+	sb->s_usr_quota_inum = ext2fs_swab32(sb->s_usr_quota_inum);
+	sb->s_grp_quota_inum = ext2fs_swab32(sb->s_grp_quota_inum);

 	for (i=0; i < 4; i++)
 		sb->s_hash_seed[i] = ext2fs_swab32(sb->s_hash_seed[i]);
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
