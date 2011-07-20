From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 5/5] e2fsck: check quota accounting during fsck
Date: Wed, 20 Jul 2011 15:03:01 -0700
Message-ID: <CAGr1F2GF1w7Tj8wiMuAfm3KbyNmcFJskMfwmbghsLFrY2xDhZQ@mail.gmail.com>
References: <1311187206-30553-1-git-send-email-adityakali@google.com> <1311187206-30553-6-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Aditya Kali <adityakali@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:42643 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab1GTWDY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jul 2011 18:03:24 -0400
Received: from hpaq3.eem.corp.google.com (hpaq3.eem.corp.google.com [172.25.149.3])
	by smtp-out.google.com with ESMTP id p6KM3NTt026924
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jul 2011 15:03:23 -0700
Received: from pvf24 (pvf24.prod.google.com [10.241.210.88])
	by hpaq3.eem.corp.google.com with ESMTP id p6KM2p28027636
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jul 2011 15:03:21 -0700
Received: by pvf24 with SMTP id 24so800899pvf.34
        for <linux-ext4@vger.kernel.org>; Wed, 20 Jul 2011 15:03:21 -0700 (PDT)
In-Reply-To: <1311187206-30553-6-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixed a minor error.

---

This patch adds support for doing quota accounting during full
e2fsck scan if the 'quota' feature was set on the superblock.
If user-visible quota inodes are in use, they will be hidden
and converted to the reserved quota inodes.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 e2fsck/Makefile.in |   43 ++++++++++++++++---------
 e2fsck/e2fsck.h    |    9 +++++
 e2fsck/message.c   |    2 +
 e2fsck/pass1.c     |   34 ++++++++++++++++++++
 e2fsck/pass1b.c    |    6 +++-
 e2fsck/pass2.c     |   16 ++++++++--
 e2fsck/pass3.c     |    3 ++
 e2fsck/pass4.c     |    1 +
 e2fsck/problem.c   |   15 +++++++++
 e2fsck/problem.h   |    9 +++++
 e2fsck/quota.c     |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/super.c     |    5 +++
 e2fsck/unix.c      |   17 ++++++++++
 13 files changed, 229 insertions(+), 19 deletions(-)
 create mode 100644 e2fsck/quota.c

diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 315db62..e252ad6 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -16,19 +16,23 @@ MANPAGES=	e2fsck.8
 FMANPAGES=	e2fsck.conf.5
 XTRA_CFLAGS=	-DRESOURCE_TRACK -I.

-LIBS= $(LIBEXT2FS) $(LIBCOM_ERR) $(LIBBLKID) $(LIBUUID) $(LIBINTL) $(LIBE2P)
-DEPLIBS= $(LIBEXT2FS) $(DEPLIBCOM_ERR) $(DEPLIBBLKID) $(DEPLIBUUID) \
-	$(DEPLIBE2P)
-
-STATIC_LIBS= $(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR) $(STATIC_LIBBLKID) \
-	$(STATIC_LIBUUID) $(LIBINTL) $(STATIC_LIBE2P)
-STATIC_DEPLIBS= $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR) \
-	$(DEPSTATIC_LIBBLKID) $(DEPSTATIC_LIBUUID) $(DEPSTATIC_LIBE2P)
-
-PROFILED_LIBS= $(PROFILED_LIBEXT2FS) $(PROFILED_LIBCOM_ERR) \
-	$(PROFILED_LIBBLKID) $(PROFILED_LIBUUID) $(PROFILED_LIBE2P) $(LIBINTL)
-PROFILED_DEPLIBS= $(PROFILED_LIBEXT2FS) $(DEPPROFILED_LIBCOM_ERR) \
-	$(DEPPROFILED_LIBBLKID) $(DEPPROFILED_LIBUUID) $(DEPPROFILED_LIBE2P)
+LIBS= $(LIBQUOTA) $(LIBEXT2FS) $(LIBCOM_ERR) $(LIBBLKID) $(LIBUUID) \
+	$(LIBINTL) $(LIBE2P)
+DEPLIBS= $(DEPLIBQUOTA) $(LIBEXT2FS) $(DEPLIBCOM_ERR) $(DEPLIBBLKID) \
+	 $(DEPLIBUUID) $(DEPLIBE2P)
+
+STATIC_LIBS= $(STATIC_LIBQUOTA) $(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR) \
+	     $(STATIC_LIBBLKID) $(STATIC_LIBUUID) $(LIBINTL) $(STATIC_LIBE2P)
+STATIC_DEPLIBS= $(DEPSTATIC_LIBQUOTA) $(STATIC_LIBEXT2FS) \
+		$(DEPSTATIC_LIBCOM_ERR) $(DEPSTATIC_LIBBLKID) \
+		$(DEPSTATIC_LIBUUID) $(DEPSTATIC_LIBE2P)
+
+PROFILED_LIBS= $(PROFILED_LIBQUOTA) $(PROFILED_LIBEXT2FS) \
+	       $(PROFILED_LIBCOM_ERR) $(PROFILED_LIBBLKID) $(PROFILED_LIBUUID) \
+	       $(PROFILED_LIBE2P) $(LIBINTL) \
+PROFILED_DEPLIBS= $(DEPPROFILED_LIBQUOTA) $(PROFILED_LIBEXT2FS) \
+		  $(DEPPROFILED_LIBCOM_ERR) $(DEPPROFILED_LIBBLKID) \
+		  $(DEPPROFILED_LIBUUID) $(DEPPROFILED_LIBE2P)

 COMPILE_ET=$(top_builddir)/lib/et/compile_et --build-tree

@@ -64,7 +68,8 @@ COMPILE_ET=$(top_builddir)/lib/et/compile_et --build-tree
 OBJS= crc32.o dict.o unix.o e2fsck.o super.o pass1.o pass1b.o pass2.o \
 	pass3.o pass4.o pass5.o journal.o badblocks.o util.o dirinfo.o \
 	dx_dirinfo.o ehandler.o problem.o message.o recovery.o region.o \
-	revoke.o ea_refcount.o rehash.o profile.o prof_err.o $(MTRACE_OBJ)
+	revoke.o ea_refcount.o rehash.o profile.o prof_err.o quota.o \
+	$(MTRACE_OBJ)

 PROFILED_OBJS= profiled/dict.o profiled/unix.o profiled/e2fsck.o \
 	profiled/super.o profiled/pass1.o profiled/pass1b.o \
@@ -74,7 +79,7 @@ PROFILED_OBJS= profiled/dict.o profiled/unix.o
profiled/e2fsck.o \
 	profiled/message.o profiled/problem.o \
 	profiled/recovery.o profiled/region.o profiled/revoke.o \
 	profiled/ea_refcount.o profiled/rehash.o profiled/profile.o \
-	profiled/crc32.o profiled/prof_err.o
+	profiled/crc32.o profiled/prof_err.o profiled/quota.o

 SRCS= $(srcdir)/e2fsck.c \
 	$(srcdir)/crc32.c \
@@ -103,6 +108,7 @@ SRCS= $(srcdir)/e2fsck.c \
 	$(srcdir)/region.c \
 	$(srcdir)/profile.c \
 	prof_err.c \
+	$(srcdir)/quota.c \
 	$(MTRACE_SRC)

 all:: profiled $(PROGS) e2fsck $(MANPAGES) $(FMANPAGES)
@@ -439,3 +445,10 @@ region.o: $(srcdir)/region.c $(srcdir)/e2fsck.h \
 profile.o: $(srcdir)/profile.c $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/profile.h prof_err.h
 prof_err.o: prof_err.c
+quota.o: $(srcdir)/quota.c $(srcdir)/e2fsck.h
$(top_srcdir)/lib/quota/mkquota.h\
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(srcdir)/profile.h prof_err.h $(srcdir)/problem.h
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index b4a1a88..3ece906 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -61,6 +61,8 @@
 #define P_(singular, plural, n) ((n) == 1 ? (singular) : (plural))
 #endif

+#include "quota/mkquota.h"
+
 /*
  * Exit codes used by fsck-type programs
  */
@@ -305,6 +307,10 @@ struct e2fsck_struct {
 	io_channel	journal_io;
 	char	*journal_name;

+	/*
+	 * Ext4 quota support
+	 */
+	quota_ctx_t qctx;
 #ifdef RESOURCE_TRACK
 	/*
 	 * For timing purposes
@@ -441,6 +447,9 @@ extern int e2fsck_run_ext3_journal(e2fsck_t ctx);
 extern void e2fsck_move_ext3_journal(e2fsck_t ctx);
 extern int e2fsck_fix_ext3_journal_hint(e2fsck_t ctx);

+/* quota.c */
+extern void e2fsck_hide_quota(e2fsck_t ctx);
+
 /* pass1.c */
 extern void e2fsck_setup_tdb_icount(e2fsck_t ctx, int flags,
 				    ext2_icount_t *ret);
diff --git a/e2fsck/message.c b/e2fsck/message.c
index c456752..49b861d 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -76,6 +76,7 @@
  *	@n	invalid
  * 	@o	orphaned
  * 	@p	problem in
+ *	@q	quota
  * 	@r	root inode
  * 	@s	should be
  * 	@S	superblock
@@ -131,6 +132,7 @@ static const char *abbrevs[] = {
 	N_("ninvalid"),
 	N_("oorphaned"),
 	N_("pproblem in"),
+	N_("qquota"),
 	N_("rroot @i"),
 	N_("sshould be"),
 	N_("Ssuper@b"),
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index fe5dd9b..dd18ade 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -893,6 +893,33 @@ void e2fsck_pass1(e2fsck_t ctx)
 				e2fsck_write_inode_full(ctx, ino, inode,
 							inode_size, "pass1");
 			}
+		} else if ((ino == EXT4_USR_QUOTA_INO) ||
+			   (ino == EXT4_GRP_QUOTA_INO)) {
+			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
+			if ((fs->super->s_feature_ro_compat &
+					EXT4_FEATURE_RO_COMPAT_QUOTA) &&
+			    (fs->super->s_usr_quota_inum == ino) ||
+			    (fs->super->s_grp_quota_inum == ino)) {
+				if (!LINUX_S_ISREG(inode->i_mode) &&
+				    fix_problem(ctx, PR_1_QUOTA_BAD_MODE,
+							&pctx)) {
+					inode->i_mode = LINUX_S_IFREG;
+					e2fsck_write_inode(ctx, ino, inode,
+							"pass1");
+				}
+				check_blocks(ctx, &pctx, block_buf);
+				continue;
+			}
+			if ((inode->i_links_count ||
+			     inode->i_blocks || inode->i_block[0]) &&
+			    fix_problem(ctx, PR_1_QUOTA_INODE_NOT_CLEAR,
+					&pctx)) {
+				memset(inode, 0, inode_size);
+				ext2fs_icount_store(ctx->inode_link_info,
+						    ino, 0);
+				e2fsck_write_inode_full(ctx, ino, inode,
+							inode_size, "pass1");
+			}
 		} else if (ino < EXT2_FIRST_INODE(fs->super)) {
 			int	problem = 0;

@@ -918,6 +945,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 			check_blocks(ctx, &pctx, block_buf);
 			continue;
 		}
+
 		/*
 		 * Check for inodes who might have been part of the
 		 * orphaned list linked list.  They should have gotten
@@ -1978,6 +2006,12 @@ static void check_blocks(e2fsck_t ctx, struct
problem_context *pctx,
 		}
 	}

+	if (ino == EXT2_ROOT_INO || ino >= EXT2_FIRST_INODE(ctx->fs->super)) {
+		quota_data_add(ctx->qctx, inode, ino,
+			       pb.num_blocks * fs->blocksize);
+		quota_data_inodes(ctx->qctx, inode, ino, +1);
+	}
+
 	if (!(fs->super->s_feature_ro_compat &
 	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
 	    !(inode->i_flags & EXT4_HUGE_FILE_FL))
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 12a03b0..0858482 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -596,6 +596,7 @@ static int delete_file_block(ext2_filsys fs,
 	} else {
 		ext2fs_unmark_block_bitmap2(ctx->block_found_map, *block_nr);
 		ext2fs_block_alloc_stats2(fs, *block_nr, -1);
+		pb->dup_blocks++;
 	}

 	return 0;
@@ -612,7 +613,7 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,

 	clear_problem_context(&pctx);
 	pctx.ino = pb.ino = ino;
-	pb.dup_blocks = dp->num_dupblocks;
+	pb.dup_blocks = 0;
 	pb.ctx = ctx;
 	pctx.str = "delete_file";

@@ -625,6 +626,8 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 	if (ctx->inode_bad_map)
 		ext2fs_unmark_inode_bitmap2(ctx->inode_bad_map, ino);
 	ext2fs_inode_alloc_stats2(fs, ino, -1, LINUX_S_ISDIR(inode.i_mode));
+	quota_data_sub(ctx->qctx, &inode, ino, pb.dup_blocks * fs->blocksize);
+	quota_data_inodes(ctx->qctx, &inode, ino, -1);

 	/* Inode may have changed by block_iterate, so reread it */
 	e2fsck_read_inode(ctx, ino, &inode, "delete_file");
@@ -656,6 +659,7 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 			delete_file_block(fs, &blk,
 					  BLOCK_COUNT_EXTATTR, 0, 0, &pb);
 			ext2fs_file_acl_block_set(&inode, blk);
+			quota_data_sub(ctx->qctx, &inode, ino, fs->blocksize);
 		}
 	}
 }
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 2863699..e57afb9 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1149,6 +1149,11 @@ abort_free_dict:
 	return DIRENT_ABORT;
 }

+struct del_block {
+	e2fsck_t	ctx;
+	e2_blkcnt_t	num;
+};
+
 /*
  * This function is called to deallocate a block, and is an interator
  * functioned called by deallocate inode via ext2fs_iterate_block().
@@ -1160,15 +1165,16 @@ static int deallocate_inode_block(ext2_filsys fs,
 				  int ref_offset EXT2FS_ATTR((unused)),
 				  void *priv_data)
 {
-	e2fsck_t	ctx = (e2fsck_t) priv_data;
+	struct del_block *p = priv_data;

 	if (HOLE_BLKADDR(*block_nr))
 		return 0;
 	if ((*block_nr < fs->super->s_first_data_block) ||
 	    (*block_nr >= ext2fs_blocks_count(fs->super)))
 		return 0;
-	ext2fs_unmark_block_bitmap2(ctx->block_found_map, *block_nr);
+	ext2fs_unmark_block_bitmap2(p->ctx->block_found_map, *block_nr);
 	ext2fs_block_alloc_stats2(fs, *block_nr, -1);
+	p->num++;
 	return 0;
 }

@@ -1181,6 +1187,7 @@ static void deallocate_inode(e2fsck_t ctx,
ext2_ino_t ino, char* block_buf)
 	struct ext2_inode	inode;
 	struct problem_context	pctx;
 	__u32			count;
+	struct del_block	del_block;

 	e2fsck_read_inode(ctx, ino, &inode, "deallocate_inode");
 	e2fsck_clear_inode(ctx, ino, &inode, 0, "deallocate_inode");
@@ -1223,8 +1230,11 @@ static void deallocate_inode(e2fsck_t ctx,
ext2_ino_t ino, char* block_buf)
 	if (LINUX_S_ISREG(inode.i_mode) && EXT2_I_SIZE(&inode) >= 0x80000000UL)
 		ctx->large_files--;

+	del_block.ctx = ctx;
+	del_block.num = 0;
 	pctx.errcode = ext2fs_block_iterate3(fs, ino, 0, block_buf,
-					     deallocate_inode_block, ctx);
+					     deallocate_inode_block,
+					     &del_block);
 	if (pctx.errcode) {
 		fix_problem(ctx, PR_2_DEALLOC_INODE, &pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index c067164..e3d2ef7 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -488,6 +488,8 @@ ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 	ext2fs_icount_store(ctx->inode_count, ino, 2);
 	ext2fs_icount_store(ctx->inode_link_info, ino, 2);
 	ctx->lost_and_found = ino;
+	quota_data_add(ctx->qctx, &inode, ino, fs->blocksize);
+	quota_data_inodes(ctx->qctx, &inode, ino, +1);
 #if 0
 	printf("/lost+found created; inode #%lu\n", ino);
 #endif
@@ -790,6 +792,7 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx,
ext2_ino_t dir,

 	inode.i_size = (es.last_block + 1) * fs->blocksize;
 	ext2fs_iblk_add_blocks(fs, &inode, es.newblocks);
+	quota_data_add(ctx->qctx, &inode, dir, es.newblocks * fs->blocksize);

 	e2fsck_write_inode(ctx, dir, &inode, "expand_directory");

diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index 695612b..4b845f6 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -63,6 +63,7 @@ static int disconnect_inode(e2fsck_t ctx, ext2_ino_t i,
 			e2fsck_read_bitmaps(ctx);
 			ext2fs_inode_alloc_stats2(fs, i, -1,
 						  LINUX_S_ISDIR(inode->i_mode));
+			quota_data_inodes(ctx->qctx, inode, i, -1);
 			return 0;
 		}
 	}
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index c5bebf8..750127a 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -412,6 +412,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Setting free @bs count to %c (was %b)\n"),
 	  PROMPT_NONE, PR_PREEN_NOMSG },

+	/* Making quota file hidden */
+	{ PR_0_HIDE_QUOTA,
+	  N_("Making @q @is hidden.\n\n"),
+	  PROMPT_NONE, PR_PREEN_OK },
+
 	/* Pass 1 errors */

 	/* Pass 1: Checking inodes, blocks, and sizes */
@@ -905,6 +910,16 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Error converting subcluster @b @B: %m\n"),
 	  PROMPT_NONE, PR_FATAL },

+	/* Quota inode has bad mode */
+	{ PR_1_QUOTA_BAD_MODE,
+	  N_("@q is not regular file.  "),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* Quota inode is not in use, but contains data */
+	{ PR_1_QUOTA_INODE_NOT_CLEAR,
+	  N_("@q @i is not in use, but contains data.  "),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
 	/* Pass 1b errors */

 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 8379e0c..262a472 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -233,6 +233,9 @@ struct problem_context {
 /* Free blocks count wrong */
 #define PR_0_FREE_BLOCK_COUNT			0x000040

+/* Make quota file hidden */
+#define	PR_0_HIDE_QUOTA				0x000041
+

 /*
  * Pass 1 errors
@@ -529,6 +532,12 @@ struct problem_context {
 /* Failed to convert subcluster bitmap */
 #define PR_1_CONVERT_SUBCLUSTER		0x010061

+/* Quota inode has wrong mode */
+#define PR_1_QUOTA_BAD_MODE		0x010062
+
+/* Quota inode is not in use, but contains data */
+#define PR_1_QUOTA_INODE_NOT_CLEAR	0x010063
+
 /*
  * Pass 1b errors
  */
diff --git a/e2fsck/quota.c b/e2fsck/quota.c
new file mode 100644
index 0000000..54b8d23
--- /dev/null
+++ b/e2fsck/quota.c
@@ -0,0 +1,88 @@
+/*
+ * quota.c --- code for handling ext4 quota inodes
+ *
+ */
+
+#ifdef HAVE_SYS_MOUNT_H
+#include <sys/param.h>
+#include <sys/mount.h>
+#define MNT_FL (MS_MGC_VAL | MS_RDONLY)
+#endif
+#ifdef HAVE_SYS_STAT_H
+#include <sys/stat.h>
+#endif
+
+#include "e2fsck.h"
+#include "problem.h"
+#include "quota/mkquota.h"
+
+static void move_quota_inode(ext2_filsys fs, ext2_ino_t from_ino,
+			     ext2_ino_t to_ino, int qtype)
+{
+	struct ext2_super_block *sb = fs->super;
+	ext2_ino_t		ino;
+	struct ext2_inode	inode;
+	errcode_t		retval;
+	char			qf_name[255];
+
+	if (ext2fs_read_inode(fs, from_ino, &inode))
+		return;
+
+	inode.i_links_count = 1;
+	inode.i_mode = LINUX_S_IFREG | 0600;
+	inode.i_flags = EXT2_IMMUTABLE_FL;
+	if (fs->super->s_feature_incompat &
+			EXT3_FEATURE_INCOMPAT_EXTENTS)
+		inode.i_flags |= EXT4_EXTENTS_FL;
+
+	ext2fs_write_new_inode(fs, to_ino, &inode);
+	/* unlink the old inode */
+	get_qf_name(qtype, QFMT_VFS_V1, qf_name);
+	ext2fs_unlink(fs, EXT2_ROOT_INO, qf_name, from_ino, 0);
+	ext2fs_inode_alloc_stats(fs, from_ino, -1);
+}
+
+void e2fsck_hide_quota(e2fsck_t ctx)
+{
+	struct ext2_super_block *sb = ctx->fs->super;
+	struct problem_context	pctx;
+	ext2_filsys		fs = ctx->fs;
+
+	clear_problem_context(&pctx);
+
+	if ((ctx->options & E2F_OPT_READONLY) ||
+	    !(sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA))
+		return;
+
+	/* We need the inode bitmap to be loaded */
+	if (ext2fs_read_bitmaps(fs))
+		return;
+
+	if (!sb->s_usr_quota_inum && !sb->s_grp_quota_inum)
+		/* nothing to do */
+		return;
+
+	if (sb->s_usr_quota_inum == EXT4_USR_QUOTA_INO &&
+	    sb->s_grp_quota_inum == EXT4_GRP_QUOTA_INO)
+		/* nothing to do */
+		return;
+
+	if (!fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx))
+		return;
+
+	if (sb->s_usr_quota_inum &&
+	    sb->s_usr_quota_inum != EXT4_USR_QUOTA_INO) {
+		move_quota_inode(fs, sb->s_usr_quota_inum, EXT4_USR_QUOTA_INO,
+				 USRQUOTA);
+		sb->s_usr_quota_inum = EXT4_USR_QUOTA_INO;
+	}
+
+	if (sb->s_grp_quota_inum &&
+	    sb->s_grp_quota_inum != EXT4_GRP_QUOTA_INO) {
+		move_quota_inode(fs, sb->s_grp_quota_inum, EXT4_GRP_QUOTA_INO,
+				 GRPQUOTA);
+		sb->s_grp_quota_inum = EXT4_GRP_QUOTA_INO;
+	}
+
+	return;
+}
diff --git a/e2fsck/super.c b/e2fsck/super.c
index a61eb33..14251ab 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -856,6 +856,11 @@ void check_super_block(e2fsck_t ctx)
 	 */
 	e2fsck_fix_dirhash_hint(ctx);

+	/*
+	 * Hide quota inodes if necessary.
+	 */
+	e2fsck_hide_quota(ctx);
+
 	return;
 }

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 7e95ca8..c5cee0c 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1410,6 +1410,18 @@ print_unsupp_features:
 	else
 		journal_size = -1;

+	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA) {
+		int qtype;
+		/* Quotas were enabled. Do quota accounting during fsck. */
+		if ((sb->s_usr_quota_inum && sb->s_grp_quota_inum) ||
+		    (!sb->s_usr_quota_inum && !sb->s_grp_quota_inum))
+			qtype = -1;
+		else
+			qtype = sb->s_usr_quota_inum ? USRQUOTA : GRPQUOTA;
+
+		init_quota_context(&ctx->qctx, ctx->fs, qtype);
+	}
+
 	run_result = e2fsck_run(ctx);
 	e2fsck_clear_progbar(ctx);

@@ -1442,6 +1454,11 @@ print_unsupp_features:
 	}
 no_journal:

+	if (ctx->qctx) {
+		write_quota_inode(ctx->qctx, -1);
+		release_quota_context(&ctx->qctx);
+	}
+
 	if (run_result == E2F_FLAG_RESTART) {
 		printf(_("Restarting e2fsck from the beginning...\n"));
 		retval = e2fsck_reset_context(ctx);
-- 
1.7.3.1
