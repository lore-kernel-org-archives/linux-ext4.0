From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH,RFC] Adding quotacheck functionality to e2fsck
Date: Thu, 25 Mar 2010 20:20:18 -0400
Message-ID: <E1NuxHe-0005cj-JN@closure.thunk.org>
To: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:54267 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab0CZAVD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Mar 2010 20:21:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is something I whipped up last night to speed up quotacheck by
doing the data collection in e2fsck.  If e2fsck runs and does a full
check, it's likely that quotacheck needs to be run as well --- and it's
faster if e2fsck does the dirty work of fetching the information since
(1) it needs to paw through all of the inodes anyway, and (2) quotacheck
has to go through the file system and iterate over the files in an
non-optimal order.

What do folks think?  Obviously changes in quotacheck would be required
before it could take advantage of these output files, but hopefully that
shouldn't be hard...

To use, either use:

   e2fsck -E usrquota_check=/tmp/quota.user,grpquota_check=/tmp/quota.group

or you can edit /etc/e2fsck.conf and add:

[quota]
	directory = /var/e2fsck/quota

I still need to write documentation, update the man pages, and do some
polishing, so this is still in a pretty rough state, but I'd appreciate
comments.

Thanks,

     	      					- Ted

diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 8296e72..91b7354 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -63,8 +63,9 @@ COMPILE_ET=$(top_builddir)/lib/et/compile_et --build-tree
 
 OBJS= crc32.o dict.o unix.o e2fsck.o super.o pass1.o pass1b.o pass2.o \
 	pass3.o pass4.o pass5.o journal.o badblocks.o util.o dirinfo.o \
-	dx_dirinfo.o ehandler.o problem.o message.o recovery.o region.o \
-	revoke.o ea_refcount.o rehash.o profile.o prof_err.o $(MTRACE_OBJ)
+	dx_dirinfo.o ehandler.o problem.o message.o quota.o recovery.o \
+	region.o revoke.o ea_refcount.o rehash.o profile.o prof_err.o \
+	$(MTRACE_OBJ)
 
 PROFILED_OBJS= profiled/dict.o profiled/unix.o profiled/e2fsck.o \
 	profiled/super.o profiled/pass1.o profiled/pass1b.o \
@@ -88,6 +89,7 @@ SRCS= $(srcdir)/e2fsck.c \
 	$(srcdir)/pass4.c \
 	$(srcdir)/pass5.c \
 	$(srcdir)/journal.c \
+	$(srcdir)/quota.c \
 	$(srcdir)/recovery.c \
 	$(srcdir)/revoke.c \
 	$(srcdir)/badblocks.c \
diff --git a/e2fsck/e2fsck.c b/e2fsck/e2fsck.c
index 26f7b5e..331656e 100644
--- a/e2fsck/e2fsck.c
+++ b/e2fsck/e2fsck.c
@@ -159,6 +159,8 @@ errcode_t e2fsck_reset_context(e2fsck_t ctx)
 	for (i=0; i < MAX_EXTENT_DEPTH_COUNT; i++)
 		ctx->extent_depth_count[i] = 0;
 
+	quota_data_release(ctx);
+
 	/* Reset the superblock to the user's requested value */
 	ctx->superblock = ctx->use_superblock;
 
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index e763b89..b18b91c 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -61,6 +61,8 @@
 #define P_(singular, plural, n) ((n) == 1 ? (singular) : (plural))
 #endif
 
+#include "dict.h"
+
 /*
  * Exit codes used by fsck-type programs
  */
@@ -188,6 +190,13 @@ struct resource_track {
 #define E2F_PASS_1B	6
 
 /*
+ * Quota types
+ */
+#define MAXQUOTAS 2
+#define USRQUOTA  0		/* element used for user quotas */
+#define GRPQUOTA  1		/* element used for group quotas */
+
+/*
  * Define the extended attribute refcount structure
  */
 typedef struct ea_refcount *ext2_refcount_t;
@@ -286,6 +295,12 @@ struct e2fsck_struct {
 	ext2_u32_list	dirs_to_hash;
 
 	/*
+	 * Quota information
+	 */
+	char *quota_fname[MAXQUOTAS];
+	dict_t *quota_dict[MAXQUOTAS];
+
+	/*
 	 * Tuning parameters
 	 */
 	int process_inode_size;
@@ -459,6 +474,18 @@ extern errcode_t e2fsck_adjust_inode_count(e2fsck_t ctx, ext2_ino_t ino,
 					   int adj);
 
 
+/* quota.c */
+extern void default_quota_files_setup(e2fsck_t ctx);
+extern void quota_data_initialize(e2fsck_t ctx);
+extern void quota_data_add(e2fsck_t ctx, struct ext2_inode *inode,
+			   __u64 blocks);
+extern void quota_data_sub(e2fsck_t ctx, struct ext2_inode *inode,
+			   __u64 blocks);
+extern void quota_data_inodes(e2fsck_t ctx, struct ext2_inode *inode,
+			      int adjust);
+extern void quota_data_output(e2fsck_t ctx);
+extern void quota_data_release(e2fsck_t ctx);
+
 /* region.c */
 extern region_t region_create(region_addr_t min, region_addr_t max);
 extern void region_free(region_t region);
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index c39d837..1ffa90d 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -654,13 +654,15 @@ void e2fsck_pass1(e2fsck_t ctx)
 		return;
 	}
 
+	quota_data_initialize(ctx);
+
 	/*
 	 * If the last orphan field is set, clear it, since the pass1
 	 * processing will automatically find and clear the orphans.
 	 * In the future, we may want to try using the last_orphan
 	 * linked list ourselves, but for now, we clear it so that the
 	 * ext3 mount code won't get confused.
-	 */
+ 	 */
 	if (!(ctx->options & E2F_OPT_READONLY)) {
 		if (fs->super->s_last_orphan) {
 			fs->super->s_last_orphan = 0;
@@ -1962,6 +1964,9 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		}
 	}
 
+	quota_data_add(ctx, inode, pb.num_blocks * (fs->blocksize / 1024));
+	quota_data_inodes(ctx, inode, +1);
+
 	if (!(fs->super->s_feature_ro_compat &
 	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
 	    !(inode->i_flags & EXT4_HUGE_FILE_FL))
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 99f0a3c..10885d5 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -583,6 +583,7 @@ static int delete_file_block(ext2_filsys fs,
 	} else {
 		ext2fs_unmark_block_bitmap(ctx->block_found_map, *block_nr);
 		ext2fs_block_alloc_stats(fs, *block_nr, -1);
+		pb->dup_blocks++;
 	}
 
 	return 0;
@@ -599,7 +600,7 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 
 	clear_problem_context(&pctx);
 	pctx.ino = pb.ino = ino;
-	pb.dup_blocks = dp->num_dupblocks;
+	pb.dup_blocks = 0;
 	pb.ctx = ctx;
 	pctx.str = "delete_file";
 
@@ -612,6 +613,8 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 	if (ctx->inode_bad_map)
 		ext2fs_unmark_inode_bitmap(ctx->inode_bad_map, ino);
 	ext2fs_inode_alloc_stats2(fs, ino, -1, LINUX_S_ISDIR(inode.i_mode));
+	quota_data_sub(ctx, &inode, pb.dup_blocks * (fs->blocksize / 1024));
+	quota_data_inodes(ctx, &inode, -1);
 
 	/* Inode may have changed by block_iterate, so reread it */
 	e2fsck_read_inode(ctx, ino, &inode, "delete_file");
@@ -637,9 +640,11 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 		 */
 		if ((count == 0) ||
 		    ext2fs_test_block_bitmap(ctx->block_dup_map,
-					     inode.i_file_acl))
+					     inode.i_file_acl)) {
 			delete_file_block(fs, &inode.i_file_acl,
 					  BLOCK_COUNT_EXTATTR, 0, 0, &pb);
+			quota_data_sub(ctx, &inode, fs->blocksize / 1024);
+		}
 	}
 }
 
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 761c2f1..da4e21b 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1143,6 +1143,11 @@ abort_free_dict:
 	return DIRENT_ABORT;
 }
 
+struct del_block {
+	e2fsck_t		ctx;
+	e2_blkcnt_t		num;
+};
+
 /*
  * This function is called to deallocate a block, and is an interator
  * functioned called by deallocate inode via ext2fs_iterate_block().
@@ -1154,15 +1159,16 @@ static int deallocate_inode_block(ext2_filsys fs,
 				  int ref_offset EXT2FS_ATTR((unused)),
 				  void *priv_data)
 {
-	e2fsck_t	ctx = (e2fsck_t) priv_data;
+	struct del_block *p = priv_data;
 
 	if (HOLE_BLKADDR(*block_nr))
 		return 0;
 	if ((*block_nr < fs->super->s_first_data_block) ||
 	    (*block_nr >= fs->super->s_blocks_count))
 		return 0;
-	ext2fs_unmark_block_bitmap(ctx->block_found_map, *block_nr);
+	ext2fs_unmark_block_bitmap(p->ctx->block_found_map, *block_nr);
 	ext2fs_block_alloc_stats(fs, *block_nr, -1);
+	p->num++;
 	return 0;
 }
 
@@ -1175,6 +1181,7 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 	struct ext2_inode	inode;
 	struct problem_context	pctx;
 	__u32			count;
+	struct del_block	del_block;
 
 	e2fsck_read_inode(ctx, ino, &inode, "deallocate_inode");
 	e2fsck_clear_inode(ctx, ino, &inode, 0, "deallocate_inode");
@@ -1216,8 +1223,10 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 	    (inode.i_size_high || inode.i_size & 0x80000000UL))
 		ctx->large_files--;
 
+	del_block.ctx = ctx;
+	del_block.num = 0;
 	pctx.errcode = ext2fs_block_iterate2(fs, ino, 0, block_buf,
-					    deallocate_inode_block, ctx);
+					    deallocate_inode_block, &del_block);
 	if (pctx.errcode) {
 		fix_problem(ctx, PR_2_DEALLOC_INODE, &pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 5a5fd3e..21963a0 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -488,6 +488,9 @@ ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 	ext2fs_icount_store(ctx->inode_count, ino, 2);
 	ext2fs_icount_store(ctx->inode_link_info, ino, 2);
 	ctx->lost_and_found = ino;
+	quota_data_add(ctx, &inode, fs->blocksize / 1024);
+	quota_data_inodes(ctx, &inode, +1);
+
 #if 0
 	printf("/lost+found created; inode #%lu\n", ino);
 #endif
@@ -790,6 +793,7 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
 
 	inode.i_size = (es.last_block + 1) * fs->blocksize;
 	ext2fs_iblk_add_blocks(fs, &inode, es.newblocks);
+	quota_data_add(ctx, &inode, num * (fs->blocksize / 1024));
 
 	e2fsck_write_inode(ctx, dir, &inode, "expand_directory");
 
diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index d9706ce..0540e63 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -63,6 +63,7 @@ static int disconnect_inode(e2fsck_t ctx, ext2_ino_t i,
 			e2fsck_read_bitmaps(ctx);
 			ext2fs_inode_alloc_stats2(fs, i, -1,
 						  LINUX_S_ISDIR(inode->i_mode));
+			quota_data_inodes(ctx, inode, -1);
 			return 0;
 		}
 	}
@@ -183,6 +184,8 @@ void e2fsck_pass4(e2fsck_t ctx)
 	ctx->inode_bb_map = 0;
 	ext2fs_free_inode_bitmap(ctx->inode_imagic_map);
 	ctx->inode_imagic_map = 0;
+	quota_data_output(ctx);
+	quota_data_release(ctx);
 errout:
 	if (buf)
 		ext2fs_free_mem(&buf);
diff --git a/e2fsck/quota.c b/e2fsck/quota.c
new file mode 100644
index 0000000..f25a480
--- /dev/null
+++ b/e2fsck/quota.c
@@ -0,0 +1,275 @@
+/*
+ * quota.c --- collect and output quota information 
+ *
+ * Copyright (C) 2010 Theodore Ts'o.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include <errno.h>
+
+#include "e2fsck.h"
+#include "../version.h"
+
+#ifdef HAVE_INTTYPES_H
+#include <inttypes.h>
+#endif
+
+#ifndef HAVE_INTPTR_T
+typedef long intptr_t;
+#endif
+
+/* Needed for architectures where sizeof(int) != sizeof(void *) */
+#define UINT_TO_VOIDPTR(val)  ((void *)(intptr_t)(val))
+#define VOIDPTR_TO_UINT(ptr)  ((unsigned int)(intptr_t)(ptr))
+
+struct quota_el {
+	__u64	blks;
+	__u32	inodes;
+};
+
+static void quota_dnode_free(dnode_t *node,
+			     void *context EXT2FS_ATTR((unused)))
+{
+	void *ptr = node ? dnode_get(node) : 0;
+
+	free(ptr);
+	free(node);
+}
+
+static int dict_uint_cmp(const void *a, const void *b)
+{
+	unsigned int	c, d;
+
+	c = VOIDPTR_TO_UINT(a);
+	d = VOIDPTR_TO_UINT(b);
+
+	return (c-d);
+}
+
+static char *fn_canon(e2fsck_t ctx, char *name)
+{
+	char *cp, *ret;
+
+	cp = name;
+	if (!strncmp(cp, "/dev/", 5))
+		cp += 5;
+	else if (!strncmp(cp, "/device/", 8))
+		cp += 8;
+	ret = string_copy(ctx, cp, 0);
+	if (!ret)
+		return NULL;
+	for (cp = ret; *cp; cp++)
+		if (*cp == '/')
+			*cp = '_';
+	return ret;
+}
+
+void quota_data_files_default(e2fsck_t ctx)
+{
+	char	*cp, *quota_dir, *name_format, *name;
+	int	do_user, do_group, len;
+
+	profile_get_string(ctx->profile, "quota", "directory", 0, 0,
+			   &quota_dir);
+	if (quota_dir == 0)
+		return;
+	profile_get_string(ctx->profile, "quota", "name_format", 0, "name",
+			   &name_format);
+	profile_get_boolean(ctx->profile, "quota", "usrquota", 0, 1,
+			    &do_user);
+	profile_get_boolean(ctx->profile, "quota", "grpquota", 0, 1,
+			    &do_group);
+
+	if (ctx->quota_fname[USRQUOTA] || ctx->quota_fname[GRPQUOTA] ||
+	    (!do_user && !do_group))
+		return;
+
+	if (!strcmp(name_format, "uuid") ||
+	    !strcmp(name_format, "shortuuid")) {
+		char	uuid[37];
+
+		uuid_unparse(ctx->fs->super->s_uuid, uuid);
+		if (name_format[0] == 's')
+			uuid[8] = 0;
+		name = string_copy(ctx, uuid, 0);
+	} else if (!strcmp(name_format, "device")) {
+		name = fn_canon(ctx, ctx->filesystem_name);
+	} else /* if (!strcmp(name_format, "name")) */ {
+		name = fn_canon(ctx, ctx->device_name);
+	}
+	if (!name)
+		fatal_error(ctx, "Couldn't allocate quota file name!");
+
+	len = strlen(quota_dir) + strlen(name) + 32;
+
+	if (do_user) {
+		ctx->quota_fname[USRQUOTA] = 
+			e2fsck_allocate_memory(ctx, len, "quota file name");
+		sprintf(ctx->quota_fname[USRQUOTA], "%s/%s.user",
+			quota_dir, name);
+	}
+
+	if (do_group) {
+		ctx->quota_fname[GRPQUOTA] = 
+			e2fsck_allocate_memory(ctx, len, "quota file name");
+		sprintf(ctx->quota_fname[GRPQUOTA], "%s/%s.group",
+			quota_dir, name);
+	}
+}
+
+/*
+ * Called in Pass #1 to set up the quota tracking data structures
+ */
+void quota_data_initialize(e2fsck_t ctx)
+{
+	int	i;
+	dict_t	*dict;
+
+	for (i=0; i < MAXQUOTAS; i++) {
+		if (ctx->quota_fname[i] == 0)
+			continue;
+
+		dict = (dict_t *) e2fsck_allocate_memory(ctx, sizeof(dict_t),
+							 "quota data dict");
+		ctx->quota_dict[i] = dict;
+		dict_init(dict, DICTCOUNT_T_MAX, dict_uint_cmp);
+		dict_set_allocator(dict, NULL, quota_dnode_free, NULL);
+	}
+	return;
+}
+
+static struct quota_el *get_qp(e2fsck_t ctx, dict_t *dict, __u32 key)
+{
+	struct quota_el	*qp;
+	dnode_t		*n;
+
+	n = dict_lookup(dict, UINT_TO_VOIDPTR(key));
+	if (n)
+		qp = dnode_get(n);
+	else {
+		qp = e2fsck_allocate_memory(ctx,
+			    sizeof(struct quota_el), "quota block count");
+		dict_alloc_insert(dict, UINT_TO_VOIDPTR(key), qp);
+	}
+	return qp;
+}
+
+/*
+ * Called to update the blocks used by a particular inode
+ */
+void quota_data_add(e2fsck_t ctx, struct ext2_inode *inode, __u64 blocks)
+{
+	struct quota_el	*qp;
+	dict_t		*dict;
+
+	if ((dict = ctx->quota_dict[USRQUOTA]) != NULL) {
+		qp = get_qp(ctx, dict, inode_uid(*inode));
+		qp->blks += blocks;
+	}
+	if ((dict = ctx->quota_dict[GRPQUOTA]) != NULL) {
+		qp = get_qp(ctx, dict, inode_gid(*inode));
+		qp->blks += blocks;
+	}
+}
+
+/*
+ * Called to remove some blocks used by a particular inode
+ */
+void quota_data_sub(e2fsck_t ctx, struct ext2_inode *inode, __u64 blocks)
+{
+	struct quota_el	*qp;
+	dict_t		*dict;
+
+	if ((dict = ctx->quota_dict[USRQUOTA]) != NULL) {
+		qp = get_qp(ctx, dict, inode_uid(*inode));
+		qp->blks -= blocks;
+	}
+	if ((dict = ctx->quota_dict[GRPQUOTA]) != NULL) {
+		qp = get_qp(ctx, dict, inode_gid(*inode));
+		qp->blks -= blocks;
+	}
+}
+
+/*
+ * Called to count the files used by an inode's user/group
+ */
+void quota_data_inodes(e2fsck_t ctx, struct ext2_inode *inode, int adjust)
+{
+	struct quota_el	*qp;
+	dict_t		*dict;
+
+	if ((dict = ctx->quota_dict[USRQUOTA]) != NULL) {
+		qp = get_qp(ctx, dict, inode_uid(*inode));
+		qp->inodes += adjust;
+	}
+	if ((dict = ctx->quota_dict[GRPQUOTA]) != NULL) {
+		qp = get_qp(ctx, dict, inode_gid(*inode));
+		qp->inodes += adjust;
+	}
+}
+
+/*
+ * Output the data to ascii files
+ */
+void quota_data_output(e2fsck_t ctx)
+{
+	struct quota_el	*qp;
+	dnode_t		*n;
+	dict_t		*dict;
+	FILE		*f;
+	int		i;
+	__u32		key;
+
+	for (i=0; i < MAXQUOTAS; i++) {
+		dict = ctx->quota_dict[i];
+
+		if (!dict || ctx->quota_fname[i] == 0)
+			continue;
+
+		f = fopen(ctx->quota_fname[i], "w");
+		if (!f) {
+			com_err("quota_data_output", errno,
+				"while trying to open %s",
+				ctx->quota_fname[i]);
+			fatal_error(ctx, 0);
+		}
+		fprintf(f, "# Quota %s file for %s\n#\n",
+			(i == USRQUOTA) ? "user" : "group",
+			ctx->filesystem_name);
+		fprintf(f, "# Generated by e2fsck %s (%s) on %s#\n",
+			E2FSPROGS_VERSION, E2FSPROGS_DATE,
+			asctime(localtime(&ctx->now)));
+		fprintf(f, "# Format: %s-id\tnumblocks\tnumfiles\n#\n",
+			(i == USRQUOTA) ? "user" : "group");
+
+		for (n = dict_first(dict); n; n = dict_next(dict, n)) {
+			key = VOIDPTR_TO_UINT(dnode_getkey(n));
+			qp = dnode_get(n);
+			fprintf(f, "%-9u %-10llu %u\n", key,
+				(unsigned long long) qp->blks, qp->inodes);
+		}
+		fclose(f);
+	}
+}
+
+/*
+ * Release the data structures used to track user/group usage
+ */
+void quota_data_release(e2fsck_t ctx)
+{
+	dict_t	*dict;
+	int	i;
+	__u32	key;
+	__u64	*bp;
+
+	for (i=0; i < MAXQUOTAS; i++) {
+		dict = ctx->quota_dict[i];
+		if (dict)
+			dict_free_nodes(dict);
+		ctx->quota_dict[i] = 0;
+	}
+}
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index fd62ce5..c749ac0 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -586,6 +586,22 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 		} else if (strcmp(token, "fragcheck") == 0) {
 			ctx->options |= E2F_OPT_FRAGCHECK;
 			continue;
+		} else if (strcmp(token, "usrquota_check") == 0) {
+			if (!arg) {
+				extended_usage++;
+				continue;
+			}
+			if (ctx->quota_fname[USRQUOTA])
+				free(ctx->quota_fname[USRQUOTA]);
+			ctx->quota_fname[USRQUOTA] = string_copy(ctx, arg, 0);
+		} else if (strcmp(token, "grpquota_check") == 0) {
+			if (!arg) {
+				extended_usage++;
+				continue;
+			}
+			if (ctx->quota_fname[GRPQUOTA])
+				free(ctx->quota_fname[GRPQUOTA]);
+			ctx->quota_fname[GRPQUOTA] = string_copy(ctx, arg, 0);
 		} else {
 			fprintf(stderr, _("Unknown extended option: %s\n"),
 				token);
@@ -600,6 +616,8 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 		       "is set off by an equals ('=') sign.  "
 		       "Valid extended options are:\n"), stderr);
 		fputs(("\tea_ver=<ea_version (1 or 2)>\n"), stderr);
+		fputs(("\tusrquota_check=<output file name>\n"), stderr);
+		fputs(("\tgrpquota_check=<output file name>\n"), stderr);
 		fputs(("\tfragcheck\n"), stderr);
 		fputc('\n', stderr);
 		exit(1);
@@ -1178,6 +1196,8 @@ failure:
 		if (isspace(*cp) || *cp == ':')
 			*cp = '_';
 
+	quota_data_files_default(ctx);
+
 	ehandler_init(fs->io);
 
 	if ((ctx->mount_flags & EXT2_MF_MOUNTED) &&
