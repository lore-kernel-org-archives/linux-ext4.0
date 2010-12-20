From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH] e4defrag: Call ext2fs_open() to get the correct superblock
 information
Date: Mon, 20 Dec 2010 17:01:24 +0900
Message-ID: <4D0F0D54.7080602@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:55336 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab0LTIDd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Dec 2010 03:03:33 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Currently, e4defrag always does byte-swapping when it gets superblock
information, so the calculation of the best extents count is not correct
on little endian machine. This doesn't cause data corruption, but it may
confuse users by showing the wrong extent count.
To solve this problem, we use ext2fs_open() instead of get_superblock_info()
that is the original function.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.c |  185 +++++---------------------------------------------------
 1 file changed, 18 insertions(+), 167 deletions(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 83625fc..b314edb 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -163,101 +163,6 @@ struct frag_statistic_ino {
 	char msg_buffer[PATH_MAX + 1];	/* pathname of the file */
 };
 
-typedef __u16 __le16;
-typedef __u32 __le32;
-typedef __u64 __le64;
-
-/*
- * Structure of the super block
- */
-struct ext4_super_block {
-/*00*/	__le32	s_inodes_count;		/* Inodes count */
-	__le32	s_blocks_count_lo;	/* Blocks count */
-	__le32	s_r_blocks_count_lo;	/* Reserved blocks count */
-	__le32	s_free_blocks_count_lo;	/* Free blocks count */
-/*10*/	__le32	s_free_inodes_count;	/* Free inodes count */
-	__le32	s_first_data_block;	/* First Data Block */
-	__le32	s_log_block_size;	/* Block size */
-	__le32	s_obso_log_frag_size;	/* Obsoleted fragment size */
-/*20*/	__le32	s_blocks_per_group;	/* # Blocks per group */
-	__le32	s_obso_frags_per_group;	/* Obsoleted fragments per group */
-	__le32	s_inodes_per_group;	/* # Inodes per group */
-	__le32	s_mtime;		/* Mount time */
-/*30*/	__le32	s_wtime;		/* Write time */
-	__le16	s_mnt_count;		/* Mount count */
-	__le16	s_max_mnt_count;	/* Maximal mount count */
-	__le16	s_magic;		/* Magic signature */
-	__le16	s_state;		/* File system state */
-	__le16	s_errors;		/* Behaviour when detecting errors */
-	__le16	s_minor_rev_level;	/* minor revision level */
-/*40*/	__le32	s_lastcheck;		/* time of last check */
-	__le32	s_checkinterval;	/* max. time between checks */
-	__le32	s_creator_os;		/* OS */
-	__le32	s_rev_level;		/* Revision level */
-/*50*/	__le16	s_def_resuid;		/* Default uid for reserved blocks */
-	__le16	s_def_resgid;		/* Default gid for reserved blocks */
-	/*
-	 * These fields are for EXT4_DYNAMIC_REV superblocks only.
-	 *
-	 * Note: the difference between the compatible feature set and
-	 * the incompatible feature set is that if there is a bit set
-	 * in the incompatible feature set that the kernel doesn't
-	 * know about, it should refuse to mount the filesystem.
-	 *
-	 * e2fsck's requirements are more strict; if it doesn't know
-	 * about a feature in either the compatible or incompatible
-	 * feature set, it must abort and not try to meddle with
-	 * things it doesn't understand...
-	 */
-	__le32	s_first_ino;		/* First non-reserved inode */
-	__le16  s_inode_size;		/* size of inode structure */
-	__le16	s_block_group_nr;	/* block group # of this superblock */
-	__le32	s_feature_compat;	/* compatible feature set */
-/*60*/	__le32	s_feature_incompat;	/* incompatible feature set */
-	__le32	s_feature_ro_compat;	/* readonly-compatible feature set */
-/*68*/	__u8	s_uuid[16];		/* 128-bit uuid for volume */
-/*78*/	char	s_volume_name[16];	/* volume name */
-/*88*/	char	s_last_mounted[64];	/* directory where last mounted */
-/*C8*/	__le32	s_algorithm_usage_bitmap; /* For compression */
-	/*
-	 * Performance hints.  Directory preallocation should only
-	 * happen if the EXT4_FEATURE_COMPAT_DIR_PREALLOC flag is on.
-	 */
-	__u8	s_prealloc_blocks;	/* Nr of blocks to try to preallocate*/
-	__u8	s_prealloc_dir_blocks;	/* Nr to preallocate for dirs */
-	__le16	s_reserved_gdt_blocks;	/* Per group desc for online growth */
-	/*
-	 * Journaling support valid if EXT4_FEATURE_COMPAT_HAS_JOURNAL set.
-	 */
-/*D0*/	__u8	s_journal_uuid[16];	/* uuid of journal superblock */
-/*E0*/	__le32	s_journal_inum;		/* inode number of journal file */
-	__le32	s_journal_dev;		/* device number of journal file */
-	__le32	s_last_orphan;		/* start of list of inodes to delete */
-	__le32	s_hash_seed[4];		/* HTREE hash seed */
-	__u8	s_def_hash_version;	/* Default hash version to use */
-	__u8	s_reserved_char_pad;
-	__le16  s_desc_size;		/* size of group descriptor */
-/*100*/	__le32	s_default_mount_opts;
-	__le32	s_first_meta_bg;	/* First metablock block group */
-	__le32	s_mkfs_time;		/* When the filesystem was created */
-	__le32	s_jnl_blocks[17];	/* Backup of the journal inode */
-	/* 64bit support valid if EXT4_FEATURE_COMPAT_64BIT */
-/*150*/	__le32	s_blocks_count_hi;	/* Blocks count */
-	__le32	s_r_blocks_count_hi;	/* Reserved blocks count */
-	__le32	s_free_blocks_count_hi;	/* Free blocks count */
-	__le16	s_min_extra_isize;	/* All inodes have at least # bytes */
-	__le16	s_want_extra_isize; 	/* New inodes should reserve # bytes */
-	__le32	s_flags;		/* Miscellaneous flags */
-	__le16  s_raid_stride;		/* RAID stride */
-	__le16  s_mmp_interval;         /* # seconds to wait in MMP checking */
-	__le64  s_mmp_block;            /* Block for multi-mount protection */
-	__le32  s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
-	__u8	s_log_groups_per_flex;  /* FLEX_BG group size */
-	__u8	s_reserved_char_pad2;
-	__le16  s_reserved_pad;
-	__u32   s_reserved[162];        /* Padding to the end of the block */
-};
-
 char	lost_found_dir[PATH_MAX + 1];
 int	block_size;
 int	extents_before_defrag;
@@ -271,8 +176,8 @@ unsigned int	regular_count;
 unsigned int	succeed_cnt;
 unsigned int	total_count;
 __u8 log_groups_per_flex;
-__le32 blocks_per_group;
-__le32 feature_incompat;
+__u32 blocks_per_group;
+__u32 feature_incompat;
 ext4_fsblk_t	files_block_count;
 struct frag_statistic_ino	frag_rank[SHOW_FRAG_FILES];
 
@@ -392,7 +297,7 @@ static int get_mount_point(const char *devname, char *mount_point,
  *
  * @file:		the file's name.
  */
-static int is_ext4(const char *file)
+static int is_ext4(const char *file, char *devname)
 {
 	int 	maxlen = 0;
 	int	len, ret;
@@ -449,6 +354,7 @@ static int is_ext4(const char *file)
 		memset(mnt_type, 0, strlen(mnt->mnt_type) + 1);
 		strncpy(mnt_type, mnt->mnt_type, strlen(mnt->mnt_type));
 		strncpy(lost_found_dir, mnt->mnt_dir, PATH_MAX);
+		strncpy(devname, mnt->mnt_fsname, strlen(mnt->mnt_fsname) + 1);
 	}
 
 	endmntent(fp);
@@ -1128,67 +1034,6 @@ static void free_exts_group(struct fiemap_extent_group *ext_group_head)
 }
 
 /*
- * get_superblock_info() -	Get superblock info by the file name.
- *
- * @file:		the file's name.
- * @sb:		the pointer of the struct ext4_super_block.
- */
-static int get_superblock_info(const char *file, struct ext4_super_block *sb)
-{
-	/* Refer to /etc/mtab */
-	const char	*mtab = MOUNTED;
-	FILE	*fp = NULL;
-
-	int	fd = -1;
-	int	ret;
-	size_t maxlen = 0;
-	size_t len;
-	char	dev_name[PATH_MAX + 1];
-	struct mntent	*mnt = NULL;
-
-	fp = setmntent(mtab, "r");
-	if (fp == NULL)
-		return -1;
-
-	while ((mnt = getmntent(fp)) != NULL) {
-		len = strlen(mnt->mnt_dir);
-		ret = memcmp(file, mnt->mnt_dir, len);
-		if (ret != 0)
-			continue;
-
-		if (len < maxlen)
-			continue;
-
-		maxlen = len;
-
-		memset(dev_name, 0, PATH_MAX + 1);
-		strncpy(dev_name, mnt->mnt_fsname,
-				strnlen(mnt->mnt_fsname, PATH_MAX));
-	}
-
-	fd = open64(dev_name, O_RDONLY);
-	if (fd < 0) {
-		ret = -1;
-		goto out;
-	}
-
-	/* Set offset to read superblock */
-	ret = lseek64(fd, SUPERBLOCK_OFFSET, SEEK_SET);
-	if (ret < 0)
-		goto out;
-
-	ret = read(fd, sb, sizeof(struct ext4_super_block));
-	if (ret < 0)
-		goto out;
-
-out:
-	if (fd != -1)
-		close(fd);
-	endmntent(fp);
-	return ret;
-}
-
-/*
  * get_best_count() -	Get the file best extents count.
  *
  * @block_count:		the file's physical block count.
@@ -1854,13 +1699,14 @@ out:
 int main(int argc, char *argv[])
 {
 	int	opt;
-	int	i, j;
+	int	i, j, ret = 0;
 	int	flags = FTW_PHYS | FTW_MOUNT;
 	int	arg_type = -1;
 	int	success_flag = 0;
 	char	dir_name[PATH_MAX + 1];
+	char	dev_name[PATH_MAX + 1];
 	struct stat64	buf;
-	struct ext4_super_block sb;
+	ext2_filsys fs = NULL;
 
 	/* Parse arguments */
 	if (argc == 1)
@@ -1900,6 +1746,7 @@ int main(int argc, char *argv[])
 		log_groups_per_flex = 0;
 
 		memset(dir_name, 0, PATH_MAX + 1);
+		memset(dev_name, 0, PATH_MAX + 1);
 		memset(lost_found_dir, 0, PATH_MAX + 1);
 		memset(frag_rank, 0,
 			sizeof(struct frag_statistic_ino) * SHOW_FRAG_FILES);
@@ -1921,6 +1768,7 @@ int main(int argc, char *argv[])
 
 		if (S_ISBLK(buf.st_mode)) {
 			/* Block device */
+			strncpy(dev_name, argv[i], strnlen(argv[i], PATH_MAX));
 			if (get_mount_point(argv[i], dir_name, PATH_MAX) < 0)
 				continue;
 			if (lstat64(dir_name, &buf) < 0) {
@@ -1957,7 +1805,7 @@ int main(int argc, char *argv[])
 		 * filesystem type checked in get_mount_point()
 		 */
 		if (arg_type == FILENAME || arg_type == DIRNAME) {
-			if (is_ext4(argv[i]) < 0)
+			if (is_ext4(argv[i], dev_name) < 0)
 				continue;
 			if (realpath(argv[i], dir_name) == NULL) {
 				perror("Couldn't get full path");
@@ -1968,8 +1816,9 @@ int main(int argc, char *argv[])
 
 		if (current_uid == ROOT_UID) {
 			/* Get super block info */
-			memset(&sb, 0, sizeof(struct ext4_super_block));
-			if (get_superblock_info(dir_name, &sb) < 0) {
+			ret = ext2fs_open(dev_name, 0, 0, block_size,
+					unix_io_manager, &fs);
+			if (ret) {
 				if (mode_flag & DETAIL) {
 					perror("Can't get super block info");
 					PRINT_FILE_NAME(argv[i]);
@@ -1977,9 +1826,11 @@ int main(int argc, char *argv[])
 				continue;
 			}
 
-			blocks_per_group = ext2fs_swab32(sb.s_blocks_per_group);
-			feature_incompat = ext2fs_swab32(sb.s_feature_incompat);
-			log_groups_per_flex = sb.s_log_groups_per_flex;
+			blocks_per_group = fs->super->s_blocks_per_group;
+			feature_incompat = fs->super->s_feature_incompat;
+			log_groups_per_flex = fs->super->s_log_groups_per_flex;
+
+			ext2fs_close(fs);
 		}
 
 		switch (arg_type) {
