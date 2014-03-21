From: Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH] build: fix miscellaneous build warnings
Date: Fri, 21 Mar 2014 00:47:42 -0600
Message-ID: <1395384462-30244-1-git-send-email-andreas.dilger@intel.com>
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <andreas.dilger@intel.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:9416 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaCUG5K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Mar 2014 02:57:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix various unused variable and use-uninitialized warnings.

Add generated files into .gitignore.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .gitignore                |    8 ++++++++
 lib/blkid/save.c          |    2 +-
 lib/ext2fs/alloc.c        |    2 +-
 lib/ext2fs/blkmap64_rb.c  |    5 +----
 lib/ext2fs/csum.c         |    1 -
 lib/ext2fs/gen_bitmap64.c |    2 --
 misc/mk_hugefiles.c       |    2 +-
 misc/mke2fs.c             |    3 +--
 misc/tune2fs.c            |    2 +-
 9 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/.gitignore b/.gitignore
index b243fc2..1024cc3 100644
--- a/.gitignore
+++ b/.gitignore
@@ -8,9 +8,11 @@ FILES
 patches
 Makefile
 *.bak
+*.diff
 *.dSYM
 *.o
 *.orig
+*.patch
 *.pc
 *.rej
 *.swp
@@ -22,6 +24,7 @@ config.status
 debugfs/debug_cmds.c
 debugfs/debugfs
 debugfs/debugfs.8
+debugfs/extent_cmds.c
 doc/libext2fs.aux
 doc/libext2fs.cp
 doc/libext2fs.dvi
@@ -159,9 +162,11 @@ misc/e2undo
 misc/e2undo.8
 misc/e4defrag
 misc/e4defrag.8
+misc/ext4.5
 misc/filefrag
 misc/filefrag.8
 misc/findfs.8
+misc/findsuper
 misc/fsck
 misc/fsck.8
 misc/logsave
@@ -195,6 +200,7 @@ tags
 TAGS
 tests/progs/test_icount
 tests/progs/test_icount_cmds.c
+tests/progs/crcsum
 tests/*.ok
 tests/*.failed
 tests/*.log
@@ -202,7 +208,9 @@ tests/*.tmp
 tests/mke2fs.conf
 tests/test_script
 tests/test_one
+util/dirpaths.h
 util/gen-tarball
+util/install-symlink
 util/subst
 util/subst.conf
 Meta
diff --git a/lib/blkid/save.c b/lib/blkid/save.c
index a6538db..762ffef 100644
--- a/lib/blkid/save.c
+++ b/lib/blkid/save.c
@@ -146,7 +146,7 @@ int blkid_flush_cache(blkid_cache cache)
 			if (backup) {
 				sprintf(backup, "%s.old", filename);
 				unlink(backup);
-				link(filename, backup);
+				(void) link(filename, backup);
 				free(backup);
 			}
 			if (rename(opened, filename) < 0)
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 7dcfd3c..0acbc4e 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -138,7 +138,7 @@ errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
 			   ext2fs_block_bitmap map, blk64_t *ret)
 {
 	errcode_t retval;
-	blk64_t	b;
+	blk64_t	b = 0;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index a484751..4dcb03f 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -813,10 +813,8 @@ static errcode_t rb_find_first_zero(ext2fs_generic_bitmap bitmap,
 				   __u64 start, __u64 end, __u64 *out)
 {
 	struct rb_node *parent = NULL, **n;
-	struct rb_node *node, *next;
 	struct ext2fs_rb_private *bp;
 	struct bmap_rb_extent *ext;
-	int retval = 1;
 
 	bp = (struct ext2fs_rb_private *) bitmap->private;
 	n = &bp->root.rb_node;
@@ -851,10 +849,9 @@ static errcode_t rb_find_first_set(ext2fs_generic_bitmap bitmap,
 				   __u64 start, __u64 end, __u64 *out)
 {
 	struct rb_node *parent = NULL, **n;
-	struct rb_node *node, *next;
+	struct rb_node *node;
 	struct ext2fs_rb_private *bp;
 	struct bmap_rb_extent *ext;
-	int retval = 1;
 
 	bp = (struct ext2fs_rb_private *) bitmap->private;
 	n = &bp->root.rb_node;
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 6989880..669f806 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -35,7 +35,6 @@ __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
 	struct ext2_group_desc *desc = ext2fs_group_desc(fs, fs->group_desc,
 							 group);
 	size_t size = EXT2_DESC_SIZE(fs->super);
-	size_t offset;
 	__u16 crc = 0;
 
 	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 9615f1e..af55097 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -800,7 +800,6 @@ errcode_t ext2fs_convert_subcluster_bitmap(ext2_filsys fs,
 errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap bitmap,
 					      __u64 start, __u64 end, __u64 *out)
 {
-	int b;
 	__u64 cstart, cend, cout;
 	errcode_t retval;
 
@@ -855,7 +854,6 @@ errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap bitmap,
 errcode_t ext2fs_find_first_set_generic_bmap(ext2fs_generic_bitmap bitmap,
 					     __u64 start, __u64 end, __u64 *out)
 {
-	int b;
 	__u64 cstart, cend, cout;
 	errcode_t retval;
 
diff --git a/misc/mk_hugefiles.c b/misc/mk_hugefiles.c
index d4dadc4..b7a9840 100644
--- a/misc/mk_hugefiles.c
+++ b/misc/mk_hugefiles.c
@@ -119,7 +119,7 @@ static errcode_t mk_hugefile(ext2_filsys fs, blk64_t num,
 
 {
 	errcode_t		retval;
-	blk64_t			lblk, bend;
+	blk64_t			lblk, bend = 0;
 	__u64			size;
 	blk64_t			left;
 	blk64_t			count = 0;
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index abc8bd0..176dc40 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -115,7 +115,6 @@ char **fs_types;
 static profile_t	profile;
 
 static int sys_page_size = 4096;
-static int linux_version_code = 0;
 
 static void usage(void)
 {
@@ -2489,7 +2488,7 @@ int main (int argc, char *argv[])
 	errcode_t	retval = 0;
 	ext2_filsys	fs;
 	badblocks_list	bb_list = 0;
-	unsigned int	journal_blocks;
+	unsigned int	journal_blocks = 0;
 	unsigned int	i, checkinterval;
 	int		max_mnt_count;
 	int		val, hash_alg;
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index d35d54b..3359c4a 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2052,7 +2052,7 @@ retry_open:
 		printf(_("Setting reserved blocks gid to %lu\n"), resgid);
 	}
 	if (i_flag) {
-		if (interval >= (1ULL << 32)) {
+		if ((unsigned long long)interval >= (1ULL << 32)) {
 			com_err(program_name, 0,
 				_("interval between checks is too big (%lu)"),
 				interval);
-- 
1.7.3.4

