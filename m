From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/3] e2fsprogs: Support for large inode migration.
Date: Wed, 25 Jul 2007 11:06:28 +0530
Message-ID: <11853418612030-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11853417881304-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11853417952078-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11853418382585-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: tytso@mit.edu, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:49855 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbXGYFil (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Jul 2007 01:38:41 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l6P621G1343480
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jul 2007 16:02:01 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6P5g7Wb162794
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jul 2007 15:42:07 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6P5cYCS016981
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jul 2007 15:38:34 +1000
In-Reply-To: <11853418382585-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <3ae4c55b831a13f9fbb9a187efcd65d29434bf09.1185341470.git.aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <bee58d48110eee4d5cd133167245b99644148d96.1185341470.git.aneesh.kumar@linux.vnet.ibm.com>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185341470.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Add new option -I <inode_size> to tune2fs.
This is used to change the inode size. The size
need to be multiple of 2 and we don't allow to
decrease the inode size.

As a part of increasing the inode size we throw
away the free inodes in the last block group. If
we can't we fail. In such case one can resize the
file system and then try to increase the inode size.


tune2fs use undo I/O manager when migrating to large
inode. This helps in reverting the changes if end results
are not correct.The environment variable TUNE2FS_SCRATCH_DIR
is used to indicate the  directory within which the tdb
file need to be created. The file will be named tune2fs-XXXXXX

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 misc/tune2fs.c |  269 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 266 insertions(+), 3 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 833b994..d8f12a6 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -61,6 +61,7 @@ char * new_label, *new_last_mounted, *new_UUID;
 char * io_options;
 static int c_flag, C_flag, e_flag, f_flag, g_flag, i_flag, l_flag, L_flag;
 static int m_flag, M_flag, r_flag, s_flag = -1, u_flag, U_flag, T_flag;
+static int I_flag;
 static time_t last_check_time;
 static int print_label;
 static int max_mount_count, mount_count, mount_flags;
@@ -71,6 +72,7 @@ static unsigned short errors;
 static int open_flag;
 static char *features_cmd;
 static char *mntopts_cmd;
+static unsigned long int new_inode_size;
 
 int journal_size, journal_flags;
 char *journal_device;
@@ -89,7 +91,8 @@ static void usage(void)
 		  "\t[-o [^]mount_options[,...]] [-r reserved_blocks_count]\n"
 		  "\t[-u user] [-C mount_count] [-L volume_label] "
 		  "[-M last_mounted_dir]\n"
-		  "\t[-O [^]feature[,...]] [-T last_check_time] [-U UUID]"
+		  "\t[-O [^]feature[,...]] [-T last_check_time] [-U UUID]\n"
+		  "\t[ -I new_inode_size ]"
 		  " device\n"), program_name);
 	exit (1);
 }
@@ -505,7 +508,7 @@ static void parse_tune2fs_options(int argc, char **argv)
 	struct passwd * pw;
 
 	printf("tune2fs %s (%s)\n", E2FSPROGS_VERSION, E2FSPROGS_DATE);
-	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:r:s:u:C:J:L:M:O:T:U:")) != EOF)
+	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:r:s:u:C:J:L:M:O:T:U:I:")) != EOF)
 		switch (c)
 		{
 			case 'c':
@@ -702,6 +705,23 @@ static void parse_tune2fs_options(int argc, char **argv)
 				open_flag = EXT2_FLAG_RW |
 					EXT2_FLAG_JOURNAL_DEV_OK;
 				break;
+			case 'I':
+				new_inode_size = strtoul (optarg, &tmp, 0);
+				if (*tmp) {
+					com_err (program_name, 0,
+							_("bad Inode size - %s"),
+							optarg);
+					usage();
+				}
+				if (!((new_inode_size & (new_inode_size - 1)) == 0)) {
+					com_err (program_name, 0,
+							_("bad Inode size - %s"),
+							optarg);
+					usage();
+				}
+				open_flag = EXT2_FLAG_RW;
+				I_flag = 1;
+				break;
 			default:
 				usage();
 		}
@@ -739,6 +759,215 @@ void do_findfs(int argc, char **argv)
 	exit(0);
 }
 
+static void *ext2fs_read_next_inode(ext2_filsys fs,
+				void *inode, void *inode_table,
+				int *retval)
+{
+	int blk;
+	static int group = 0, offset = -1;
+	int max_group = fs->super->s_inodes_count/fs->super->s_inodes_per_group;
+	int itable_size = fs->blocksize * fs->inode_blocks_per_group;
+
+	*retval = 0;
+
+	if (offset != -1 && offset < itable_size)
+		goto found;
+
+
+	if (group >= max_group)
+		return NULL;
+
+	blk = fs->group_desc[group].bg_inode_table;
+	*retval = io_channel_read_blk(fs->io, blk,
+			fs->inode_blocks_per_group, inode_table);
+	if (*retval)
+		return NULL;
+	group++;
+	offset = 0;
+
+found:
+	memcpy(inode, inode_table + offset, EXT2_INODE_SIZE(fs->super));
+	offset +=  EXT2_INODE_SIZE(fs->super);
+	return inode;
+
+}
+
+static int ext2fs_write_itb(ext2_filsys fs, int group,
+				void *inode_table_block, int free_inodes_count)
+{
+	int retval;
+	int blk = fs->group_desc[group].bg_inode_table;
+	retval = io_channel_write_blk(fs->io, blk,
+				fs->inode_blocks_per_group, inode_table_block);
+	if (retval)
+		return retval;
+
+	fs->group_desc[group].bg_free_inodes_count = free_inodes_count;
+
+	return 0;
+}
+
+static int resize_inode(ext2_filsys fs, unsigned long int new_inode_size)
+{
+	ext2_ino_t inode_num;
+	int itable_size, retval;
+	int new_inode_per_group, new_max_inode;
+	int copied_inode_count = 0;
+	void *inode, *buf, *tmp_buf, *inode_table;
+	int free_inodes_count = 0, group_count = 0;
+	int old_size = EXT2_INODE_SIZE(fs->super);
+	int max_group = fs->super->s_inodes_count/fs->super->s_inodes_per_group;
+
+	if (new_inode_size <= fs->super->s_inode_size ) {
+		fprintf(stderr, _("New Inode size too small\n"));
+		return EXT2_ET_INVALID_ARGUMENT;
+	}
+
+	new_inode_per_group = ((fs->inode_blocks_per_group) *
+						fs->blocksize)/new_inode_size;
+
+	new_max_inode = new_inode_per_group * max_group;
+
+	/*
+	 * Test whether we can resize the inode
+	 */
+	ext2fs_read_inode_bitmap(fs);
+	for (inode_num = new_max_inode+1;
+			inode_num <= fs->super->s_inodes_count; inode_num++) {
+
+		if (ext2fs_test_inode_bitmap(fs->inode_map, inode_num)) {
+			fprintf(stderr, _("Failed for inode %d\n"), inode_num);
+
+			return EXT2_ET_TOOSMALL;
+		}
+	}
+	retval = ext2fs_get_mem(fs->blocksize * fs->inode_blocks_per_group,
+								&inode_table);
+	if (retval) {
+		com_err(__FUNCTION__, retval, "Failed to allocate mem\n");
+		return retval;
+	}
+
+	retval = ext2fs_get_mem(old_size, &inode); 
+	if (retval) {
+		com_err(__FUNCTION__, retval, "Failed to allocate mem\n");
+		return retval;
+	}
+
+	/* New inode table block */
+	itable_size = fs->blocksize * fs->inode_blocks_per_group;
+	retval = ext2fs_get_mem(itable_size, &buf);
+	if (retval) {
+		com_err(__FUNCTION__, retval, "Failed to allocate mem\n");
+		return retval;
+	}
+	tmp_buf = buf;
+	inode_num = 0;
+
+	while (ext2fs_read_next_inode(fs, inode, inode_table, &retval)) {
+
+		memcpy(buf, inode, old_size);
+		memset(buf+old_size, 0, new_inode_size - old_size);
+		buf = buf + new_inode_size;
+		copied_inode_count++;
+		inode_num++;
+
+		if (!ext2fs_test_inode_bitmap(fs->inode_map, inode_num)) {
+			free_inodes_count++;
+		}
+
+		if (copied_inode_count < new_inode_per_group) {
+			/*
+			 * we can have only new_inode_per_group
+			 * in this group
+			 */
+			continue;
+		}
+
+		/* Now write the inode table related to the group */
+		retval = ext2fs_write_itb(fs, group_count,
+						tmp_buf, free_inodes_count);
+		if (retval) {
+			com_err(__FUNCTION__, retval,
+					"Failed to write inode table block\n");
+			return retval;
+		}
+		group_count++;
+		if (group_count >= max_group) {
+			/*
+			 * We ignore all the following inodes
+			 */
+			break;
+		}
+
+		buf = tmp_buf;
+		copied_inode_count = 0;
+		free_inodes_count = 0;
+	}
+
+	if (retval) {
+		/*
+		 *ext2fs_read_next_inode returned error
+		 */
+		com_err(__FUNCTION__, retval,
+				"Failed to read inode table block\n");
+		return retval;
+	}
+
+	/* Now update all the meta data fields */
+	fs->super->s_inode_size = new_inode_size;
+	fs->super->s_inodes_per_group = new_inode_per_group;
+	fs->super->s_free_inodes_count -= fs->super->s_inodes_count -
+								new_max_inode;
+	fs->super->s_inodes_count = new_max_inode;
+	/*
+	 * Mark the inode bitmap dirty so that 
+	 * the readjusted inode bitmap get written
+	 * automatically
+	 */
+	ext2fs_mark_ib_dirty(fs);
+	ext2fs_mark_super_dirty(fs);
+
+	return 0;
+}
+static int setup_tdb(void)
+{
+	char *tdb_dir, tdb_file[PATH_MAX];
+#if 0 /* FIXME!! */
+	/*
+	 * Configuration via a conf file would be
+	 * nice
+	 */
+	profile_get_string(profile, "scratch_files",
+					"directory", 0, 0,
+					&tdb_dir);
+#endif
+	tdb_dir = getenv("TUNE2FS_SCRATCH_DIR");
+	if (!tdb_dir) {
+		com_err(__FUNCTION__, 0,
+			_("TUNE2FS_SCRATCH_DIR not configured\n"));
+		return EXT2_ET_INVALID_ARGUMENT;
+	}
+	if (access(tdb_dir, W_OK)) {
+		fprintf(stderr,
+			_("Cannot create file under %s\n"),
+			tdb_dir);
+		return EXT2_ET_INVALID_ARGUMENT;
+
+	}
+
+	sprintf(tdb_file, "%s/tune2fs-XXXXXX", tdb_dir);
+	printf (_("Using tdb file %s\n"), tdb_file);
+
+	if (!access(tdb_file, F_OK)) {
+		fprintf(stderr,
+			_("File exist %s\n"), tdb_file);
+		return EXT2_ET_INVALID_ARGUMENT;
+	}
+
+	set_undo_io_backup_file(tdb_file);
+	return 0;
+}
 
 int main (int argc, char ** argv)
 {
@@ -768,7 +997,19 @@ int main (int argc, char ** argv)
 	io_ptr = test_io_manager;
 	test_io_backing_manager = unix_io_manager;
 #else
-	io_ptr = unix_io_manager;
+	if (new_inode_size) {
+		/*
+		 * If inode resize is requested use the
+		 * Undo I/O manager
+		 */
+		io_ptr = undo_io_manager;
+		set_undo_io_backing_manager(unix_io_manager);
+		retval = setup_tdb();
+		if (retval)
+			exit(1);
+	} else {
+		io_ptr = unix_io_manager;
+	}
 #endif
 	retval = ext2fs_open2(device_name, io_options, open_flag, 
 			      0, 0, io_ptr, &fs);
@@ -919,6 +1160,28 @@ int main (int argc, char ** argv)
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
