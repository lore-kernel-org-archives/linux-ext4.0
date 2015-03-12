From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC v1 2/4] resize2fs: add option -I for reserving more
 special inodes
Date: Thu, 12 Mar 2015 19:20:13 +0300
Message-ID: <20150312162013.17173.71244.stgit@buzz>
References: <20150312161341.17173.96760.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Li Xi <pkuelelixi@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:46418 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932395AbbCLQUS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2015 12:20:18 -0400
In-Reply-To: <20150312161341.17173.96760.stgit@buzz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Resize2fs relocates last inodes when it shinks filesystem.
This patch reuses this code for relocating first inodes,
it adds option '-I' for changing first normal inode.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 resize/main.c         |   38 ++++++++++++++++++++++++++++++++----
 resize/resize2fs.8.in |    8 ++++++++
 resize/resize2fs.c    |   52 +++++++++++++++++++++++++++++++++++++++++++++++--
 resize/resize2fs.h    |    3 +++
 4 files changed, 95 insertions(+), 6 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index 16f48d438cb0..eae7146f41ab 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -41,8 +41,9 @@ static char *device_name, *io_options;
 
 static void usage (char *prog)
 {
-	fprintf (stderr, _("Usage: %s [-d debug_flags] [-f] [-F] [-M] [-P] "
-			   "[-p] device [-b|-s|new_size]\n\n"), prog);
+	fprintf (stderr, _("Usage: %s [-d debug_flags] [-f] [-F] [-M] [-P]"
+			   "[-p] [-I first_inode] device [-b|-s|new_size]\n\n"),
+			prog);
 
 	exit (1);
 }
@@ -213,7 +214,7 @@ int main (int argc, char ** argv)
 		exit(1);
 	}
 
-	while ((c = getopt(argc, argv, "d:fFhMPpS:bs")) != EOF) {
+	while ((c = getopt(argc, argv, "d:fFhMPpS:bsI:")) != EOF) {
 		switch (c) {
 		case 'h':
 			usage(program_name);
@@ -245,6 +246,10 @@ int main (int argc, char ** argv)
 		case 's':
 			flags |= RESIZE_DISABLE_64BIT;
 			break;
+		case 'I':
+			flags |= RESIZE_SPECIAL_INODES;
+			rfs->first_ino = atoi(optarg);
+			break;
 		default:
 			usage(program_name);
 		}
@@ -430,7 +435,8 @@ int main (int argc, char ** argv)
 			new_size &= ~((sys_page_size / blocksize)-1);
 	}
 	/* If changing 64bit, don't change the filesystem size. */
-	if (flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT)) {
+	if (flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT |
+		     RESIZE_SPECIAL_INODES)) {
 		new_size = ext2fs_blocks_count(fs->super);
 	}
 	if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
@@ -507,6 +513,28 @@ int main (int argc, char ** argv)
 				"feature.\n"));
 			exit(1);
 		}
+	} else if (flags & RESIZE_SPECIAL_INODES) {
+		if (rfs->first_ino > fs->super->s_inodes_count) {
+			fprintf(stderr, _("First inode too big\n"));
+			exit(1);
+		}
+		if (rfs->first_ino < EXT2_FIRST_INO(fs->super)) {
+			fprintf(stderr, _("The filesystem has %d special inodes."
+					  "Reducing isn't supported.\n\n"),
+					EXT2_FIRST_INO(fs->super));
+			exit(1);
+		}
+		if (rfs->first_ino == EXT2_FIRST_INO(fs->super)) {
+			fprintf(stderr, _("The filesystem already has %d "
+					  "special inodes. Nothing to do!\n\n"),
+					EXT2_FIRST_INO(fs->super));
+			exit(0);
+		}
+		if (mount_flags & EXT2_MF_MOUNTED) {
+			fprintf(stderr, _("Cannot change count of special "
+				"inodes while the filesystem is mounted.\n"));
+			exit(1);
+		}
 	} else if (new_size == ext2fs_blocks_count(fs->super)) {
 		fprintf(stderr, _("The filesystem is already %llu (%dk) "
 			"blocks long.  Nothing to do!\n\n"), new_size,
@@ -532,6 +560,8 @@ int main (int argc, char ** argv)
 			printf(_("Converting the filesystem to 64-bit.\n"));
 		else if (flags & RESIZE_DISABLE_64BIT)
 			printf(_("Converting the filesystem to 32-bit.\n"));
+		else if (flags & RESIZE_SPECIAL_INODES)
+			printf(_("Reserving special inodes.\n"));
 		else
 			printf(_("Resizing the filesystem on "
 				 "%s to %llu (%dk) blocks.\n"),
diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
index 0129bfcafa3b..f22563fe07e1 100644
--- a/resize/resize2fs.8.in
+++ b/resize/resize2fs.8.in
@@ -18,6 +18,10 @@ resize2fs \- ext2/ext3/ext4 file system resizer
 .B \-S
 .I RAID-stride
 ]
+[
+.B \-I
+.I first-inode
+]
 .I device
 [
 .I size
@@ -101,6 +105,10 @@ to resize the filesystem concurrent with changing the 64bit status.
 Turns on the 64bit feature, resizes the group descriptors as necessary, and
 moves other metadata out of the way.
 .TP
+.B \-I \fI <first-inode>
+This changes first normal inode and relocates inuse inodes into vacant slots.
+Inodes below that are reserved for internal use. Reducing isn't supported.
+.TP
 .B \-d \fIdebug-flags
 Turns on various resize2fs debugging features, if they have been compiled
 into the binary.
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index dead364bf4bf..2fb653b76dd8 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -48,6 +48,7 @@ static errcode_t block_mover(ext2_resize_t rfs);
 static errcode_t inode_scan_and_fix(ext2_resize_t rfs);
 static errcode_t inode_ref_fix(ext2_resize_t rfs);
 static errcode_t move_itables(ext2_resize_t rfs);
+static errcode_t zero_new_special_inodes(ext2_resize_t rfs);
 static errcode_t fix_resize_inode(ext2_filsys fs);
 static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs);
 static errcode_t fix_sb_journal_backup(ext2_filsys fs);
@@ -112,6 +113,11 @@ errcode_t resize_fs(ext2_filsys fs, ext2_resize_t rfs)
 	if (retval)
 		goto errout;
 
+	if (flags & RESIZE_SPECIAL_INODES) {
+		ext2fs_update_dynamic_rev(rfs->new_fs);
+		EXT2_SB(rfs->new_fs->super)->s_first_ino = rfs->first_ino;
+	}
+
 	init_resource_track(&rtrack, "resize_group_descriptors", fs->io);
 	retval = resize_group_descriptors(rfs);
 	if (retval)
@@ -177,6 +183,12 @@ errcode_t resize_fs(ext2_filsys fs, ext2_resize_t rfs)
 		goto errout;
 	print_resource_track(rfs, &rtrack, fs->io);
 
+	init_resource_track(&rtrack, "zero_new_special_inodes", fs->io);
+	retval = zero_new_special_inodes(rfs);
+	if (retval)
+		goto errout;
+	print_resource_track(rfs, &rtrack, fs->io);
+
 	init_resource_track(&rtrack, "move_itables", fs->io);
 	retval = move_itables(rfs);
 	if (retval)
@@ -1963,7 +1975,8 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 
 	if ((rfs->old_fs->group_desc_count <=
 	     rfs->new_fs->group_desc_count) &&
-	    !rfs->bmap)
+	    !rfs->bmap &&
+	    !(rfs->flags & RESIZE_SPECIAL_INODES))
 		return 0;
 
 	set_com_err_hook(quiet_com_err_proc);
@@ -2018,7 +2031,11 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 			goto errout;
 
 		new_inode = ino;
-		if (ino <= start_to_move)
+		if (ino >= EXT2_FIRST_INO(rfs->old_fs->super) &&
+		    ino <  EXT2_FIRST_INO(rfs->new_fs->super)) {
+			ext2fs_inode_alloc_stats2(rfs->new_fs, ino, -1,
+						  pb.is_dir);
+		} else if (ino <= start_to_move)
 			goto remap_blocks; /* Don't need to move inode. */
 
 		/*
@@ -2552,6 +2569,37 @@ static errcode_t reserve_sparse_super2_last_group(ext2_resize_t rfs,
 }
 
 /*
+ * Clear new special inodes
+ */
+static errcode_t zero_new_special_inodes(ext2_resize_t rfs)
+{
+	ext2_filsys		fs = rfs->new_fs;
+	int			inode_size;
+	struct ext2_inode	*inode;
+	errcode_t		retval;
+	ext2_ino_t		ino;
+
+	if (!(rfs->flags & RESIZE_SPECIAL_INODES))
+		return 0;
+
+	inode_size = EXT2_INODE_SIZE(fs->super);
+	retval = ext2fs_get_memzero(inode_size, &inode);
+	if (retval)
+		return retval;
+
+	for (ino = EXT2_FIRST_INO(rfs->old_fs->super);
+	     ino < EXT2_FIRST_INO(fs->super); ino++) {
+		/* All special inodes are marked as inuse */
+		ext2fs_inode_alloc_stats2(fs, ino, +1, 0);
+		retval = ext2fs_write_inode_full(fs, ino, inode, inode_size);
+		if (retval)
+			break;
+	}
+	ext2fs_free_mem(&inode);
+	return retval;
+}
+
+/*
  * Fix the resize inode
  */
 static errcode_t fix_resize_inode(ext2_filsys fs)
diff --git a/resize/resize2fs.h b/resize/resize2fs.h
index c5377e2b06c3..84f83b09f237 100644
--- a/resize/resize2fs.h
+++ b/resize/resize2fs.h
@@ -85,6 +85,8 @@ typedef struct ext2_sim_progress *ext2_sim_progmeter;
 #define RESIZE_ENABLE_64BIT		0x0400
 #define RESIZE_DISABLE_64BIT		0x0800
 
+#define RESIZE_SPECIAL_INODES		0x1000
+
 /*
  * This structure is used for keeping track of how much resources have
  * been used for a particular resize2fs pass.
@@ -130,6 +132,7 @@ struct ext2_resize_struct {
 	void		*prog_data;
 
 	blk64_t		new_size;
+	ext2_ino_t	first_ino;
 };
 
 /*

