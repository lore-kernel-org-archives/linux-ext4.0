From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 01/37] e2fsprogs: Read and write full-sized inodes
Date: Wed, 31 Aug 2011 17:35:17 -0700
Message-ID: <20110901003517.1176.46651.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49404 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757249Ab1IAAfX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 20:35:23 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Wed, 31 Aug 2011 20:35:22 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810ZJr0182132
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:35:19 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p810ZIg0010899
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:35:19 -0400
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As part of adding inode checksums, it is necessary for all e2fsprogs to read
and write full inodes so that checksums may be calculated correctly.  Since
struct ext2_inode_large is a superset of struct ext2_inode, replace the smaller
one with the larger one.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 debugfs/debugfs.c               |   28 ++++++++--------
 debugfs/debugfs.h               |   12 ++++---
 debugfs/dump.c                  |   12 +++----
 debugfs/htree.c                 |   10 +++---
 debugfs/icheck.c                |    2 +
 debugfs/logdump.c               |   13 ++++---
 debugfs/ls.c                    |    4 +-
 debugfs/lsdel.c                 |    2 +
 debugfs/ncheck.c                |    2 +
 debugfs/set_fields.c            |    2 +
 debugfs/util.c                  |    8 ++---
 doc/libext2fs.texinfo           |   12 +++----
 e2fsck/e2fsck.h                 |   23 +++++++------
 e2fsck/emptydir.c               |    2 +
 e2fsck/iscan.c                  |    2 +
 e2fsck/jfs_user.h               |    2 +
 e2fsck/journal.c                |    5 ++-
 e2fsck/message.c                |    2 +
 e2fsck/pass1.c                  |   35 ++++++++++----------
 e2fsck/pass1b.c                 |   10 +++---
 e2fsck/pass2.c                  |   10 +++---
 e2fsck/pass3.c                  |   10 +++---
 e2fsck/pass4.c                  |   11 ++++--
 e2fsck/problem.h                |    2 +
 e2fsck/rehash.c                 |    6 ++-
 e2fsck/scantest.c               |    2 +
 e2fsck/super.c                  |    6 ++-
 e2fsck/util.c                   |    8 ++---
 ext2ed/dir_com.c                |    2 +
 ext2ed/doc/ext2ed-design.sgml   |    6 ++-
 ext2ed/doc/ext2fs-overview.sgml |    2 +
 ext2ed/ext2.descriptors         |    2 +
 ext2ed/ext2ed.h                 |    4 +-
 ext2ed/file_com.c               |    2 +
 ext2ed/init.c                   |    2 +
 ext2ed/inode_com.c              |   18 +++++-----
 lib/e2p/ls.c                    |    2 +
 lib/ext2fs/bb_inode.c           |    2 +
 lib/ext2fs/blknum.c             |    8 ++---
 lib/ext2fs/block.c              |    2 +
 lib/ext2fs/bmap.c               |   16 +++++----
 lib/ext2fs/bmove.c              |    4 +-
 lib/ext2fs/expanddir.c          |    2 +
 lib/ext2fs/ext2_fs.h            |   47 ---------------------------
 lib/ext2fs/ext2fs.h             |   61 ++++++++++++++++++-----------------
 lib/ext2fs/ext2fsP.h            |    2 +
 lib/ext2fs/extent.c             |    6 ++-
 lib/ext2fs/fileio.c             |    8 ++---
 lib/ext2fs/i_block.c            |    7 ++--
 lib/ext2fs/initialize.c         |    2 +
 lib/ext2fs/inode.c              |   68 ++++++++++++++++++---------------------
 lib/ext2fs/inode_io.c           |    6 ++-
 lib/ext2fs/link.c               |    2 +
 lib/ext2fs/mkdir.c              |    4 +-
 lib/ext2fs/mkjournal.c          |    2 +
 lib/ext2fs/namei.c              |    2 +
 lib/ext2fs/punch.c              |   11 +++---
 lib/ext2fs/read_bb.c            |    2 +
 lib/ext2fs/res_gdt.c            |    2 +
 lib/ext2fs/swapfs.c             |   22 ++++++-------
 lib/ext2fs/tst_iscan.c          |    2 +
 lib/ext2fs/valid_blk.c          |    2 +
 misc/dumpe2fs.c                 |    2 +
 misc/e2image.c                  |    6 ++-
 misc/e2initrd_helper.c          |    2 +
 misc/mke2fs.c                   |    2 +
 misc/tune2fs.c                  |    4 +-
 resize/resize2fs.c              |   10 +++---
 68 files changed, 283 insertions(+), 318 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index e7d7436..94732b9 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -688,7 +688,7 @@ static void dump_extents(FILE *f, const char *prefix, ext2_ino_t ino,
 }
 
 void internal_dump_inode(FILE *out, const char *prefix,
-			 ext2_ino_t inode_num, struct ext2_inode *inode,
+			 ext2_ino_t inode_num, struct ext2_inode_large *inode,
 			 int do_dump_blocks)
 {
 	const char *i_type;
@@ -812,7 +812,7 @@ void internal_dump_inode(FILE *out, const char *prefix,
 	}
 }
 
-static void dump_inode(ext2_ino_t inode_num, struct ext2_inode *inode)
+static void dump_inode(ext2_ino_t inode_num, struct ext2_inode_large *inode)
 {
 	FILE	*out;
 
@@ -824,12 +824,12 @@ static void dump_inode(ext2_ino_t inode_num, struct ext2_inode *inode)
 void do_stat(int argc, char *argv[])
 {
 	ext2_ino_t	inode;
-	struct ext2_inode * inode_buf;
+	struct ext2_inode_large *inode_buf;
 
 	if (check_fs_open(argv[0]))
 		return;
 
-	inode_buf = (struct ext2_inode *)
+	inode_buf = (struct ext2_inode_large *)
 			malloc(EXT2_INODE_SIZE(current_fs->super));
 	if (!inode_buf) {
 		fprintf(stderr, "do_stat: can't allocate buffer\n");
@@ -854,7 +854,7 @@ void do_stat(int argc, char *argv[])
 
 void do_dump_extents(int argc, char **argv)
 {
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	ext2_ino_t	ino;
 	FILE		*out;
 	int		c, flags = 0;
@@ -959,7 +959,7 @@ void do_chroot(int argc, char *argv[])
 void do_clri(int argc, char *argv[])
 {
 	ext2_ino_t inode;
-	struct ext2_inode inode_buf;
+	struct ext2_inode_large inode_buf;
 
 	if (common_inode_args_process(argc, argv, &inode, CHECK_FS_RW))
 		return;
@@ -1135,7 +1135,7 @@ static void modify_u32(char *com, const char *prompt,
 
 void do_modify_inode(int argc, char *argv[])
 {
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	ext2_ino_t	inode_num;
 	int 		i;
 	unsigned char	*frag, *fsize;
@@ -1293,7 +1293,7 @@ static int ext2_file_type(unsigned int mode)
 static void make_link(char *sourcename, char *destname)
 {
 	ext2_ino_t	ino;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	int		retval;
 	ext2_ino_t	dir;
 	char		*dest, *cp, *base_name;
@@ -1369,7 +1369,7 @@ static int mark_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
 void do_undel(int argc, char *argv[])
 {
 	ext2_ino_t	ino;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 
 	if (common_args_process(argc, argv, 2, 3, "undelete",
 				"<inode_num> [dest_name]",
@@ -1577,7 +1577,7 @@ void do_write(int argc, char *argv[])
 	struct stat	statbuf;
 	ext2_ino_t	newfile;
 	errcode_t	retval;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 
 	if (common_args_process(argc, argv, 3, 3, "write",
 				"<native file> <new file>", CHECK_FS_RW))
@@ -1654,7 +1654,7 @@ void do_mknod(int argc, char *argv[])
 	unsigned long	mode, major, minor;
 	ext2_ino_t	newfile;
 	errcode_t 	retval;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	int		filetype, nr;
 
 	if (check_fs_open(argv[0]))
@@ -1792,7 +1792,7 @@ static int release_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
 
 static void kill_file_by_inode(ext2_ino_t inode)
 {
-	struct ext2_inode inode_buf;
+	struct ext2_inode_large inode_buf;
 
 	if (debugfs_read_inode(inode, &inode_buf, 0))
 		return;
@@ -1824,7 +1824,7 @@ void do_rm(int argc, char *argv[])
 {
 	int retval;
 	ext2_ino_t inode_num;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 
 	if (common_args_process(argc, argv, 2, 2, "rm",
 				"<filename>", CHECK_FS_RW))
@@ -1885,7 +1885,7 @@ void do_rmdir(int argc, char *argv[])
 {
 	int retval;
 	ext2_ino_t inode_num;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	struct rd_struct rds;
 
 	if (common_args_process(argc, argv, 2, 2, "rmdir",
diff --git a/debugfs/debugfs.h b/debugfs/debugfs.h
index 0ea2474..d65a371 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -44,13 +44,15 @@ extern int common_inode_args_process(int argc, char *argv[],
 				     ext2_ino_t *inode, int flags);
 extern int common_block_args_process(int argc, char *argv[],
 				     blk64_t *block, blk64_t *count);
-extern int debugfs_read_inode(ext2_ino_t ino, struct ext2_inode * inode,
+extern int debugfs_read_inode(ext2_ino_t ino, struct ext2_inode_large *inode,
 			      const char *cmd);
-extern int debugfs_read_inode_full(ext2_ino_t ino, struct ext2_inode * inode,
+extern int debugfs_read_inode_full(ext2_ino_t ino,
+				   struct ext2_inode_large *inode,
 				   const char *cmd, int bufsize);
-extern int debugfs_write_inode(ext2_ino_t ino, struct ext2_inode * inode,
+extern int debugfs_write_inode(ext2_ino_t ino, struct ext2_inode_large *inode,
 			       const char *cmd);
-extern int debugfs_write_new_inode(ext2_ino_t ino, struct ext2_inode * inode,
+extern int debugfs_write_new_inode(ext2_ino_t ino,
+				   struct ext2_inode_large *inode,
 				   const char *cmd);
 
 /* ss command functions */
@@ -87,7 +89,7 @@ extern void do_dump_unused(int argc, char **argv);
 
 /* debugfs.c */
 extern void internal_dump_inode(FILE *, const char *, ext2_ino_t,
-				struct ext2_inode *, int);
+				struct ext2_inode_large *, int);
 
 extern void do_dirty_filesys(int argc, char **argv);
 extern void do_open_filesys(int argc, char **argv);
diff --git a/debugfs/dump.c b/debugfs/dump.c
index 4cf0752..fe7e7f4 100644
--- a/debugfs/dump.c
+++ b/debugfs/dump.c
@@ -66,7 +66,7 @@ static mode_t mode_xlate(__u16 lmode)
 	return mode;
 }
 
-static void fix_perms(const char *cmd, const struct ext2_inode *inode,
+static void fix_perms(const char *cmd, const struct ext2_inode_large *inode,
 		      int fd, const char *name)
 {
 	struct utimbuf ut;
@@ -103,7 +103,7 @@ static void dump_file(const char *cmdname, ext2_ino_t ino, int fd,
 		      int preserve, char *outname)
 {
 	errcode_t retval;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	char 		buf[8192];
 	ext2_file_t	e2_file;
 	int		nbytes;
@@ -187,7 +187,7 @@ void do_dump(int argc, char **argv)
 	return;
 }
 
-static void rdump_symlink(ext2_ino_t ino, struct ext2_inode *inode,
+static void rdump_symlink(ext2_ino_t ino, struct ext2_inode_large *inode,
 			  const char *fullname)
 {
 	ext2_file_t e2_file;
@@ -241,7 +241,7 @@ errout:
 
 static int rdump_dirent(struct ext2_dir_entry *, int, int, char *, void *);
 
-static void rdump_inode(ext2_ino_t ino, struct ext2_inode *inode,
+static void rdump_inode(ext2_ino_t ino, struct ext2_inode_large *inode,
 			const char *name, const char *dumproot)
 {
 	char *fullname;
@@ -298,7 +298,7 @@ static int rdump_dirent(struct ext2_dir_entry *dirent,
 	char name[EXT2_NAME_LEN + 1];
 	int thislen;
 	const char *dumproot = private;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 
 	thislen = ((dirent->name_len & 0xFF) < EXT2_NAME_LEN
 		   ? (dirent->name_len & 0xFF) : EXT2_NAME_LEN);
@@ -316,7 +316,7 @@ static int rdump_dirent(struct ext2_dir_entry *dirent,
 void do_rdump(int argc, char **argv)
 {
 	ext2_ino_t ino;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	struct stat st;
 	int i;
 	char *p;
diff --git a/debugfs/htree.c b/debugfs/htree.c
index b829e25..d72b996 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -29,7 +29,7 @@ extern char *optarg;
 static FILE *pager;
 
 static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
-				 struct ext2_inode *inode,
+				 struct ext2_inode_large *inode,
 				 struct ext2_dx_root_info * rootnode,
 				 blk64_t blk, char *buf)
 {
@@ -107,13 +107,13 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
 
 
 static void htree_dump_int_block(ext2_filsys fs, ext2_ino_t ino,
-				 struct ext2_inode *inode,
+				 struct ext2_inode_large *inode,
 				 struct ext2_dx_root_info * rootnode,
 				 blk64_t blk, char *buf, int level);
 
 
 static void htree_dump_int_node(ext2_filsys fs, ext2_ino_t ino,
-				struct ext2_inode *inode,
+				struct ext2_inode_large *inode,
 				struct ext2_dx_root_info * rootnode,
 				struct ext2_dx_entry *ent,
 				char *buf, int level)
@@ -156,7 +156,7 @@ static void htree_dump_int_node(ext2_filsys fs, ext2_ino_t ino,
 }
 
 static void htree_dump_int_block(ext2_filsys fs, ext2_ino_t ino,
-				 struct ext2_inode *inode,
+				 struct ext2_inode_large *inode,
 				 struct ext2_dx_root_info * rootnode,
 				 blk64_t blk, char *buf, int level)
 {
@@ -196,7 +196,7 @@ errout:
 void do_htree_dump(int argc, char *argv[])
 {
 	ext2_ino_t	ino;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	blk64_t		blk;
 	char		*buf = NULL;
 	struct 		ext2_dx_root_info  *rootnode;
diff --git a/debugfs/icheck.c b/debugfs/icheck.c
index 729ac93..d1aaefe 100644
--- a/debugfs/icheck.c
+++ b/debugfs/icheck.c
@@ -59,7 +59,7 @@ void do_icheck(int argc, char **argv)
 	int			i;
 	ext2_inode_scan		scan = 0;
 	ext2_ino_t		ino;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	errcode_t		retval;
 	char			*block_buf;
 
diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index d1e64fd..dfb243e 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -83,7 +83,7 @@ void do_logdump(int argc, char **argv)
 	int		journal_fd = 0;
 	int		use_sb = 0;
 	ext2_ino_t	journal_inum;
-	struct ext2_inode journal_inode;
+	struct ext2_inode_large journal_inode;
 	ext2_file_t 	journal_file;
 	char		*tmp;
 	struct journal_source journal_source;
@@ -154,13 +154,13 @@ void do_logdump(int argc, char **argv)
 		group_offset = ((inode_to_dump - 1)
 				% es->s_inodes_per_group);
 		inodes_per_block = (current_fs->blocksize
-				    / sizeof(struct ext2_inode));
+				    / EXT2_GOOD_OLD_INODE_SIZE);
 
 		inode_block_to_dump =
 			ext2fs_inode_table_loc(current_fs, inode_group) +
 			(group_offset / inodes_per_block);
 		inode_offset_to_dump = ((group_offset % inodes_per_block)
-					* sizeof(struct ext2_inode));
+					* EXT2_GOOD_OLD_INODE_SIZE);
 		printf("Inode %u is at group %u, block %u, offset %u\n",
 		       inode_to_dump, inode_group,
 		       inode_block_to_dump, inode_offset_to_dump);
@@ -206,7 +206,8 @@ void do_logdump(int argc, char **argv)
 					"no journal backup in super block\n");
 				goto errout;
 			}
-			memset(&journal_inode, 0, sizeof(struct ext2_inode));
+			memset(&journal_inode, 0,
+			       sizeof(struct ext2_inode_large));
 			memcpy(&journal_inode.i_block[0], es->s_jnl_blocks,
 			       EXT2_N_BLOCKS*4);
 			journal_inode.i_size_high = es->s_jnl_blocks[15];
@@ -630,13 +631,13 @@ static void dump_metadata_block(FILE *out_file, struct journal_source *source,
 	}
 
 	if (fs_blocknr == inode_block_to_dump) {
-		struct ext2_inode *inode;
+		struct ext2_inode_large *inode;
 		int first, prev, this, start_extent, i;
 
 		fprintf(out_file, "    (inode block for inode %u):\n",
 			inode_to_dump);
 
-		inode = (struct ext2_inode *) (buf + inode_offset_to_dump);
+		inode = (struct ext2_inode_large *)(buf + inode_offset_to_dump);
 		internal_dump_inode(out_file, "    ", inode_to_dump, inode, 0);
 
 		/* Dump out the direct/indirect blocks here:
diff --git a/debugfs/ls.c b/debugfs/ls.c
index 8e019d2..9977a79 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -49,7 +49,7 @@ static int list_dir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 			 char	*buf EXT2FS_ATTR((unused)),
 			 void	*private)
 {
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	ext2_ino_t		ino;
 	struct tm		*tm_p;
 	time_t			modtime;
@@ -94,7 +94,7 @@ static int list_dir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 				tm_p->tm_min);
 		} else {
 			strcpy(datestr, "                 ");
-			memset(&inode, 0, sizeof(struct ext2_inode));
+			memset(&inode, 0, sizeof(struct ext2_inode_large));
 		}
 		fprintf(ls->f, "%c%6u%c %6o (%d)  %5d  %5d   ", lbr, ino, rbr,
 			inode.i_mode, dirent->name_len >> 8,
diff --git a/debugfs/lsdel.c b/debugfs/lsdel.c
index ba7a90f..4126dac 100644
--- a/debugfs/lsdel.c
+++ b/debugfs/lsdel.c
@@ -77,7 +77,7 @@ void do_lsdel(int argc, char **argv)
 	int			num_delarray, max_delarray;
 	ext2_inode_scan		scan = 0;
 	ext2_ino_t		ino;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	errcode_t		retval;
 	char			*block_buf;
 	int			i;
diff --git a/debugfs/ncheck.c b/debugfs/ncheck.c
index a366281..2de66ae 100644
--- a/debugfs/ncheck.c
+++ b/debugfs/ncheck.c
@@ -56,7 +56,7 @@ void do_ncheck(int argc, char **argv)
 	int			i;
 	ext2_inode_scan		scan = 0;
 	ext2_ino_t		ino;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	errcode_t		retval;
 	char			*tmp;
 
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index ac6bc25..1bc6410 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -40,7 +40,7 @@
 #include "e2p/e2p.h"
 
 static struct ext2_super_block set_sb;
-static struct ext2_inode set_inode;
+static struct ext2_inode_large set_inode;
 static struct ext2_group_desc set_gd;
 static dgrp_t set_bg;
 static ext2_ino_t set_ino;
diff --git a/debugfs/util.c b/debugfs/util.c
index c3ac6f8..ff1f878 100644
--- a/debugfs/util.c
+++ b/debugfs/util.c
@@ -375,7 +375,7 @@ int common_block_args_process(int argc, char *argv[],
 	return 0;
 }
 
-int debugfs_read_inode_full(ext2_ino_t ino, struct ext2_inode * inode,
+int debugfs_read_inode_full(ext2_ino_t ino, struct ext2_inode_large *inode,
 			const char *cmd, int bufsize)
 {
 	int retval;
@@ -388,7 +388,7 @@ int debugfs_read_inode_full(ext2_ino_t ino, struct ext2_inode * inode,
 	return 0;
 }
 
-int debugfs_read_inode(ext2_ino_t ino, struct ext2_inode * inode,
+int debugfs_read_inode(ext2_ino_t ino, struct ext2_inode_large *inode,
 			const char *cmd)
 {
 	int retval;
@@ -401,7 +401,7 @@ int debugfs_read_inode(ext2_ino_t ino, struct ext2_inode * inode,
 	return 0;
 }
 
-int debugfs_write_inode(ext2_ino_t ino, struct ext2_inode * inode,
+int debugfs_write_inode(ext2_ino_t ino, struct ext2_inode_large *inode,
 			const char *cmd)
 {
 	int retval;
@@ -414,7 +414,7 @@ int debugfs_write_inode(ext2_ino_t ino, struct ext2_inode * inode,
 	return 0;
 }
 
-int debugfs_write_new_inode(ext2_ino_t ino, struct ext2_inode * inode,
+int debugfs_write_new_inode(ext2_ino_t ino, struct ext2_inode_large *inode,
 			    const char *cmd)
 {
 	int retval;
diff --git a/doc/libext2fs.texinfo b/doc/libext2fs.texinfo
index d607396..5785f50 100644
--- a/doc/libext2fs.texinfo
+++ b/doc/libext2fs.texinfo
@@ -426,7 +426,7 @@ opened via inode numbers instead of via pathnames.  To resolve a
 pathname to an inode number, use the function @code{ext2fs_namei} or to
 create a new file, use @code{ext2fs_new_inode} and @code{ext2fs_link}.
 
-@deftypefun errcode_t ext2fs_file_open2 (ext2_filsys @var{fs}, ext2_ino_t @var{ino}, struct ext2_inode *@var{inode}, int @var{flags}, ext2_file_t *@var{ret})
+@deftypefun errcode_t ext2fs_file_open2 (ext2_filsys @var{fs}, ext2_ino_t @var{ino}, struct ext2_inode_large *@var{inode}, int @var{flags}, ext2_file_t *@var{ret})
 @deftypefunx errcode_t ext2fs_file_open (ext2_filsys @var{fs}, ext2_ino_t @var{ino}, int @var{flags}, ext2_file_t *@var{ret})
 
 Opens a file identified by inode number @var{ino} in filesystem @var{fs}
@@ -538,11 +538,11 @@ Return the size of the file @var{file}.
 @comment  node-name,  next,  previous,  up
 @subsection Reading and writing inodes
 
-@deftypefun errcode_t ext2fs_read_inode (ext2_filsys @var{fs}, ext2_ino_t @var{ino}, struct ext2_inode *@var{inode})
+@deftypefun errcode_t ext2fs_read_inode (ext2_filsys @var{fs}, ext2_ino_t @var{ino}, struct ext2_inode_large *@var{inode})
 Read the inode number @var{ino} into @var{inode}.
 @end deftypefun
 
-@deftypefun errcode_t ext2fs_write_inode (ext2_filsys @var{fs}, ext2_ino_t @var{ino}, struct ext2_inode *@var{inode})
+@deftypefun errcode_t ext2fs_write_inode (ext2_filsys @var{fs}, ext2_ino_t @var{ino}, struct ext2_inode_large *@var{inode})
 Write @var{inode} to inode @var{ino}.
 @end deftypefun
 
@@ -569,7 +569,7 @@ suitable default value will be used.
 Release the memory associated with @var{scan} and invalidate it.
 @end deftypefun
 
-@deftypefun errcode_t ext2fs_get_next_inode (ext2_inode_scan @var{scan}, ext2_ino_t *@var{ino}, struct ext2_inode *@var{inode})
+@deftypefun errcode_t ext2fs_get_next_inode (ext2_inode_scan @var{scan}, ext2_ino_t *@var{ino}, struct ext2_inode_large *@var{inode})
 
 This function returns the next inode from the filesystem; the inode
 number of the inode is stored in @var{ino}, and the inode is stored in
@@ -712,7 +712,7 @@ inode structure.
 Returns 0 if @var{ino} is a directory, and @code{ENOTDIR} if it is not.
 @end deftypefun
 
-@deftypefun int ext2fs_inode_has_valid_blocks (struct ext2_inode *@var{inode})
+@deftypefun int ext2fs_inode_has_valid_blocks (struct ext2_inode_large *@var{inode})
 
 Returns 1 if the inode's block entries actually valid block entries, and
 0 if not.  Inodes which represent devices and fast symbolic links do not
@@ -1281,7 +1281,7 @@ intended for debugging and testing use only.
 @deftypefun void ext2fs_swap_group_desc (struct ext2_group_desc *@var{gdp})
 @end deftypefun
 
-@deftypefun void ext2fs_swap_inode (ext2_filsys @var{fs}, struct ext2_inode *@var{to}, struct ext2_inode *@var{from}, int @var{hostorder})
+@deftypefun void ext2fs_swap_inode (ext2_filsys @var{fs}, struct ext2_inode_large *@var{to}, struct ext2_inode_large *@var{from}, int @var{hostorder})
 @end deftypefun
 
 @deftypefun int ext2fs_native_flag (void)
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index b4a1a88..d515a9d 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -267,7 +267,7 @@ struct e2fsck_struct {
 	 * For pass1_check_directory and pass1_get_blocks
 	 */
 	ext2_ino_t stashed_ino;
-	struct ext2_inode *stashed_inode;
+	struct ext2_inode_large *stashed_inode;
 
 	/*
 	 * Location of the lost and found directory
@@ -446,11 +446,12 @@ extern void e2fsck_setup_tdb_icount(e2fsck_t ctx, int flags,
 				    ext2_icount_t *ret);
 extern void e2fsck_use_inode_shortcuts(e2fsck_t ctx, int bool);
 extern int e2fsck_pass1_check_device_inode(ext2_filsys fs,
-					   struct ext2_inode *inode);
+					   struct ext2_inode_large *inode);
 extern int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
-				      struct ext2_inode *inode, char *buf);
+				      struct ext2_inode_large *inode,
+				      char *buf);
 extern void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino,
-			       struct ext2_inode *inode, int restart_flag,
+			       struct ext2_inode_large *inode, int restart_flag,
 			       const char *source);
 
 /* pass2.c */
@@ -505,17 +506,19 @@ extern void init_resource_track(struct resource_track *track,
 #define print_resource_track(ctx, desc, track, channel) do { } while (0)
 #define init_resource_track(track, channel) do { } while (0)
 #endif
-extern int inode_has_valid_blocks(struct ext2_inode *inode);
+extern int inode_has_valid_blocks(struct ext2_inode_large *inode);
 extern void e2fsck_read_inode(e2fsck_t ctx, unsigned long ino,
-			      struct ext2_inode * inode, const char * proc);
+			      struct ext2_inode_large *inode,
+			      const char *proc);
 extern void e2fsck_read_inode_full(e2fsck_t ctx, unsigned long ino,
-				   struct ext2_inode *inode,
+				   struct ext2_inode_large *inode,
 				   const int bufsize, const char *proc);
 extern void e2fsck_write_inode(e2fsck_t ctx, unsigned long ino,
-			       struct ext2_inode * inode, const char * proc);
+			       struct ext2_inode_large *inode,
+			       const char *proc);
 extern void e2fsck_write_inode_full(e2fsck_t ctx, unsigned long ino,
-                               struct ext2_inode * inode, int bufsize,
-                               const char *proc);
+				    struct ext2_inode_large *inode, int bufsize,
+				    const char *proc);
 #ifdef MTRACE
 extern void mtrace_print(char *mesg);
 #endif
diff --git a/e2fsck/emptydir.c b/e2fsck/emptydir.c
index cf9b521..2ae5dcc 100644
--- a/e2fsck/emptydir.c
+++ b/e2fsck/emptydir.c
@@ -24,7 +24,7 @@ struct empty_dir_info_struct {
 	ext2fs_inode_bitmap dir_map;
 	char *block_buf;
 	ext2_ino_t ino;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	blk64_t	logblk;
 	blk64_t	freed_blocks;
 };
diff --git a/e2fsck/iscan.c b/e2fsck/iscan.c
index 84e2cc1..8cae736 100644
--- a/e2fsck/iscan.c
+++ b/e2fsck/iscan.c
@@ -99,7 +99,7 @@ int main (int argc, char *argv[])
 	ext2_filsys	fs;
 	ext2_ino_t	ino;
 	__u32	num_inodes = 0;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	ext2_inode_scan	scan;
 
 	init_resource_track(&global_rtrack);
diff --git a/e2fsck/jfs_user.h b/e2fsck/jfs_user.h
index 2bb71c3..2fada54 100644
--- a/e2fsck/jfs_user.h
+++ b/e2fsck/jfs_user.h
@@ -28,7 +28,7 @@ struct buffer_head {
 struct inode {
 	e2fsck_t	i_ctx;
 	ext2_ino_t	i_ino;
-	struct ext2_inode i_ext2;
+	struct ext2_inode_large i_ext2;
 };
 
 struct kdev_s {
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 6d350ee..0e2816f 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -285,7 +285,8 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 			if (sb->s_jnl_backup_type != EXT3_JNL_BACKUP_BLOCKS ||
 			    tried_backup_jnl)
 				goto errout;
-			memset(&j_inode->i_ext2, 0, sizeof(struct ext2_inode));
+			memset(&j_inode->i_ext2, 0,
+			       sizeof(struct ext2_inode_large));
 			memcpy(&j_inode->i_ext2.i_block[0], sb->s_jnl_blocks,
 			       EXT2_N_BLOCKS*4);
 			j_inode->i_ext2.i_size_high = sb->s_jnl_blocks[15];
@@ -912,7 +913,7 @@ void e2fsck_move_ext3_journal(e2fsck_t ctx)
 {
 	struct ext2_super_block *sb = ctx->fs->super;
 	struct problem_context	pctx;
-	struct ext2_inode 	inode;
+	struct ext2_inode_large	inode;
 	ext2_filsys		fs = ctx->fs;
 	ext2_ino_t		ino;
 	errcode_t		retval;
diff --git a/e2fsck/message.c b/e2fsck/message.c
index c456752..753dd26 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -261,7 +261,7 @@ static _INLINE_ void expand_at_expression(e2fsck_t ctx, char ch,
 static _INLINE_ void expand_inode_expression(ext2_filsys fs, char ch,
 					     struct problem_context *ctx)
 {
-	struct ext2_inode	*inode;
+	struct ext2_inode_large	*inode;
 	struct ext2_inode_large	*large_inode;
 
 	if (!ctx || !ctx->inode)
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index fe5dd9b..ba17b30 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -86,7 +86,7 @@ struct process_block_struct {
 	e2_blkcnt_t	last_db_block;
 	int		num_illegal_blocks;
 	blk64_t		previous_block;
-	struct ext2_inode *inode;
+	struct ext2_inode_large *inode;
 	struct problem_context *pctx;
 	ext2fs_block_bitmap fs_meta_blocks;
 	e2fsck_t	ctx;
@@ -94,7 +94,7 @@ struct process_block_struct {
 
 struct process_inode_block {
 	ext2_ino_t ino;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 };
 
 struct scan_callback_struct {
@@ -130,7 +130,7 @@ static void unwind_pass1(ext2_filsys fs EXT2FS_ATTR((unused)))
  * zero.
  */
 int e2fsck_pass1_check_device_inode(ext2_filsys fs EXT2FS_ATTR((unused)),
-				    struct ext2_inode *inode)
+				    struct ext2_inode_large *inode)
 {
 	int	i;
 
@@ -165,7 +165,7 @@ int e2fsck_pass1_check_device_inode(ext2_filsys fs EXT2FS_ATTR((unused)),
  * checks out, 0 if not.
  */
 int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
-			       struct ext2_inode *inode, char *buf)
+			       struct ext2_inode_large *inode, char *buf)
 {
 	unsigned int len;
 	int i;
@@ -254,7 +254,7 @@ static void check_immutable(e2fsck_t ctx, struct problem_context *pctx)
  */
 static void check_size(e2fsck_t ctx, struct problem_context *pctx)
 {
-	struct ext2_inode *inode = pctx->inode;
+	struct ext2_inode_large *inode = pctx->inode;
 
 	if (EXT2_I_SIZE(inode) == 0)
 		return;
@@ -400,7 +400,7 @@ static void check_inode_extra_space(e2fsck_t ctx, struct problem_context *pctx)
 static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 				char *buf)
 {
-	struct ext2_inode *inode = pctx->inode;
+	struct ext2_inode_large *inode = pctx->inode;
 	struct ext2_dir_entry 	*dirent;
 	const char		*old_op;
 	errcode_t		retval;
@@ -546,7 +546,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	__u64	max_sizes;
 	ext2_filsys fs = ctx->fs;
 	ext2_ino_t	ino;
-	struct ext2_inode *inode;
+	struct ext2_inode_large *inode;
 	ext2_inode_scan	scan;
 	char		*block_buf;
 #ifdef RESOURCE_TRACK
@@ -637,8 +637,9 @@ void e2fsck_pass1(e2fsck_t ctx)
 		return;
 	}
 	inode_size = EXT2_INODE_SIZE(fs->super);
-	inode = (struct ext2_inode *)
-		e2fsck_allocate_memory(ctx, inode_size, "scratch inode");
+	if (sizeof(struct ext2_inode_large) > inode_size)
+		inode_size = sizeof(struct ext2_inode_large);
+	inode = e2fsck_allocate_memory(ctx, inode_size, "scratch inode");
 
 	inodes_to_process = (struct process_inode_block *)
 		e2fsck_allocate_memory(ctx,
@@ -1212,7 +1213,7 @@ static errcode_t scan_callback(ext2_filsys fs,
 static void process_inodes(e2fsck_t ctx, char *block_buf)
 {
 	int			i;
-	struct ext2_inode	*old_stashed_inode;
+	struct ext2_inode_large	*old_stashed_inode;
 	ext2_ino_t		old_stashed_ino;
 	const char		*old_operation;
 	char			buf[80];
@@ -1421,7 +1422,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 {
 	ext2_filsys fs = ctx->fs;
 	ext2_ino_t	ino = pctx->ino;
-	struct ext2_inode *inode = pctx->inode;
+	struct ext2_inode_large *inode = pctx->inode;
 	blk64_t		blk;
 	char *		end;
 	struct ext2_ext_attr_header *header;
@@ -1599,7 +1600,7 @@ clear_extattr:
 
 /* Returns 1 if bad htree, 0 if OK */
 static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
-			ext2_ino_t ino, struct ext2_inode *inode,
+			ext2_ino_t ino, struct ext2_inode_large *inode,
 			char *block_buf)
 {
 	struct ext2_dx_root_info	*root;
@@ -1656,7 +1657,7 @@ static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
 }
 
 void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino,
-			struct ext2_inode *inode, int restart_flag,
+			struct ext2_inode_large *inode, int restart_flag,
 			const char *source)
 {
 	inode->i_flags = 0;
@@ -1841,7 +1842,7 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 				 struct process_block_struct *pb)
 {
 	struct ext2_extent_info info;
-	struct ext2_inode	*inode = pctx->inode;
+	struct ext2_inode_large	*inode = pctx->inode;
 	ext2_extent_handle_t	ehandle;
 	ext2_filsys		fs = ctx->fs;
 	ext2_ino_t		ino = pctx->ino;
@@ -1885,7 +1886,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	ext2_filsys fs = ctx->fs;
 	struct process_block_struct pb;
 	ext2_ino_t	ino = pctx->ino;
-	struct ext2_inode *inode = pctx->inode;
+	struct ext2_inode_large *inode = pctx->inode;
 	int		bad_size = 0;
 	int		dirty_inode = 0;
 	int		extent_fs;
@@ -2671,7 +2672,7 @@ static errcode_t pass1_get_blocks(ext2_filsys fs, ext2_ino_t ino,
 }
 
 static errcode_t pass1_read_inode(ext2_filsys fs, ext2_ino_t ino,
-				  struct ext2_inode *inode)
+				  struct ext2_inode_large *inode)
 {
 	e2fsck_t ctx = (e2fsck_t) fs->priv_data;
 
@@ -2682,7 +2683,7 @@ static errcode_t pass1_read_inode(ext2_filsys fs, ext2_ino_t ino,
 }
 
 static errcode_t pass1_write_inode(ext2_filsys fs, ext2_ino_t ino,
-			    struct ext2_inode *inode)
+			    struct ext2_inode_large *inode)
 {
 	e2fsck_t ctx = (e2fsck_t) fs->priv_data;
 
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 12a03b0..efa68c7 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -78,7 +78,7 @@ struct dup_cluster {
 struct dup_inode {
 	ext2_ino_t		dir;
 	int			num_dupblocks;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	struct cluster_el	*cluster_list;
 };
 
@@ -117,7 +117,7 @@ static int dict_int_cmp(const void *a, const void *b)
  * Add a duplicate block record
  */
 static void add_dupe(e2fsck_t ctx, ext2_ino_t ino, blk64_t cluster,
-		     struct ext2_inode *inode)
+		     struct ext2_inode_large *inode)
 {
 	dnode_t	*n;
 	struct dup_cluster	*db;
@@ -258,7 +258,7 @@ struct process_block_struct {
 	e2fsck_t	ctx;
 	ext2_ino_t	ino;
 	int		dup_blocks;
-	struct ext2_inode *inode;
+	struct ext2_inode_large *inode;
 	struct problem_context *pctx;
 };
 
@@ -266,7 +266,7 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 {
 	ext2_filsys fs = ctx->fs;
 	ext2_ino_t ino;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	ext2_inode_scan	scan;
 	struct process_block_struct pb;
 	struct problem_context pctx;
@@ -606,7 +606,7 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 {
 	ext2_filsys fs = ctx->fs;
 	struct process_block_struct pb;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	struct problem_context	pctx;
 	unsigned int		count;
 
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 2863699..9241a07 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -479,7 +479,7 @@ static _INLINE_ int check_filetype(e2fsck_t ctx,
 {
 	int	filetype = dirent->name_len >> 8;
 	int	should_be = EXT2_FT_UNKNOWN;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 
 	if (!(ctx->fs->super->s_feature_incompat &
 	      EXT2_FEATURE_INCOMPAT_FILETYPE)) {
@@ -1178,7 +1178,7 @@ static int deallocate_inode_block(ext2_filsys fs,
 static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 {
 	ext2_filsys fs = ctx->fs;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	struct problem_context	pctx;
 	__u32			count;
 
@@ -1237,7 +1237,7 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
  */
 static void clear_htree(e2fsck_t ctx, ext2_ino_t ino)
 {
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 
 	e2fsck_read_inode(ctx, ino, &inode, "clear_htree");
 	inode.i_flags = inode.i_flags & ~EXT2_INDEX_FL;
@@ -1251,7 +1251,7 @@ extern int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
 				    ext2_ino_t ino, char *buf)
 {
 	ext2_filsys fs = ctx->fs;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	int			inode_modified = 0;
 	int			not_fixed = 0;
 	unsigned char		*frag, *fsize;
@@ -1404,7 +1404,7 @@ static int allocate_dir_block(e2fsck_t ctx,
 	ext2_filsys fs = ctx->fs;
 	blk64_t			blk;
 	char			*block;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 
 	if (fix_problem(ctx, PR_2_DIRECTORY_HOLE, pctx) == 0)
 		return 1;
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index c067164..2330aab 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -142,7 +142,7 @@ static void check_root(e2fsck_t ctx)
 {
 	ext2_filsys fs = ctx->fs;
 	blk64_t			blk;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	char *			block;
 	struct problem_context	pctx;
 
@@ -357,7 +357,7 @@ ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 	ext2_ino_t			ino;
 	blk64_t			blk;
 	errcode_t		retval;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	char *			block;
 	static const char	name[] = "lost+found";
 	struct 	problem_context	pctx;
@@ -503,7 +503,7 @@ int e2fsck_reconnect_file(e2fsck_t ctx, ext2_ino_t ino)
 	errcode_t	retval;
 	char		name[80];
 	struct problem_context	pctx;
-	struct ext2_inode 	inode;
+	struct ext2_inode_large	inode;
 	int		file_type = 0;
 
 	clear_problem_context(&pctx);
@@ -552,7 +552,7 @@ errcode_t e2fsck_adjust_inode_count(e2fsck_t ctx, ext2_ino_t ino, int adj)
 {
 	ext2_filsys fs = ctx->fs;
 	errcode_t		retval;
-	struct ext2_inode 	inode;
+	struct ext2_inode_large	inode;
 
 	if (!ino)
 		return 0;
@@ -753,7 +753,7 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
 	ext2_filsys fs = ctx->fs;
 	errcode_t	retval;
 	struct expand_dir_struct es;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 
 	if (!(fs->flags & EXT2_FLAG_RW))
 		return EXT2_ET_RO_FILSYS;
diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index 695612b..566854f 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -25,7 +25,7 @@
  * rest of the pass 4 tests.
  */
 static int disconnect_inode(e2fsck_t ctx, ext2_ino_t i,
-			    struct ext2_inode *inode)
+			    struct ext2_inode_large *inode)
 {
 	ext2_filsys fs = ctx->fs;
 	struct problem_context	pctx;
@@ -90,7 +90,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 {
 	ext2_filsys fs = ctx->fs;
 	ext2_ino_t	i;
-	struct ext2_inode	*inode;
+	struct ext2_inode_large	*inode;
 #ifdef RESOURCE_TRACK
 	struct resource_track	rtrack;
 #endif
@@ -98,6 +98,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 	__u16	link_count, link_counted;
 	char	*buf = 0;
 	int	group, maxgroup;
+	int	inode_size;
 
 	init_resource_track(&rtrack, ctx->fs->io);
 
@@ -116,8 +117,10 @@ void e2fsck_pass4(e2fsck_t ctx)
 		if ((ctx->progress)(ctx, 4, 0, maxgroup))
 			return;
 
-	inode = e2fsck_allocate_memory(ctx, EXT2_INODE_SIZE(fs->super),
-				       "scratch inode");
+	inode_size = EXT2_INODE_SIZE(fs->super);
+	if (sizeof(struct ext2_inode_large) > inode_size)
+		inode_size = sizeof(struct ext2_inode_large);
+	inode = e2fsck_allocate_memory(ctx, inode_size, "scratch inode");
 
 	/* Protect loop from wrap-around if s_inodes_count maxed */
 	for (i=1; i <= fs->super->s_inodes_count && i > 0; i++) {
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 8379e0c..a4d96ae 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -14,7 +14,7 @@ typedef __u32 problem_t;
 struct problem_context {
 	errcode_t	errcode;
 	ext2_ino_t ino, ino2, dir;
-	struct ext2_inode *inode;
+	struct ext2_inode_large *inode;
 	struct ext2_dir_entry *dirent;
 	blk64_t	blk, blk2;
 	e2_blkcnt_t	blkcount;
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index e8af323..1263f56 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -53,7 +53,7 @@
 
 struct fill_dir_struct {
 	char *buf;
-	struct ext2_inode *inode;
+	struct ext2_inode_large *inode;
 	int err;
 	e2fsck_t ctx;
 	struct hash_entry *harray;
@@ -670,7 +670,7 @@ static errcode_t write_directory(e2fsck_t ctx, ext2_filsys fs,
 {
 	struct write_dir_struct wd;
 	errcode_t	retval;
-	struct ext2_inode 	inode;
+	struct ext2_inode_large	inode;
 
 	retval = e2fsck_expand_directory(ctx, ino, -1, outdir->num);
 	if (retval)
@@ -704,7 +704,7 @@ errcode_t e2fsck_rehash_dir(e2fsck_t ctx, ext2_ino_t ino)
 {
 	ext2_filsys 		fs = ctx->fs;
 	errcode_t		retval;
-	struct ext2_inode 	inode;
+	struct ext2_inode_large	inode;
 	char			*dir_buf = 0;
 	struct fill_dir_struct	fd;
 	struct out_dir		outdir;
diff --git a/e2fsck/scantest.c b/e2fsck/scantest.c
index ed586b1..01b243d 100644
--- a/e2fsck/scantest.c
+++ b/e2fsck/scantest.c
@@ -95,7 +95,7 @@ int main (int argc, char *argv[])
 	ext2_filsys	fs;
 	ext2_inode_scan	scan;
 	ext2_ino_t	ino;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 
 	printf(_("size of inode=%d\n"), sizeof(inode));
 
diff --git a/e2fsck/super.c b/e2fsck/super.c
index a61eb33..28f041d 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -151,7 +151,7 @@ static int release_inode_block(ext2_filsys fs,
  * not deleted.
  */
 static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
-				struct ext2_inode *inode, char *block_buf,
+				struct ext2_inode_large *inode, char *block_buf,
 				struct problem_context *pctx)
 {
 	struct process_block_struct 	pb;
@@ -226,7 +226,7 @@ static int release_orphan_inodes(e2fsck_t ctx)
 {
 	ext2_filsys fs = ctx->fs;
 	ext2_ino_t	ino, next_ino;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	struct problem_context pctx;
 	char *block_buf;
 
@@ -308,7 +308,7 @@ return_abort:
 void check_resize_inode(e2fsck_t ctx)
 {
 	ext2_filsys fs = ctx->fs;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	struct problem_context	pctx;
 	int		i, gdt_off, ind_off;
 	dgrp_t		j;
diff --git a/e2fsck/util.c b/e2fsck/util.c
index fb9a87a..22e06c2 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -381,7 +381,7 @@ void print_resource_track(e2fsck_t ctx, const char *desc,
 #endif /* RESOURCE_TRACK */
 
 void e2fsck_read_inode(e2fsck_t ctx, unsigned long ino,
-			      struct ext2_inode * inode, const char *proc)
+			      struct ext2_inode_large *inode, const char *proc)
 {
 	int retval;
 
@@ -394,7 +394,7 @@ void e2fsck_read_inode(e2fsck_t ctx, unsigned long ino,
 }
 
 void e2fsck_read_inode_full(e2fsck_t ctx, unsigned long ino,
-			    struct ext2_inode *inode, int bufsize,
+			    struct ext2_inode_large *inode, int bufsize,
 			    const char *proc)
 {
 	int retval;
@@ -408,7 +408,7 @@ void e2fsck_read_inode_full(e2fsck_t ctx, unsigned long ino,
 }
 
 extern void e2fsck_write_inode_full(e2fsck_t ctx, unsigned long ino,
-			       struct ext2_inode * inode, int bufsize,
+			       struct ext2_inode_large *inode, int bufsize,
 			       const char *proc)
 {
 	int retval;
@@ -422,7 +422,7 @@ extern void e2fsck_write_inode_full(e2fsck_t ctx, unsigned long ino,
 }
 
 extern void e2fsck_write_inode(e2fsck_t ctx, unsigned long ino,
-			       struct ext2_inode * inode, const char *proc)
+			       struct ext2_inode_large *inode, const char *proc)
 {
 	int retval;
 
diff --git a/ext2ed/dir_com.c b/ext2ed/dir_com.c
index b023e7a..8c49af3 100644
--- a/ext2ed/dir_com.c
+++ b/ext2ed/dir_com.c
@@ -48,7 +48,7 @@ directories.
 */
 
 {
-	struct ext2_inode *ptr;
+	struct ext2_inode_large *ptr;
 
 	ptr=&type_data.u.t_ext2_inode;					/* type_data contains the inode */
 
diff --git a/ext2ed/doc/ext2ed-design.sgml b/ext2ed/doc/ext2ed-design.sgml
index ad2df96..7f42a1a 100644
--- a/ext2ed/doc/ext2ed-design.sgml
+++ b/ext2ed/doc/ext2ed-design.sgml
@@ -1955,7 +1955,7 @@ struct struct_type_data {
 		struct ext2_acl_entry t_ext2_acl_entry;
 		struct ext2_old_group_desc t_ext2_old_group_desc;
 		struct ext2_group_desc t_ext2_group_desc;
-		struct ext2_inode t_ext2_inode;
+		struct ext2_inode_large t_ext2_inode;
 		struct ext2_super_block t_ext2_super_block;
 		struct ext2_dir_entry t_ext2_dir_entry;
 	} u;
@@ -2703,7 +2703,7 @@ directory.
 <Para>
 
 <ProgramListing>
-struct ext2_inode {
+struct ext2_inode_large {
 	__u16	i_mode;		/* File mode */
 	__u16	i_uid;		/* Owner Uid */
 	__u32	i_size;		/* Size in bytes */
@@ -2873,7 +2873,7 @@ initialized:
 <ProgramListing>
 struct struct_file_info {
 
-	struct ext2_inodes *inode_ptr;
+	struct ext2_inode_larges *inode_ptr;
 	
 	long inode_offset;
 	long global_block_num,global_block_offset;
diff --git a/ext2ed/doc/ext2fs-overview.sgml b/ext2ed/doc/ext2fs-overview.sgml
index a6ebf5a..119cc26 100644
--- a/ext2ed/doc/ext2fs-overview.sgml
+++ b/ext2ed/doc/ext2fs-overview.sgml
@@ -461,7 +461,7 @@ Follows the structure of an inode in Ext2fs:
 <Para>
 
 <ProgramListing>
-struct ext2_inode {
+struct ext2_inode_large {
 	__u16	i_mode;		/* File mode */
 	__u16	i_uid;		/* Owner Uid */
 	__u32	i_size;		/* Size in bytes */
diff --git a/ext2ed/ext2.descriptors b/ext2ed/ext2.descriptors
index bf927b0..abd81f6 100644
--- a/ext2ed/ext2.descriptors
+++ b/ext2ed/ext2.descriptors
@@ -72,7 +72,7 @@ struct ext2_group_desc
 /*
  * Structure of an inode on the disk
  */
-struct ext2_inode {
+struct ext2_inode_large {
 	__u16 i_mode;		/* File mode */
 	__u16 i_uid;		/* Owner Uid */
 	__u32  i_size;		/* Size in bytes */
diff --git a/ext2ed/ext2ed.h b/ext2ed/ext2ed.h
index 2ee483e..32161f5 100644
--- a/ext2ed/ext2ed.h
+++ b/ext2ed/ext2ed.h
@@ -112,7 +112,7 @@ struct struct_type_data {				/* The object's data is usually here */
 		struct ext2_acl_header t_ext2_acl_header;
 		struct ext2_acl_entry t_ext2_acl_entry;
 		struct ext2_group_desc t_ext2_group_desc;
-		struct ext2_inode t_ext2_inode;
+		struct ext2_inode_large t_ext2_inode;
 		struct ext2_super_block t_ext2_super_block;
 		struct ext2_dir_entry t_ext2_dir_entry;
 	} u;
@@ -132,7 +132,7 @@ struct struct_file_system_info {			/* Important information about the filesystem
 
 struct struct_file_info {				/* Used to handle files and directories */
 
-	struct ext2_inode *inode_ptr;
+	struct ext2_inode_large *inode_ptr;
 
 	long inode_offset;
 	long global_block_num,global_block_offset;
diff --git a/ext2ed/file_com.c b/ext2ed/file_com.c
index 9772f66..0fdedaf 100644
--- a/ext2ed/file_com.c
+++ b/ext2ed/file_com.c
@@ -23,7 +23,7 @@ Copyright (C) 1995 Gadi Oxman
 int init_file_info (void)
 
 {
-	struct ext2_inode *ptr;
+	struct ext2_inode_large *ptr;
 
 	ptr=&type_data.u.t_ext2_inode;
 
diff --git a/ext2ed/init.c b/ext2ed/init.c
index 3815ab5..af47cd2 100644
--- a/ext2ed/init.c
+++ b/ext2ed/init.c
@@ -418,7 +418,7 @@ int set_file_system_info (void)
 		file_system_info.groups_count = ext2fs_div64_ceil(ext2fs_blocks_count(sb),
 						 sb->s_blocks_per_group);
 
-		file_system_info.inodes_per_block=file_system_info.block_size/sizeof (struct ext2_inode);
+		file_system_info.inodes_per_block=file_system_info.block_size/EXT2_GOOD_OLD_INODE_SIZE;
 		file_system_info.blocks_per_group=sb->s_inodes_per_group/file_system_info.inodes_per_block;
 		file_system_info.no_blocks_in_group=sb->s_blocks_per_group;
 		file_system_info.file_system_size=(ext2fs_blocks_count(sb)-1)*file_system_info.block_size;
diff --git a/ext2ed/inode_com.c b/ext2ed/inode_com.c
index 8d4b9f3..b2fa692 100644
--- a/ext2ed/inode_com.c
+++ b/ext2ed/inode_com.c
@@ -43,13 +43,13 @@ void type_ext2_inode___prev (char *command_line)
 
 	low_read ((char *) &desc,sizeof (struct ext2_group_desc),group_offset);
 
-	entry_num=(device_offset-desc.bg_inode_table*file_system_info.block_size)/sizeof (struct ext2_inode);
+	entry_num=(device_offset-desc.bg_inode_table*file_system_info.block_size)/EXT2_GOOD_OLD_INODE_SIZE;
 
 	first_entry=0;last_entry=file_system_info.super_block.s_inodes_per_group-1;
 	inode_num=0;
 
 	if (entry_num-mult+1>0) {
-		device_offset-=sizeof (struct ext2_inode)*mult;
+		device_offset-=sizeof (struct ext2_inode_large)*mult;
 		entry_num-=mult;
 
 		sprintf (buffer,"setoffset %ld",device_offset);dispatch (buffer);
@@ -91,13 +91,13 @@ void type_ext2_inode___next (char *command_line)
 
 	low_read ((char *) &desc,sizeof (struct ext2_group_desc),group_offset);
 
-	entry_num=(device_offset-desc.bg_inode_table*file_system_info.block_size)/sizeof (struct ext2_inode);
+	entry_num=(device_offset-desc.bg_inode_table*file_system_info.block_size)/EXT2_GOOD_OLD_INODE_SIZE;
 
 	first_entry=0;last_entry=file_system_info.super_block.s_inodes_per_group-1;
 	inode_num=0;
 
 	if (entry_num+mult-1<last_entry) {
-		device_offset+=sizeof (struct ext2_inode)*mult;
+		device_offset+=sizeof (struct ext2_inode_large)*mult;
 		entry_num+=mult;
 
 		sprintf (buffer,"setoffset %ld",device_offset);dispatch (buffer);
@@ -118,7 +118,7 @@ void type_ext2_inode___next (char *command_line)
 void type_ext2_inode___show (char *command_line)
 
 {
-	struct ext2_inode *inode_ptr;
+	struct ext2_inode_large *inode_ptr;
 
 	unsigned short temp;
 	int i;
@@ -133,7 +133,7 @@ void type_ext2_inode___show (char *command_line)
 
 	low_read ((char *) &desc,sizeof (struct ext2_group_desc),group_offset);
 
-	entry_num=(device_offset-desc.bg_inode_table*file_system_info.block_size)/sizeof (struct ext2_inode);
+	entry_num=(device_offset-desc.bg_inode_table*file_system_info.block_size)/EXT2_GOOD_OLD_INODE_SIZE;
 	first_entry=0;last_entry=file_system_info.super_block.s_inodes_per_group-1;
 	inode_num=group_num*file_system_info.super_block.s_inodes_per_group+1;
 	inode_num+=entry_num;
@@ -299,7 +299,7 @@ void type_ext2_inode___entry (char *command_line)
 
 	low_read ((char *) &desc,sizeof (struct ext2_group_desc),group_offset);
 
-	entry_num=(device_offset-desc.bg_inode_table*file_system_info.block_size)/sizeof (struct ext2_inode);
+	entry_num=(device_offset-desc.bg_inode_table*file_system_info.block_size)/EXT2_GOOD_OLD_INODE_SIZE;
 
 	if (wanted_entry > entry_num) {
 		sprintf (buffer,"next %ld",wanted_entry-entry_num);
@@ -409,7 +409,7 @@ long int inode_offset_to_inode_num (long inode_offset)
 
 	low_read ((char *) &desc,sizeof (struct ext2_group_desc),group_offset);
 
-	entry_num=(inode_offset-desc.bg_inode_table*file_system_info.block_size)/sizeof (struct ext2_inode);
+	entry_num=(inode_offset-desc.bg_inode_table*file_system_info.block_size)/EXT2_GOOD_OLD_INODE_SIZE;
 	first_entry=0;last_entry=file_system_info.super_block.s_inodes_per_group-1;
 	inode_num=group_num*file_system_info.super_block.s_inodes_per_group+1;
 	inode_num+=entry_num;
@@ -430,7 +430,7 @@ long int inode_num_to_inode_offset (long inode_num)
 	group_offset=file_system_info.first_group_desc_offset+group_num*sizeof (struct ext2_group_desc);
 	low_read ((char *) &desc,sizeof (struct ext2_group_desc),group_offset);
 
-	inode_offset=desc.bg_inode_table*file_system_info.block_size+inode_entry*sizeof (struct ext2_inode);
+	inode_offset=desc.bg_inode_table*file_system_info.block_size+inode_entry*EXT2_GOOD_OLD_INODE_SIZE;
 
 	return (inode_offset);
 }
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index 0f36f40..aa4a389 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -188,7 +188,7 @@ static __u64 e2p_free_blocks_count(struct ext2_super_block *super)
 }
 
 #ifndef EXT2_INODE_SIZE
-#define EXT2_INODE_SIZE(s) sizeof(struct ext2_inode)
+#define EXT2_INODE_SIZE(s) sizeof(struct ext2_inode_large)
 #endif
 
 #ifndef EXT2_GOOD_OLD_REV
diff --git a/lib/ext2fs/bb_inode.c b/lib/ext2fs/bb_inode.c
index 0b6c3dd..dbc29d6 100644
--- a/lib/ext2fs/bb_inode.c
+++ b/lib/ext2fs/bb_inode.c
@@ -58,7 +58,7 @@ errcode_t ext2fs_update_bb_inode(ext2_filsys fs, ext2_badblocks_list bb_list)
 {
 	errcode_t			retval;
 	struct set_badblock_record 	rec;
-	struct ext2_inode		inode;
+	struct ext2_inode_large		inode;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index b3e6dca..7e7fcd8 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -46,7 +46,7 @@ blk64_t ext2fs_group_last_block2(ext2_filsys fs, dgrp_t group)
  * Return the inode data block count
  */
 blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
-					struct ext2_inode *inode)
+					struct ext2_inode_large *inode)
 {
 	return (inode->i_blocks |
 		((fs->super->s_feature_ro_compat &
@@ -59,7 +59,7 @@ blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
  * Return the inode i_blocks count
  */
 blk64_t ext2fs_inode_i_blocks(ext2_filsys fs,
-					struct ext2_inode *inode)
+					struct ext2_inode_large *inode)
 {
 	return (inode->i_blocks |
 		((fs->super->s_feature_ro_compat &
@@ -460,7 +460,7 @@ void ext2fs_bg_checksum_set(ext2_filsys fs, dgrp_t group, __u16 checksum)
  * called don't have access to the fs struct, and the high bits should
  * be 0 in the non-64-bit case anyway.
  */
-blk64_t ext2fs_file_acl_block(const struct ext2_inode *inode)
+blk64_t ext2fs_file_acl_block(const struct ext2_inode_large *inode)
 {
 	return (inode->i_file_acl |
 		(__u64) inode->osd2.linux2.l_i_file_acl_high << 32);
@@ -469,7 +469,7 @@ blk64_t ext2fs_file_acl_block(const struct ext2_inode *inode)
 /*
  * Set the acl block of a file
  */
-void ext2fs_file_acl_block_set(struct ext2_inode *inode, blk64_t blk)
+void ext2fs_file_acl_block_set(struct ext2_inode_large *inode, blk64_t blk)
 {
 	inode->i_file_acl = blk;
 	inode->osd2.linux2.l_i_file_acl_high = (__u64) blk >> 32;
diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index 95ad31e..f193dc2 100644
--- a/lib/ext2fs/block.c
+++ b/lib/ext2fs/block.c
@@ -331,7 +331,7 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 {
 	int	i;
 	int	r, ret = 0;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	errcode_t	retval;
 	struct block_context ctx;
 	int	limit;
diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index 7a515be..26f2074 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -26,7 +26,7 @@
 #endif
 
 extern errcode_t ext2fs_bmap(ext2_filsys fs, ext2_ino_t ino,
-			     struct ext2_inode *inode,
+			     struct ext2_inode_large *inode,
 			     char *block_buf, int bmap_flags,
 			     blk_t block, blk_t *phys_blk);
 
@@ -130,14 +130,14 @@ static _BMAP_INLINE_ errcode_t block_tind_bmap(ext2_filsys fs, int flags,
 }
 
 static errcode_t extent_bmap(ext2_filsys fs, ext2_ino_t ino,
-			     struct ext2_inode *inode,
+			     struct ext2_inode_large *inode,
 			     ext2_extent_handle_t handle,
 			     char *block_buf, int bmap_flags, blk64_t block,
 			     int *ret_flags, int *blocks_alloc,
 			     blk64_t *phys_blk);
 
 static errcode_t implied_cluster_alloc(ext2_filsys fs, ext2_ino_t ino,
-				       struct ext2_inode *inode,
+				       struct ext2_inode_large *inode,
 				       ext2_extent_handle_t handle,
 				       blk64_t block, blk64_t *phys_blk)
 {
@@ -164,7 +164,7 @@ static errcode_t implied_cluster_alloc(ext2_filsys fs, ext2_ino_t ino,
 }
 
 static errcode_t extent_bmap(ext2_filsys fs, ext2_ino_t ino,
-			     struct ext2_inode *inode,
+			     struct ext2_inode_large *inode,
 			     ext2_extent_handle_t handle,
 			     char *block_buf, int bmap_flags, blk64_t block,
 			     int *ret_flags, int *blocks_alloc,
@@ -229,11 +229,12 @@ got_block:
 }
 
 
-errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
+errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino,
+		       struct ext2_inode_large *inode,
 		       char *block_buf, int bmap_flags, blk64_t block,
 		       int *ret_flags, blk64_t *phys_blk)
 {
-	struct ext2_inode inode_buf;
+	struct ext2_inode_large inode_buf;
 	ext2_extent_handle_t handle = 0;
 	blk_t addr_per_block;
 	blk_t	b, blk32;
@@ -379,7 +380,8 @@ done:
 	return retval;
 }
 
-errcode_t ext2fs_bmap(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
+errcode_t ext2fs_bmap(ext2_filsys fs, ext2_ino_t ino,
+		      struct ext2_inode_large *inode,
 		      char *block_buf, int bmap_flags, blk_t block,
 		      blk_t *phys_blk)
 {
diff --git a/lib/ext2fs/bmove.c b/lib/ext2fs/bmove.c
index deabf38..1443f57 100644
--- a/lib/ext2fs/bmove.c
+++ b/lib/ext2fs/bmove.c
@@ -27,7 +27,7 @@
 
 struct process_block_struct {
 	ext2_ino_t		ino;
-	struct ext2_inode *	inode;
+	struct ext2_inode_large	*inode;
 	ext2fs_block_bitmap	reserve;
 	ext2fs_block_bitmap	alloc_map;
 	errcode_t		error;
@@ -99,7 +99,7 @@ errcode_t ext2fs_move_blocks(ext2_filsys fs,
 			     int flags)
 {
 	ext2_ino_t	ino;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	errcode_t	retval;
 	struct process_block_struct pb;
 	ext2_inode_scan	scan;
diff --git a/lib/ext2fs/expanddir.c b/lib/ext2fs/expanddir.c
index 8f738c8..ee90970 100644
--- a/lib/ext2fs/expanddir.c
+++ b/lib/ext2fs/expanddir.c
@@ -91,7 +91,7 @@ errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir)
 {
 	errcode_t	retval;
 	struct expand_dir_struct es;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 54cb3d4..e342bf0 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -329,53 +329,6 @@ struct ext4_new_group_input {
 #define EXT4_IOC_GROUP_ADD		_IOW('f', 8,struct ext4_new_group_input)
 
 /*
- * Structure of an inode on the disk
- */
-struct ext2_inode {
-	__u16	i_mode;		/* File mode */
-	__u16	i_uid;		/* Low 16 bits of Owner Uid */
-	__u32	i_size;		/* Size in bytes */
-	__u32	i_atime;	/* Access time */
-	__u32	i_ctime;	/* Inode change time */
-	__u32	i_mtime;	/* Modification time */
-	__u32	i_dtime;	/* Deletion Time */
-	__u16	i_gid;		/* Low 16 bits of Group Id */
-	__u16	i_links_count;	/* Links count */
-	__u32	i_blocks;	/* Blocks count */
-	__u32	i_flags;	/* File flags */
-	union {
-		struct {
-			__u32	l_i_version; /* was l_i_reserved1 */
-		} linux1;
-		struct {
-			__u32  h_i_translator;
-		} hurd1;
-	} osd1;				/* OS dependent 1 */
-	__u32	i_block[EXT2_N_BLOCKS];/* Pointers to blocks */
-	__u32	i_generation;	/* File version (for NFS) */
-	__u32	i_file_acl;	/* File ACL */
-	__u32	i_size_high;	/* Formerly i_dir_acl, directory ACL */
-	__u32	i_faddr;	/* Fragment address */
-	union {
-		struct {
-			__u16	l_i_blocks_hi;
-			__u16	l_i_file_acl_high;
-			__u16	l_i_uid_high;	/* these 2 fields    */
-			__u16	l_i_gid_high;	/* were reserved2[0] */
-			__u32	l_i_reserved2;
-		} linux2;
-		struct {
-			__u8	h_i_frag;	/* Fragment number */
-			__u8	h_i_fsize;	/* Fragment size */
-			__u16	h_i_mode_high;
-			__u16	h_i_uid_high;
-			__u16	h_i_gid_high;
-			__u32	h_i_author;
-		} hurd2;
-	} osd2;				/* OS dependent 2 */
-};
-
-/*
  * Permanent part of an large inode on the disk
  */
 struct ext2_inode_large {
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index dc83fb0..b290a1f 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -229,9 +229,9 @@ struct struct_ext2_filsys {
 	errcode_t (*check_directory)(ext2_filsys fs, ext2_ino_t ino);
 	errcode_t (*write_bitmaps)(ext2_filsys fs);
 	errcode_t (*read_inode)(ext2_filsys fs, ext2_ino_t ino,
-				struct ext2_inode *inode);
+				struct ext2_inode_large *inode);
 	errcode_t (*write_inode)(ext2_filsys fs, ext2_ino_t ino,
-				struct ext2_inode *inode);
+				struct ext2_inode_large *inode);
 	ext2_badblocks_list		badblocks;
 	ext2_dblist			dblist;
 	__u32				stride;	/* for mke2fs */
@@ -758,9 +758,9 @@ extern dgrp_t ext2fs_group_of_blk2(ext2_filsys fs, blk64_t);
 extern blk64_t ext2fs_group_first_block2(ext2_filsys fs, dgrp_t group);
 extern blk64_t ext2fs_group_last_block2(ext2_filsys fs, dgrp_t group);
 extern blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
-					 struct ext2_inode *inode);
+					 struct ext2_inode_large *inode);
 extern blk64_t ext2fs_inode_i_blocks(ext2_filsys fs,
-					 struct ext2_inode *inode);
+					 struct ext2_inode_large *inode);
 extern blk64_t ext2fs_blocks_count(struct ext2_super_block *super);
 extern void ext2fs_blocks_count_set(struct ext2_super_block *super,
 				    blk64_t blk);
@@ -807,9 +807,11 @@ extern int ext2fs_bg_flags_test(ext2_filsys fs, dgrp_t group, __u16 bg_flag);
 extern void ext2fs_bg_flags_set(ext2_filsys fs, dgrp_t group, __u16 bg_flags);
 extern void ext2fs_bg_flags_clear(ext2_filsys fs, dgrp_t group, __u16 bg_flags);
 extern __u16 ext2fs_bg_checksum(ext2_filsys fs, dgrp_t group);
-extern void ext2fs_bg_checksum_set(ext2_filsys fs, dgrp_t group, __u16 checksum);
-extern blk64_t ext2fs_file_acl_block(const struct ext2_inode *inode);
-extern void ext2fs_file_acl_block_set(struct ext2_inode *inode, blk64_t blk);
+extern void ext2fs_bg_checksum_set(ext2_filsys fs, dgrp_t group,
+				   __u16 checksum);
+extern blk64_t ext2fs_file_acl_block(const struct ext2_inode_large *inode);
+extern void ext2fs_file_acl_block_set(struct ext2_inode_large *inode,
+				      blk64_t blk);
 
 /* block.c */
 extern errcode_t ext2fs_block_iterate(ext2_filsys fs,
@@ -846,11 +848,11 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 
 /* bmap.c */
 extern errcode_t ext2fs_bmap(ext2_filsys fs, ext2_ino_t ino,
-			     struct ext2_inode *inode,
+			     struct ext2_inode_large *inode,
 			     char *block_buf, int bmap_flags,
 			     blk_t block, blk_t *phys_blk);
 extern errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino,
-			      struct ext2_inode *inode,
+			      struct ext2_inode_large *inode,
 			      char *block_buf, int bmap_flags, blk64_t block,
 			      int *ret_flags, blk64_t *phys_blk);
 
@@ -1017,7 +1019,7 @@ extern errcode_t ext2fs_extent_header_verify(void *ptr, int size);
 extern errcode_t ext2fs_extent_open(ext2_filsys fs, ext2_ino_t ino,
 				    ext2_extent_handle_t *handle);
 extern errcode_t ext2fs_extent_open2(ext2_filsys fs, ext2_ino_t ino,
-					struct ext2_inode *inode,
+					struct ext2_inode_large *inode,
 					ext2_extent_handle_t *ret_handle);
 extern void ext2fs_extent_free(ext2_extent_handle_t handle);
 extern errcode_t ext2fs_extent_get(ext2_extent_handle_t handle,
@@ -1037,12 +1039,12 @@ extern errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
 
 /* fileio.c */
 extern errcode_t ext2fs_file_open2(ext2_filsys fs, ext2_ino_t ino,
-				   struct ext2_inode *inode,
+				   struct ext2_inode_large *inode,
 				   int flags, ext2_file_t *ret);
 extern errcode_t ext2fs_file_open(ext2_filsys fs, ext2_ino_t ino,
 				  int flags, ext2_file_t *ret);
 extern ext2_filsys ext2fs_file_get_fs(ext2_file_t file);
-struct ext2_inode *ext2fs_file_get_inode(ext2_file_t file);
+struct ext2_inode_large *ext2fs_file_get_inode(ext2_file_t file);
 extern errcode_t ext2fs_file_close(ext2_file_t file);
 extern errcode_t ext2fs_file_flush(ext2_file_t file);
 extern errcode_t ext2fs_file_read(ext2_file_t file, void *buf,
@@ -1147,11 +1149,12 @@ errcode_t ext2fs_get_device_sectsize(const char *file, int *sectsize);
 errcode_t ext2fs_get_device_phys_sectsize(const char *file, int *sectsize);
 
 /* i_block.c */
-errcode_t ext2fs_iblk_add_blocks(ext2_filsys fs, struct ext2_inode *inode,
+errcode_t ext2fs_iblk_add_blocks(ext2_filsys fs, struct ext2_inode_large *inode,
 				 blk64_t num_blocks);
-errcode_t ext2fs_iblk_sub_blocks(ext2_filsys fs, struct ext2_inode *inode,
+errcode_t ext2fs_iblk_sub_blocks(ext2_filsys fs, struct ext2_inode_large *inode,
 				 blk64_t num_blocks);
-errcode_t ext2fs_iblk_set(ext2_filsys fs, struct ext2_inode *inode, blk64_t b);
+errcode_t ext2fs_iblk_set(ext2_filsys fs, struct ext2_inode_large *inode,
+			  blk64_t b);
 
 /* imager.c */
 extern errcode_t ext2fs_image_inode_write(ext2_filsys fs, int fd, int flags);
@@ -1195,13 +1198,13 @@ errcode_t ext2fs_icount_validate(ext2_icount_t icount, FILE *);
 extern errcode_t ext2fs_flush_icache(ext2_filsys fs);
 extern errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan,
 					    ext2_ino_t *ino,
-					    struct ext2_inode *inode,
+					    struct ext2_inode_large *inode,
 					    int bufsize);
 extern errcode_t ext2fs_open_inode_scan(ext2_filsys fs, int buffer_blocks,
 				  ext2_inode_scan *ret_scan);
 extern void ext2fs_close_inode_scan(ext2_inode_scan scan);
 extern errcode_t ext2fs_get_next_inode(ext2_inode_scan scan, ext2_ino_t *ino,
-			       struct ext2_inode *inode);
+			       struct ext2_inode_large *inode);
 extern errcode_t ext2fs_inode_scan_goto_blockgroup(ext2_inode_scan scan,
 						   int	group);
 extern void ext2fs_set_inode_callback
@@ -1214,17 +1217,17 @@ extern void ext2fs_set_inode_callback
 extern int ext2fs_inode_scan_flags(ext2_inode_scan scan, int set_flags,
 				   int clear_flags);
 extern errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
-					struct ext2_inode * inode,
+					struct ext2_inode_large *inode,
 					int bufsize);
 extern errcode_t ext2fs_read_inode (ext2_filsys fs, ext2_ino_t ino,
-			    struct ext2_inode * inode);
+			    struct ext2_inode_large *inode);
 extern errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
-					 struct ext2_inode * inode,
+					 struct ext2_inode_large *inode,
 					 int bufsize);
 extern errcode_t ext2fs_write_inode(ext2_filsys fs, ext2_ino_t ino,
-			    struct ext2_inode * inode);
+			    struct ext2_inode_large *inode);
 extern errcode_t ext2fs_write_new_inode(ext2_filsys fs, ext2_ino_t ino,
-			    struct ext2_inode * inode);
+			    struct ext2_inode_large *inode);
 extern errcode_t ext2fs_get_blocks(ext2_filsys fs, ext2_ino_t ino, blk_t *blocks);
 extern errcode_t ext2fs_check_directory(ext2_filsys fs, ext2_ino_t ino);
 
@@ -1233,7 +1236,7 @@ extern io_manager inode_io_manager;
 extern errcode_t ext2fs_inode_io_intern(ext2_filsys fs, ext2_ino_t ino,
 					char **name);
 extern errcode_t ext2fs_inode_io_intern2(ext2_filsys fs, ext2_ino_t ino,
-					 struct ext2_inode *inode,
+					 struct ext2_inode_large *inode,
 					 char **name);
 
 /* ismounted.c */
@@ -1243,7 +1246,7 @@ extern errcode_t ext2fs_check_mount_point(const char *device, int *mount_flags,
 
 /* punch.c */
 extern errcode_t ext2fs_punch(ext2_filsys fs, ext2_ino_t ino,
-			      struct ext2_inode *inode,
+			      struct ext2_inode_large *inode,
 			      char *block_buf, blk64_t start,
 			      blk64_t end);
 
@@ -1341,11 +1344,11 @@ extern void ext2fs_swap_group_desc2(ext2_filsys, struct ext2_group_desc *gdp);
 extern void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 				   struct ext2_inode_large *f, int hostorder,
 				   int bufsize);
-extern void ext2fs_swap_inode(ext2_filsys fs,struct ext2_inode *t,
-			      struct ext2_inode *f, int hostorder);
+extern void ext2fs_swap_inode(ext2_filsys fs, struct ext2_inode_large *t,
+			      struct ext2_inode_large *f, int hostorder);
 
 /* valid_blk.c */
-extern int ext2fs_inode_has_valid_blocks(struct ext2_inode *inode);
+extern int ext2fs_inode_has_valid_blocks(struct ext2_inode_large *inode);
 
 /* version.c */
 extern int ext2fs_parse_version_string(const char *ver_string);
@@ -1385,7 +1388,7 @@ extern int ext2fs_group_of_ino(ext2_filsys fs, ext2_ino_t ino);
 extern blk_t ext2fs_group_first_block(ext2_filsys fs, dgrp_t group);
 extern blk_t ext2fs_group_last_block(ext2_filsys fs, dgrp_t group);
 extern blk_t ext2fs_inode_data_blocks(ext2_filsys fs,
-				      struct ext2_inode *inode);
+				      struct ext2_inode_large *inode);
 extern unsigned int ext2fs_div_ceil(unsigned int a, unsigned int b);
 extern __u64 ext2fs_div64_ceil(__u64 a, __u64 b);
 
@@ -1616,7 +1619,7 @@ _INLINE_ blk_t ext2fs_group_last_block(ext2_filsys fs, dgrp_t group)
 }
 
 _INLINE_ blk_t ext2fs_inode_data_blocks(ext2_filsys fs,
-					struct ext2_inode *inode)
+					struct ext2_inode_large *inode)
 {
 	return ext2fs_inode_data_blocks2(fs, inode);
 }
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index b182d7f..27c4332 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -73,7 +73,7 @@ struct ext2_inode_cache {
 
 struct ext2_inode_cache_ent {
 	ext2_ino_t		ino;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 };
 
 /* Function prototypes */
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index abb60dd..33f1a88 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -52,8 +52,8 @@ struct ext2_extent_handle {
 	errcode_t		magic;
 	ext2_filsys		fs;
 	ext2_ino_t 		ino;
-	struct ext2_inode	*inode;
-	struct ext2_inode	inodebuf;
+	struct ext2_inode_large	*inode;
+	struct ext2_inode_large	inodebuf;
 	int			type;
 	int			level;
 	int			max_depth;
@@ -183,7 +183,7 @@ extern errcode_t ext2fs_extent_open(ext2_filsys fs, ext2_ino_t ino,
 }
 
 extern errcode_t ext2fs_extent_open2(ext2_filsys fs, ext2_ino_t ino,
-				    struct ext2_inode *inode,
+				    struct ext2_inode_large *inode,
 				    ext2_extent_handle_t *ret_handle)
 {
 	struct ext2_extent_handle	*handle;
diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 324f046..6d139e5 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -22,7 +22,7 @@ struct ext2_file {
 	errcode_t		magic;
 	ext2_filsys 		fs;
 	ext2_ino_t		ino;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	int 			flags;
 	__u64			pos;
 	blk64_t			blockno;
@@ -33,7 +33,7 @@ struct ext2_file {
 #define BMAP_BUFFER (file->buf + fs->blocksize)
 
 errcode_t ext2fs_file_open2(ext2_filsys fs, ext2_ino_t ino,
-			    struct ext2_inode *inode,
+			    struct ext2_inode_large *inode,
 			    int flags, ext2_file_t *ret)
 {
 	ext2_file_t 	file;
@@ -58,7 +58,7 @@ errcode_t ext2fs_file_open2(ext2_filsys fs, ext2_ino_t ino,
 	file->flags = flags & EXT2_FILE_MASK;
 
 	if (inode) {
-		memcpy(&file->inode, inode, sizeof(struct ext2_inode));
+		memcpy(&file->inode, inode, sizeof(struct ext2_inode_large));
 	} else {
 		retval = ext2fs_read_inode(fs, ino, &file->inode);
 		if (retval)
@@ -98,7 +98,7 @@ ext2_filsys ext2fs_file_get_fs(ext2_file_t file)
 /*
  * This function returns the pointer to the inode of a file from the structure
  */
-struct ext2_inode *ext2fs_file_get_inode(ext2_file_t file)
+struct ext2_inode_large *ext2fs_file_get_inode(ext2_file_t file)
 {
 	if (file->magic != EXT2_ET_MAGIC_EXT2_FILE)
 		return NULL;
diff --git a/lib/ext2fs/i_block.c b/lib/ext2fs/i_block.c
index f36c3c4..1801570 100644
--- a/lib/ext2fs/i_block.c
+++ b/lib/ext2fs/i_block.c
@@ -26,7 +26,7 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
-errcode_t ext2fs_iblk_add_blocks(ext2_filsys fs, struct ext2_inode *inode,
+errcode_t ext2fs_iblk_add_blocks(ext2_filsys fs, struct ext2_inode_large *inode,
 				 blk64_t num_blocks)
 {
 	unsigned long long b = inode->i_blocks;
@@ -50,7 +50,7 @@ errcode_t ext2fs_iblk_add_blocks(ext2_filsys fs, struct ext2_inode *inode,
 	return 0;
 }
 
-errcode_t ext2fs_iblk_sub_blocks(ext2_filsys fs, struct ext2_inode *inode,
+errcode_t ext2fs_iblk_sub_blocks(ext2_filsys fs, struct ext2_inode_large *inode,
 				 blk64_t num_blocks)
 {
 	unsigned long long b = inode->i_blocks;
@@ -75,7 +75,8 @@ errcode_t ext2fs_iblk_sub_blocks(ext2_filsys fs, struct ext2_inode *inode,
 	return 0;
 }
 
-errcode_t ext2fs_iblk_set(ext2_filsys fs, struct ext2_inode *inode, blk64_t b)
+errcode_t ext2fs_iblk_set(ext2_filsys fs, struct ext2_inode_large *inode,
+			  blk64_t b)
 {
 	if (!(fs->super->s_feature_ro_compat &
 	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index ccc2dee..96a93b9 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -180,7 +180,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	if (super->s_rev_level >= EXT2_DYNAMIC_REV) {
 		set_field(s_first_ino, EXT2_GOOD_OLD_FIRST_INO);
 		set_field(s_inode_size, EXT2_GOOD_OLD_INODE_SIZE);
-		if (super->s_inode_size >= sizeof(struct ext2_inode_large)) {
+		if (super->s_inode_size >= EXT2_GOOD_OLD_INODE_SIZE) {
 			int extra_isize = sizeof(struct ext2_inode_large) -
 				EXT2_GOOD_OLD_INODE_SIZE;
 			set_field(s_min_extra_isize, extra_isize);
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 829e032..76893fd 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -402,13 +402,17 @@ static inline int is_empty_scan(ext2_inode_scan scan)
 #endif
 
 errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
-				     struct ext2_inode *inode, int bufsize)
+				     struct ext2_inode_large *inode,
+				     int bufsize)
 {
 	errcode_t	retval;
 	int		extra_bytes = 0;
 
 	EXT2_CHECK_MAGIC(scan, EXT2_ET_MAGIC_INODE_SCAN);
 
+	if (bufsize > scan->inode_size)
+		bufsize = scan->inode_size;
+
 	/*
 	 * Do we need to start reading a new block group?
 	 */
@@ -482,7 +486,7 @@ errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
 			       (struct ext2_inode_large *) scan->temp_buffer,
 			       0, bufsize);
 #else
-		*inode = *((struct ext2_inode *) scan->temp_buffer);
+		*inode = *((struct ext2_inode_large *) scan->temp_buffer);
 #endif
 		if (scan->scan_flags & EXT2_SF_BAD_EXTRA_BYTES)
 			retval = EXT2_ET_BAD_BLOCK_IN_INODE_TABLE;
@@ -502,6 +506,8 @@ errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
 		if (scan->scan_flags & EXT2_SF_BAD_INODE_BLK)
 			retval = EXT2_ET_BAD_BLOCK_IN_INODE_TABLE;
 	}
+	if (EXT2_INODE_SIZE(scan->fs->super) == EXT2_GOOD_OLD_INODE_SIZE)
+		inode->i_extra_isize = 0;
 
 	scan->inodes_left--;
 	scan->current_inode++;
@@ -510,17 +516,17 @@ errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
 }
 
 errcode_t ext2fs_get_next_inode(ext2_inode_scan scan, ext2_ino_t *ino,
-				struct ext2_inode *inode)
+				struct ext2_inode_large *inode)
 {
 	return ext2fs_get_next_inode_full(scan, ino, inode,
-						sizeof(struct ext2_inode));
+					  sizeof(struct ext2_inode_large));
 }
 
 /*
  * Functions to read and write a single inode.
  */
 errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
-				 struct ext2_inode * inode, int bufsize)
+				 struct ext2_inode_large *inode, int bufsize)
 {
 	blk64_t		block_nr;
 	unsigned long 	group, block, offset;
@@ -546,7 +552,7 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 			return retval;
 	}
 	/* Check to see if it's in the inode cache */
-	if (bufsize == sizeof(struct ext2_inode)) {
+	if (bufsize == sizeof(struct ext2_inode_large)) {
 		/* only old good inode can be retrieved from the cache */
 		for (i=0; i < fs->icache->cache_size; i++) {
 			if (fs->icache->cache[i].ino == ino) {
@@ -581,6 +587,8 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 	if (bufsize < length)
 		length = bufsize;
 
+	if (length == EXT2_GOOD_OLD_INODE_SIZE)
+		inode->i_extra_isize = 0;
 	ptr = (char *) inode;
 	while (length) {
 		clen = length;
@@ -620,14 +628,14 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 }
 
 errcode_t ext2fs_read_inode(ext2_filsys fs, ext2_ino_t ino,
-			    struct ext2_inode * inode)
+			    struct ext2_inode_large *inode)
 {
 	return ext2fs_read_inode_full(fs, ino, inode,
-					sizeof(struct ext2_inode));
+					sizeof(struct ext2_inode_large));
 }
 
 errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
-				  struct ext2_inode * inode, int bufsize)
+				  struct ext2_inode_large *inode, int bufsize)
 {
 	blk64_t block_nr;
 	unsigned long group, block, offset;
@@ -678,9 +686,7 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
 	memset(w_inode, 0, length);
 
 #ifdef WORDS_BIGENDIAN
-	ext2fs_swap_inode_full(fs, w_inode,
-			       (struct ext2_inode_large *) inode,
-			       1, bufsize);
+	ext2fs_swap_inode_full(fs, w_inode, inode, 1, bufsize);
 #else
 	memcpy(w_inode, inode, bufsize);
 #endif
@@ -739,10 +745,10 @@ errout:
 }
 
 errcode_t ext2fs_write_inode(ext2_filsys fs, ext2_ino_t ino,
-			     struct ext2_inode *inode)
+			     struct ext2_inode_large *inode)
 {
 	return ext2fs_write_inode_full(fs, ino, inode,
-				       sizeof(struct ext2_inode));
+				       sizeof(struct ext2_inode_large));
 }
 
 /*
@@ -750,9 +756,9 @@ errcode_t ext2fs_write_inode(ext2_filsys fs, ext2_ino_t ino,
  * sure that extra part of large inodes is initialized properly.
  */
 errcode_t ext2fs_write_new_inode(ext2_filsys fs, ext2_ino_t ino,
-				 struct ext2_inode *inode)
+				 struct ext2_inode_large *inode)
 {
-	struct ext2_inode	*buf;
+	struct ext2_inode_large	*buf;
 	int 			size = EXT2_INODE_SIZE(fs->super);
 	struct ext2_inode_large	*large_inode;
 	errcode_t		retval;
@@ -765,32 +771,20 @@ errcode_t ext2fs_write_new_inode(ext2_filsys fs, ext2_ino_t ino,
 	if (!inode->i_atime)
 		inode->i_atime = t;
 
-	if (size == sizeof(struct ext2_inode))
-		return ext2fs_write_inode_full(fs, ino, inode,
-					       sizeof(struct ext2_inode));
-
-	buf = malloc(size);
-	if (!buf)
-		return ENOMEM;
-
-	memset(buf, 0, size);
-	*buf = *inode;
-
-	large_inode = (struct ext2_inode_large *) buf;
-	large_inode->i_extra_isize = sizeof(struct ext2_inode_large) -
-		EXT2_GOOD_OLD_INODE_SIZE;
-	if (!large_inode->i_crtime)
-		large_inode->i_crtime = t;
+	if (size > EXT2_GOOD_OLD_INODE_SIZE) {
+		inode->i_extra_isize = sizeof(struct ext2_inode_large) -
+				       EXT2_GOOD_OLD_INODE_SIZE;
+		if (!inode->i_crtime)
+			inode->i_crtime = t;
+	}
 
-	retval = ext2fs_write_inode_full(fs, ino, buf, size);
-	free(buf);
-	return retval;
+	return ext2fs_write_inode_full(fs, ino, inode, size);
 }
 
 
 errcode_t ext2fs_get_blocks(ext2_filsys fs, ext2_ino_t ino, blk_t *blocks)
 {
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	int			i;
 	errcode_t		retval;
 
@@ -813,7 +807,7 @@ errcode_t ext2fs_get_blocks(ext2_filsys fs, ext2_ino_t ino, blk_t *blocks)
 
 errcode_t ext2fs_check_directory(ext2_filsys fs, ext2_ino_t ino)
 {
-	struct	ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	errcode_t		retval;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
diff --git a/lib/ext2fs/inode_io.c b/lib/ext2fs/inode_io.c
index b3e7ce5..bfd6028 100644
--- a/lib/ext2fs/inode_io.c
+++ b/lib/ext2fs/inode_io.c
@@ -36,7 +36,7 @@ struct inode_private_data {
 	ext2_file_t			file;
 	ext2_filsys			fs;
 	ext2_ino_t 			ino;
-	struct ext2_inode		inode;
+	struct ext2_inode_large		inode;
 	int				flags;
 	struct inode_private_data	*next;
 };
@@ -80,7 +80,7 @@ static struct struct_io_manager struct_inode_manager = {
 io_manager inode_io_manager = &struct_inode_manager;
 
 errcode_t ext2fs_inode_io_intern2(ext2_filsys fs, ext2_ino_t ino,
-				  struct ext2_inode *inode,
+				  struct ext2_inode_large *inode,
 				  char **name)
 {
 	struct inode_private_data 	*data;
@@ -96,7 +96,7 @@ errcode_t ext2fs_inode_io_intern2(ext2_filsys fs, ext2_ino_t ino,
 	data->ino = ino;
 	data->flags = 0;
 	if (inode) {
-		memcpy(&data->inode, inode, sizeof(struct ext2_inode));
+		memcpy(&data->inode, inode, sizeof(struct ext2_inode_large));
 		data->flags |= CHANNEL_HAS_INODE;
 	}
 	data->next = top_intern;
diff --git a/lib/ext2fs/link.c b/lib/ext2fs/link.c
index 0fd3ea8..a32ec03 100644
--- a/lib/ext2fs/link.c
+++ b/lib/ext2fs/link.c
@@ -113,7 +113,7 @@ errcode_t ext2fs_link(ext2_filsys fs, ext2_ino_t dir, const char *name,
 {
 	errcode_t		retval;
 	struct link_struct	ls;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index 9b6b799..08a0bd6 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -35,7 +35,7 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 {
 	ext2_extent_handle_t	handle;
 	errcode_t		retval;
-	struct ext2_inode	parent_inode, inode;
+	struct ext2_inode_large	parent_inode, inode;
 	ext2_ino_t		ino = inum;
 	ext2_ino_t		scratch_ino;
 	blk64_t			blk;
@@ -80,7 +80,7 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	/*
 	 * Create the inode structure....
 	 */
-	memset(&inode, 0, sizeof(struct ext2_inode));
+	memset(&inode, 0, sizeof(struct ext2_inode_large));
 	inode.i_mode = LINUX_S_IFDIR | (0777 & ~fs->umask);
 	inode.i_uid = inode.i_gid = 0;
 	ext2fs_iblk_set(fs, &inode, 1);
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index aaad2f6..33e58f7 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -302,7 +302,7 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	char			*buf;
 	dgrp_t			group, start, end, i, log_flex;
 	errcode_t		retval;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	unsigned long long	inode_size;
 	struct mkjournal_struct	es;
 
diff --git a/lib/ext2fs/namei.c b/lib/ext2fs/namei.c
index bc0ae61..b1911e3 100644
--- a/lib/ext2fs/namei.c
+++ b/lib/ext2fs/namei.c
@@ -31,7 +31,7 @@ static errcode_t follow_link(ext2_filsys fs, ext2_ino_t root, ext2_ino_t dir,
 	char *pathname;
 	char *buffer = 0;
 	errcode_t retval;
-	struct ext2_inode ei;
+	struct ext2_inode_large ei;
 
 #ifdef NAMEI_DEBUG
 	printf("follow_link: root=%lu, dir=%lu, inode=%lu, lc=%d\n",
diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index 2f24b5e..b8bd816 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -44,7 +44,7 @@ static int check_zero_block(char *buf, int blocksize)
  * each one, will recursively handle any indirect blocks and then
  * frees and deallocates the blocks.
  */
-static errcode_t ind_punch(ext2_filsys fs, struct ext2_inode *inode,
+static errcode_t ind_punch(ext2_filsys fs, struct ext2_inode_large *inode,
 			   char *block_buf, blk_t *p, int level,
 			   blk_t start, blk_t count, int max)
 {
@@ -98,7 +98,8 @@ static errcode_t ind_punch(ext2_filsys fs, struct ext2_inode *inode,
 	return ext2fs_iblk_sub_blocks(fs, inode, freed);
 }
 
-static errcode_t ext2fs_punch_ind(ext2_filsys fs, struct ext2_inode *inode,
+static errcode_t ext2fs_punch_ind(ext2_filsys fs,
+				  struct ext2_inode_large *inode,
 				  char *block_buf, blk_t start, blk_t count)
 {
 	errcode_t		retval;
@@ -176,7 +177,7 @@ static void dbg_print_extent(char *desc, struct ext2fs_extent *extent)
 #endif
 
 static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
-				     struct ext2_inode *inode,
+				     struct ext2_inode_large *inode,
 				     blk64_t start, blk64_t end)
 {
 	ext2_extent_handle_t	handle = 0;
@@ -286,12 +287,12 @@ errout:
  * If end is ~0, then this is effectively truncate.
  */
 extern errcode_t ext2fs_punch(ext2_filsys fs, ext2_ino_t ino,
-			      struct ext2_inode *inode,
+			      struct ext2_inode_large *inode,
 			      char *block_buf, blk64_t start,
 			      blk64_t end)
 {
 	errcode_t		retval;
-	struct ext2_inode	inode_buf;
+	struct ext2_inode_large	inode_buf;
 
 	if (start > end)
 		return EINVAL;
diff --git a/lib/ext2fs/read_bb.c b/lib/ext2fs/read_bb.c
index e5d6322..40d0247 100644
--- a/lib/ext2fs/read_bb.c
+++ b/lib/ext2fs/read_bb.c
@@ -65,7 +65,7 @@ errcode_t ext2fs_read_bb_inode(ext2_filsys fs, ext2_badblocks_list *bb_list)
 {
 	errcode_t	retval;
 	struct read_bb_record rb;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	blk_t	numblocks;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
diff --git a/lib/ext2fs/res_gdt.c b/lib/ext2fs/res_gdt.c
index acce650..7a80512 100644
--- a/lib/ext2fs/res_gdt.c
+++ b/lib/ext2fs/res_gdt.c
@@ -62,7 +62,7 @@ errcode_t ext2fs_create_resize_inode(ext2_filsys fs)
 {
 	errcode_t		retval, retval2;
 	struct ext2_super_block	*sb;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	__u32			*dindir_buf, *gdt_buf;
 	unsigned long long	apb, inode_size;
 	/* FIXME-64 - can't deal with extents */
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 87b1a2e..517f1d7 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -210,11 +210,11 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 	t->i_file_acl = ext2fs_swab32(f->i_file_acl);
 	if (hostorder)
 		has_data_blocks = ext2fs_inode_data_blocks(fs,
-					   (struct ext2_inode *) f);
+					   (struct ext2_inode_large *) f);
 	t->i_blocks = ext2fs_swab32(f->i_blocks);
 	if (!hostorder)
 		has_data_blocks = ext2fs_inode_data_blocks(fs,
-					   (struct ext2_inode *) t);
+					   (struct ext2_inode_large *) t);
 	if (hostorder && (f->i_flags & EXT4_EXTENTS_FL))
 		has_extents = 1;
 	t->i_flags = ext2fs_swab32(f->i_flags);
@@ -265,7 +265,7 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 		break;
 	}
 
-	if (bufsize < (int) (sizeof(struct ext2_inode) + sizeof(__u16)))
+	if (bufsize < (int) (sizeof(struct ext2_inode_large) + sizeof(__u16)))
 		return; /* no i_extra_isize field */
 
 	if (hostorder)
@@ -274,16 +274,16 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 	if (!hostorder)
 		extra_isize = t->i_extra_isize;
 	if (extra_isize > EXT2_INODE_SIZE(fs->super) -
-				sizeof(struct ext2_inode)) {
+				EXT2_GOOD_OLD_INODE_SIZE) {
 		/* this is error case: i_extra_size is too large */
 		return;
 	}
 
-	i = sizeof(struct ext2_inode) + extra_isize + sizeof(__u32);
+	i = EXT2_GOOD_OLD_INODE_SIZE + extra_isize + sizeof(__u32);
 	if (bufsize < (int) i)
 		return; /* no space for EA magic */
 
-	eaf = (__u32 *) (((char *) f) + sizeof(struct ext2_inode) +
+	eaf = (__u32 *) (((char *) f) + EXT2_GOOD_OLD_INODE_SIZE +
 					extra_isize);
 
 	attr_magic = *eaf;
@@ -293,23 +293,23 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 	if (attr_magic != EXT2_EXT_ATTR_MAGIC)
 		return; /* it seems no magic here */
 
-	eat = (__u32 *) (((char *) t) + sizeof(struct ext2_inode) +
+	eat = (__u32 *) (((char *) t) + EXT2_GOOD_OLD_INODE_SIZE +
 					extra_isize);
 	*eat = ext2fs_swab32(*eaf);
 
 	/* convert EA(s) */
 	ext2fs_swap_ext_attr((char *) (eat + 1), (char *) (eaf + 1),
-			     bufsize - sizeof(struct ext2_inode) -
+			     bufsize - EXT2_GOOD_OLD_INODE_SIZE -
 			     extra_isize - sizeof(__u32), 0);
 
 }
 
-void ext2fs_swap_inode(ext2_filsys fs, struct ext2_inode *t,
-		       struct ext2_inode *f, int hostorder)
+void ext2fs_swap_inode(ext2_filsys fs, struct ext2_inode_large *t,
+		       struct ext2_inode_large *f, int hostorder)
 {
 	ext2fs_swap_inode_full(fs, (struct ext2_inode_large *) t,
 				(struct ext2_inode_large *) f, hostorder,
-				sizeof(struct ext2_inode));
+				sizeof(struct ext2_inode_large));
 }
 
 #endif
diff --git a/lib/ext2fs/tst_iscan.c b/lib/ext2fs/tst_iscan.c
index 64246d3..dcf81d1 100644
--- a/lib/ext2fs/tst_iscan.c
+++ b/lib/ext2fs/tst_iscan.c
@@ -139,7 +139,7 @@ static void setup(void)
  */
 static void iterate(void)
 {
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	ext2_inode_scan	scan;
 	errcode_t	retval;
 	ext2_ino_t	ino;
diff --git a/lib/ext2fs/valid_blk.c b/lib/ext2fs/valid_blk.c
index ec3edd8..9419166 100644
--- a/lib/ext2fs/valid_blk.c
+++ b/lib/ext2fs/valid_blk.c
@@ -23,7 +23,7 @@
  * This function returns 1 if the inode's block entries actually
  * contain block entries.
  */
-int ext2fs_inode_has_valid_blocks(struct ext2_inode *inode)
+int ext2fs_inode_has_valid_blocks(struct ext2_inode_large *inode)
 {
 	/*
 	 * Only directories, regular files, and some symbolic links
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 9a0dd46..7d74e84 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -300,7 +300,7 @@ static void list_bad_blocks(ext2_filsys fs, int dump)
 static void print_inline_journal_information(ext2_filsys fs)
 {
 	journal_superblock_t	*jsb;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	ext2_file_t		journal_file;
 	errcode_t		retval;
 	ino_t			ino = fs->super->s_journal_inum;
diff --git a/misc/e2image.c b/misc/e2image.c
index 83a9d02..56a5321 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -232,7 +232,7 @@ struct process_block_struct {
  * the inode again.
  */
 static ino_t stashed_ino = 0;
-static struct ext2_inode *stashed_inode;
+static struct ext2_inode_large *stashed_inode;
 
 static errcode_t meta_get_blocks(ext2_filsys fs EXT2FS_ATTR((unused)),
 				 ext2_ino_t ino,
@@ -261,7 +261,7 @@ static errcode_t meta_check_directory(ext2_filsys fs EXT2FS_ATTR((unused)),
 
 static errcode_t meta_read_inode(ext2_filsys fs EXT2FS_ATTR((unused)),
 				 ext2_ino_t ino,
-				 struct ext2_inode *inode)
+				 struct ext2_inode_large *inode)
 {
 	if ((ino != stashed_ino) || !stashed_inode)
 		return EXT2_ET_CALLBACK_NOTHANDLED;
@@ -1032,7 +1032,7 @@ static void output_qcow2_meta_data_blocks(ext2_filsys fs, int fd)
 static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
 {
 	struct process_block_struct	pb;
-	struct ext2_inode		inode;
+	struct ext2_inode_large		inode;
 	ext2_inode_scan			scan;
 	ext2_ino_t			ino;
 	errcode_t			retval;
diff --git a/misc/e2initrd_helper.c b/misc/e2initrd_helper.c
index eaf9ce6..3d1535b 100644
--- a/misc/e2initrd_helper.c
+++ b/misc/e2initrd_helper.c
@@ -75,7 +75,7 @@ static errcode_t get_file(ext2_filsys fs, const char * filename,
 	char 		*buf;
 	ext2_file_t	e2_file;
 	unsigned int	got;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	ext2_ino_t	ino;
 
 	ret_file->buf = 0;
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index e062bda..2d57d09 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -352,7 +352,7 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
 static void create_root_dir(ext2_filsys fs)
 {
 	errcode_t		retval;
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	__u32			uid, gid;
 
 	retval = ext2fs_mkdir(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, 0);
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 5bf5187..82833ad 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -275,7 +275,7 @@ static int release_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
  */
 static void remove_journal_inode(ext2_filsys fs)
 {
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	errcode_t		retval;
 	ino_t			ino = fs->super->s_journal_inum;
 
@@ -1209,7 +1209,7 @@ static int inode_scan_and_fix(ext2_filsys fs, ext2fs_block_bitmap bmap)
 	ext2_ino_t ino;
 	blk64_t blk;
 	char *block_buf = 0;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 	ext2_inode_scan	scan = NULL;
 
 	retval = ext2fs_get_mem(fs->blocksize * 3, &block_buf);
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 45ea5f4..d35be59 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1234,7 +1234,7 @@ errout:
 struct process_block_struct {
 	ext2_resize_t 		rfs;
 	ext2_ino_t		ino;
-	struct ext2_inode *	inode;
+	struct ext2_inode_large	*inode;
 	errcode_t		error;
 	int			is_dir;
 	int			changed;
@@ -1309,7 +1309,7 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 {
 	struct process_block_struct	pb;
 	ext2_ino_t		ino, new_inode;
-	struct ext2_inode 	*inode = NULL;
+	struct ext2_inode_large	*inode = NULL;
 	ext2_inode_scan 	scan = NULL;
 	errcode_t		retval;
 	char			*block_buf = 0;
@@ -1475,7 +1475,7 @@ static int check_and_change_inodes(ext2_ino_t dir,
 				   void *priv_data)
 {
 	struct istruct *is = (struct istruct *) priv_data;
-	struct ext2_inode 	inode;
+	struct ext2_inode_large	inode;
 	ext2_ino_t		new_inode;
 	errcode_t		retval;
 
@@ -1712,7 +1712,7 @@ errout:
  */
 static errcode_t fix_resize_inode(ext2_filsys fs)
 {
-	struct ext2_inode	inode;
+	struct ext2_inode_large	inode;
 	errcode_t		retval;
 	char *			block_buf;
 
@@ -1866,7 +1866,7 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 static errcode_t fix_sb_journal_backup(ext2_filsys fs)
 {
 	errcode_t	  retval;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 
 	if (!(fs->super->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL))
 		return 0;

