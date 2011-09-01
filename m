From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 13/16] ext4: Calculate and verify checksums of extended
	attribute blocks
Date: Wed, 31 Aug 2011 17:32:00 -0700
Message-ID: <20110901003200.31048.70117.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Calculate and verify the checksums of extended attribute blocks.  This only
applies to separate EA blocks that are pointed to by inode->i_file_acl (i.e.
external EA blocks); the checksum lives in the EA header.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/xattr.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++---------
 fs/ext4/xattr.h |    3 +-
 2 files changed, 76 insertions(+), 15 deletions(-)


diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c757adc..2825e59 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -56,6 +56,7 @@
 #include <linux/mbcache.h>
 #include <linux/quotaops.h>
 #include <linux/rwsem.h>
+#include <linux/crc32c.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
 #include "xattr.h"
@@ -122,6 +123,58 @@ const struct xattr_handler *ext4_xattr_handlers[] = {
 	NULL
 };
 
+static __le32 ext4_xattr_block_csum(struct inode *inode,
+				    sector_t block_nr,
+				    struct ext4_xattr_header *hdr)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	int offset = offsetof(struct ext4_xattr_header, h_checksum);
+	__u32 crc = 0;
+
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	block_nr = cpu_to_le64(block_nr);
+	crc = crc32c_le(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
+	crc = crc32c_le(crc, (__u8 *)&block_nr, sizeof(block_nr));
+	crc = crc32c_le(crc, (__u8 *)hdr, offset);
+	offset += sizeof(hdr->h_checksum); /* skip checksum */
+	crc = crc32c_le(crc, (__u8 *)hdr + offset,
+			EXT4_BLOCK_SIZE(inode->i_sb) - offset);
+	return cpu_to_le32(crc);
+}
+
+static int ext4_xattr_block_csum_verify(struct inode *inode,
+					sector_t block_nr,
+					struct ext4_xattr_header *hdr)
+{
+	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    (hdr->h_checksum != ext4_xattr_block_csum(inode, block_nr, hdr)))
+		return 0;
+	return 1;
+}
+
+static void ext4_xattr_block_csum_set(struct inode *inode,
+				      sector_t block_nr,
+				      struct ext4_xattr_header *hdr)
+{
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	hdr->h_checksum = ext4_xattr_block_csum(inode, block_nr, hdr);
+}
+
+static inline int ext4_handle_dirty_xattr_block(handle_t *handle,
+						struct inode *inode,
+						struct buffer_head *bh)
+{
+	ext4_xattr_block_csum_set(inode, bh->b_blocknr, BHDR(bh));
+	return ext4_handle_dirty_metadata(handle, inode, bh);
+}
+
 static inline const struct xattr_handler *
 ext4_xattr_handler(int name_index)
 {
@@ -156,14 +209,21 @@ ext4_xattr_check_names(struct ext4_xattr_entry *entry, void *end)
 }
 
 static inline int
-ext4_xattr_check_block(struct buffer_head *bh)
+ext4_xattr_check_block(struct inode *inode, struct buffer_head *bh)
 {
 	int error;
 
+	if (buffer_verified(bh))
+		return 0;
+
 	if (BHDR(bh)->h_magic != cpu_to_le32(EXT4_XATTR_MAGIC) ||
 	    BHDR(bh)->h_blocks != cpu_to_le32(1))
 		return -EIO;
+	if (!ext4_xattr_block_csum_verify(inode, bh->b_blocknr, BHDR(bh)))
+		return -EIO;
 	error = ext4_xattr_check_names(BFIRST(bh), bh->b_data + bh->b_size);
+	if (!error)
+		set_buffer_verified(bh);
 	return error;
 }
 
@@ -226,7 +286,7 @@ ext4_xattr_block_get(struct inode *inode, int name_index, const char *name,
 		goto cleanup;
 	ea_bdebug(bh, "b_count=%d, refcount=%d",
 		atomic_read(&(bh->b_count)), le32_to_cpu(BHDR(bh)->h_refcount));
-	if (ext4_xattr_check_block(bh)) {
+	if (ext4_xattr_check_block(inode, bh)) {
 bad_block:
 		EXT4_ERROR_INODE(inode, "bad block %llu",
 				 EXT4_I(inode)->i_file_acl);
@@ -370,7 +430,7 @@ ext4_xattr_block_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 		goto cleanup;
 	ea_bdebug(bh, "b_count=%d, refcount=%d",
 		atomic_read(&(bh->b_count)), le32_to_cpu(BHDR(bh)->h_refcount));
-	if (ext4_xattr_check_block(bh)) {
+	if (ext4_xattr_check_block(inode, bh)) {
 		EXT4_ERROR_INODE(inode, "bad block %llu",
 				 EXT4_I(inode)->i_file_acl);
 		error = -EIO;
@@ -489,7 +549,7 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 				 EXT4_FREE_BLOCKS_FORGET);
 	} else {
 		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
-		error = ext4_handle_dirty_metadata(handle, inode, bh);
+		error = ext4_handle_dirty_xattr_block(handle, inode, bh);
 		if (IS_SYNC(inode))
 			ext4_handle_sync(handle);
 		dquot_free_block(inode, 1);
@@ -662,7 +722,7 @@ ext4_xattr_block_find(struct inode *inode, struct ext4_xattr_info *i,
 		ea_bdebug(bs->bh, "b_count=%d, refcount=%d",
 			atomic_read(&(bs->bh->b_count)),
 			le32_to_cpu(BHDR(bs->bh)->h_refcount));
-		if (ext4_xattr_check_block(bs->bh)) {
+		if (ext4_xattr_check_block(inode, bs->bh)) {
 			EXT4_ERROR_INODE(inode, "bad block %llu",
 					 EXT4_I(inode)->i_file_acl);
 			error = -EIO;
@@ -725,9 +785,9 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			if (error == -EIO)
 				goto bad_block;
 			if (!error)
-				error = ext4_handle_dirty_metadata(handle,
-								   inode,
-								   bs->bh);
+				error = ext4_handle_dirty_xattr_block(handle,
+								      inode,
+								      bs->bh);
 			if (error)
 				goto cleanup;
 			goto inserted;
@@ -796,9 +856,9 @@ inserted:
 				ea_bdebug(new_bh, "reusing; refcount now=%d",
 					le32_to_cpu(BHDR(new_bh)->h_refcount));
 				unlock_buffer(new_bh);
-				error = ext4_handle_dirty_metadata(handle,
-								   inode,
-								   new_bh);
+				error = ext4_handle_dirty_xattr_block(handle,
+								      inode,
+								      new_bh);
 				if (error)
 					goto cleanup_dquot;
 			}
@@ -848,8 +908,8 @@ getblk_failed:
 			set_buffer_uptodate(new_bh);
 			unlock_buffer(new_bh);
 			ext4_xattr_cache_insert(new_bh);
-			error = ext4_handle_dirty_metadata(handle,
-							   inode, new_bh);
+			error = ext4_handle_dirty_xattr_block(handle,
+							      inode, new_bh);
 			if (error)
 				goto cleanup;
 		}
@@ -1190,7 +1250,7 @@ retry:
 		error = -EIO;
 		if (!bh)
 			goto cleanup;
-		if (ext4_xattr_check_block(bh)) {
+		if (ext4_xattr_check_block(inode, bh)) {
 			EXT4_ERROR_INODE(inode, "bad block %llu",
 					 EXT4_I(inode)->i_file_acl);
 			error = -EIO;
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 25b7387..b2b20af 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -27,7 +27,8 @@ struct ext4_xattr_header {
 	__le32	h_refcount;	/* reference count */
 	__le32	h_blocks;	/* number of disk blocks used */
 	__le32	h_hash;		/* hash value of all attributes */
-	__u32	h_reserved[4];	/* zero right now */
+	__le32	h_checksum;	/* crc32c(uuid+inum+xattrblock) */
+	__u32	h_reserved[3];	/* zero right now */
 };
 
 struct ext4_xattr_ibody_header {
