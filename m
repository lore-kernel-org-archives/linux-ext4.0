From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 27/47] libext2fs: Verify and calculate extended attribute
	block checksums
Date: Sat, 08 Oct 2011 00:36:08 -0700
Message-ID: <20111008073607.17888.9379.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:39935 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab1JHHim (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Oct 2011 03:38:42 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p987KGSP005450
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:20:16 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987aAJ6025836
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:36:10 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987a9Q5015245
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:36:10 -0600
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Calculate and verify the checksum for separate (i.e. not in the inode) extended
attribute blocks; the checksum lives in the header.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/pass1.c             |   10 ++++--
 e2fsck/pass1b.c            |    4 +-
 e2fsck/pass2.c             |    5 ++-
 e2fsck/super.c             |    5 ++-
 lib/ext2fs/csum.c          |   75 ++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_err.et.in  |    3 ++
 lib/ext2fs/ext2_ext_attr.h |    4 ++
 lib/ext2fs/ext2fs.h        |   15 ++++++++-
 lib/ext2fs/ext_attr.c      |   55 +++++++++++++++++++++++++-------
 lib/ext2fs/swapfs.c        |    3 +-
 10 files changed, 153 insertions(+), 26 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index e2fe53c..0423565 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1483,7 +1483,8 @@ static void adjust_extattr_refcount(e2fsck_t ctx, ext2_refcount_t refcount,
 		if ((blk = ea_refcount_intr_next(refcount, &count)) == 0)
 			break;
 		pctx.blk = blk;
-		pctx.errcode = ext2fs_read_ext_attr2(fs, blk, block_buf);
+		pctx.errcode = ext2fs_read_ext_attr3(fs, blk, block_buf,
+						     pctx.ino);
 		if (pctx.errcode) {
 			fix_problem(ctx, PR_1_EXTATTR_READ_ABORT, &pctx);
 			return;
@@ -1494,8 +1495,9 @@ static void adjust_extattr_refcount(e2fsck_t ctx, ext2_refcount_t refcount,
 		pctx.num = should_be;
 		if (fix_problem(ctx, PR_1_EXTATTR_REFCOUNT, &pctx)) {
 			header->h_refcount = should_be;
-			pctx.errcode = ext2fs_write_ext_attr2(fs, blk,
-							     block_buf);
+			pctx.errcode = ext2fs_write_ext_attr3(fs, blk,
+							     block_buf,
+							     pctx.ino);
 			if (pctx.errcode) {
 				fix_problem(ctx, PR_1_EXTATTR_WRITE_ABORT,
 					    &pctx);
@@ -1592,7 +1594,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	 * validate it
 	 */
 	pctx->blk = blk;
-	pctx->errcode = ext2fs_read_ext_attr2(fs, blk, block_buf);
+	pctx->errcode = ext2fs_read_ext_attr3(fs, blk, block_buf, pctx->ino);
 	if (pctx->errcode && fix_problem(ctx, PR_1_READ_EA_BLOCK, pctx))
 		goto clear_extattr;
 	header = (struct ext2_ext_attr_header *) block_buf;
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 5ff92c2..0551fc0 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -640,9 +640,9 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 	if (ext2fs_file_acl_block(&inode) &&
 	    (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
 		count = 1;
-		pctx.errcode = ext2fs_adjust_ea_refcount2(fs,
+		pctx.errcode = ext2fs_adjust_ea_refcount3(fs,
 						   ext2fs_file_acl_block(&inode),
-						   block_buf, -1, &count);
+						   block_buf, -1, &count, ino);
 		if (pctx.errcode == EXT2_ET_BAD_EA_BLOCK_NUM) {
 			pctx.errcode = 0;
 			count = 1;
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 7b11405..d664c8d 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1283,8 +1283,9 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 
 	if (ext2fs_file_acl_block(&inode) &&
 	    (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
-		pctx.errcode = ext2fs_adjust_ea_refcount2(fs, ext2fs_file_acl_block(&inode),
-						   block_buf, -1, &count);
+		pctx.errcode = ext2fs_adjust_ea_refcount3(fs,
+				ext2fs_file_acl_block(&inode),
+				block_buf, -1, &count, ino);
 		if (pctx.errcode == EXT2_ET_BAD_EA_BLOCK_NUM) {
 			pctx.errcode = 0;
 			count = 1;
diff --git a/e2fsck/super.c b/e2fsck/super.c
index abf8081..605a96e 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -198,8 +198,9 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
 		ext2fs_iblk_sub_blocks(fs, inode, pb.truncated_blocks);
 
 	if (ext2fs_file_acl_block(inode)) {
-		retval = ext2fs_adjust_ea_refcount2(fs, ext2fs_file_acl_block(inode),
-						   block_buf, -1, &count);
+		retval = ext2fs_adjust_ea_refcount3(fs,
+				ext2fs_file_acl_block(inode),
+				block_buf, -1, &count, ino);
 		if (retval == EXT2_ET_BAD_EA_BLOCK_NUM) {
 			retval = 0;
 			count = 1;
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 133cf84..aec5c87 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -30,6 +30,81 @@
 #define STATIC static
 #endif
 
+static errcode_t ext2fs_ext_attr_block_csum(ext2_filsys fs, ext2_ino_t inum,
+					    blk64_t block,
+					    struct ext2_ext_attr_header *hdr,
+					    __u32 *crc)
+{
+	errcode_t retval = 0;
+	char *buf = (char *)hdr;
+	__u32 ncrc, old_crc = hdr->h_checksum;
+
+	hdr->h_checksum = 0;
+#ifdef WORDS_BIGENDIAN
+	retval = ext2fs_get_mem(fs->blocksize, &buf);
+	if (retval)
+		return retval;
+	ext2fs_swap_ext_attr(buf, (char *)hdr, fs->blocksize, 1);
+#endif
+
+	ncrc = ext2fs_crc32c_le(~0, fs->super->s_uuid,
+				sizeof(fs->super->s_uuid));
+	if (hdr->h_refcount != 1) {
+		block = ext2fs_cpu_to_le64(block);
+		ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&block,
+					sizeof(block));
+	} else {
+		inum = ext2fs_cpu_to_le32(inum);
+		ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&inum,
+					sizeof(inum));
+	}
+	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)buf, fs->blocksize);
+	hdr->h_checksum = old_crc;
+	*crc = ncrc;
+
+#ifdef WORDS_BIGENDIAN
+	ext2fs_free_mem(&buf);
+#endif
+
+	return retval;
+}
+
+int ext2fs_ext_attr_block_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+				      blk64_t block,
+				      struct ext2_ext_attr_header *hdr)
+{
+	__u32 calculated;
+	errcode_t retval;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	retval = ext2fs_ext_attr_block_csum(fs, inum, block, hdr, &calculated);
+	if (retval)
+		return 0;
+
+	return hdr->h_checksum == calculated;
+}
+
+errcode_t ext2fs_ext_attr_block_csum_set(ext2_filsys fs, ext2_ino_t inum,
+					 blk64_t block,
+					 struct ext2_ext_attr_header *hdr)
+{
+	errcode_t retval;
+	__u32 crc;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	retval = ext2fs_ext_attr_block_csum(fs, inum, block, hdr, &crc);
+	if (retval)
+		return retval;
+	hdr->h_checksum = crc;
+	return 0;
+}
+
 void ext2fs_initialize_dirent_tail(ext2_filsys fs,
 				   struct ext2_dir_entry_tail *t)
 {
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index fa66b85..e210f8d 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -452,4 +452,7 @@ ec	EXT2_ET_INODE_CORRUPT,
 ec	EXT2_ET_INODE_CSUM_NONZERO,
 	"Inode checksum should not be set"
 
+ec	EXT2_ET_EXT_ATTR_BLOCK_CORRUPT,
+	"Extended attribute block fails checksum"
+
 	end
diff --git a/lib/ext2fs/ext2_ext_attr.h b/lib/ext2fs/ext2_ext_attr.h
index ed548d1..bbb0aaa 100644
--- a/lib/ext2fs/ext2_ext_attr.h
+++ b/lib/ext2fs/ext2_ext_attr.h
@@ -20,7 +20,9 @@ struct ext2_ext_attr_header {
 	__u32	h_refcount;	/* reference count */
 	__u32	h_blocks;	/* number of disk blocks used */
 	__u32	h_hash;		/* hash value of all attributes */
-	__u32	h_reserved[4];	/* zero right now */
+	__u32	h_checksum;	/* crc32c(uuid+id+xattrs) */
+				/* id = inum if refcount = 1, else blknum */
+	__u32	h_reserved[3];	/* zero right now */
 };
 
 struct ext2_ext_attr_entry {
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 77a92af..9f0e8fa 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -929,10 +929,15 @@ extern __u32 ext2fs_crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 ext2fs_crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern errcode_t ext2fs_ext_attr_block_csum_set(ext2_filsys fs,
+					ext2_ino_t inum, blk64_t block,
+					struct ext2_ext_attr_header *hdr);
+extern int ext2fs_ext_attr_block_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+					     blk64_t block,
+					     struct ext2_ext_attr_header *hdr);
 #define EXT2_DIRENT_TAIL(block, blocksize, csum_size) \
 	((struct ext2_dir_entry_tail *)(((void *)(block)) + \
 					(blocksize) - (csum_size)))
-
 extern void ext2fs_initialize_dirent_tail(ext2_filsys fs,
 					  struct ext2_dir_entry_tail *t);
 extern int ext2fs_dirent_has_tail(ext2_filsys fs,
@@ -1086,16 +1091,24 @@ extern __u32 ext2fs_ext_attr_hash_entry(struct ext2_ext_attr_entry *entry,
 extern errcode_t ext2fs_read_ext_attr(ext2_filsys fs, blk_t block, void *buf);
 extern errcode_t ext2fs_read_ext_attr2(ext2_filsys fs, blk64_t block,
 				       void *buf);
+extern errcode_t ext2fs_read_ext_attr3(ext2_filsys fs, blk64_t block,
+				       void *buf, ext2_ino_t inum);
 extern errcode_t ext2fs_write_ext_attr(ext2_filsys fs, blk_t block,
 				       void *buf);
 extern errcode_t ext2fs_write_ext_attr2(ext2_filsys fs, blk64_t block,
 				       void *buf);
+extern errcode_t ext2fs_write_ext_attr3(ext2_filsys fs, blk64_t block,
+				       void *buf, ext2_ino_t inum);
 extern errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
 					   char *block_buf,
 					   int adjust, __u32 *newcount);
 extern errcode_t ext2fs_adjust_ea_refcount2(ext2_filsys fs, blk64_t blk,
 					   char *block_buf,
 					   int adjust, __u32 *newcount);
+extern errcode_t ext2fs_adjust_ea_refcount3(ext2_filsys fs, blk64_t blk,
+					   char *block_buf,
+					   int adjust, __u32 *newcount,
+					   ext2_ino_t inum);
 
 /* extent.c */
 extern errcode_t ext2fs_extent_header_verify(void *ptr, int size);
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 1889824..79d97d7 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -61,7 +61,8 @@ __u32 ext2fs_ext_attr_hash_entry(struct ext2_ext_attr_entry *entry, void *data)
 #undef NAME_HASH_SHIFT
 #undef VALUE_HASH_SHIFT
 
-errcode_t ext2fs_read_ext_attr2(ext2_filsys fs, blk64_t block, void *buf)
+errcode_t ext2fs_read_ext_attr3(ext2_filsys fs, blk64_t block, void *buf,
+				ext2_ino_t inum)
 {
 	errcode_t	retval;
 
@@ -71,38 +72,57 @@ errcode_t ext2fs_read_ext_attr2(ext2_filsys fs, blk64_t block, void *buf)
 #ifdef WORDS_BIGENDIAN
 	ext2fs_swap_ext_attr(buf, buf, fs->blocksize, 1);
 #endif
+
+	if (!(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+	    !ext2fs_ext_attr_block_csum_verify(fs, inum, block, buf))
+		return EXT2_ET_EXT_ATTR_BLOCK_CORRUPT;
+
 	return 0;
 }
 
+errcode_t ext2fs_read_ext_attr2(ext2_filsys fs, blk64_t block, void *buf)
+{
+	return ext2fs_read_ext_attr3(fs, block, buf, 0);
+}
+
 errcode_t ext2fs_read_ext_attr(ext2_filsys fs, blk_t block, void *buf)
 {
 	return ext2fs_read_ext_attr2(fs, block, buf);
 }
 
-errcode_t ext2fs_write_ext_attr2(ext2_filsys fs, blk64_t block, void *inbuf)
+errcode_t ext2fs_write_ext_attr3(ext2_filsys fs, blk64_t block, void *inbuf,
+				 ext2_ino_t inum)
 {
 	errcode_t	retval;
 	char		*write_buf;
-#ifdef WORDS_BIGENDIAN
-	char		*buf = NULL;
 
-	retval = ext2fs_get_mem(fs->blocksize, &buf);
+	retval = ext2fs_ext_attr_block_csum_set(fs, inum, block,
+			(struct ext2_ext_attr_header *)inbuf);
+	if (retval)
+		return retval;
+
+#ifdef WORDS_BIGENDIAN
+	retval = ext2fs_get_mem(fs->blocksize, &write_buf);
 	if (retval)
 		return retval;
-	write_buf = buf;
-	ext2fs_swap_ext_attr(buf, inbuf, fs->blocksize, 1);
+	ext2fs_swap_ext_attr(write_buf, inbuf, fs->blocksize, 1);
 #else
 	write_buf = (char *) inbuf;
 #endif
 	retval = io_channel_write_blk64(fs->io, block, 1, write_buf);
 #ifdef WORDS_BIGENDIAN
-	ext2fs_free_mem(&buf);
+	ext2fs_free_mem(&write_buf);
 #endif
 	if (!retval)
 		ext2fs_mark_changed(fs);
 	return retval;
 }
 
+errcode_t ext2fs_write_ext_attr2(ext2_filsys fs, blk64_t block, void *inbuf)
+{
+	return ext2fs_write_ext_attr3(fs, block, inbuf, 0);
+}
+
 errcode_t ext2fs_write_ext_attr(ext2_filsys fs, blk_t block, void *inbuf)
 {
 	return ext2fs_write_ext_attr2(fs, block, inbuf);
@@ -111,9 +131,9 @@ errcode_t ext2fs_write_ext_attr(ext2_filsys fs, blk_t block, void *inbuf)
 /*
  * This function adjusts the reference count of the EA block.
  */
-errcode_t ext2fs_adjust_ea_refcount2(ext2_filsys fs, blk64_t blk,
+errcode_t ext2fs_adjust_ea_refcount3(ext2_filsys fs, blk64_t blk,
 				    char *block_buf, int adjust,
-				    __u32 *newcount)
+				    __u32 *newcount, ext2_ino_t inum)
 {
 	errcode_t	retval;
 	struct ext2_ext_attr_header *header;
@@ -130,7 +150,7 @@ errcode_t ext2fs_adjust_ea_refcount2(ext2_filsys fs, blk64_t blk,
 		block_buf = buf;
 	}
 
-	retval = ext2fs_read_ext_attr2(fs, blk, block_buf);
+	retval = ext2fs_read_ext_attr3(fs, blk, block_buf, inum);
 	if (retval)
 		goto errout;
 
@@ -139,7 +159,7 @@ errcode_t ext2fs_adjust_ea_refcount2(ext2_filsys fs, blk64_t blk,
 	if (newcount)
 		*newcount = header->h_refcount;
 
-	retval = ext2fs_write_ext_attr2(fs, blk, block_buf);
+	retval = ext2fs_write_ext_attr3(fs, blk, block_buf, inum);
 	if (retval)
 		goto errout;
 
@@ -149,9 +169,18 @@ errout:
 	return retval;
 }
 
+errcode_t ext2fs_adjust_ea_refcount2(ext2_filsys fs, blk64_t blk,
+				    char *block_buf, int adjust,
+				    __u32 *newcount)
+{
+	return ext2fs_adjust_ea_refcount3(fs, blk, block_buf, adjust,
+					  newcount, 0);
+}
+
 errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
 					char *block_buf, int adjust,
 					__u32 *newcount)
 {
-	return ext2fs_adjust_ea_refcount(fs, blk, block_buf, adjust, newcount);
+	return ext2fs_adjust_ea_refcount2(fs, blk, block_buf, adjust,
+					  newcount);
 }
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 69916e5..de178a4 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -157,7 +157,8 @@ void ext2fs_swap_ext_attr_header(struct ext2_ext_attr_header *to_header,
 	to_header->h_blocks   = ext2fs_swab32(from_header->h_blocks);
 	to_header->h_refcount = ext2fs_swab32(from_header->h_refcount);
 	to_header->h_hash     = ext2fs_swab32(from_header->h_hash);
-	for (n = 0; n < 4; n++)
+	to_header->h_checksum = ext2fs_swab32(from_header->h_checksum);
+	for (n = 0; n < 3; n++)
 		to_header->h_reserved[n] =
 			ext2fs_swab32(from_header->h_reserved[n]);
 }

