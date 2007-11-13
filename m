From: Coly Li <coyli@suse.de>
Subject: [PATCH] ext4: dir inode reservation V3
Date: Tue, 13 Nov 2007 22:12:16 +0800
Message-ID: <4739B0C0.3060907@suse.de>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:45314 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbXKMODx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Nov 2007 09:03:53 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Basic idea of my dir inode reservation patch can be found here,
http://lists.openwall.net/linux-ext4/2007/11/05/3

1, What does dir inode reservation do
Dir inode reservation tries to reserve several inodes in inodes table for a directory when this
directory is created. When create new file under this directory, try to allocate inode from the
reserved inodes area. This is called as dir_ireserve inode allocator.


2, What does dir inode reservation help
If we create huge number of directories, and create files in each directory alternatively (like some
web proxy or mail server do), current linear inode allocator in ext[234] will introduce unnecessary
hard disk accessing and seeking during creation/unlink, which brings out poor performance.

Here is an example. The uppercase letters represent directories inode, and corresponded lowercase
letters represent file inodes under the parent directory. When number of directories are much more
than block groups number, some inodes of directories will be allocated in inodes table like this,
        <--  blk 0  -->
        A B C D E F H I
When the files under each directory increase alternatively, some time latter (if each directory has
2 files), the layout of this inodes table will be,
        <--  blk 0  --> <-- blk 1  -->  <-- blk 2  -->
        A B C D E F H I a b c d e f h i a b c d e f h i
Now if these directories are unlinked recursively in hashed order, because every time when unlink a
file from a directory, the inode of directory should also be updated to hard disk. If each I/O
session can only write 1 block into hard disk (this is the most simple condition which will not
happen in practice), the access sequence should be,
        1 0 2 0 1 0 2 0 1 0 2 0 1 0 2 0 1 0 2 0 1 0 2 0 1 0 2 0 1 0 2 0
>From the above sequence, we can find in order to remove 8 directories and their files, 32 blocks
should be written to hard disk.

Dir inode reservation patches tries to improve unlink performance in above condition. In
dir_ireserve inode allocator, directory inodes will be allocated like,
        <--  blk 0  --> <-- blk 1  --> ...<--  blk 6  --> <-- blk 7  -->
        A               B                 H               I
If we create new files under each directory, the layout in inodes table will be,
        <--  blk 0  --> <-- blk 1  --> ...<--  blk 6  --> <-- blk 7  -->
        A a a           B b b             H h h           I i i
Because files inodes are very near to parent directory inode, when these files are removed
recursively, directory inode and its file inodes can be updated to hard disk in one I/O session. If
each I/O session can only write 1 block into hard disk (like we assumed as before), the access
sequence should be,
        0 1 2 3 4 5 6 7
By dir_ireserve inode allocator, 25 extra block I/O can be avoided. At the same time, because files
inodes are near to parent directory inode, we also avoid the unnecessary hard disk seeking between
files inode and directory inode.

>From benchmark, I also find a helpful side effect from dir inode reservation -- it is 10%~30% faster
to create these directories and files, faster result can be observed on more directories are
created. The reason is same, when create new files the parent directory inode is updated to hard
disk, too. Place files inodes and directory inode nearly can merge many redundant block I/O.


3, Full compatible to current ext[234]
This is 3rd release (and 5th house keeping version)of my dir inode reservation patch. V1 is only for
 feasibility research, V2 is in compatible to ext[23], both require to patch e2fsprogs. V3 is only
patch to kernel, no e2fsprogs modification. V3 has no any on-disk modification or file system data
structure change, therefore it is full compatible to current ext[234].

4, Dir inode reservation is optional
Dir inode reservation is optional, you can use -o followed by one of these options to enable dir
inode reservation during mount ext4 file system:
         dir_ireserve=low
         dir_ireserve=normal
         dir_ireserve=high
Currently, 'low' reserves 15 file inodes for each directory, 'normal' reserves 31 inodes and 'high'
reserves 127 inodes. Reserving more than 127 inodes does not help to performance obviously.


5, Performance number
On a Core-Duo, 2MB DDM memory, 7200 RPM SATA PC, I built a 50GB ext4 partition, and tried to create
50000 directories, and create 15 (1KB) files in each directory alternatively. After a remount, I
tried to remove all the directories and files recursively by a 'rm -rf'. Bellow is the benchmark result,
			normal ext4			ext4 with dir inode reservation
	mount options:	-o data=writeback		-o data=writeback,dir_ireserve=low
	Create dirs:	real    0m49.101s		real    2m59.703s
	Create files:	real    24m17.962s		real    21m8.161s
	Unlink all:	real    24m43.788s		real    17m29.862s
Creating dirs with dir inode reservation is slower than normal ext4 as predicted, because allocating
directory inodes in non-linear order will cause extra hard disk seeking and block I/O. Creating
files with dir inode reservation is 13% faster than normal ext4. Unlink all the directories and
files is 29.2% faster as expected.
When number of directories is increased, the performance improvement will be more considerable. More
benchmark result will be posted here if necessary, because I need more time to run more test cases.


6, Credits
Andreas Dilger and Danial Phillips developed the original idea of inode reservation. Andreas
introduced me this idea when I wanted to improve unlink performance on ext4. Theodore Tso noted me
compatibility issue in V2 patch and brought out several useful advice on e2fsprogs patching.
Mingming Cao reviewed V2 kernel patch and pointed out several issues on the patch e.g. lack of
document, unacceptable patch to ext4 patch queue, and provided many other help on my work. Jan Kara
helped to review V2 kernel patch, most of the code of V3 patch is developed based on Jan Kara's
advice.Also thank Eric Sandeen, Chris Wedgwood and other friendly guys who discussed ext4 stuffs
with me in irc. Thanks to make me enjoy open source development.


7, Feedback
For any feedback, criticism, please email to coyli at suse dot de. I am very happy to hear from you
and improve the dir inode reservation patch.


Signed-off-by: Coly Li <coyli@suse.de>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/ialloc.c           |   77 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c            |   16 +++++++++
 include/linux/ext4_fs.h    |    8 ++++
 include/linux/ext4_fs_sb.h |    2 +
 4 files changed, 103 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 17b5df1..f838a72 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -10,6 +10,8 @@
  *  Stephen Tweedie (sct@redhat.com), 1993
  *  Big-endian to little-endian byte-swapping/bitmaps by
  *        David S. Miller (davem@caip.rutgers.edu), 1995
+ *  Directory inodes reservation by
+ *        Coly Li (coyli@suse.de), 2007
  */

 #include <linux/time.h>
@@ -478,6 +480,75 @@ static int find_group_other(struct super_block *sb, struct inode *parent,
 	return -1;
 }

+static int ext4_ino_from_ireserve(handle_t *handle, struct inode *dir,
+			  int mode, ext4_group_t *group, unsigned long *ino)
+{
+	struct super_block *sb;
+	struct ext4_sb_info *sbi;
+	struct ext4_group_desc *gdp = NULL;
+	struct buffer_head *gdp_bh = NULL, *bitmap_bh = NULL;
+	ext4_group_t ires_group = *group;
+	unsigned long ires_ino;
+	int i, bit;
+
+	sb = dir->i_sb;
+	sbi = EXT4_SB(sb);
+
+	/* if the inode number is not for directory,
+	 * only try to allocate after directory's inode
+	 */
+	if (!S_ISDIR(mode)) {
+		*ino = dir->i_ino % EXT4_INODES_PER_GROUP(sb);
+		return 0;
+	}
+
+	/* reserve inodes for new directory */
+	for (i = 0; i < sbi->s_groups_count; i++) {
+		gdp = ext4_get_group_desc(sb, ires_group, &gdp_bh);
+		if (!gdp)
+			goto fail;
+		bit = 0;
+try_same_group:
+		if (bit < EXT4_INODES_PER_GROUP(sb)) {
+			brelse(bitmap_bh);
+			bitmap_bh = read_inode_bitmap(sb, ires_group);
+			if (!bitmap_bh)
+				goto fail;
+
+			BUFFER_TRACE(bitmap_bh, "get_write_access");
+			if (ext4_journal_get_write_access(
+				handle, bitmap_bh) != 0)
+				goto fail;
+			if (!ext4_set_bit_atomic(sb_bgl_lock(sbi, ires_group),
+					bit, bitmap_bh->b_data)) {
+				/* we won it */
+				BUFFER_TRACE(bitmap_bh,
+					"call ext4_journal_dirty_metadata");
+				if (ext4_journal_dirty_metadata(handle,
+							bitmap_bh) != 0)
+					goto fail;
+				ires_ino = bit;
+				goto find;
+			}
+			/* we lost it */
+			jbd2_journal_release_buffer(handle, bitmap_bh);
+			bit += sbi->s_dir_ireserve_nr;
+			goto try_same_group;
+		}
+		if (++ires_group == sbi->s_groups_count)
+			ires_group = 0;
+	}
+	goto fail;
+find:
+	brelse(bitmap_bh);
+	*group = ires_group;
+	*ino = ires_ino;
+	return 0;
+fail:
+	brelse(bitmap_bh);
+	return -ENOSPC;
+}
+
 /*
  * There are two policies for allocating an inode.  If the new inode is
  * a directory, then a forward search is made for a block group with both
@@ -543,6 +614,12 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)

 		ino = 0;

+		if (test_opt(sb, DIR_IRESERVE)) {
+			err = ext4_ino_from_ireserve(handle, dir,
+						     mode, &group, &ino);
+			if ((!err) && S_ISDIR(mode))
+				goto got;
+		}
 repeat_in_this_group:
 		ino = ext4_find_next_zero_bit((unsigned long *)
 				bitmap_bh->b_data, EXT4_INODES_PER_GROUP(sb), ino);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b626339..9b873b7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -884,6 +884,7 @@ enum {
 	Opt_commit, Opt_journal_update, Opt_journal_inum, Opt_journal_dev,
 	Opt_journal_checksum, Opt_journal_async_commit,
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
+	Opt_dir_ireserve_low, Opt_dir_ireserve_normal, Opt_dir_ireserve_high,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
@@ -929,6 +930,9 @@ static match_table_t tokens = {
 	{Opt_data_journal, "data=journal"},
 	{Opt_data_ordered, "data=ordered"},
 	{Opt_data_writeback, "data=writeback"},
+	{Opt_dir_ireserve_low, "dir_ireserve=low"},
+	{Opt_dir_ireserve_normal, "dir_ireserve=normal"},
+	{Opt_dir_ireserve_high, "dir_ireserve=high"},
 	{Opt_offusrjquota, "usrjquota="},
 	{Opt_usrjquota, "usrjquota=%s"},
 	{Opt_offgrpjquota, "grpjquota="},
@@ -1311,6 +1315,18 @@ clear_qf_name:
 				return 0;
 			sbi->s_stripe = option;
 			break;
+		case Opt_dir_ireserve_low:
+			set_opt(sbi->s_mount_opt, DIR_IRESERVE);
+			sbi->s_dir_ireserve_nr = EXT4_DIR_IRESERVE_LOW;
+			break;
+		case Opt_dir_ireserve_normal:
+			set_opt(sbi->s_mount_opt, DIR_IRESERVE);
+			sbi->s_dir_ireserve_nr = EXT4_DIR_IRESERVE_NORMAL;
+			break;
+		case Opt_dir_ireserve_high:
+			set_opt(sbi->s_mount_opt, DIR_IRESERVE);
+			sbi->s_dir_ireserve_nr = EXT4_DIR_IRESERVE_HIGH;
+			break;
 		default:
 			printk (KERN_ERR
 				"EXT4-fs: Unrecognized mount option \"%s\" "
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index bcdb59d..88f5173 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -92,6 +92,13 @@ struct ext4_allocation_request {
 #define EXT4_GOOD_OLD_FIRST_INO	11

 /*
+ * Macro-instructions used to reserve inodes for directories
+ */
+#define EXT4_DIR_IRESERVE_LOW		16
+#define EXT4_DIR_IRESERVE_NORMAL	64
+#define EXT4_DIR_IRESERVE_HIGH		128
+
+/*
  * Maximal count of links to a file
  */
 #define EXT4_LINK_MAX		65000
@@ -502,6 +509,7 @@ do {									       \
 #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
 #define EXT4_MOUNT_DELALLOC		0x2000000 /* Delalloc support */
 #define EXT4_MOUNT_MBALLOC		0x4000000 /* Buddy allocation support */
+#define EXT4_MOUNT_DIR_IRESERVE		0x10000000/* dir inode reservation */
 /* Compatibility, for having both ext2_fs.h and ext4_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
 #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt
diff --git a/include/linux/ext4_fs_sb.h b/include/linux/ext4_fs_sb.h
index 744e746..790b0cf 100644
--- a/include/linux/ext4_fs_sb.h
+++ b/include/linux/ext4_fs_sb.h
@@ -147,6 +147,8 @@ struct ext4_sb_info {

 	/* locality groups */
 	struct ext4_locality_group *s_locality_groups;
+	/* number of inodes we reserve in a directory */
+	int s_dir_ireserve_nr;
 };
 #define EXT4_GROUP_INFO(sb, group)					   \
 	EXT4_SB(sb)->s_group_info[(group) >> EXT4_DESC_PER_BLOCK_BITS(sb)] \


-- 
Coly Li
SuSE PRC Labs
