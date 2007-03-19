From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/2] e2fsprogs: Add ext4migrate
Date: Mon, 19 Mar 2007 15:05:38 +0530
Message-ID: <11742969422569-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11742969394136-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:63848 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbXCSJfs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Mar 2007 05:35:48 -0400
Received: from sd0208e0.au.ibm.com (d23rh904.au.ibm.com [202.81.18.202])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l2JLau8E8057000
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 20:36:56 -0100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0208e0.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2J9dGiX174820
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 20:39:16 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2J9Zkj8030593
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 20:35:46 +1100
In-Reply-To: <11742969394136-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <94a49d2abd02893948f50e49acebb9ade7146d7a.1174296734.git.aneesh.kumar@linux.vnet.ibm.com>
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
fail at any intermediate stage, we exit without touching the disk. Another option I am thinking
is to copy the old mapping to a temporary inode. This makes sure that if by any chance the migration
fails partially writing to the disk one can retrieve the file using temporary inode.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 Makefile.in             |    3 +-
 configure.in            |   21 ++-
 ext4migrate/Makefile.in |   66 ++++++
 ext4migrate/migrate.c   |  568 +++++++++++++++++++++++++++++++++++++++++++++++
 ext4migrate/migrate.h   |   14 ++
 5 files changed, 670 insertions(+), 2 deletions(-)
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
index 0000000..05b089e
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
index 0000000..de1d04f
--- /dev/null
+++ b/ext4migrate/migrate.c
@@ -0,0 +1,568 @@
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "migrate.h"
+#include "extents.h"
+
+static struct list_head blk_cache_head;
+static blk_t first_logical_block = 0;
+static blk_t logical_block = 0;
+static ext4_fsblk_t cont_block_start = 0;
+static ext4_fsblk_t prev_block = 0;
+static blk_t i_block[EXT2_N_BLOCKS];
+static int migrate = 0;
+
+static void blk_cache_init(void)
+{
+	INIT_LIST_HEAD(&blk_cache_head);
+
+}
+
+static void inode_i_block_init()
+{
+	struct ext3_extent_header *eh = (struct ext3_extent_header *)i_block;
+	eh->eh_magic = EXT4_EXT_MAGIC;
+	eh->eh_entries = 0;
+	eh->eh_depth = 0;
+	eh->eh_max = ext3_ext_space_root();
+
+}
+
+static void usage(char *prg_name)
+{
+	fprintf(stderr, "%s [--display | --migrate ] <image_name> <filename>\n", prg_name);
+	exit(1);
+}
+
+static void show_extent(struct ext3_extent *ex)
+{
+	ext4_fsblk_t physical_block = ext_pblock(ex);
+
+	printf("logical block start block %u\nNumber of blocks covered %u\n"
+			"Physical block %llu\n", ex->ee_block, ex->ee_len, physical_block);
+}
+static void show_extent_idx(ext2_filsys , struct ext3_extent_idx *);
+static void _get_extent_details(ext2_filsys filesys, struct ext3_extent_header *eh)
+{
+	struct ext3_extent_idx *ix;
+	struct ext3_extent *ex;
+	int i;
+
+	if (eh->eh_depth == 0) {
+		ex = EXT_FIRST_EXTENT(eh);
+		for (i=0; i < eh->eh_entries; i++, ex++) {
+			show_extent(ex);
+		}
+	} else {
+		ix = EXT_FIRST_INDEX(eh);
+		for (i = 0; i < eh->eh_entries; i++, ix++) {
+			show_extent_idx(filesys, ix);
+		}
+
+
+	}
+
+}
+static void show_extent_idx(ext2_filsys filesys, struct ext3_extent_idx *ix)
+{
+	char *block;
+	int retval;
+	ext4_fsblk_t physical_block = idx_pblock(ix);
+
+
+	printf("extent_idx: Physical start block: %llu\n"
+			"Logical Blocks Addressed by this idx is from %d\n",
+			physical_block, ix->ei_block);
+
+	retval = ext2fs_get_mem(filesys->blocksize, &block);
+	if (retval) {
+		com_err("Allocation error", retval, ": Failed to allocate memory");
+		return;
+	}
+
+	retval = ext2fs_read_ext_block(filesys, physical_block, block);
+	if (retval) {
+		com_err("extent", retval,": Unable to read physical block");
+		free(block);
+		return;
+	}
+
+	_get_extent_details(filesys, (struct ext3_extent_header *)block);
+
+	free(block);
+	return;
+
+
+}
+static void get_extent_details(ext2_filsys filesys, struct ext2_inode *file_inode_struct)
+{
+	struct ext3_extent_header *eh;
+
+	eh = (struct ext3_extent_header *)file_inode_struct->i_block;
+	return _get_extent_details(filesys, eh);
+
+}
+static void block_iterate(ext2_filsys filesys, struct ext2_inode *file_inode_struct, ext4_fsblk_t block_num,
+			void (*func)(ext2_filsys filesys, struct ext2_inode *file_inode_struct, ext4_fsblk_t block))
+{
+	int i, retval;
+	blk_t *block;
+	int max_entries = filesys->blocksize/4;
+	retval = ext2fs_get_mem(filesys->blocksize,  &block);
+	if (retval) {
+		com_err("Allocation error", retval, ": Failed to allocate memory");
+		return;
+	}
+	retval = ext2fs_read_ext_block(filesys, block_num, block);
+	if (retval) {
+		com_err("block_interate", retval,": Unable to read physical block");
+		free(block);
+		return;
+	}
+	for (i=0; i < max_entries; i++) {
+		if (block[i]) {
+			(*func)(filesys, file_inode_struct, block[i]);
+		}
+	}
+	free(block);
+
+}
+
+/*FIXME!! goal value passed as zero */
+
+/* FIXME!! 48 bit block
+ * Can we ask for block addressed by 48 bit ?
+ * We have actually mounted a ext3 file system via ext4dev If want want
+ * we will have to change the group descriptor also */
+/* Function is also called from extents.c */
+struct blk_cache * get_block(ext2_filsys filesys, ext4_fsblk_t pblock)
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
+		retval = ext2fs_new_block(filesys, 0, NULL, (blk_t *)&block);
+		if (retval) {
+			/*
+			 * In case we fail we don't write/sync previous update
+			 * we don't want partial conversion
+			 */
+			return NULL;
+		}
+		ext2fs_mark_block_bitmap(filesys->block_map, block);
+		ext2fs_mark_bb_dirty(filesys);
+
+		addr = malloc(filesys->blocksize);
+		if (!addr)
+			return NULL;
+		memset(addr, 0, filesys->blocksize);
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
+	retval = ext2fs_new_block(filesys, 0, NULL, (blk_t *)&block);
+	if (retval) {
+		/*
+		 * In case we fail we don't write/sync previous update
+		 * we don't want partial conversion
+		 */
+		return NULL;
+	}
+	ext2fs_mark_block_bitmap(filesys->block_map, block);
+	ext2fs_mark_bb_dirty(filesys);
+
+	addr = malloc(filesys->blocksize);
+	if (!addr)
+		return NULL;
+	memset(addr, 0, filesys->blocksize);
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
+
+static int update_extent(ext2_filsys filesys, struct ext2_inode *file_inode_struct,
+				blk_t logical_blk, ext4_fsblk_t start_blk, ext4_fsblk_t end_blk)
+{
+	static int count = 0;
+	int retval = 0;
+	struct ext4_ext_path *path;
+	struct ext3_extent newext;
+	/* start with a local allocated array without touching the inode */
+	struct ext3_extent_header *eh = (struct ext3_extent_header *)i_block;
+	(void)filesys;
+
+	count++;
+	printf("%d Contiguos block %llu <-> %llu\n", count, start_blk, end_blk);
+
+	/* If ware not intending to migrate just return success */
+	if (!migrate)
+		return 0;
+
+
+	newext.ee_block = logical_blk;
+	newext.ee_len = end_blk - start_blk +1;
+	ext3_ext_store_pblock(&newext, start_blk);
+
+	path = ext3_ext_find_extent(filesys, file_inode_struct, eh, logical_blk, NULL);
+
+	if (!path)
+		return EXT2_ET_BLOCK_ALLOC_FAIL;
+
+	retval = ext3_ext_insert_extent(filesys, file_inode_struct, eh, path, &newext);
+
+	free(path);
+	return retval;
+}
+
+static void show_lblk_mapping(ext2_filsys filesys, struct ext2_inode *file_inode_struct, ext4_fsblk_t block)
+{
+	int retval = 0;
+	(void)filesys;
+
+	if (cont_block_start == 0) {
+		cont_block_start = block;
+		prev_block = block;
+		first_logical_block = logical_block;
+	} else {
+
+		if (prev_block+1 == block) {
+
+			prev_block = block;
+
+		} else {
+			retval = update_extent(filesys, file_inode_struct,
+						first_logical_block, cont_block_start, prev_block);
+			if (retval) {
+				com_err("update_extent", retval, ": Failed to update the extent");
+				/* If we fail to update extent we exit */
+				exit(1);
+			}
+			cont_block_start = block;
+			prev_block = block;
+			first_logical_block = logical_block;
+		}
+	}
+
+	//printf("block number is [%d] -> %llu\n", logical_block,  block);
+	logical_block++;
+
+
+	return;
+
+}
+static void dind_blk_iterate(ext2_filsys filesys, struct ext2_inode *file_inode_struct, ext4_fsblk_t block_num)
+{
+	//printf("Indirect mappings %llu\n", block_num);
+	block_iterate(filesys, file_inode_struct, block_num , show_lblk_mapping);
+}
+static void tind_blk_iterate(ext2_filsys filesys, struct ext2_inode *file_inode_struct, ext4_fsblk_t block_num)
+{
+	//printf("Double indirect mappings %llu\n", block_num);
+	block_iterate(filesys, file_inode_struct, block_num , dind_blk_iterate);
+}
+
+static int get_indirect_block_mapping_details(ext2_filsys filesys, struct ext2_inode *file_inode_struct)
+{
+	int i, retval = 0;
+	//printf("Direct mappings\n");
+	for (i = 0; i < EXT2_NDIR_BLOCKS; i++) {
+
+		/* EXT2_NDIR_BLOCKS direct blocks */
+		if (file_inode_struct->i_block[i]) {
+			show_lblk_mapping(filesys, file_inode_struct, file_inode_struct->i_block[i]);
+		}
+
+	}
+	if (file_inode_struct->i_block[EXT2_IND_BLOCK]) {
+
+		/* indirect block */
+		//printf("Indirect mappings %d\n", file_inode_struct->i_block[EXT2_IND_BLOCK]);
+		block_iterate(filesys, file_inode_struct, file_inode_struct->i_block[EXT2_IND_BLOCK] , show_lblk_mapping);
+	}
+	if (file_inode_struct->i_block[EXT2_DIND_BLOCK]) {
+
+		/* double indirect block */
+		//printf("Double indirect mappings %d\n", file_inode_struct->i_block[EXT2_DIND_BLOCK]);
+		block_iterate(filesys, file_inode_struct, file_inode_struct->i_block[EXT2_DIND_BLOCK], dind_blk_iterate);
+
+	}
+	if (file_inode_struct->i_block[EXT2_TIND_BLOCK]) {
+
+		/* triple indirect block */
+		//printf("Triple indirect mappings %d\n", file_inode_struct->i_block[EXT2_TIND_BLOCK]);
+		block_iterate(filesys, file_inode_struct, file_inode_struct->i_block[EXT2_TIND_BLOCK], tind_blk_iterate);
+
+	}
+
+	/* update with the last contiguos block */
+	retval = update_extent(filesys, file_inode_struct, first_logical_block, cont_block_start, prev_block);
+	return retval;
+
+
+}
+
+static int write_extent_block(ext2_filsys filesys, ext4_fsblk_t pblock, void *buf)
+{
+	struct ext3_extent_header *eh = (struct ext3_extent_header *)buf;
+	struct ext3_extent_idx *ix;
+	ext4_fsblk_t tpblock;
+	struct blk_cache *blkc;
+	int i, retval;
+
+	if (eh->eh_depth == 0) {
+		retval = ext2fs_write_ext_block(filesys, pblock, buf);
+		if (retval)
+			goto err_out;
+	} else {
+		ix = EXT_FIRST_INDEX(eh);
+		for (i = 0; i < eh->eh_entries; i++, ix++) {
+
+			tpblock = idx_pblock(ix);
+			blkc = get_block(filesys, tpblock);
+			if (!blkc) {
+				retval = EXT2_ET_BLOCK_ALLOC_FAIL;
+				goto err_out;
+			}
+			retval = write_extent_block(filesys, blkc->pblock, blkc->block_mem_addr);
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
+static int reset_block_bitmap(ext2_filsys filesys)
+{
+	struct list_head *entry;
+	struct blk_cache *blk;
+	int retval;
+
+	list_for_each(entry, &blk_cache_head) {
+
+		blk = list_entry(entry, struct blk_cache, head);
+
+		ext2fs_unmark_block_bitmap(filesys->block_map, blk->pblock);
+
+	}
+	ext2fs_mark_bb_dirty(filesys);
+	retval = ext2fs_write_block_bitmap(filesys);
+
+	return retval;
+}
+
+static int write_extent_details(ext2_filsys filesys, ext2_ino_t file_ino,
+		struct ext2_inode *file_inode_struct, blk_t *i_block)
+{
+
+	struct ext3_extent_header *eh = (struct ext3_extent_header *)i_block;
+	struct ext3_extent_idx *ix;
+	ext4_fsblk_t pblock;
+	struct blk_cache *blkc;
+	int i, retval;
+
+	/* write  the updated block bit map */
+	retval = ext2fs_write_block_bitmap(filesys);
+	if (retval) {
+		return retval;
+	}
+
+	/* Write the blocks to the disk */
+	if (eh->eh_depth != 0) {
+		/* need to write blocks corresponding to  extent_idx */
+		ix = EXT_FIRST_INDEX(eh);
+		for (i = 0; i < eh->eh_entries; i++, ix++) {
+
+			pblock = idx_pblock(ix);
+			blkc = get_block(filesys, pblock);
+			if (!blkc) {
+				retval = EXT2_ET_BLOCK_ALLOC_FAIL;
+				goto err_out;
+			}
+			retval = write_extent_block(filesys, blkc->pblock, blkc->block_mem_addr);
+			if (retval) {
+				goto err_out;
+			}
+		}
+	}
+
+	file_inode_struct->i_flags |= EXT4_EXTENTS_FL;
+	memcpy(file_inode_struct->i_block, i_block, sizeof(file_inode_struct->i_block));
+	/* write inode */
+	retval = ext2fs_write_inode(filesys, file_ino, file_inode_struct);
+	if (retval) {
+		goto err_out;
+	}
+
+	if (!(filesys->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS)) {
+		filesys->super->s_feature_incompat |= EXT3_FEATURE_INCOMPAT_EXTENTS;
+
+		/* FIXME!! should we write super block */
+		ext2fs_mark_super_dirty(filesys);
+	}
+
+	return retval;
+err_out:
+	if (reset_block_bitmap(filesys)) {
+		com_err("reset_block_bitmap", retval, ": Failed to reset the block bitmap");
+	}
+
+	return retval;
+
+}
+
+main(int argc, char *argv[])
+{
+	char *dev_name, *file_name;
+	int flags, superblock = 0;
+	unsigned int block_size = 0;
+	ext2_filsys filesys;
+	ext2_ino_t file_ino;
+	struct ext2_inode file_inode_struct;
+	int retval;
+
+	if (argc < 3 || argc > 4) {
+		usage(argv[0]);
+	}
+
+	blk_cache_init();
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
+				block_size, unix_io_manager, &filesys);
+	if (retval) {
+		com_err(dev_name, retval,": Unable to open the file system");
+		return;
+	}
+
+	retval = ext2fs_read_inode_bitmap(filesys);
+	if (retval) {
+		com_err(dev_name, retval,": Unable to read inode bitmap");
+		goto err_out;
+	}
+	retval =  ext2fs_read_block_bitmap(filesys);
+	if (retval) {
+		com_err(dev_name, retval,": Unable to read block bitmap");
+		goto err_out;
+	}
+
+	retval = ext2fs_namei(filesys, EXT2_ROOT_INO,
+				EXT2_ROOT_INO, file_name, &file_ino);
+	if (retval) {
+		com_err(file_name, retval,": Unable to get file inode number");
+		goto err_out;
+	}
+
+	printf("Inode number %d\n", file_ino);
+
+	retval = ext2fs_read_inode(filesys, file_ino, &file_inode_struct);
+	if (retval) {
+		com_err(file_name, retval,": Unable to get file inode number");
+		goto err_out;
+	}
+	if (file_inode_struct.i_flags &  EXT4_EXTENTS_FL) {
+		/*
+		 * extents support
+		 */
+		printf("extent: Support enabled\n");
+		get_extent_details(filesys, &file_inode_struct);
+
+	} else {
+
+		retval = get_indirect_block_mapping_details(filesys, &file_inode_struct);
+
+		if (retval) {
+
+			com_err("get_indirect_block_mapping_details", retval,
+					": Failed to get the block mapaping details");
+
+		} else if (migrate) {
+
+			/*
+			 * Only if we have successfully walked the block mapping write the extent details
+			 */
+			retval = write_extent_details(filesys, file_ino, &file_inode_struct, i_block);
+			if (retval) {
+				com_err("write_extent_details", 0, "Failed to write extent details");
+				goto err_out;
+			}
+
+			/* dump the migrated extent details */
+			get_extent_details(filesys, &file_inode_struct);
+		}
+	}
+
+err_out:
+	ext2fs_close(filesys);
+
+}
diff --git a/ext4migrate/migrate.h b/ext4migrate/migrate.h
new file mode 100644
index 0000000..b3f25ac
--- /dev/null
+++ b/ext4migrate/migrate.h
@@ -0,0 +1,14 @@
+
+#include "ext2fs/ext2_fs.h"
+#include "ext2fs/ext2fs.h"
+#include "ext2fs/kernel-list.h"
+
+typedef unsigned long long ext4_fsblk_t;
+
+#define EXT4_EXT_MAGIC		0xf30a
+
+struct blk_cache {
+	struct list_head  head;
+	ext4_fsblk_t pblock;
+	void * block_mem_addr;
+};
-- 
1.5.0.4.402.g8035-dirty
