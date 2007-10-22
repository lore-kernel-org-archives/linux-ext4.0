From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 02/14] Add initial checksum support.
Date: Sun, 21 Oct 2007 21:03:19 -0500
Message-ID: <20071022020319.23849.95310.stgit@toolssf2>
References: <20071022020308.23849.98773.stgit@toolssf2>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:34807 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbXJVCGp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Oct 2007 22:06:45 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9M26j6X020125
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 22:06:45 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9M26jY3113276
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:06:45 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9M26iNB007879
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:06:44 -0600
Received: from [127.0.0.1] (toolssf2.ltc.austin.ibm.com [9.3.190.66])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9M26i9j007871
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:06:44 -0600
In-Reply-To: <20071022020308.23849.98773.stgit@toolssf2>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Add initial checksum support.

- Add support for computing CRC-16 value.
- Add call to check/verify/set csum on block_groups.
- Add a test program to verify csum operations.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-Off-By: Andreas Dilger <adilger@clusterfs.com>
--

 lib/ext2fs/Makefile.in |   19 ++++++
 lib/ext2fs/crc16.c     |   59 +++++++++++++++++++
 lib/ext2fs/crc16.h     |   46 +++++++++++++++
 lib/ext2fs/csum.c      |  149 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_fs.h   |    1 
 lib/ext2fs/ext2fs.h    |    7 ++
 lib/ext2fs/tst_csum.c  |  113 ++++++++++++++++++++++++++++++++++++
 7 files changed, 393 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index ca65427..dff2774 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -28,6 +28,8 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	bmap.o \
 	check_desc.o \
 	closefs.o \
+	crc16.o \
+	csum.o \
 	dblist.o \
 	dblist_dir.o \
 	dirblock.o \
@@ -82,6 +84,8 @@ SRCS= ext2_err.c \
 	$(srcdir)/bmap.c \
 	$(srcdir)/check_desc.c \
 	$(srcdir)/closefs.c \
+	$(srcdir)/crc16.c \
+	$(srcdir)/csum.c \
 	$(srcdir)/dblist.c \
 	$(srcdir)/dblist_dir.c \
 	$(srcdir)/dirblock.c \
@@ -126,6 +130,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/tst_badblocks.c \
 	$(srcdir)/tst_bitops.c \
 	$(srcdir)/tst_byteswap.c \
+	$(srcdir)/tst_csum.c \
 	$(srcdir)/tst_getsize.c \
 	$(srcdir)/tst_iscan.c \
 	$(srcdir)/unix_io.c \
@@ -239,17 +244,23 @@ ext2_tdbtool: tdbtool.o
 	@echo "	LD $@"
 	@$(CC) -o ext2_tdbtool tdbtool.o tdb.o
 
+tst_csum: tst_csum.o csum.o crc16.o $(STATIC_LIBEXT2FS)
+	@echo " LD $@"
+	@$(CC) -o tst_csum csum.o tst_csum.o crc16.o $(STATIC_LIBEXT2FS) \
+		$(LIBCOM_ERR)
+
 mkjournal: mkjournal.c $(STATIC_LIBEXT2FS)
 	@echo "	LD $@"
 	@$(CC) -o mkjournal $(srcdir)/mkjournal.c -DDEBUG $(STATIC_LIBEXT2FS) $(LIBCOM_ERR) $(ALL_CFLAGS)
 
-check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount tst_super_size
+check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount tst_super_size tst_types tst_csum
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_bitops
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_badblocks
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_iscan
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_types
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_icount
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_super_size
+	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_csum
 
 installdirs::
 	@echo "	MKINSTALLDIRS $(libdir) $(includedir)/ext2fs"
@@ -357,6 +368,10 @@ closefs.o: $(srcdir)/closefs.c $(srcdir)/ext2_fs.h \
  $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h \
  $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
+crc16.o: $(srcdir)/crc16.c $(srcdir)/ext2_fs.h $(srcdir)/crc16.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h
+csum.o: $(srcdir)/csum.c $(srcdir)/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h
 dblist.o: $(srcdir)/dblist.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fsP.h \
  $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h \
@@ -571,3 +586,5 @@ tst_iscan.o: $(srcdir)/tst_iscan.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
+tst_csum.o: $(srcdir)/tst_csum.c $(srcdir)/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h
diff --git a/lib/ext2fs/crc16.c b/lib/ext2fs/crc16.c
new file mode 100644
index 0000000..d480dba
--- /dev/null
+++ b/lib/ext2fs/crc16.c
@@ -0,0 +1,59 @@
+/*
+ *      crc16.c
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2. See the file COPYING for more details.
+ */
+
+#include "crc16.h"
+
+/** CRC table for the CRC-16. The poly is 0x8005 (x16 + x15 + x2 + 1) */
+__u16 const crc16_table[256] = {
+	0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
+	0xC601, 0x06C0, 0x0780, 0xC741, 0x0500, 0xC5C1, 0xC481, 0x0440,
+	0xCC01, 0x0CC0, 0x0D80, 0xCD41, 0x0F00, 0xCFC1, 0xCE81, 0x0E40,
+	0x0A00, 0xCAC1, 0xCB81, 0x0B40, 0xC901, 0x09C0, 0x0880, 0xC841,
+	0xD801, 0x18C0, 0x1980, 0xD941, 0x1B00, 0xDBC1, 0xDA81, 0x1A40,
+	0x1E00, 0xDEC1, 0xDF81, 0x1F40, 0xDD01, 0x1DC0, 0x1C80, 0xDC41,
+	0x1400, 0xD4C1, 0xD581, 0x1540, 0xD701, 0x17C0, 0x1680, 0xD641,
+	0xD201, 0x12C0, 0x1380, 0xD341, 0x1100, 0xD1C1, 0xD081, 0x1040,
+	0xF001, 0x30C0, 0x3180, 0xF141, 0x3300, 0xF3C1, 0xF281, 0x3240,
+	0x3600, 0xF6C1, 0xF781, 0x3740, 0xF501, 0x35C0, 0x3480, 0xF441,
+	0x3C00, 0xFCC1, 0xFD81, 0x3D40, 0xFF01, 0x3FC0, 0x3E80, 0xFE41,
+	0xFA01, 0x3AC0, 0x3B80, 0xFB41, 0x3900, 0xF9C1, 0xF881, 0x3840,
+	0x2800, 0xE8C1, 0xE981, 0x2940, 0xEB01, 0x2BC0, 0x2A80, 0xEA41,
+	0xEE01, 0x2EC0, 0x2F80, 0xEF41, 0x2D00, 0xEDC1, 0xEC81, 0x2C40,
+	0xE401, 0x24C0, 0x2580, 0xE541, 0x2700, 0xE7C1, 0xE681, 0x2640,
+	0x2200, 0xE2C1, 0xE381, 0x2340, 0xE101, 0x21C0, 0x2080, 0xE041,
+	0xA001, 0x60C0, 0x6180, 0xA141, 0x6300, 0xA3C1, 0xA281, 0x6240,
+	0x6600, 0xA6C1, 0xA781, 0x6740, 0xA501, 0x65C0, 0x6480, 0xA441,
+	0x6C00, 0xACC1, 0xAD81, 0x6D40, 0xAF01, 0x6FC0, 0x6E80, 0xAE41,
+	0xAA01, 0x6AC0, 0x6B80, 0xAB41, 0x6900, 0xA9C1, 0xA881, 0x6840,
+	0x7800, 0xB8C1, 0xB981, 0x7940, 0xBB01, 0x7BC0, 0x7A80, 0xBA41,
+	0xBE01, 0x7EC0, 0x7F80, 0xBF41, 0x7D00, 0xBDC1, 0xBC81, 0x7C40,
+	0xB401, 0x74C0, 0x7580, 0xB541, 0x7700, 0xB7C1, 0xB681, 0x7640,
+	0x7200, 0xB2C1, 0xB381, 0x7340, 0xB101, 0x71C0, 0x7080, 0xB041,
+	0x5000, 0x90C1, 0x9181, 0x5140, 0x9301, 0x53C0, 0x5280, 0x9241,
+	0x9601, 0x56C0, 0x5780, 0x9741, 0x5500, 0x95C1, 0x9481, 0x5440,
+	0x9C01, 0x5CC0, 0x5D80, 0x9D41, 0x5F00, 0x9FC1, 0x9E81, 0x5E40,
+	0x5A00, 0x9AC1, 0x9B81, 0x5B40, 0x9901, 0x59C0, 0x5880, 0x9841,
+	0x8801, 0x48C0, 0x4980, 0x8941, 0x4B00, 0x8BC1, 0x8A81, 0x4A40,
+	0x4E00, 0x8EC1, 0x8F81, 0x4F40, 0x8D01, 0x4DC0, 0x4C80, 0x8C41,
+	0x4400, 0x84C1, 0x8581, 0x4540, 0x8701, 0x47C0, 0x4680, 0x8641,
+	0x8201, 0x42C0, 0x4380, 0x8341, 0x4100, 0x81C1, 0x8081, 0x4040
+};
+
+/**
+ * Compute the CRC-16 for the data buffer
+ *
+ * @param crc     previous CRC value
+ * @param buffer  data pointer
+ * @param len     number of bytes in the buffer
+ * @return        the updated CRC value
+ */
+crc16_t crc16(crc16_t crc, unsigned char const *buffer, unsigned int len)
+{
+	while (len--)
+		crc = crc16_byte(crc, *buffer++);
+	return crc;
+}
diff --git a/lib/ext2fs/crc16.h b/lib/ext2fs/crc16.h
new file mode 100644
index 0000000..bcea638
--- /dev/null
+++ b/lib/ext2fs/crc16.h
@@ -0,0 +1,46 @@
+/*
+ *	crc16.h - CRC-16 routine
+ *
+ * Implements the standard CRC-16:
+ *   Width 16
+ *   Poly  0x8005 (x16 + x15 + x2 + 1)
+ *   Init  0
+ *
+ * Copyright (c) 2005 Ben Gardner <bgardner@wabtec.com>
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2. See the file COPYING for more details.
+ */
+
+#ifndef __CRC16_H
+#define __CRC16_H
+
+#include <ext2fs/ext2_types.h>
+
+extern __u16 const crc16_table[256];
+
+#ifdef WORDS_BIGENDIAN
+/* for an unknown reason, PPC treats __u16 as signed and keeps doing sign
+ * extension on the value.  Instead, use only the low 16 bits of an
+ * unsigned int for holding the CRC value to avoid this.
+ */
+typedef unsigned crc16_t;
+
+static inline crc16_t crc16_byte(crc16_t crc, const unsigned char data)
+{
+	return (((crc >> 8) & 0xffU) ^ crc16_table[(crc ^ data) & 0xffU]) &
+		0x0000ffffU;
+}
+#else
+typedef __u16 crc16_t;
+
+static inline crc16_t crc16_byte(crc16_t crc, const unsigned char data)
+{
+	return (crc >> 8) ^ crc16_table[(crc ^ data) & 0xff];
+}
+#endif
+
+extern crc16_t crc16(crc16_t crc, unsigned char const *buffer, unsigned int len);
+
+
+#endif /* __CRC16_H */
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
new file mode 100644
index 0000000..fc05179
--- /dev/null
+++ b/lib/ext2fs/csum.c
@@ -0,0 +1,149 @@
+/*
+ * csum.c --- checksumming of ext3 structures
+ *
+ * Copyright (C) 2006 Cluster File Systems, Inc.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include "ext2_fs.h"
+#include "ext2fs.h"
+#include <assert.h>
+
+#ifndef offsetof
+#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+#endif
+
+__u16 ext2fs_group_desc_csum(struct ext2_super_block *sb, __u32 group,
+			     struct ext2_group_desc *desc)
+{
+	__u16 crc = 0;
+
+	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
+		int offset = offsetof(struct ext2_group_desc, bg_checksum);
+
+#ifdef WORDS_BIGENDIAN
+		struct ext2_group_desc swabdesc = *desc;
+
+		/* Have to swab back to little-endian to do the checksum */
+		ext2fs_swap_group_desc(&swabdesc);
+		desc = &swabdesc;
+
+		group = ext2fs_swab32(group);
+#endif
+		crc = crc16(~0, sb->s_uuid, sizeof(sb->s_uuid));
+		crc = crc16(crc, &group, sizeof(group));
+		crc = crc16(crc, desc, offset);
+		offset += sizeof(desc->bg_checksum); /* skip checksum */
+		assert(offset == sizeof(*desc)); /* XXX handle s_desc_size */
+		/* for checksum of struct ext4_group_desc do the rest...*/
+		if (offset < sb->s_desc_size) {
+			crc = crc16(crc, (char *)desc + offset,
+				    sb->s_desc_size - offset);
+		}
+	}
+
+	return crc;
+}
+
+int ext2fs_group_desc_csum_verify(struct ext2_super_block *sb, __u32 group,
+				  struct ext2_group_desc *desc)
+{
+	if (desc->bg_checksum != ext2fs_group_desc_csum(sb, group, desc))
+		return 0;
+
+	return 1;
+}
+
+static __u32 find_last_inode_ingrp(ext2fs_inode_bitmap bitmap,
+				   __u32 inodes_per_grp, dgrp_t grp_no)
+{
+	ext2_ino_t i, start_ino, end_ino;
+
+	start_ino = grp_no * inodes_per_grp + 1;
+	end_ino = start_ino + inodes_per_grp - 1;
+
+	for (i = end_ino; i >= start_ino; i--) {
+		if (ext2fs_fast_test_inode_bitmap(bitmap, i))
+			return i - start_ino + 1;
+	}
+	return inodes_per_grp;
+}
+
+/* update the bitmap flags, set the itable high watermark, and calculate
+ * checksums for the group descriptors */
+void ext2fs_set_gdt_csum(ext2_filsys fs)
+{
+	struct ext2_super_block *sb = fs->super;
+	struct ext2_group_desc *bg = fs->group_desc;
+	int blks, lazy_flag, csum_flag, dirty = 0;
+	dgrp_t i;
+
+	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
+				     EXT2_FEATURE_COMPAT_LAZY_BG) && !csum_flag)
+		return;
+
+	for (i = 0; i < fs->group_desc_count; i++, bg++) {
+		int old_csum = bg->bg_checksum;
+
+		/* Even if it wasn't zeroed, by the time this function is
+		 * called by e2fsck we have already scanned and corrected
+		 * the whole inode table so we may as well not overwrite it.
+		 * This is just a hint to the kernel that it could do lazy
+		 * zeroing of the inode table if mke2fs didn't do it, to help
+		 * out if we need to do a full itable scan sometime later. */
+		if (!(bg->bg_flags & (EXT2_BG_INODE_UNINIT |
+				      EXT2_BG_INODE_ZEROED))) {
+			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_ZEROED;
+			dirty = 1;
+		}
+
+		if (bg->bg_free_inodes_count == sb->s_inodes_per_group &&
+		    i > 0 && (i < fs->group_desc_count - 1 || csum_flag)) {
+			if (!(bg->bg_flags & EXT2_BG_INODE_UNINIT)) {
+				bg->bg_flags |= EXT2_BG_INODE_UNINIT;
+				dirty = 1;
+			}
+			if (csum_flag) {
+				int old_unused = bg->bg_itable_unused;
+				bg->bg_itable_unused = sb->s_inodes_per_group;
+				if (old_unused != bg->bg_itable_unused)
+					dirty = 1;
+			}
+		} else if (csum_flag) {
+			int old_unused = bg->bg_itable_unused;
+			bg->bg_flags &= ~EXT2_BG_INODE_UNINIT;
+			bg->bg_itable_unused = sb->s_inodes_per_group -
+				find_last_inode_ingrp(fs->inode_map,
+						      sb->s_inodes_per_group,i);
+			if (old_unused != bg->bg_itable_unused)
+				dirty = 1;
+		}
+
+		/* skip first and last groups, or groups with GDT backups
+		 * because the resize inode has blocks allocated in them. */
+		if (i == 0 || (i == fs->group_desc_count - 1 && !csum_flag) ||
+		    (ext2fs_bg_has_super(fs, i) && sb->s_reserved_gdt_blocks))
+			goto checksum;
+
+		blks = ext2fs_super_and_bgd_loc(fs, i, 0, 0, 0, 0);
+		if (bg->bg_free_blocks_count == blks &&
+		    bg->bg_flags & EXT2_BG_INODE_UNINIT &&
+		    !(bg->bg_flags & EXT2_BG_BLOCK_UNINIT)) {
+			bg->bg_flags |= EXT2_BG_BLOCK_UNINIT;
+			dirty = 1;
+		}
+checksum:
+		bg->bg_checksum =
+			ext2fs_group_desc_csum(fs->super, i, bg);
+		if (old_csum != bg->bg_checksum)
+			dirty = 1;
+	}
+	if (dirty)
+		ext2fs_mark_super_dirty(fs);
+}
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a316665..7b63828 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -173,6 +173,7 @@ struct ext4_group_desc
 
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
 #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
+#define EXT2_BG_INODE_ZEROED	0x0004 /* On-disk itable initialized to zero */
 
 /*
  * Data structures used by the directory indexing feature
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 5536b60..58c8606 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -628,6 +628,13 @@ extern int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 				    int *ret_meta_bg);
 extern void ext2fs_update_dynamic_rev(ext2_filsys fs);
 
+/* csum.c */
+extern __u16 ext2fs_group_desc_csum(struct ext2_super_block *sb, __u32 group,
+				    struct ext2_group_desc *desc);
+extern int ext2fs_group_desc_csum_verify(struct ext2_super_block *sb,
+				     __u32 group, struct ext2_group_desc *desc);
+extern void ext2fs_set_gdt_csum(ext2_filsys fs);
+
 /* dblist.c */
 
 extern errcode_t ext2fs_get_num_dirs(ext2_filsys fs, ext2_ino_t *ret_num_dirs);
diff --git a/lib/ext2fs/tst_csum.c b/lib/ext2fs/tst_csum.c
new file mode 100644
index 0000000..d4d26db
--- /dev/null
+++ b/lib/ext2fs/tst_csum.c
@@ -0,0 +1,113 @@
+/*
+ * This testing program verifies checksumming operations
+ *
+ * Copyright (C) 2006, 2007 by Andreas Dilger <adilger@clusterfs.com>
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include "ext2fs/ext2_fs.h"
+#include "ext2fs/ext2fs.h"
+
+#ifndef offsetof
+#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+#endif
+
+void print_csum(const char *msg, struct ext2_super_block *sb,
+		__u32 group, struct ext2_group_desc *desc)
+{
+	__u16 crc1, crc2, crc3;
+	__u32 swabgroup;
+
+#ifdef WORDS_BIGENDIAN
+	struct ext2_group_desc swabdesc = *desc;
+
+	/* Have to swab back to little-endian to do the checksum */
+	ext2fs_swap_group_desc(&swabdesc);
+	desc = &swabdesc;
+
+	swabgroup = ext2fs_swab32(group);
+#else
+	swabgroup = group;
+#endif
+
+	crc1 = crc16(~0, sb->s_uuid, sizeof(sb->s_uuid));
+	crc2 = crc16(crc1, &swabgroup, sizeof(swabgroup));
+	crc3 = crc16(crc2, desc, offsetof(struct ext2_group_desc, bg_checksum));
+	printf("%s: UUID %016Lx%016Lx(%04x), grp %u(%04x): %04x=%04x\n",
+	       msg, *(long long *)&sb->s_uuid, *(long long *)&sb->s_uuid[8],
+	       crc1, group, crc2, crc3, ext2fs_group_desc_csum(sb, group,desc));
+}
+
+main(int argc, char **argv)
+{
+	struct ext2_group_desc desc = { .bg_block_bitmap = 124,
+					.bg_inode_bitmap = 125,
+					.bg_inode_table = 126,
+					.bg_free_blocks_count = 31119,
+					.bg_free_inodes_count = 15701,
+					.bg_used_dirs_count = 2,
+					.bg_flags = 0,
+					};
+	struct ext2_super_block sb = {  .s_feature_ro_compat =
+					EXT4_FEATURE_RO_COMPAT_GDT_CSUM,
+					.s_uuid = { 0x4f, 0x25, 0xe8, 0xcf,
+						    0xe7, 0x97, 0x48, 0x23,
+						    0xbe, 0xfa, 0xa7, 0x88,
+						    0x4b, 0xae, 0xec, 0xdb } };
+	__u16 csum1, csum2, csum_known = 0xd3a4;
+
+	csum1 = ext2fs_group_desc_csum(&sb, 0, &desc);
+	print_csum("csum0000", &sb, 0, &desc);
+
+#ifdef WORDS_BIGENDIAN
+	csum_known = ext2fs_swab16(known);
+#endif
+	if (csum1 != csum_known) {
+		printf("checksum for group 0 should be %04x\n", csum_known);
+		exit(1);
+	}
+	csum2 = ext2fs_group_desc_csum(&sb, 1, &desc);
+	print_csum("csum0001", &sb, 1, &desc);
+	if (csum1 == csum2) {
+		printf("checksums for different groups shouldn't match\n");
+		exit(1);
+	}
+	csum2 = ext2fs_group_desc_csum(&sb, 0xffff, &desc);
+	print_csum("csumffff", &sb, 0xffff, &desc);
+	if (csum1 == csum2) {
+		printf("checksums for different groups shouldn't match\n");
+		exit(1);
+	}
+	desc.bg_checksum = csum1;
+	csum2 = ext2fs_group_desc_csum(&sb, 0, &desc);
+	print_csum("csum_set", &sb, 0, &desc);
+	if (csum1 != csum2) {
+		printf("checksums should not depend on checksum field\n");
+		exit(1);
+	}
+	if (!ext2fs_group_desc_csum_verify(&sb, 0, &desc)) {
+		printf("checksums should verify against gd_checksum\n");
+		exit(1);
+	}
+	memset(sb.s_uuid, 0x30, sizeof(sb.s_uuid));
+	print_csum("new_uuid", &sb, 0, &desc);
+	if (ext2fs_group_desc_csum_verify(&sb, 0, &desc) != 0) {
+		printf("checksums for different filesystems shouldn't match\n");
+		exit(1);
+	}
+	csum1 = desc.bg_checksum = ext2fs_group_desc_csum(&sb, 0, &desc);
+	print_csum("csum_new", &sb, 0, &desc);
+	desc.bg_free_blocks_count = 1;
+	csum2 = ext2fs_group_desc_csum(&sb, 0, &desc);
+	print_csum("csum_blk", &sb, 0, &desc);
+	if (csum1 == csum2) {
+		printf("checksums for different data shouldn't match\n");
+		exit(1);
+	}
+
+	return 0;
+}
