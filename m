From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 4/4] e2fsprogs: Support for large inode migration.
Date: Wed,  1 Aug 2007 21:04:11 +0530
Message-ID: <1185982550333-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11859824513552-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11859824581652-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11859825032637-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11859825351217-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:45257 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbXHAPgm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2007 11:36:42 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.18.232])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l71FdSgx269700
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 01:39:28 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.250.243])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l71FZqhS254798
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 01:35:52 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l71FadFV016103
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 01:36:39 +1000
In-Reply-To: <11859825351217-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <5fa196da3ae691bc49533fc43d09ff1e272f6563.1185981319.git.aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <f2c3823cb66c7a30436b1f2163cbe3bba791a115.1185981319.git.aneesh.kumar@linux.vnet.ibm.com>
References: <f2c3823cb66c7a30436b1f2163cbe3bba791a115.1185981319.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Add new option -I <inode_size> to tune2fs.
This is used to change the inode size. The size
need to be multiple of 2 and we don't allow to
decrease the inode size.

As a part of increasing the inode size we increase the
inode table size. We also move the used data blocks around
and update the respective inodes to point to the new block


tune2fs use undo I/O manager when migrating to large
inode. This helps in reverting the changes if end results
are not correct.The environment variable TUNE2FS_SCRATCH_DIR
is used to indicate the  directory within which the tdb
file need to be created. The file will be named tune2fs-XXXXXX
If TUNE2FS_SCRATCH_DIR is not set /var/lib/e2fsprogs is used

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 misc/tune2fs.c |  535 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 532 insertions(+), 3 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 833b994..88842a2 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -42,6 +42,7 @@ extern int optind;
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>
+#include <libgen.h>
 
 #include "ext2fs/ext2_fs.h"
 #include "ext2fs/ext2fs.h"
@@ -61,6 +62,7 @@ char * new_label, *new_last_mounted, *new_UUID;
 char * io_options;
 static int c_flag, C_flag, e_flag, f_flag, g_flag, i_flag, l_flag, L_flag;
 static int m_flag, M_flag, r_flag, s_flag = -1, u_flag, U_flag, T_flag;
+static int I_flag;
 static time_t last_check_time;
 static int print_label;
 static int max_mount_count, mount_count, mount_flags;
@@ -71,10 +73,20 @@ static unsigned short errors;
 static int open_flag;
 static char *features_cmd;
 static char *mntopts_cmd;
+static unsigned long int new_inode_size;
 
 int journal_size, journal_flags;
 char *journal_device;
 
+static struct list_head blk_move_list;
+
+struct blk_move {
+	struct list_head list;
+	blk_t old_loc;
+	blk_t new_loc;
+};
+
+
 static const char *please_fsck = N_("Please run e2fsck on the filesystem.\n");
 
 void do_findfs(int argc, char **argv);
@@ -89,7 +101,8 @@ static void usage(void)
 		  "\t[-o [^]mount_options[,...]] [-r reserved_blocks_count]\n"
 		  "\t[-u user] [-C mount_count] [-L volume_label] "
 		  "[-M last_mounted_dir]\n"
-		  "\t[-O [^]feature[,...]] [-T last_check_time] [-U UUID]"
+		  "\t[-O [^]feature[,...]] [-T last_check_time] [-U UUID]\n"
+		  "\t[ -I new_inode_size ]"
 		  " device\n"), program_name);
 	exit (1);
 }
@@ -505,7 +518,7 @@ static void parse_tune2fs_options(int argc, char **argv)
 	struct passwd * pw;
 
 	printf("tune2fs %s (%s)\n", E2FSPROGS_VERSION, E2FSPROGS_DATE);
-	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:r:s:u:C:J:L:M:O:T:U:")) != EOF)
+	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:r:s:u:C:J:L:M:O:T:U:I:")) != EOF)
 		switch (c)
 		{
 			case 'c':
@@ -702,6 +715,25 @@ static void parse_tune2fs_options(int argc, char **argv)
 				open_flag = EXT2_FLAG_RW |
 					EXT2_FLAG_JOURNAL_DEV_OK;
 				break;
+			case 'I':
+				new_inode_size = strtoul (optarg, &tmp, 0);
+				if (*tmp) {
+					com_err (program_name, 0,
+						_("bad Inode size - %s"),
+							optarg);
+					usage();
+				}
+				if (!((new_inode_size &
+						(new_inode_size - 1)) == 0)) {
+					com_err (program_name, 0,
+						_("Inode size must be a "
+						"power of two- %s"),
+							optarg);
+					usage();
+				}
+				open_flag = EXT2_FLAG_RW;
+				I_flag = 1;
+				break;
 			default:
 				usage();
 		}
@@ -739,6 +771,469 @@ void do_findfs(int argc, char **argv)
 	exit(0);
 }
 
+static int get_move_bitmap(ext2_filsys fs, int new_ino_blks_per_grp,
+					ext2fs_block_bitmap bmap)
+{
+	dgrp_t i;
+	blk_t j, needed_blocks = 0;
+	blk_t start_blk, end_blk;
+
+	for (i = 0; i < fs->group_desc_count; i++) {
+
+		start_blk = fs->group_desc[i].bg_inode_table +
+					fs->inode_blocks_per_group;
+
+		end_blk = fs->group_desc[i].bg_inode_table +
+					new_ino_blks_per_grp;
+
+		for (j = start_blk; j < end_blk; j++) {
+
+			if (ext2fs_test_block_bitmap(fs->block_map, j)) {
+				/* FIXME!!
+				 * What happens if the block is marked
+				 * as a bad block
+				 */
+				ext2fs_mark_block_bitmap(bmap, j);
+				needed_blocks++;
+			} else {
+				/*
+				 * We are going to use this block for
+				 * inode table. So mark them used.
+				 */
+				ext2fs_mark_block_bitmap(fs->block_map, j);
+			}
+		}
+	}
+
+	if (needed_blocks > fs->super->s_free_blocks_count ) {
+		return ENOSPC;
+	}
+
+	return 0;
+}
+
+static int move_block(ext2_filsys fs, ext2fs_block_bitmap bmap)
+{
+	char *buf;
+	errcode_t retval;
+	blk_t blk, new_blk;
+	struct blk_move *bmv;
+
+
+	retval = ext2fs_get_mem(fs->blocksize, &buf);
+	if (retval)
+		return retval;
+
+	for (blk = fs->super->s_first_data_block;
+			blk < fs->super->s_blocks_count; blk++) {
+
+		if (!ext2fs_test_block_bitmap(bmap, blk))
+			continue;
+
+		retval = ext2fs_new_block(fs, blk, NULL, &new_blk);
+		if (retval)
+			goto err_out;
+
+		/* Mark this block as allocated */
+		ext2fs_mark_block_bitmap(fs->block_map, new_blk);
+
+		/* Add it to block move list */
+		retval = ext2fs_get_mem(sizeof(struct blk_move), &bmv);
+		if (retval)
+			goto err_out;
+
+		bmv->old_loc = blk;
+		bmv->new_loc = new_blk;
+
+		list_add(&(bmv->list), &blk_move_list);
+
+		retval = io_channel_read_blk(fs->io, blk, 1, buf);
+		if (retval)
+			goto err_out;
+
+		retval = io_channel_write_blk(fs->io, new_blk, 1, buf);
+		if (retval)
+			goto err_out;
+	}
+
+err_out:
+	ext2fs_free_mem(&buf);
+	return retval;
+}
+static blk_t transalate_block(blk_t blk)
+{
+	struct list_head *entry;
+	struct blk_move *bmv;
+
+	list_for_each(entry, &blk_move_list) {
+
+		bmv = list_entry(entry, struct blk_move, list);
+		if (bmv->old_loc == blk)
+			return bmv->new_loc;
+	}
+
+	return 0;
+}
+
+static int process_block(ext2_filsys fs, blk_t	*block_nr,
+			 e2_blkcnt_t blockcnt,
+			 blk_t ref_block EXT2FS_ATTR((unused)),
+			 int ref_offset EXT2FS_ATTR((unused)),
+			 void *priv_data EXT2FS_ATTR((unused)))
+{
+	int ret = 0;
+	blk_t new_blk;
+
+
+	new_blk = transalate_block(*block_nr);
+	if (new_blk) {
+		*block_nr = new_blk;
+		/*
+		 * This will force the ext2fs_write_inode in the iterator
+		 */
+		ret |= BLOCK_CHANGED;
+	}
+
+	return ret;
+}
+
+static int inode_scan_and_fix(ext2_filsys fs)
+{
+	errcode_t retval = 0;
+	ext2_ino_t ino;
+	blk_t blk;
+	char *block_buf = 0;
+	struct ext2_inode inode;
+	ext2_inode_scan	scan = NULL;
+
+	retval = ext2fs_get_mem(fs->blocksize * 3, &block_buf);
+	if (retval)
+		return retval;
+
+	retval = ext2fs_open_inode_scan(fs, 0, &scan);
+	if (retval)
+		goto err_out;
+
+	while (1) {
+
+		retval = ext2fs_get_next_inode(scan, &ino, &inode);
+		if (retval)
+			goto err_out;
+
+		if (!ino)
+			break;
+
+		if (inode.i_links_count == 0)
+			continue; /* inode not in use */
+
+		/* FIXME!!
+		 * If we end up modifying the journal inode
+		 * the sb->s_jnl_blocks will differ. But a
+		 * subsequent e2fsck fixes that.
+		 * Do we need to fix this ??
+		 */
+
+		if (inode.i_file_acl) {
+
+			blk = transalate_block(inode.i_file_acl);
+			if (!blk)
+				continue;
+
+			inode.i_file_acl = blk;
+
+			/*
+			 * Write the inode to disk so that inode table
+			 * resizing can work
+			 */
+			retval = ext2fs_write_inode(fs, ino, &inode);
+			if (retval)
+				goto err_out;
+		}
+
+		if (!ext2fs_inode_has_valid_blocks(&inode))
+			continue;
+
+		retval = ext2fs_block_iterate2(fs, ino, 0,
+						block_buf, process_block,
+						0);
+		if (retval)
+			goto err_out;
+
+	}
+
+err_out:
+	ext2fs_free_mem(&block_buf);
+
+	return retval;
+
+}
+
+
+static int expand_inode_table(ext2_filsys fs, unsigned long int new_inode_size)
+{
+	dgrp_t i;
+	blk_t blk;
+	errcode_t retval;
+	int new_ino_blks_per_grp, j;
+	char *old_itable = NULL, *new_itable = NULL;
+	char *tmp_old_itable = NULL, *tmp_new_itable = NULL;
+	unsigned long int old_inode_size;
+	int old_itable_size, new_itable_size;
+
+	old_itable_size = fs->inode_blocks_per_group * fs->blocksize;
+	old_inode_size = EXT2_INODE_SIZE(fs->super);
+
+	new_ino_blks_per_grp = ext2fs_div_ceil(
+					EXT2_INODES_PER_GROUP(fs->super) *
+					new_inode_size,
+					fs->blocksize);
+
+	new_itable_size = new_ino_blks_per_grp * fs->blocksize;
+
+	retval = ext2fs_get_mem(old_itable_size, &old_itable);
+	if (retval)
+		return retval;
+
+	retval = ext2fs_get_mem(new_itable_size, &new_itable);
+	if (retval)
+		goto err_out;
+
+	tmp_old_itable = old_itable;
+	tmp_new_itable = new_itable;
+
+	for (i = 0; i < fs->group_desc_count; i++) {
+
+		blk = fs->group_desc[i].bg_inode_table;
+		retval = io_channel_read_blk(fs->io, blk,
+				fs->inode_blocks_per_group, old_itable);
+		if (retval)
+			goto err_out;
+
+		for (j = 0; j < EXT2_INODES_PER_GROUP(fs->super); j++) {
+
+			memcpy(new_itable, old_itable, old_inode_size);
+
+			memset(new_itable+old_inode_size, 0,
+					new_inode_size - old_inode_size);
+
+			new_itable +=  new_inode_size;
+			old_itable += old_inode_size;
+		}
+
+		/* reset the pointer */
+		old_itable = tmp_old_itable;
+		new_itable = tmp_new_itable;
+
+		retval = io_channel_write_blk(fs->io, blk,
+					new_ino_blks_per_grp, new_itable);
+		if (retval)
+			goto err_out;
+	}
+
+	/* Update the meta data */
+	fs->inode_blocks_per_group = new_ino_blks_per_grp;
+	fs->super->s_inode_size = new_inode_size;
+
+err_out:
+	if (old_itable)
+		ext2fs_free_mem(&old_itable);
+
+	if (new_itable)
+		ext2fs_free_mem(&new_itable);
+
+	return retval;
+
+}
+
+static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
+{
+	blk_t		blk;
+	ext2_ino_t	ino;
+	unsigned int	group = 0;
+	unsigned int	count = 0;
+	int		total_free = 0;
+	int		group_free = 0;
+
+	/*
+	 * First calculate the block statistics
+	 */
+	for (blk = fs->super->s_first_data_block;
+	     blk < fs->super->s_blocks_count; blk++) {
+		if (!ext2fs_fast_test_block_bitmap(fs->block_map, blk)) {
+			group_free++;
+			total_free++;
+		}
+		count++;
+		if ((count == fs->super->s_blocks_per_group) ||
+		    (blk == fs->super->s_blocks_count-1)) {
+			fs->group_desc[group++].bg_free_blocks_count =
+				group_free;
+			count = 0;
+			group_free = 0;
+		}
+	}
+	fs->super->s_free_blocks_count = total_free;
+	
+	/*
+	 * Next, calculate the inode statistics
+	 */
+	group_free = 0;
+	total_free = 0;
+	count = 0;
+	group = 0;
+
+	/* Protect loop from wrap-around if s_inodes_count maxed */
+	for (ino = 1; ino <= fs->super->s_inodes_count && ino > 0; ino++) {
+		if (!ext2fs_fast_test_inode_bitmap(fs->inode_map, ino)) {
+			group_free++;
+			total_free++;
+		}
+		count++;
+		if ((count == fs->super->s_inodes_per_group) ||
+		    (ino == fs->super->s_inodes_count)) {
+			fs->group_desc[group++].bg_free_inodes_count =
+				group_free;
+			count = 0;
+			group_free = 0;
+		}
+	}
+	fs->super->s_free_inodes_count = total_free;
+	ext2fs_mark_super_dirty(fs);
+	return 0;
+}
+
+#define list_for_each_safe(pos, pnext, head) \
+	for (pos = (head)->next, pnext = pos->next; pos != (head); \
+	     pos = pnext, pnext = pos->next)
+
+static void free_blk_move_list()
+{
+	struct list_head *entry, *tmp;
+	struct blk_move *bmv;
+
+	list_for_each_safe(entry, tmp, &blk_move_list) {
+
+		bmv = list_entry(entry, struct blk_move, list);
+		list_del(entry);
+		ext2fs_free_mem(&bmv);
+	}
+
+	return ;
+}
+static int resize_inode(ext2_filsys fs, unsigned long int new_inode_size)
+{
+	errcode_t retval;
+	int new_ino_blks_per_grp;
+	ext2fs_block_bitmap bmap;
+
+	if (new_inode_size <= EXT2_INODE_SIZE(fs->super)) {
+		fprintf(stderr, _("New Inode size too small\n"));
+		return EXT2_ET_INVALID_ARGUMENT;
+	}
+
+	ext2fs_read_inode_bitmap(fs);
+	ext2fs_read_block_bitmap(fs);
+	INIT_LIST_HEAD(&blk_move_list);
+
+
+	new_ino_blks_per_grp = ext2fs_div_ceil(
+					EXT2_INODES_PER_GROUP(fs->super)*
+					new_inode_size,
+					fs->blocksize);
+
+	/* We may change the file system.
+	 * Mark the file system as invalid so that
+	 * the user is prompted to run fsck.
+	 */
+	fs->super->s_state &= ~EXT2_VALID_FS;
+
+	retval = ext2fs_allocate_block_bitmap(fs, _("blocks to be moved"),
+						&bmap);
+	if (retval)
+		return retval;
+
+	retval = get_move_bitmap(fs, new_ino_blks_per_grp, bmap);
+	if (retval)
+		goto err_out;
+
+	retval = move_block(fs, bmap);
+	if (retval)
+		goto err_out;
+
+	retval = inode_scan_and_fix(fs);
+	if (retval)
+		goto err_out;
+
+	retval = expand_inode_table(fs, new_inode_size);
+	if (retval)
+		goto err_out;
+
+	ext2fs_calculate_summary_stats(fs);
+
+	fs->super->s_state |= EXT2_VALID_FS;
+	/* mark super block and block bitmap as dirty */
+	ext2fs_mark_super_dirty(fs);
+	ext2fs_mark_bb_dirty(fs);
+
+err_out:
+	free_blk_move_list();
+	ext2fs_free_block_bitmap(bmap);
+
+	return retval;
+}
+
+static int tune2fs_setup_tdb(const char *name)
+{
+	errcode_t retval = 0;
+	char *tdb_dir, tdb_file[PATH_MAX];
+	char *device_name, *tmp_name;
+
+#if 0 /* FIXME!! */
+	/*
+	 * Configuration via a conf file would be
+	 * nice
+	 */
+	profile_get_string(profile, "scratch_files",
+					"directory", 0, 0,
+					&tdb_dir);
+#endif
+	tmp_name = strdup(name);
+	device_name = basename(tmp_name);
+
+	tdb_dir = getenv("TUNE2FS_SCRATCH_DIR");
+	if (!tdb_dir) {
+		com_err(__FUNCTION__, 0,
+			_("TUNE2FS_SCRATCH_DIR not configured\n"));
+		printf(_("Using /var/lib/e2fsprogs\n"));
+		tdb_dir="/var/lib/e2fsprogs";
+
+	}
+	if (access(tdb_dir, W_OK)) {
+		fprintf(stderr,
+			_("Cannot create file under %s\n"),
+			tdb_dir);
+		retval = EXT2_ET_INVALID_ARGUMENT;
+		goto err_out;
+
+	}
+
+	sprintf(tdb_file, "%s/tune2fs-%s", tdb_dir, device_name);
+
+	if (!access(tdb_file, F_OK)) {
+		fprintf(stderr,
+			_("File exist %s\n"), tdb_file);
+		retval = EXT2_ET_INVALID_ARGUMENT;
+		goto err_out;
+	}
+
+	set_undo_io_backup_file(tdb_file);
+	printf(_("To undo the tune2fs operations please run "
+		 "the command\nundoe2fs %s  %s\n\n"),
+		 tdb_file, name);
+err_out:
+	free(tmp_name);
+	return retval;
+}
 
 int main (int argc, char ** argv)
 {
@@ -768,7 +1263,19 @@ int main (int argc, char ** argv)
 	io_ptr = test_io_manager;
 	test_io_backing_manager = unix_io_manager;
 #else
-	io_ptr = unix_io_manager;
+	if (I_flag) {
+		/*
+		 * If inode resize is requested use the
+		 * Undo I/O manager
+		 */
+		io_ptr = undo_io_manager;
+		set_undo_io_backing_manager(unix_io_manager);
+		retval = tune2fs_setup_tdb(device_name);
+		if (retval)
+			exit(1);
+	} else {
+		io_ptr = unix_io_manager;
+	}
 #endif
 	retval = ext2fs_open2(device_name, io_options, open_flag, 
 			      0, 0, io_ptr, &fs);
@@ -919,6 +1426,28 @@ int main (int argc, char ** argv)
 		}
 		ext2fs_mark_super_dirty(fs);
 	}
+	if (I_flag) {
+		if (mount_flags & EXT2_MF_MOUNTED) {
+			fputs(_("The Inode size may only be "
+				"changed when the filesystem is "
+				"unmounted.\n"), stderr);
+			exit(1);
+		}
+		/*
+		 * We want to update group descriptor also
+		 * with the new free inode count
+		 */
+		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+		if (resize_inode(fs, new_inode_size)) {
+
+			fputs(_("Error in resizing the Inode.\n"
+				"Run undoe2fs to undo the "
+				"file system changes. \n"), stderr);
+		} else {
+			printf (_("Setting Inode size  %d\n"),
+							new_inode_size);
+		}
+	}
 
 	if (l_flag)
 		list_super (sb);
-- 
1.5.3.rc2.22.g69a9b-dirty
