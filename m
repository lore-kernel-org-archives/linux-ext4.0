From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] build: quiet some "gcc -Wall" compiler warnings
Date: Thu, 22 Nov 2012 16:30:18 -0700
Message-ID: <1353627018-14373-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:57352 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2KVXaU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Nov 2012 18:30:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quiet a number of simple compiler warnings:
- pointers not initialized by ext2fs_get_mem()
- return without value in non-void function
- dereferencing type-punned pointers
- unused variables

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 e2fsck/message.c         |    2 +-
 e2fsck/problem.c         |    2 +-
 e2fsck/recovery.c        |    2 +-
 e2fsck/region.c          |    2 +-
 e2fsck/unix.c            |    2 +-
 e2fsck/util.c            |    1 -
 lib/blkid/probe.c        |   12 ++++++++----
 lib/ext2fs/crc32c.c      |    4 ++--
 lib/ext2fs/csum.c        |    4 +---
 lib/ext2fs/dblist.c      |    2 +-
 lib/ext2fs/qcow2.c       |    2 +-
 lib/ext2fs/rw_bitmaps.c  |    1 -
 lib/ext2fs/tst_bitmaps.c |    7 +++----
 lib/quota/mkquota.c      |    4 +++-
 lib/quota/quotaio.c      |    2 --
 misc/filefrag.c          |    2 +-
 misc/tune2fs.c           |    3 +--
 resize/resize2fs.c       |    4 +---
 18 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/e2fsck/message.c b/e2fsck/message.c
index 980dc4b..b79b895 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -197,7 +197,7 @@ static void safe_print(FILE *f, const char *cp, int len)
 static void print_pathname(FILE *f, ext2_filsys fs, ext2_ino_t dir,
 			   ext2_ino_t ino)
 {
-	errcode_t	retval;
+	errcode_t	retval = 0;
 	char		*path;
 
 	if (!dir && (ino < num_special_inodes)) {
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 78b05bb..dfe264a 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1905,7 +1905,7 @@ int fix_problem(e2fsck_t ctx, problem_t code, struct problem_context *pctx)
 		return 0;
 	}
 	if (!(ptr->flags & PR_CONFIG)) {
-		char	key[9], *new_desc;
+		char	key[9], *new_desc = NULL;
 
 		sprintf(key, "0x%06x", code);
 
diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index 54acb1b..8ba4060 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -603,7 +603,7 @@ static int do_one_pass(journal_t *journal,
 						success = -EIO;
 						printk(KERN_ERR "JBD: Invalid "
 						       "checksum recovering "
-						       "block %ld in log\n",
+						       "block %lld in log\n",
 						       blocknr);
 						continue;
 					}
diff --git a/e2fsck/region.c b/e2fsck/region.c
index e9abb56..4b669f0 100644
--- a/e2fsck/region.c
+++ b/e2fsck/region.c
@@ -171,7 +171,7 @@ void region_print(region_t region, FILE *f)
 
 int main(int argc, char **argv)
 {
-	region_t	r;
+	region_t	r = NULL;
 	int		pc = 0, ret;
 	region_addr_t	start, end;
 
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index d2b1bbd..57a490e 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1178,7 +1178,7 @@ int main (int argc, char *argv[])
 	int old_bitmaps;
 	__u32 features[3];
 	char *cp;
-	int qtype;  /* quota type */
+	int qtype = 0;  /* quota type */
 
 	clear_problem_context(&pctx);
 	sigcatcher_setup();
diff --git a/e2fsck/util.c b/e2fsck/util.c
index a808eec..e181967 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -797,7 +797,6 @@ void e2fsck_set_bitmap_type(ext2_filsys fs, unsigned int default_type,
 			    const char *profile_name, unsigned int *old_type)
 {
 	unsigned type;
-	errcode_t	retval;
 
 	if (old_type)
 		*old_type = fs->default_bitmap_type;
diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 6970b12..4a929b0 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -1163,7 +1163,8 @@ static int probe_hfs(struct blkid_probe *probe __BLKID_ATTR((unused)),
 			 struct blkid_magic *id __BLKID_ATTR((unused)),
 			 unsigned char *buf)
 {
-	struct hfs_mdb *hfs = (struct hfs_mdb *) buf;
+	struct hfs_mdb *hfs = (struct hfs_mdb *)buf;
+	unsigned long long *uuid_ptr;
 	char	uuid_str[17];
 	__u64	uuid;
 
@@ -1171,7 +1172,8 @@ static int probe_hfs(struct blkid_probe *probe __BLKID_ATTR((unused)),
 	    (memcmp(hfs->embed_sig, "HX", 2) == 0))
 		return 1;	/* Not hfs, but an embedded HFS+ */
 
-	uuid = blkid_le64(*((unsigned long long *) hfs->finder_info.id));
+	uuid_ptr = (unsigned long long *)hfs->finder_info.id;
+	uuid = blkid_le64(*uuid_ptr);
 	if (uuid) {
 		sprintf(uuid_str, "%016llX", uuid);
 		blkid_set_tag(probe->dev, "UUID", uuid_str, 0);
@@ -1205,9 +1207,10 @@ static int probe_hfsplus(struct blkid_probe *probe,
 	unsigned int leaf_node_size;
 	unsigned int leaf_block;
 	unsigned int label_len;
-	int ext;
+	unsigned long long *uuid_ptr;
 	__u64 leaf_off, uuid;
 	char	uuid_str[17], label[512];
+	int ext;
 
 	/* Check for a HFS+ volume embedded in a HFS volume */
 	if (memcmp(sbd->signature, "BD", 2) == 0) {
@@ -1235,7 +1238,8 @@ static int probe_hfsplus(struct blkid_probe *probe,
 	    (memcmp(hfsplus->signature, "HX", 2) != 0))
 		return 1;
 
-	uuid = blkid_le64(*((unsigned long long *) hfsplus->finder_info.id));
+	uuid_ptr = (unsigned long long *)hfsplus->finder_info.id;
+	uuid = blkid_le64(*uuid_ptr);
 	if (uuid) {
 		sprintf(uuid_str, "%016llX", uuid);
 		blkid_set_tag(probe->dev, "UUID", uuid_str, 0);
diff --git a/lib/ext2fs/crc32c.c b/lib/ext2fs/crc32c.c
index 5cb211b..750e52e 100644
--- a/lib/ext2fs/crc32c.c
+++ b/lib/ext2fs/crc32c.c
@@ -905,12 +905,12 @@ static int test_crc32c(void)
 		be = ext2fs_crc32_be(t->crc, test_buf + t->start, t->length);
 		if (le != t->crc32c_le) {
 			printf("Test %d LE fails, %x != %x\n",
-			       (t - test), le, t->crc32c_le);
+			       (int)(t - test), le, t->crc32c_le);
 			failures++;
 		}
 		if (be != t->crc32_be) {
 			printf("Test %d BE fails, %x != %x\n",
-			       (t - test), be, t->crc32_be);
+			       (int)(t - test), be, t->crc32_be);
 			failures++;
 		}
 		t++;
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 6c2e562..c133ee5 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -113,10 +113,8 @@ static errcode_t ext2fs_ext_attr_block_csum(ext2_filsys fs, ext2_ino_t inum,
 					    struct ext2_ext_attr_header *hdr,
 					    __u32 *crc)
 {
-	errcode_t retval;
 	char *buf = (char *)hdr;
-	__u32 gen, old_crc = hdr->h_checksum;
-	struct ext2_inode inode;
+	__u32 old_crc = hdr->h_checksum;
 
 	hdr->h_checksum = 0;
 	block = ext2fs_cpu_to_le64(block);
diff --git a/lib/ext2fs/dblist.c b/lib/ext2fs/dblist.c
index ceaae8f..3503615 100644
--- a/lib/ext2fs/dblist.c
+++ b/lib/ext2fs/dblist.c
@@ -33,7 +33,7 @@ static errcode_t make_dblist(ext2_filsys fs, ext2_ino_t size,
 			     struct ext2_db_entry2 *list,
 			     ext2_dblist *ret_dblist)
 {
-	ext2_dblist	dblist;
+	ext2_dblist	dblist = NULL;
 	errcode_t	retval;
 	ext2_ino_t	num_dirs;
 	size_t		len;
diff --git a/lib/ext2fs/qcow2.c b/lib/ext2fs/qcow2.c
index b0a0278..8394270 100644
--- a/lib/ext2fs/qcow2.c
+++ b/lib/ext2fs/qcow2.c
@@ -155,7 +155,7 @@ int qcow2_write_raw_image(int qcow2_fd, int raw_fd,
 	errcode_t ret = 0;
 	unsigned int l1_index, l2_index;
 	ext2_off64_t offset;
-	blk64_t *l1_table, *l2_table;
+	blk64_t *l1_table, *l2_table = NULL;
 	void *copy_buf = NULL;
 	size_t size;
 
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 601b8bd..a885c69 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -165,7 +165,6 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	int block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
 	int inode_nbytes = EXT2_INODES_PER_GROUP(fs->super) / 8;
 	int csum_flag;
-	int do_image = fs->flags & EXT2_FLAG_IMAGE_FILE;
 	unsigned int	cnt;
 	blk64_t	blk;
 	blk64_t	blk_itr = EXT2FS_B2C(fs, fs->super->s_first_data_block);
diff --git a/lib/ext2fs/tst_bitmaps.c b/lib/ext2fs/tst_bitmaps.c
index 5da3693..ef0978e 100644
--- a/lib/ext2fs/tst_bitmaps.c
+++ b/lib/ext2fs/tst_bitmaps.c
@@ -193,8 +193,7 @@ errout:
 
 void setup_cmd(int argc, char **argv)
 {
-	errcode_t	retval;
-	int		i, c, err;
+	int		c, err;
 	unsigned int	blocks = 128;
 	unsigned int	inodes = 0;
 	unsigned int	type = EXT2FS_BMAP64_BITARRAY;
@@ -372,7 +371,7 @@ void do_testb(int argc, char *argv[])
 {
 	unsigned int block, num;
 	int err;
-	int test_result, op_result;
+	int test_result;
 
 	if (check_fs_open(argv[0]))
 		return;
@@ -508,7 +507,7 @@ void do_testi(int argc, char *argv[])
 {
 	unsigned int inode;
 	int err;
-	int test_result, op_result;
+	int test_result;
 
 	if (check_fs_open(argv[0]))
 		return;
diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index 42af1f2..fd3fbb5 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -25,6 +25,7 @@
 #define UINT_TO_VOIDPTR(val)  ((void *)(intptr_t)(val))
 #define VOIDPTR_TO_UINT(ptr)  ((unsigned int)(intptr_t)(ptr))
 
+#if DEBUG_QUOTA
 static void print_inode(struct ext2_inode *inode)
 {
 	if (!inode)
@@ -44,6 +45,7 @@ static void print_inode(struct ext2_inode *inode)
 
 	return;
 }
+#endif
 
 /*
  * Returns 0 if not able to find the quota file, otherwise returns its
@@ -121,7 +123,7 @@ errcode_t quota_write_inode(quota_ctx_t qctx, int qtype)
 	int		retval = 0, i;
 	dict_t		*dict;
 	ext2_filsys	fs;
-	struct quota_handle *h;
+	struct quota_handle *h = NULL;
 	int		fmt = QFMT_VFS_V1;
 
 	if (!qctx)
diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index 7cdd653..ac34a80 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -117,7 +117,6 @@ static int compute_num_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
 			       int ref_offset EXT2FS_ATTR((unused)),
 			       void *private)
 {
-	blk64_t	block;
 	blk64_t *num_blocks = private;
 
 	*num_blocks += 1;
@@ -128,7 +127,6 @@ errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino)
 {
 	struct ext2_inode inode;
 	errcode_t err;
-	int i;
 
 	if ((err = ext2fs_read_inode(fs, ino, &inode)))
 		return err;
diff --git a/misc/filefrag.c b/misc/filefrag.c
index 3ec788f..56985a1 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -242,7 +242,7 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 	} while (last == 0);
 
 	*num_extents = tot_extents;
-out:
+
 	return 0;
 }
 
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index b290c46..e4cc38b 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -764,9 +764,8 @@ static void disable_uninit_bg(ext2_filsys fs, __u32 csum_feature_flag)
 static int update_feature_set(ext2_filsys fs, char *features)
 {
 	struct ext2_super_block *sb = fs->super;
-	struct ext2_group_desc *gd;
 	__u32		old_features[3];
-	int		i, type_err;
+	int		type_err;
 	unsigned int	mask_err;
 
 #define FEATURE_ON(type, mask) (!(old_features[(type)] & (mask)) && \
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 8d6f198..9d49db2 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1722,7 +1722,7 @@ static errcode_t fix_resize_inode(ext2_filsys fs)
 {
 	struct ext2_inode	inode;
 	errcode_t		retval;
-	char *			block_buf;
+	char *			block_buf = NULL;
 
 	if (!(fs->super->s_feature_compat &
 	      EXT2_FEATURE_COMPAT_RESIZE_INODE))
@@ -1924,8 +1924,6 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs)
 	blk64_t blks_needed, groups, data_blocks;
 	blk64_t grp, data_needed, last_start;
 	blk64_t overhead = 0;
-	int num_of_superblocks = 0;
-	blk64_t super_overhead = 0;
 	int old_desc_blocks;
 	int extra_groups = 0;
 	int flexbg_size = 1 << fs->super->s_log_groups_per_flex;
-- 
1.7.3.4

