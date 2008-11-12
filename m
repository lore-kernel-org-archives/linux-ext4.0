From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [RFC PATCH 02/17] Squash warnings
Date: Tue, 11 Nov 2008 19:42:55 -0800
Message-ID: <1226461390-5502-3-git-send-email-vaurora@redhat.com>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
 <1226461390-5502-2-git-send-email-vaurora@redhat.com>
Cc: Valerie Aurora Henson <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42461 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbYKLDnt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 22:43:49 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAC3hnmG007417
	for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 22:43:49 -0500
In-Reply-To: <1226461390-5502-2-git-send-email-vaurora@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>
---
 debugfs/debugfs.c   |    2 +-
 debugfs/htree.c     |    4 ++--
 lib/blkid/probe.c   |    5 +++--
 lib/e2p/e2p.h       |    2 ++
 lib/ext2fs/alloc.c  |    6 +++---
 lib/ext2fs/inode.c  |    1 +
 lib/uuid/gen_uuid.c |    4 +++-
 misc/blkid.c        |    1 -
 misc/dumpe2fs.c     |    2 +-
 misc/mke2fs.c       |    7 ++++---
 misc/tune2fs.c      |    2 +-
 11 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 8b0965e..d1c6460 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1850,7 +1850,7 @@ static int find_supp_feature(__u32 *supp, int feature_type, char *name)
 
 void do_supported_features(int argc, char *argv[])
 {
-        int	i, j, ret;
+        int	ret;
 	__u32	supp[3] = { EXT2_LIB_FEATURE_COMPAT_SUPP,
 			    EXT2_LIB_FEATURE_INCOMPAT_SUPP,
 			    EXT2_LIB_FEATURE_RO_COMPAT_SUPP };
diff --git a/debugfs/htree.c b/debugfs/htree.c
index 983dc9a..f9332ab 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -48,11 +48,11 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
 		return;
 	}
 
-	printf("Reading directory block %lu, phys %lu\n", blk, pblk);
+	printf("Reading directory block %u, phys %u\n", blk, pblk);
 	errcode = ext2fs_read_dir_block2(current_fs, pblk, buf, 0);
 	if (errcode) {
 		com_err("htree_dump_leaf_node", errcode,
-			"while reading block %lu (%lu)\n", blk, pblk);
+			"while reading block %u (%u)\n", blk, pblk);
 		return;
 	}
 	hash_alg = rootnode->hash_version;
diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 10ac803..4bdc62a 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -1099,7 +1099,8 @@ static int probe_hfs(struct blkid_probe *probe __BLKID_ATTR((unused)),
 		sprintf(uuid_str, "%016llX", uuid);
 		blkid_set_tag(probe->dev, "UUID", uuid_str, 0);
 	}
-	blkid_set_tag(probe->dev, "LABEL", hfs->label, hfs->label_len);
+	blkid_set_tag(probe->dev, "LABEL", (char *) hfs->label,
+		      hfs->label_len);
 	return 0;
 }
 
@@ -1220,7 +1221,7 @@ static int probe_hfsplus(struct blkid_probe *probe,
 		return 0;
 
 	label_len = blkid_be16(key->unicode_len) * 2;
-	unicode_16be_to_utf8(label, sizeof(label), key->unicode, label_len);
+	unicode_16be_to_utf8((unsigned char *) label, sizeof(label), key->unicode, label_len);
 	blkid_set_tag(probe->dev, "LABEL", label, 0);
 	return 0;
 }
diff --git a/lib/e2p/e2p.h b/lib/e2p/e2p.h
index 98c97db..d5d10a5 100644
--- a/lib/e2p/e2p.h
+++ b/lib/e2p/e2p.h
@@ -38,6 +38,8 @@ int setversion (int fd, unsigned long version);
 
 const char *e2p_feature2string(int compat, unsigned int mask);
 int e2p_string2feature(char *string, int *compat, unsigned int *mask);
+const char *e2p_jrnl_feature2string(int compat, unsigned int mask);
+int e2p_jrnl_string2feature(char *string, int *compat_type, unsigned int *mask);
 int e2p_edit_feature(const char *str, __u32 *compat_array, __u32 *ok_array);
 int e2p_edit_feature2(const char *str, __u32 *compat_array, __u32 *ok_array,
 		      __u32 *clear_ok_array, int *type_err,
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 696f27e..fe4fdb4 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -29,8 +29,8 @@
 /*
  * Check for uninit block bitmaps and deal with them appropriately
  */
-static check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
-			  dgrp_t group)
+static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
+			       dgrp_t group)
 {
 	int		i;
 	blk_t		blk, super_blk, old_desc_blk, new_desc_blk;
@@ -75,7 +75,7 @@ static check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
 /*
  * Check for uninit inode bitmaps and deal with them appropriately
  */
-static check_inode_uninit(ext2_filsys fs, ext2fs_inode_bitmap map,
+static void check_inode_uninit(ext2_filsys fs, ext2fs_inode_bitmap map,
 			  dgrp_t group)
 {
 	int		i;
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index b75cb77..667f3c6 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -11,6 +11,7 @@
 
 #include <stdio.h>
 #include <string.h>
+#include <time.h>
 #if HAVE_UNISTD_H
 #include <unistd.h>
 #endif
diff --git a/lib/uuid/gen_uuid.c b/lib/uuid/gen_uuid.c
index a3052d4..76c989c 100644
--- a/lib/uuid/gen_uuid.c
+++ b/lib/uuid/gen_uuid.c
@@ -35,8 +35,10 @@
 /*
  * Force inclusion of SVID stuff since we need it if we're compiling in
  * gcc-wall wall mode
+ *
+ * XXX - below somehow hides ftruncate() definition and _creates_ warnings
  */
-#define _SVID_SOURCE
+/* #define _SVID_SOURCE */
 
 #ifdef _WIN32
 #define _WIN32_WINNT 0x0500
diff --git a/misc/blkid.c b/misc/blkid.c
index 4bbf9fb..e5c8088 100644
--- a/misc/blkid.c
+++ b/misc/blkid.c
@@ -170,7 +170,6 @@ static void pretty_print_dev(blkid_dev dev)
 	blkid_tag_iterate	iter;
 	const char		*type, *value, *devname;
 	const char		*uuid = "", *fs_type = "", *label = "";
-	char			*cp;
 	int			len, mount_flags;
 	char			mtpt[80];
 	errcode_t		retval;
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 9ef5476..1c70c24 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -214,7 +214,7 @@ static void list_desc (ext2_filsys fs)
 		diff = fs->group_desc[i].bg_inode_table - first_block;
 		if (diff > 0)
 			printf(" (+%ld)", diff);
-		printf (_("\n  %u free blocks, %u free inodes, "
+		printf (_("\n  %d free blocks, %u free inodes, "
 			  "%u directories%s"),
 			fs->group_desc[i].bg_free_blocks_count,
 			fs->group_desc[i].bg_free_inodes_count,
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 77f1bc0..be9f4e6 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -48,6 +48,7 @@ extern int optind;
 #include <sys/types.h>
 #include <libgen.h>
 #include <limits.h>
+#include <strings.h>
 
 #include "ext2fs/ext2_fs.h"
 #include "et/com_err.h"
@@ -380,7 +381,7 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag)
 		retval = ext2fs_zero_blocks2(fs, blk, num, &blk, &num);
 		if (retval) {
 			fprintf(stderr, _("\nCould not write %d "
-				  "blocks in inode table starting at %ull: %s\n"),
+				  "blocks in inode table starting at %llu: %s\n"),
 				num, blk, error_message(retval));
 			exit(1);
 		}
@@ -597,7 +598,7 @@ static void show_stats(ext2_filsys fs)
 	int			need, col_left;
 
 	if (ext2fs_blocks_count(&fs_param) != ext2fs_blocks_count(s))
-		fprintf(stderr, _("warning: %u blocks unused.\n\n"),
+		fprintf(stderr, _("warning: %llu blocks unused.\n\n"),
 		       ext2fs_blocks_count(&fs_param) - ext2fs_blocks_count(s));
 
 	memset(buf, 0, sizeof(buf));
@@ -1995,7 +1996,7 @@ int main (int argc, char *argv[])
 
 		if (retval) {
 			com_err(program_name, retval,
-				_("while zeroing block %u at end of filesystem"),
+				_("while zeroing block %llu at end of filesystem"),
 				ret_blk);
 		}
 		write_inode_tables(fs, lazy_itable_init);
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index a1fa57b..04e2b9f 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1440,7 +1440,7 @@ retry_open:
 		 * file.
 		 */
 		if (new_inode_size == EXT2_INODE_SIZE(fs->super)) {
-			fprintf(stderr, _("The inode size is already %d\n"),
+			fprintf(stderr, _("The inode size is already %lu\n"),
 				new_inode_size);
 			exit(1);
 		}
-- 
1.5.6.5

