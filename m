From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/4] e2fsprogs: Add ext4migrate
Date: Fri,  4 May 2007 14:43:23 +0530
Message-ID: <11782700113984-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11782700042368-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11782700081019-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11782700102643-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:42562 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767763AbXEDJNh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 May 2007 05:13:37 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l449FNTU4038802
	for <linux-ext4@vger.kernel.org>; Fri, 4 May 2007 19:15:23 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l449H5vo135566
	for <linux-ext4@vger.kernel.org>; Fri, 4 May 2007 19:17:05 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l449DYNK009146
	for <linux-ext4@vger.kernel.org>; Fri, 4 May 2007 19:13:34 +1000
In-Reply-To: <11782700102643-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <1dcc9dea2106570ec314b59bf69e7e3720818a94.1178262586.git.aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <eb16ba5f2c6f399ea747169097434ae84443728f.1178262585.git.aneesh.kumar@linux.vnet.ibm.com>
References: <eb16ba5f2c6f399ea747169097434ae84443728f.1178262585.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Add ext4migrate utility that helps in migrating a ext3 block mapped
inode to ext4 extent mapped inode.

ext4migrate command takes the below syntax
ext4migrate --display | --migrate  <image_name> [<filename>]

The --display option helps in displaying the block map details for an ext3 inode
and extent map details for an ext4 inode. The --migrate option convert a block mapped
ext3 inode to extent mapped ext4 inode.

This needs to be run on an unmounted file system (offline migration).

The inode modification is done only at the last stage. This is to make sure that if we
fail at any intermediate stage, we exit without touching the disk.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 Makefile.in             |    3 +-
 configure.in            |   21 ++-
 ext4migrate/Makefile.in |   66 ++++
 ext4migrate/migrate.c   |  791 +++++++++++++++++++++++++++++++++++++++++++++++
 ext4migrate/migrate.h   |   30 ++
 5 files changed, 909 insertions(+), 2 deletions(-)
 create mode 100644 ext4migrate/Makefile.in
 create mode 100644 ext4migrate/migrate.c
 create mode 100644 ext4migrate/migrate.h

diff --git a/Makefile.in b/Makefile.in
index 0d31caa..9d8d291 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -9,9 +9,10 @@ INSTALL = @INSTALL@
 
 @RESIZER_CMT@RESIZE_DIR= resize
 @DEBUGFS_CMT@DEBUGFS_DIR= debugfs
+@EXT4MIGRATE_CMT@EXT4MIGRATE_DIR= ext4migrate
 
 LIB_SUBDIRS=lib/et lib/ss lib/e2p lib/ext2fs lib/uuid lib/blkid intl
-PROG_SUBDIRS=e2fsck $(DEBUGFS_DIR) misc $(RESIZE_DIR) tests/progs po
+PROG_SUBDIRS=e2fsck $(DEBUGFS_DIR) misc $(RESIZE_DIR) tests/progs po $(EXT4MIGRATE_DIR)
 SUBDIRS=util $(LIB_SUBDIRS) $(PROG_SUBDIRS) tests
 
 SUBS= lib/ext2fs/ext2_types.h lib/blkid/blkid_types.h lib/uuid/uuid_types.h
diff --git a/configure.in b/configure.in
index 44b718d..5ae5e0b 100644
--- a/configure.in
+++ b/configure.in
@@ -436,6 +436,24 @@ echo "Building e2fsck statically by default"
 )
 AC_SUBST(E2FSCK_TYPE)
 dnl
+dnl handle --enable-ext4migrate
+dnl
+AC_ARG_ENABLE([ext4migrate],
+[  --disable-ext4migrate	  disable support of ext4migrate program],
+if test "$enableval" = "no"
+then
+	echo "Disabling ext4migrate support"
+	EXT4MIGRATE_CMT="#"
+else
+	EXT4MIGRATE_CMT=
+	echo "Enabling ext4migrate support"
+fi
+,
+echo "Enabling ext4migrate support by default"
+EXT4MIGRATE_CMT=
+)
+AC_SUBST(EXT4MIGRATE_CMT)
+dnl
 dnl See whether to install the `fsck' wrapper program (that calls e2fsck)
 dnl
 AC_ARG_ENABLE([fsck],
@@ -862,7 +880,8 @@ for i in MCONFIG Makefile e2fsprogs.spec \
 	lib/e2p/e2p.pc lib/blkid/blkid.pc lib/ext2fs/ext2fs.pc \
 	misc/Makefile ext2ed/Makefile e2fsck/Makefile \
 	debugfs/Makefile tests/Makefile tests/progs/Makefile \
-	resize/Makefile doc/Makefile intl/Makefile po/Makefile.in ; do
+	resize/Makefile doc/Makefile intl/Makefile po/Makefile.in \
+	ext4migrate/Makefile ; do
 	if test -d `dirname ${srcdir}/$i` ; then
 		outlist="$outlist $i"
 	fi
diff --git a/ext4migrate/Makefile.in b/ext4migrate/Makefile.in
new file mode 100644
index 0000000..b000ae7
--- /dev/null
+++ b/ext4migrate/Makefile.in
@@ -0,0 +1,66 @@
+#
+# Standard e2fsprogs prologue....
+#
+
+srcdir = @srcdir@
+top_srcdir = @top_srcdir@
+VPATH = @srcdir@
+top_builddir = ..
+my_dir = util
+INSTALL = @INSTALL@
+@MCONFIG@
+
+SRCS = $(srcdir)/migrate.c
+
+LIBS= $(LIBEXT2FS)  $(LIBCOM_ERR) -ltdb
+DEPLIBS= $(LIBEXT2FS)  $(LIBCOM_ERR)
+
+.c.o:
+	@echo "	CC $<"
+	@$(CC) -c $(ALL_CFLAGS) $< -o $@
+	@#cc -g -I../lib/  -Wunreachable-code -Wunused -Wunused-function
+	@#-Wunused-label  -Wunused-parameter -Wunused-value  -Wunused-variable  -c migrate.c
+
+PROGS= ext4migrate
+
+all:: $(PROGS)
+
+ext4migrate: migrate.o  extents.o $(DEPLIBS)
+	@echo "	LD $@"
+	@$(CC) $(ALL_LDFLAGS) -o ext4migrate migrate.o extents.o $(LIBS)
+
+installdirs:
+	@echo "	MKINSTALLDIRS $(root_sbindir)"
+	@$(MKINSTALLDIRS) $(DESTDIR)$(root_sbindir)
+
+install: $(PROGS) installdirs
+	@for i in $(PROGS); do \
+		echo "	INSTALL $(root_sbindir)/$$i"; \
+		$(INSTALL_PROGRAM) $$i $(DESTDIR)$(root_sbindir)/$$i; \
+	done
+
+install-strip: install
+	@for i in $(PROGS); do \
+		echo "	STRIP $(root_sbindir)/$$i"; \
+		$(STRIP) $(DESTDIR)$(root_sbindir)/$$i; \
+	done
+
+uninstall:
+	for i in $(PROGS); do \
+		$(RM) -f $(DESTDIR)$(root_sbindir)/$$i; \
+	done
+clean:
+	$(RM) -f $(PROGS) \#* *.s *.o *.a *~ core
+
+mostlyclean: clean
+
+distclean: clean
+	$(RM) -f .depend Makefile $(srcdir)/TAGS $(srcdir)/Makefile.in.old
+
+# +++ Dependency line eater +++
+#
+# Makefile dependencies follow.  This must be the last section in
+# the Makefile.in file
+#
+migrate.o: $(srcdir)/migrate.c
+extents.o: $(srcdir)/extents.c
diff --git a/ext4migrate/migrate.c b/ext4migrate/migrate.c
new file mode 100644
index 0000000..d6348c8
--- /dev/null
+++ b/ext4migrate/migrate.c
@@ -0,0 +1,791 @@
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "migrate.h"
+#include "extents.h"
+
+static struct list_head blk_cache_head;
+static struct list_head blk_stat_head;
+static blk_t i_block[EXT2_N_BLOCKS];
+static int migrate = 0;
+ext2_filsys current_fs = NULL;
+
+static void free_blk_cache(void)
+{
+	struct list_head *entry, *tmp;
+	struct blk_cache *blk;
+
+	list_for_each_safe(entry, tmp, &blk_cache_head) {
+		blk = list_entry(entry, struct blk_cache, head);
+		list_del(entry);
+		free(blk->block_mem_addr);
+		free(blk);
+	}
+
+	INIT_LIST_HEAD(&blk_cache_head);
+}
+
+static void free_blk_stat(void)
+{
+	struct list_head *entry, *tmp;
+	struct blk_stat *stat;
+
+	list_for_each_safe(entry, tmp, &blk_stat_head) {
+		stat = list_entry(entry, struct blk_stat, head);
+		list_del(entry);
+		free(stat);
+	}
+	INIT_LIST_HEAD(&blk_stat_head);
+}
+
+static void init_iblock()
+{
+	struct ext3_extent_header *eh = (struct ext3_extent_header *)i_block;
+	eh->eh_magic = EXT4_EXT_MAGIC;
+	eh->eh_entries = 0;
+	eh->eh_depth = 0;
+	eh->eh_max = ext3_ext_space_root();
+}
+
+static void usage(char *prg_name)
+{
+	fprintf(stderr,
+			"%s --display | --migrate <image_name> [<filename>]\n",
+			prg_name);
+	exit(1);
+}
+
+static int build_extent(blk_t start_blk, blk_t end_blk,
+		e2_blkcnt_t start_pblk, e2_blkcnt_t end_pblk)
+{
+
+	int retval = 0;
+	struct ext3_extent newext;
+	struct ext4_ext_path *path;
+	/* start with a local allocated array without touching the inode */
+	struct ext3_extent_header *eh = (struct ext3_extent_header *)i_block;
+	(void)end_pblk;
+
+	newext.ee_block = start_blk;
+	newext.ee_len = end_blk - start_blk +1;
+	ext3_ext_store_pblock(&newext, start_pblk);
+
+	path = ext3_ext_find_extent(eh, start_blk, NULL);
+
+	if (!path)
+		return EXT2_ET_BLOCK_ALLOC_FAIL;
+
+	retval = ext3_ext_insert_extent(eh, path, &newext);
+
+	free(path);
+	return retval;
+}
+
+static void finish_range(struct list_blocks_struct *lb)
+{
+	int retval;
+
+	if (lb->first_block == 0)
+		return;
+
+	printf("(%lld-%lld):%u-%u\n", lb->first_bcnt, lb->last_bcnt,
+					lb->first_block, lb->last_block);
+
+	if (migrate) {
+		retval = build_extent(lb->first_bcnt, lb->last_bcnt,
+					lb->first_block, lb->last_block);
+		if (retval) {
+			com_err("build_extent", retval,
+					": Failed to build extent");
+			exit(1);
+		}
+	}
+
+	lb->first_block = 0;
+}
+/*
+ * We don't want to update the filesystem block bitmap
+ * directly. For indirect blocks and others which we need
+ * to mark as unused, we want to track them but not update
+ * the file systembitmap early. This is needed to make sure
+ * the subsequent request for free blocks are not satisfied
+ * by these indirect blocks. This makes sure that if
+ * we fail later writing the inode, we have consistent
+ * block bitmap.
+ */
+
+static int mark_block_bitmap(ext4_fsblk_t pblock, int update)
+{
+	struct blk_stat *stat;
+
+	stat = malloc(sizeof(struct blk_stat));
+	if (!stat) {
+		return EXT2_ET_BLOCK_ALLOC_FAIL;
+	}
+
+	stat->pblock = pblock;
+	stat->dirty = 1;
+	list_add(&(stat->head),  &blk_stat_head);
+
+	if (update) {
+		ext2fs_mark_block_bitmap(current_fs->block_map, stat->pblock);
+		ext2fs_mark_bb_dirty(current_fs);
+	}
+
+	return 0;
+
+
+}
+static int unmark_block_bitmap(ext4_fsblk_t pblock, int update)
+{
+	struct blk_stat *stat;
+
+	stat = malloc(sizeof(struct blk_stat));
+	if (!stat) {
+		return EXT2_ET_BLOCK_ALLOC_FAIL;
+	}
+
+	stat->pblock = pblock;
+	stat->dirty = 0;
+	list_add(&(stat->head),  &blk_stat_head);
+
+	if (update) {
+		ext2fs_unmark_block_bitmap(current_fs->block_map, stat->pblock);
+		ext2fs_mark_bb_dirty(current_fs);
+	}
+
+	return 0;
+}
+
+static int write_block_bitmap(struct ext2_inode *inode, int write_to_fs)
+{
+	struct blk_stat *stat;
+	struct list_head *entry;
+	int total_blocks_added = 0, group;
+
+	list_for_each(entry, &blk_stat_head) {
+
+		stat = list_entry(entry, struct blk_stat, head);
+		group = ext2fs_group_of_blk(current_fs, stat->pblock);
+		if (stat->dirty) {
+			total_blocks_added++;
+			current_fs->group_desc[group].bg_free_blocks_count--;
+			current_fs->super->s_free_blocks_count--;
+			ext2fs_mark_block_bitmap(current_fs->block_map,
+								stat->pblock);
+		} else {
+			total_blocks_added--;
+			current_fs->group_desc[group].bg_free_blocks_count++;
+			current_fs->super->s_free_blocks_count++;
+			ext2fs_unmark_block_bitmap(current_fs->block_map,
+								stat->pblock);
+		}
+	}
+
+	/*
+	 * Update the inode block count
+	 */
+	if (total_blocks_added) {
+
+		inode->i_blocks += total_blocks_added *
+					(current_fs->blocksize / 512);
+	}
+
+
+	if (write_to_fs) {
+		ext2fs_mark_bb_dirty(current_fs);
+		return ext2fs_write_block_bitmap(current_fs);
+	}
+	return 0;
+}
+
+static int undo_write_block_bitmap(struct ext2_inode *inode, int write_to_fs)
+{
+	struct blk_stat *stat;
+	struct list_head *entry;
+	int total_blocks_added = 0, group;
+
+	list_for_each(entry, &blk_stat_head) {
+
+		stat = list_entry(entry, struct blk_stat, head);
+		group = ext2fs_group_of_blk(current_fs, stat->pblock);
+		if (stat->dirty) {
+			total_blocks_added--;
+			current_fs->group_desc[group].bg_free_blocks_count++;
+			current_fs->super->s_free_blocks_count++;
+			ext2fs_unmark_block_bitmap(current_fs->block_map,
+								stat->pblock);
+		} else {
+			total_blocks_added++;
+			current_fs->group_desc[group].bg_free_blocks_count--;
+			current_fs->super->s_free_blocks_count--;
+			ext2fs_mark_block_bitmap(current_fs->block_map,
+								stat->pblock);
+		}
+	}
+
+	/*
+	 * Update the inode block count
+	 */
+	if (total_blocks_added) {
+
+		inode->i_blocks += total_blocks_added *
+					(current_fs->blocksize / 512);
+	}
+
+
+	if (write_to_fs) {
+		ext2fs_mark_bb_dirty(current_fs);
+		return ext2fs_write_block_bitmap(current_fs);
+	}
+	return 0;
+}
+
+
+static int list_blocks_proc(ext2_filsys fs EXT2FS_ATTR((unused)),
+			    blk_t *blocknr, e2_blkcnt_t blockcnt,
+			    blk_t ref_block EXT2FS_ATTR((unused)),
+			    int ref_offset EXT2FS_ATTR((unused)),
+			    void *private)
+{
+	struct list_blocks_struct *lb = (struct list_blocks_struct *) private;
+
+	if (blockcnt >= 0) {
+		/*
+		 * See if we can add on to the existing range (if it exists)
+		 */
+		if (lb->first_block &&
+		    (lb->last_block+1 == *blocknr) &&
+		    (lb->last_bcnt+1 == blockcnt)) {
+			lb->last_block = *blocknr;
+			lb->last_bcnt = blockcnt;
+			return 0;
+		}
+		/*
+		 * Start a new range.
+		 */
+		finish_range(lb);
+		lb->first_block = lb->last_block = *blocknr;
+		lb->first_bcnt = lb->last_bcnt = blockcnt;
+	} else {
+		/*
+		 * special blocks such as indirect, double indrect and triple
+		 * indirect blocks. Mark them as free if we are migrating
+		 * BLOCK_COUNT_IND BLOCK_COUNT_DIND BLOCK_COUNT_TIND
+		 */
+		if (migrate) {
+			/*
+			 * We should not update the file system bitmap
+			 * because we don't want the next request for
+			 * free block to be satisfied by this block.
+			 */
+			if (unmark_block_bitmap(*blocknr, 0))
+				return BLOCK_ABORT;
+		}
+	}
+
+	return 0;
+}
+
+static void iterate_blocks(ext2_filsys current_fs, ext2_ino_t inode_num)
+{
+	struct list_blocks_struct lb;
+	lb.first_block = 0;
+
+	ext2fs_block_iterate2(current_fs, inode_num, 0, NULL,
+					list_blocks_proc, (void *)&lb);
+
+	finish_range(&lb);
+}
+
+/*FIXME!! goal value passed as zero */
+
+/* FIXME!! 48 bit block
+ * Can we ask for block addressed by 48 bit ?
+ * We have actually mounted a ext3 file system via ext4dev If want want
+ * we will have to change the group descriptor also */
+/* Function is also called from extents.c */
+static struct blk_cache * __get_block(ext2_filsys current_fs,
+						ext4_fsblk_t pblock)
+{
+	struct list_head *entry;
+	struct blk_cache *blk;
+	void *addr;
+	int retval;
+	/* need to initialize to fix corruption due to (long) typecasting */
+	ext4_fsblk_t block = 0;
+
+
+	if (pblock == 0) {
+		/* allocate in disk and give back */
+		/* FIXME!! 48 bit block */
+		retval = ext2fs_new_block(current_fs, 0, NULL, (blk_t *)&block);
+		if (retval) {
+			/*
+			 * In case we fail we don't write/sync previous update
+			 * we don't want partial conversion
+			 */
+			return NULL;
+		}
+		/*
+		 * We need to update the file system bitmap also
+		 * otherwise this block may be double allocated
+		 */
+		if (mark_block_bitmap(block, 1))
+			return NULL;
+
+		addr = malloc(current_fs->blocksize);
+		if (!addr)
+			return NULL;
+		memset(addr, 0, current_fs->blocksize);
+
+		blk = malloc(sizeof(struct blk_cache));
+		if (!blk) {
+			free(addr);
+			return NULL;
+		}
+
+		blk->pblock = (ext4_fsblk_t)block;
+		blk->block_mem_addr = addr;
+		list_add(&(blk->head),  &blk_cache_head);
+
+		return blk;
+	}
+
+
+	list_for_each(entry, &blk_cache_head) {
+
+		blk = list_entry(entry, struct blk_cache, head);
+
+		if (blk->pblock == pblock ) {
+			return blk;
+
+		}
+	}
+
+	/*
+	 * No block present. Allocate a disk block and a memory equivalent
+	 * add the same to the list and return the address
+	 */
+
+	/* FIXME!! 48 bit block */
+	retval = ext2fs_new_block(current_fs, 0, NULL, (blk_t *)&block);
+	if (retval) {
+		/*
+		 * In case we fail we don't write/sync previous update
+		 * we don't want partial conversion
+		 */
+		return NULL;
+	}
+	/*
+	 * We need to update the file system bitmap also
+	 * otherwise this block may be double allocated
+	 */
+	if (mark_block_bitmap(block, 1))
+		return NULL;
+
+	addr = malloc(current_fs->blocksize);
+	if (!addr)
+		return NULL;
+	memset(addr, 0, current_fs->blocksize);
+
+	blk = malloc(sizeof(struct blk_cache));
+	if (!blk) {
+		free(addr);
+		return NULL;
+	}
+
+	blk->pblock = (ext4_fsblk_t)block;
+	blk->block_mem_addr = addr;
+	list_add(&(blk->head),  &blk_cache_head);
+
+	return blk;
+
+}
+
+struct blk_cache * get_block(ext4_fsblk_t pblock)
+{
+
+	return __get_block(current_fs, pblock);
+}
+
+static int write_extent_block(ext2_filsys current_fs,
+				ext4_fsblk_t pblock, void *buf)
+{
+	struct ext3_extent_header *eh = (struct ext3_extent_header *)buf;
+	struct ext3_extent_idx *ix;
+	ext4_fsblk_t tpblock;
+	struct blk_cache *blkc;
+	int i, retval;
+
+	if (eh->eh_depth == 0) {
+		retval = ext2fs_write_ext_block(current_fs, pblock, buf);
+		if (retval)
+			goto err_out;
+	} else {
+		ix = EXT_FIRST_INDEX(eh);
+		for (i = 0; i < eh->eh_entries; i++, ix++) {
+
+			tpblock = idx_pblock(ix);
+			blkc = get_block(tpblock);
+			if (!blkc) {
+				retval = EXT2_ET_BLOCK_ALLOC_FAIL;
+				goto err_out;
+			}
+			retval = write_extent_block(current_fs,
+							blkc->pblock,
+							blkc->block_mem_addr);
+			if (retval) {
+				goto err_out;
+			}
+		}
+		retval = ext2fs_write_ext_block(current_fs, pblock, buf);
+		if (retval)
+			goto err_out;
+
+	}
+
+err_out:
+
+	return retval;
+
+}
+
+
+static int write_extent_details(ext2_filsys current_fs, ext2_ino_t inode_num,
+				struct ext2_inode *inode, blk_t *i_block)
+{
+
+	struct ext3_extent_header *eh = (struct ext3_extent_header *)i_block;
+	struct ext3_extent_idx *ix;
+	ext4_fsblk_t pblock;
+	struct blk_cache *blkc;
+	int i, retval;
+
+
+	/* Write the blocks to the disk */
+	if (eh->eh_depth != 0) {
+		/* need to write blocks corresponding to  extent_idx */
+		ix = EXT_FIRST_INDEX(eh);
+		for (i = 0; i < eh->eh_entries; i++, ix++) {
+
+			pblock = idx_pblock(ix);
+			blkc = get_block(pblock);
+			if (!blkc) {
+				retval = EXT2_ET_BLOCK_ALLOC_FAIL;
+				goto err_out;
+			}
+			retval = write_extent_block(current_fs,
+							blkc->pblock,
+							blkc->block_mem_addr);
+			if (retval) {
+				goto err_out;
+			}
+		}
+	}
+
+	/*
+	 * Don't write to the file system. If we have
+	 * multiple files to migrate we batch the block
+	 * bitmap update
+	 */
+	retval = write_block_bitmap(inode, 0);
+	if (retval) {
+		goto err_out;
+	}
+
+	inode->i_flags |= EXT4_EXTENTS_FL;
+	memcpy(inode->i_block, i_block, sizeof(inode->i_block));
+	/* write inode */
+	retval = ext2fs_write_inode(current_fs, inode_num, inode);
+	if (retval) {
+		undo_write_block_bitmap(inode, 0);
+		goto err_out;
+	}
+
+
+
+err_out:
+	return retval;
+
+}
+
+static int do_migrate(ext2_filsys current_fs,
+				ext2_ino_t inode_num, char *file_name)
+{
+	int retval, saved_migrate;
+	struct ext2_inode inode;
+
+	/* reset the i_block array */
+	init_iblock();
+
+	saved_migrate = migrate;
+
+
+	printf("%s inode number %d\n", file_name, inode_num);
+
+	retval = ext2fs_read_inode(current_fs, inode_num, &inode);
+	if (retval) {
+		com_err(file_name, retval,": Unable to get file inode number");
+		goto err_out;
+	}
+
+	if (inode.i_flags & EXT4_EXTENTS_FL) {
+		printf("Extent already enabled\n");
+		migrate = 0 ;
+	}
+
+	iterate_blocks(current_fs, inode_num);
+
+	if (migrate) {
+
+		/*
+		 * Only if we have successfully walked the
+		 * block mapping write the extent details
+		 */
+		retval = write_extent_details(current_fs, inode_num,
+							&inode, i_block);
+		if (retval) {
+			com_err(file_name, 0,
+					"Failed to write extent details");
+			goto err_out;
+		}
+
+		/* dump the migrated extent details */
+		migrate = 0;
+		printf("Extent details after migrate\n");
+		iterate_blocks(current_fs, inode_num);
+	}
+
+	/* reset the value of migrate */
+	migrate = saved_migrate;
+
+err_out:
+	free_blk_cache();
+	free_blk_stat();
+	return retval;
+
+
+}
+
+static int dir_migrate_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
+				int	entry EXT2FS_ATTR((unused)),
+				struct ext2_dir_entry *dirent,
+				int	offset EXT2FS_ATTR((unused)),
+				int	blocksize EXT2FS_ATTR((unused)),
+				char	*buf EXT2FS_ATTR((unused)),
+				void	*private EXT2FS_ATTR((unused)))
+{
+	int retval;
+	struct ext2_inode inode;
+	char file_name[EXT2_NAME_LEN];
+
+	if (dirent->inode == 0)
+		return 0;
+	if (((dirent->name_len&0xFF) == 1) && (dirent->name[0] == '.'))
+		return 0;
+	if (((dirent->name_len&0xFF) == 2) && (dirent->name[0] == '.') &&
+						(dirent->name[1] == '.')) {
+		return 0;
+	}
+
+	retval = ext2fs_read_inode(current_fs, dirent->inode, &inode);
+	if (retval) {
+		goto err_out;
+	}
+	if (LINUX_S_ISDIR(inode.i_mode)) {
+		/*
+		 * Directory iterate this again
+		 */
+		retval = ext2fs_dir_iterate2(current_fs, dirent->inode, 0, 0,
+							dir_migrate_proc, 0);
+		if (retval) {
+			goto err_out;
+		}
+
+
+	} else if (LINUX_S_ISREG(inode.i_mode)) {
+
+		/*
+		 * properly NULL terminate the name
+		 */
+		int this_len = ((dirent->name_len & 0xFF) < EXT2_NAME_LEN) ?
+				(dirent->name_len & 0xFF) : EXT2_NAME_LEN;
+
+		strncpy(file_name, dirent->name, this_len);
+		file_name[this_len] = '\0';
+
+		retval = do_migrate(current_fs, dirent->inode, file_name);
+		if (retval) {
+			goto err_out;
+		}
+
+	}
+
+	return 0;
+
+err_out:
+	retval = DIRENT_ABORT;
+	return retval;
+
+
+}
+static void recursive_migrate(ext2_filsys current_fs)
+{
+
+	int retval;
+
+	retval = ext2fs_dir_iterate2(current_fs, EXT2_ROOT_INO, 0, 0,
+						dir_migrate_proc, 0);
+	if (retval)
+		goto err_out;
+
+	if (migrate && !EXT2_HAS_INCOMPAT_FEATURE(current_fs->super,
+				EXT3_FEATURE_INCOMPAT_EXTENTS)) {
+
+		EXT2_SET_INCOMPAT_FEATURE(current_fs->super,
+				EXT3_FEATURE_INCOMPAT_EXTENTS);
+
+	}
+
+	if (migrate) {
+
+		ext2fs_mark_bb_dirty(current_fs);
+		ext2fs_mark_super_dirty(current_fs);
+
+		/*
+		 * Write the block bitmap
+		 */
+		retval = ext2fs_write_block_bitmap(current_fs);
+		if (retval == 0)
+			current_fs->super->s_state |= EXT2_VALID_FS;
+	}
+err_out:
+	ext2fs_close(current_fs);
+	return ;
+}
+
+main(int argc, char *argv[])
+{
+	char *dev_name, *file_name;
+	int flags, superblock = 0;
+	unsigned int block_size = 0;
+	int retval, i, recursive = 0;
+	ext2_ino_t inode_num;
+
+	if (argc < 3) {
+		usage(argv[0]);
+	}
+
+	if (strcmp(argv[1], "--migrate") == 0) {
+		migrate = 1;
+	} else if (strcmp(argv[1], "--display") == 0) {
+		migrate = 0;
+	} else {
+		usage(argv[0]);
+	}
+
+	dev_name = argv[2];
+
+	if (argc == 3) {
+		recursive = 1;
+	}
+
+	if (migrate) {
+		flags = EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_RW;
+		retval = ext2fs_open2(dev_name,"tdbfilename=/tmp/test.tdb&",
+					flags, superblock, block_size,
+					unix_cow_io_manager, &current_fs);
+	} else {
+		flags = EXT2_FLAG_SOFTSUPP_FEATURES;
+		retval = ext2fs_open2(dev_name, 0,
+					flags, superblock, block_size,
+					unix_cow_io_manager, &current_fs);
+	}
+
+#ifdef DEBUG
+	retval = ext2fs_open2(dev_name, 0, flags, superblock,
+				block_size, unix_io_manager, &current_fs);
+#endif
+
+	if (retval) {
+		com_err(dev_name, retval,": Unable to open the file system");
+		return;
+	}
+
+	retval = ext2fs_read_inode_bitmap(current_fs);
+	if (retval) {
+		com_err(dev_name, retval,": Unable to read inode bitmap");
+		goto err_out;
+	}
+	retval =  ext2fs_read_block_bitmap(current_fs);
+	if (retval) {
+		com_err(dev_name, retval,": Unable to read block bitmap");
+		goto err_out;
+	}
+
+	/*
+	 * initialize the list head for block cache and bloc stat
+	 */
+	INIT_LIST_HEAD(&blk_cache_head);
+	INIT_LIST_HEAD(&blk_stat_head);
+
+	/* Mark the file system as unclean
+	 * This will force a fsck if something goes wrong later
+	 */
+	if (migrate)
+		current_fs->super->s_state &= ~EXT2_VALID_FS;
+
+	if (recursive) {
+		/*
+		 * Migrate all the ext3 inode in the file
+		 * system to extent map
+		 */
+		recursive_migrate(current_fs);
+		return ;
+	}
+
+	for (i = 3; i < argc; i++) {
+
+		file_name = argv[i];
+		retval = ext2fs_namei(current_fs, EXT2_ROOT_INO,
+				EXT2_ROOT_INO, file_name, &inode_num);
+		if (retval) {
+			com_err(file_name, retval,
+					": Unable to get file inode number");
+			goto err_out;
+		}
+
+		retval = do_migrate(current_fs, inode_num, file_name);
+		if (retval) {
+			/*
+			 * If we fail to migrate then exit
+			 */
+				goto err_out;
+		}
+	}
+
+	if (migrate && !EXT2_HAS_INCOMPAT_FEATURE(current_fs->super,
+				EXT3_FEATURE_INCOMPAT_EXTENTS)) {
+
+		EXT2_SET_INCOMPAT_FEATURE(current_fs->super,
+				EXT3_FEATURE_INCOMPAT_EXTENTS);
+
+	}
+
+	if (migrate) {
+
+		ext2fs_mark_bb_dirty(current_fs);
+		ext2fs_mark_super_dirty(current_fs);
+
+		/*
+		 * Write the block bitmap
+		 */
+		retval = ext2fs_write_block_bitmap(current_fs);
+		if (retval == 0)
+			current_fs->super->s_state |= EXT2_VALID_FS;
+	}
+err_out:
+	ext2fs_close(current_fs);
+}
+
diff --git a/ext4migrate/migrate.h b/ext4migrate/migrate.h
new file mode 100644
index 0000000..7dbb93b
--- /dev/null
+++ b/ext4migrate/migrate.h
@@ -0,0 +1,30 @@
+
+#include "ext2fs/ext2_fs.h"
+#include "ext2fs/ext2fs.h"
+#include "blkid/list.h"
+
+typedef unsigned long long ext4_fsblk_t;
+
+extern ext2_filsys current_fs;
+
+#define EXT4_EXT_MAGIC		0xf30a
+#define EXT2_SET_INCOMPAT_FEATURE(sb,mask) \
+	( EXT2_SB(sb)->s_feature_incompat |= (mask) )
+
+
+struct list_blocks_struct {
+	blk_t		first_block, last_block;
+	e2_blkcnt_t	first_bcnt, last_bcnt;
+};
+
+struct  blk_stat {
+	struct list_head  head;
+	ext4_fsblk_t pblock;
+	int dirty;
+};
+
+struct blk_cache {
+	struct list_head  head;
+	ext4_fsblk_t pblock;
+	void * block_mem_addr;
+};
-- 
1.5.2.rc0.71.g4342-dirty
