From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] libext2fs: fix gcc -Wall nits
Date: Mon, 20 May 2013 09:59:01 -0400
Message-ID: <1369058343-1988-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49955 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930Ab3ETN7E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 May 2013 09:59:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/blkmap64_rb.c |  4 +++-
 lib/ext2fs/crc32c.c      |  6 +++---
 lib/ext2fs/csum.c        | 22 ++++++++++++----------
 lib/ext2fs/ext2fs.h      |  4 +++-
 4 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index 9c1abc5..d6442fc 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -862,7 +862,9 @@ static void rb_print_stats(ext2fs_generic_bitmap bitmap)
 		eff);
 }
 #else
-static void rb_print_stats(ext2fs_generic_bitmap bitmap){}
+static void rb_print_stats(ext2fs_generic_bitmap bitmap EXT2FS_ATTR((unused)))
+{
+}
 #endif
 
 struct ext2_bitmap_ops ext2fs_blkmap64_rbtree = {
diff --git a/lib/ext2fs/crc32c.c b/lib/ext2fs/crc32c.c
index 4e72eda..624ad77 100644
--- a/lib/ext2fs/crc32c.c
+++ b/lib/ext2fs/crc32c.c
@@ -125,7 +125,7 @@ crc32_body(uint32_t crc, unsigned char const *buf, size_t len,
 	len = rem_len;
 	/* And the last few bytes */
 	if (len) {
-		uint8_t *p = (uint8_t *)(b + 1) - 1;
+		const uint8_t *p = (const uint8_t *)(b + 1) - 1;
 		do {
 			DO_CRC(*++p); /* use pre increment for speed */
 		} while (--len);
@@ -146,7 +146,7 @@ crc32_body(uint32_t crc, unsigned char const *buf, size_t len,
  */
 static inline uint32_t crc32_le_generic(uint32_t crc, unsigned char const *p,
 					size_t len, const uint32_t (*tab)[256],
-					uint32_t polynomial)
+					uint32_t polynomial EXT2FS_ATTR((unused)))
 {
 #if CRC_LE_BITS == 1
 	int i;
@@ -197,7 +197,7 @@ uint32_t ext2fs_crc32c_le(uint32_t crc, unsigned char const *p, size_t len)
  */
 static inline uint32_t crc32_be_generic(uint32_t crc, unsigned char const *p,
 					size_t len, const uint32_t (*tab)[256],
-					uint32_t polynomial)
+					uint32_t polynomial EXT2FS_ATTR((unused)))
 {
 #if CRC_BE_BITS == 1
 	int i;
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index ebd544f..607f74a 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -73,7 +73,8 @@ int ext2fs_verify_csum_type(ext2_filsys fs, struct ext2_super_block *sb)
 	return sb->s_checksum_type == EXT2_CRC32C_CHKSUM;
 }
 
-static __u32 ext2fs_superblock_csum(ext2_filsys fs, struct ext2_super_block *sb)
+static __u32 ext2fs_superblock_csum(ext2_filsys fs EXT2FS_ATTR((unused)),
+				    struct ext2_super_block *sb)
 {
 	int offset = offsetof(struct ext2_super_block, s_checksum);
 
@@ -108,7 +109,8 @@ errcode_t ext2fs_superblock_csum_set(ext2_filsys fs,
 	return 0;
 }
 
-static errcode_t ext2fs_ext_attr_block_csum(ext2_filsys fs, ext2_ino_t inum,
+static errcode_t ext2fs_ext_attr_block_csum(ext2_filsys fs,
+					    ext2_ino_t inum EXT2FS_ATTR((unused)),
 					    blk64_t block,
 					    struct ext2_ext_attr_header *hdr,
 					    __u32 *crc)
@@ -190,11 +192,11 @@ static errcode_t __get_dx_countlimit(ext2_filsys fs,
 	if (rec_len == fs->blocksize && translate(dirent->name_len) == 0)
 		count_offset = 8;
 	else if (rec_len == 12) {
-		dp = (struct ext2_dir_entry *)(((void *)dirent) + rec_len);
+		dp = (struct ext2_dir_entry *)(((char *)dirent) + rec_len);
 		rec_len = translate(dp->rec_len);
 		if (rec_len != fs->blocksize - 12)
 			return EXT2_ET_DB_NOT_FOUND;
-		root = (struct ext2_dx_root_info *)(((void *)dp + 12));
+		root = (struct ext2_dx_root_info *)(((char *)dp + 12));
 		if (root->reserved_zero ||
 		    root->info_length != sizeof(struct ext2_dx_root_info))
 			return EXT2_ET_DB_NOT_FOUND;
@@ -202,7 +204,7 @@ static errcode_t __get_dx_countlimit(ext2_filsys fs,
 	} else
 		return EXT2_ET_DB_NOT_FOUND;
 
-	c = (struct ext2_dx_countlimit *)(((void *)dirent) + count_offset);
+	c = (struct ext2_dx_countlimit *)(((char *)dirent) + count_offset);
 	max_sane_entries = (fs->blocksize - count_offset) /
 			   sizeof(struct ext2_dx_entry);
 	if (ext2fs_le16_to_cpu(c->limit) > max_sane_entries ||
@@ -251,7 +253,7 @@ static errcode_t __get_dirent_tail(ext2_filsys fs,
 
 	rec_len = translate(d->rec_len);
 	while (rec_len && !(rec_len & 0x3)) {
-		d = (struct ext2_dir_entry *)(((void *)d) + rec_len);
+		d = (struct ext2_dir_entry *)(((char *)d) + rec_len);
 		if ((void *)d >= top)
 			break;
 		rec_len = translate(d->rec_len);
@@ -315,7 +317,7 @@ int ext2fs_dirent_csum_verify(ext2_filsys fs, ext2_ino_t inum,
 	 * so the swapfs.c functions won't change the endianness.
 	 */
 	retval = ext2fs_dirent_csum(fs, inum, dirent, &calculated,
-				    (void *)t - (void *)dirent);
+				    (char *)t - (char *)dirent);
 	if (retval)
 		return 0;
 	return ext2fs_le32_to_cpu(t->det_checksum) == calculated;
@@ -334,7 +336,7 @@ static errcode_t ext2fs_dirent_csum_set(ext2_filsys fs, ext2_ino_t inum,
 
 	/* swapfs.c functions don't change the checksum endianness */
 	retval = ext2fs_dirent_csum(fs, inum, dirent, &crc,
-				    (void *)t - (void *)dirent);
+				    (char *)t - (char *)dirent);
 	if (retval)
 		return retval;
 	t->det_checksum = ext2fs_cpu_to_le32(crc);
@@ -464,7 +466,7 @@ errcode_t ext2fs_dir_block_csum_set(ext2_filsys fs, ext2_ino_t inum,
 
 static struct ext3_extent_tail *get_extent_tail(struct ext3_extent_header *h)
 {
-	return (struct ext3_extent_tail *)(((void *)h) +
+	return (struct ext3_extent_tail *)(((char *)h) +
 					   EXT3_EXTENT_TAIL_OFFSET(h));
 }
 
@@ -653,7 +655,7 @@ int ext2fs_inode_csum_verify(ext2_filsys fs, ext2_ino_t inum,
 {
 	errcode_t retval;
 	__u32 provided, calculated;
-	int i, has_hi;
+	unsigned int i, has_hi;
 	char *cp;
 
 	if (fs->super->s_creator_os != EXT2_OS_LINUX ||
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index cd59473..6923f34 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -963,13 +963,15 @@ extern int ext2fs_ext_attr_block_csum_verify(ext2_filsys fs, ext2_ino_t inum,
 					     blk64_t block,
 					     struct ext2_ext_attr_header *hdr);
 #define EXT2_DIRENT_TAIL(block, blocksize) \
-	((struct ext2_dir_entry_tail *)(((void *)(block)) + \
+	((struct ext2_dir_entry_tail *)(((char *)(block)) + \
 	(blocksize) - sizeof(struct ext2_dir_entry_tail)))
 
 extern void ext2fs_initialize_dirent_tail(ext2_filsys fs,
 					  struct ext2_dir_entry_tail *t);
 extern int ext2fs_dirent_has_tail(ext2_filsys fs,
 				  struct ext2_dir_entry *dirent);
+extern int ext2fs_dirent_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+				     struct ext2_dir_entry *dirent);
 extern int ext2fs_dir_block_csum_verify(ext2_filsys fs, ext2_ino_t inum,
 					struct ext2_dir_entry *dirent);
 extern errcode_t ext2fs_dir_block_csum_set(ext2_filsys fs, ext2_ino_t inum,
-- 
1.7.12.rc0.22.gcdd159b

