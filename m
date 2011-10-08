From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 32/47] libext2fs: Use i_generation in inode-related metadata
	checksums
Date: Sat, 08 Oct 2011 00:36:40 -0700
Message-ID: <20111008073640.17888.74853.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49959 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1JHHje (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:39:34 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p987CXBs024086
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:12:33 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987ah111613840
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:36:43 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987agOj011723
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:36:43 -0400
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Whenever we are calculating a checksum for a piece of metadata that is
associated with an inode, incorporate i_generation into that calculation so
that old metadata blocks cannot be re-associated after a delete/create cycle.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/csum.c  |   45 +++++++++++++++++++++++++++++++++++++--------
 lib/ext2fs/mkdir.c |    4 ++--
 2 files changed, 39 insertions(+), 10 deletions(-)


diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index d89fa37..e2c32f4 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -71,7 +71,8 @@ static errcode_t ext2fs_ext_attr_block_csum(ext2_filsys fs, ext2_ino_t inum,
 {
 	errcode_t retval = 0;
 	char *buf = (char *)hdr;
-	__u32 ncrc, old_crc = hdr->h_checksum;
+	__u32 gen, ncrc, old_crc = hdr->h_checksum;
+	struct ext2_inode inode;
 
 	hdr->h_checksum = 0;
 #ifdef WORDS_BIGENDIAN
@@ -88,14 +89,21 @@ static errcode_t ext2fs_ext_attr_block_csum(ext2_filsys fs, ext2_ino_t inum,
 		ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&block,
 					sizeof(block));
 	} else {
+		retval = ext2fs_read_inode(fs, inum, &inode);
+		if (retval)
+			goto out;
 		inum = ext2fs_cpu_to_le32(inum);
+		gen = ext2fs_cpu_to_le32(inode.i_generation);
 		ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&inum,
 					sizeof(inum));
+		ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&gen,
+					sizeof(gen));
 	}
 	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)buf, fs->blocksize);
 	hdr->h_checksum = old_crc;
 	*crc = ncrc;
 
+out:
 #ifdef WORDS_BIGENDIAN
 	ext2fs_free_mem(&buf);
 #endif
@@ -190,7 +198,8 @@ static errcode_t ext2fs_dirent_csum(ext2_filsys fs, ext2_ino_t inum,
 {
 	errcode_t retval = 0;
 	char *buf = (char *)dirent;
-	__u32 ncrc;
+	__u32 ncrc, gen;
+	struct ext2_inode inode;
 
 #ifdef WORDS_BIGENDIAN
 	retval = ext2fs_get_mem(fs->blocksize, &buf);
@@ -202,15 +211,20 @@ static errcode_t ext2fs_dirent_csum(ext2_filsys fs, ext2_ino_t inum,
 		goto out;
 #endif
 
+	retval = ext2fs_read_inode(fs, inum, &inode);
+	if (retval)
+		goto out;
 	inum = ext2fs_cpu_to_le32(inum);
+	gen = ext2fs_cpu_to_le32(inode.i_generation);
 	ncrc = ext2fs_crc32c_le(~0, fs->super->s_uuid,
 				sizeof(fs->super->s_uuid));
 	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&inum, sizeof(inum));
+	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&gen, sizeof(gen));
 	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)buf, size);
 	*crc = ncrc;
 
-#ifdef WORDS_BIGENDIAN
 out:
+#ifdef WORDS_BIGENDIAN
 	ext2fs_free_mem(&buf);
 #endif
 
@@ -270,7 +284,8 @@ static errcode_t ext2fs_dx_csum(ext2_filsys fs, ext2_ino_t inum,
 	errcode_t retval = 0;
 	char *buf = (char *)dirent;
 	int size;
-	__u32 ncrc;
+	__u32 ncrc, gen;
+	struct ext2_inode inode;
 
 	size = count_offset + (count * sizeof(struct ext2_dx_entry));
 
@@ -289,15 +304,20 @@ static errcode_t ext2fs_dx_csum(ext2_filsys fs, ext2_ino_t inum,
 		goto out;
 #endif
 
+	retval = ext2fs_read_inode(fs, inum, &inode);
+	if (retval)
+		goto out;
 	inum = ext2fs_cpu_to_le32(inum);
+	gen = ext2fs_cpu_to_le32(inode.i_generation);
 	ncrc = ext2fs_crc32c_le(~0, fs->super->s_uuid,
 				sizeof(fs->super->s_uuid));
 	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&inum, sizeof(inum));
+	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&gen, sizeof(gen));
 	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)buf, size);
 	*crc = ncrc;
 
-#ifdef WORDS_BIGENDIAN
 out:
+#ifdef WORDS_BIGENDIAN
 	ext2fs_free_mem(&buf);
 #endif
 
@@ -409,19 +429,26 @@ static errcode_t ext2fs_extent_block_csum(ext2_filsys fs, ext2_ino_t inum,
 					  __u32 *crc)
 {
 	int size;
-	__u32 ncrc;
-	errcode_t retval = 0;
+	__u32 ncrc, gen;
+	errcode_t retval;
+	struct ext2_inode inode;
 
 	size = EXT3_EXTENT_TAIL_OFFSET(eh) + offsetof(struct ext3_extent_tail,
 						      et_checksum);
 
+	retval = ext2fs_read_inode(fs, inum, &inode);
+	if (retval)
+		goto out;
 	inum = ext2fs_cpu_to_le32(inum);
+	gen = ext2fs_cpu_to_le32(inode.i_generation);
 	ncrc = ext2fs_crc32c_le(~0, fs->super->s_uuid,
 			       sizeof(fs->super->s_uuid));
 	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&inum, sizeof(inum));
+	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&gen, sizeof(gen));
 	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)eh, size);
 	*crc = ncrc;
 
+out:
 	return retval;
 }
 
@@ -566,7 +593,7 @@ static errcode_t ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
 			       struct ext2_inode_large *inode,
 			       __u32 *crc)
 {
-	__u32 ncrc;
+	__u32 ncrc, gen;
 	struct ext2_inode_large *desc = inode;
 	size_t size = fs->super->s_inode_size;
 	__u16 old_lo;
@@ -594,9 +621,11 @@ static errcode_t ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
 #endif
 
 	inum = ext2fs_cpu_to_le32(inum);
+	gen = ext2fs_cpu_to_le32(inode->i_generation);
 	ncrc = ext2fs_crc32c_le(~0, fs->super->s_uuid,
 				sizeof(fs->super->s_uuid));
 	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&inum, sizeof(inum));
+	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&gen, sizeof(gen));
 	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)desc, size);
 	*crc = ncrc;
 
diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index 0d1b7b8..e4c7d05 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -95,10 +95,10 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	/*
 	 * Write out the inode and inode data block
 	 */
-	retval = ext2fs_write_dir_block4(fs, blk, block, 0, ino);
+	retval = ext2fs_write_new_inode(fs, ino, &inode);
 	if (retval)
 		goto cleanup;
-	retval = ext2fs_write_new_inode(fs, ino, &inode);
+	retval = ext2fs_write_dir_block4(fs, blk, block, 0, ino);
 	if (retval)
 		goto cleanup;
 

