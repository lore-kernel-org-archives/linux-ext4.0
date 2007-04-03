From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/2] e2fsprogs: Add ext4migrate
Date: Tue,  3 Apr 2007 15:37:25 +0530
Message-ID: <1175594870272-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11755948452525-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <11755948531653-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:45776 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966157AbXDCKIr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Apr 2007 06:08:47 -0400
Received: from sd0208e0.au.ibm.com (d23rh904.au.ibm.com [202.81.18.202])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l33AQdOF328186
	for <linux-ext4@vger.kernel.org>; Tue, 3 Apr 2007 20:26:39 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0208e0.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l33ABxTt162554
	for <linux-ext4@vger.kernel.org>; Tue, 3 Apr 2007 20:12:04 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l33A8DPr027192
	for <linux-ext4@vger.kernel.org>; Tue, 3 Apr 2007 20:08:14 +1000
In-Reply-To: <11755948531653-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <1fddbefe9a421383b472c740fd89378c2c4b4020.1175594287.git.aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <df654d0faa4a4be12a023ed99c5853956ce05664.1175594287.git.aneesh.kumar@linux.vnet.ibm.com>
References: <df654d0faa4a4be12a023ed99c5853956ce05664.1175594287.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Add ext4migrate utility that helps in migrating a ext3 block mapped
inode to ext4 extent mapped inode.

ext4migrate command takes the below syntax
ext4migrate [--display | --migrate ] <image_name> <filename>

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
 ext4migrate/Makefile.in |   66 +++++++
 ext4migrate/migrate.c   |  491 +++++++++++++++++++++++++++++++++++++++++++++++
 ext4migrate/migrate.h   |   27 +++
 5 files changed, 606 insertions(+), 2 deletions(-)
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
index 0000000..2596508
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
+LIBS= $(LIBEXT2FS)  $(LIBCOM_ERR) 
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
index 0000000..0d851cc
--- /dev/null
+++ b/ext4migrate/migrate.c
@@ -0,0 +1,491 @@
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
+static void blk_init(void)
+{
+	INIT_LIST_HEAD(&blk_cache_head);
+	INIT_LIST_HEAD(&blk_stat_head);
+}
+
+static void inode_i_block_init()
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
+	fprintf(stderr, "%s [--display | --migrate ] <image_name> <filename>\n", prg_name);
+	exit(1);
+}
+
+static int build_extent(blk_t start_blk, blk_t end_blk, e2_blkcnt_t start_pblk, e2_blkcnt_t end_pblk)
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
+						lb->first_block, lb->last_block);
+		if (retval) {
+			com_err("build_extent", retval, ": Failed to build extent");
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
+static int mark_block_bitmap(ext4_fsblk_t pblock)
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
+	return 0;
+
+
+}
+static int unmark_block_bitmap(ext4_fsblk_t pblock)
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
+	return 0;
+}
+
+static int write_block_bitmap()
+{
+	struct blk_stat *stat;
+	struct list_head *entry;
+
+	list_for_each(entry, &blk_stat_head) {
+
+		stat = list_entry(entry, struct blk_stat, head);
+		if (stat->dirty) {
+			ext2fs_mark_block_bitmap(current_fs->block_map, stat->pblock);
+		} else {
+			ext2fs_unmark_block_bitmap(current_fs->block_map, stat->pblock);
+		}
+	}
+
+	ext2fs_mark_bb_dirty(current_fs);
+
+	return ext2fs_write_block_bitmap(current_fs);
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
+			if (unmark_block_bitmap(*blocknr))
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
+	ext2fs_block_iterate2(current_fs, inode_num, 0, NULL, list_blocks_proc, (void *)&lb);
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
+static struct blk_cache * __get_block(ext2_filsys current_fs, ext4_fsblk_t pblock)
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
+		if (mark_block_bitmap(block))
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
+	if (mark_block_bitmap(block))
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
+static int write_extent_block(ext2_filsys current_fs, ext4_fsblk_t pblock, void *buf)
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
+			retval = write_extent_block(current_fs, blkc->pblock, blkc->block_mem_addr);
+			if (retval) {
+				goto err_out;
+			}
+		}
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
+		struct ext2_inode *inode, blk_t *i_block)
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
+			retval = write_extent_block(current_fs, blkc->pblock, blkc->block_mem_addr);
+			if (retval) {
+				goto err_out;
+			}
+		}
+	}
+
+	inode->i_flags |= EXT4_EXTENTS_FL;
+	memcpy(inode->i_block, i_block, sizeof(inode->i_block));
+	/* write inode */
+	retval = ext2fs_write_inode(current_fs, inode_num, inode);
+	if (retval) {
+		goto err_out;
+	}
+
+	/*
+	 * write  the updated block bit map at the end
+	 * so that we don't need to reset the bitmap later
+	 * if something fails
+	 */
+
+	retval = write_block_bitmap();
+	if (retval) {
+		goto err_out;
+	}
+
+	if (!(current_fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS)) {
+		current_fs->super->s_feature_incompat |= EXT3_FEATURE_INCOMPAT_EXTENTS;
+
+		/* FIXME!! should we write super block */
+		ext2fs_mark_super_dirty(current_fs);
+	}
+
+err_out:
+	return retval;
+
+}
+
+main(int argc, char *argv[])
+{
+	char *dev_name, *file_name;
+	int flags, superblock = 0;
+	unsigned int block_size = 0;
+	ext2_ino_t inode_num;
+	struct ext2_inode inode;
+	int retval;
+
+	if (argc < 3 || argc > 4) {
+		usage(argv[0]);
+	}
+
+	blk_init();
+	inode_i_block_init();
+
+	if (argc == 3 ) {
+		dev_name = argv[1];
+		file_name = argv[2];
+	} else {
+		if (strcmp(argv[1], "--migrate") == 0) {
+			migrate = 1;
+		} else if (strcmp(argv[1], "--display") == 0) {
+			migrate = 0;
+		} else {
+			usage(argv[0]);
+		}
+		dev_name = argv[2];
+		file_name = argv[3];
+	}
+
+	if (migrate) {
+		flags = EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_RW | EXT2_FLAG_SUPER_ONLY | EXT2_FLAG_MASTER_SB_ONLY;
+	} else {
+		flags = EXT2_FLAG_SOFTSUPP_FEATURES;
+	}
+
+	retval = ext2fs_open(dev_name, flags, superblock,
+				block_size, unix_io_manager, &current_fs);
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
+	retval = ext2fs_namei(current_fs, EXT2_ROOT_INO,
+				EXT2_ROOT_INO, file_name, &inode_num);
+	if (retval) {
+		com_err(file_name, retval,": Unable to get file inode number");
+		goto err_out;
+	}
+
+	printf("Inode number %d\n", inode_num);
+
+	retval = ext2fs_read_inode(current_fs, inode_num, &inode);
+	if (retval) {
+		com_err(file_name, retval,": Unable to get file inode number");
+		goto err_out;
+	}
+
+	if (inode.i_flags & EXT4_EXTENTS_FL) {
+		printf("Extent enabled\n");
+		migrate = 0 ;
+	}
+
+	iterate_blocks(current_fs, inode_num);
+
+	if (migrate) {
+
+		/*
+		 * Only if we have successfully walked the block mapping write the extent details
+		 */
+		retval = write_extent_details(current_fs, inode_num, &inode, i_block);
+		if (retval) {
+			com_err("write_extent_details", 0, "Failed to write extent details");
+			goto err_out;
+		}
+
+		/* dump the migrated extent details */
+		migrate = 0;
+		printf("Extent details after migrate\n");
+		iterate_blocks(current_fs, inode_num);
+	}
+
+err_out:
+	ext2fs_close(current_fs);
+
+}
diff --git a/ext4migrate/migrate.h b/ext4migrate/migrate.h
new file mode 100644
index 0000000..4b00f99
--- /dev/null
+++ b/ext4migrate/migrate.h
@@ -0,0 +1,27 @@
+
+#include "ext2fs/ext2_fs.h"
+#include "ext2fs/ext2fs.h"
+#include "ext2fs/kernel-list.h"
+
+typedef unsigned long long ext4_fsblk_t;
+
+extern ext2_filsys current_fs;
+
+#define EXT4_EXT_MAGIC		0xf30a
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
1.5.1.rc3.30.ga8f4-dirty
