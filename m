From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 32/51] libext2fs: Use i_generation in inode-related metadata
	checksums
Date: Tue, 13 Dec 2011 17:16:51 -0800
Message-ID: <20111214011650.20947.38376.stgit@elm3c44.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e34.co.us.ibm.com ([32.97.110.152]:33744 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab1LNBRI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Dec 2011 20:17:08 -0500
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 13 Dec 2011 18:17:07 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBE1GrI6058012
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 18:16:53 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBE1GpGT019444
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 18:16:52 -0700
In-Reply-To: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Whenever we are calculating a checksum for a piece of metadata that is
associated with an inode, incorporate i_generation into that calculation so
that old metadata blocks cannot be re-associated after a delete/create cycle.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/csum.c  |   45 +++++++++++++++++++++++++++++++++++++++------
 lib/ext2fs/mkdir.c |    8 +++++---
 2 files changed, 44 insertions(+), 9 deletions(-)


diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index a171f21..c064c0d 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -72,7 +72,8 @@ static errcode_t ext2fs_ext_attr_block_csum(ext2_filsys fs, ext2_ino_t inum,
 {
 	errcode_t retval = 0;
 	char *buf = (char *)hdr;
-	__u32 ncrc, old_crc = hdr->h_checksum;
+	__u32 gen, ncrc, old_crc = hdr->h_checksum;
+	struct ext2_inode inode;
 
 	hdr->h_checksum = 0;
 	ncrc = ext2fs_crc32c_le(~0, fs->super->s_uuid,
@@ -82,14 +83,21 @@ static errcode_t ext2fs_ext_attr_block_csum(ext2_filsys fs, ext2_ino_t inum,
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
 	return retval;
 }
 
@@ -249,15 +257,23 @@ static errcode_t ext2fs_dirent_csum(ext2_filsys fs, ext2_ino_t inum,
 {
 	errcode_t retval = 0;
 	char *buf = (char *)dirent;
-	__u32 ncrc;
+	__u32 ncrc, gen;
+	struct ext2_inode inode;
+
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
 
+out:
 	return retval;
 }
 
@@ -311,16 +327,23 @@ static errcode_t ext2fs_dx_csum(ext2_filsys fs, ext2_ino_t inum,
 	errcode_t retval = 0;
 	char *buf = (char *)dirent;
 	int size;
-	__u32 ncrc, old_csum;
+	__u32 ncrc, old_csum, gen;
+	struct ext2_inode inode;
 
 	size = count_offset + (count * sizeof(struct ext2_dx_entry));
 	old_csum = t->checksum;
 	t->checksum = 0;
 
+	retval = ext2fs_read_inode(fs, inum, &inode);
+	if (retval)
+		goto out;
+
 	inum = ext2fs_cpu_to_le32(inum);
+	gen = ext2fs_cpu_to_le32(inode.i_generation);
 	ncrc = ext2fs_crc32c_le(~0, fs->super->s_uuid,
 				sizeof(fs->super->s_uuid));
 	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&inum, sizeof(inum));
+	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&gen, sizeof(gen));
 	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)buf, size);
 	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)t,
 				sizeof(struct ext2_dx_tail));
@@ -328,6 +351,7 @@ static errcode_t ext2fs_dx_csum(ext2_filsys fs, ext2_ino_t inum,
 
 	*crc = ncrc;
 
+out:
 	return retval;
 }
 
@@ -431,19 +455,26 @@ static errcode_t ext2fs_extent_block_csum(ext2_filsys fs, ext2_ino_t inum,
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
 
@@ -584,7 +615,7 @@ static errcode_t ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
 			       struct ext2_inode_large *inode,
 			       __u32 *crc, int has_hi)
 {
-	__u32 ncrc;
+	__u32 ncrc, gen;
 	struct ext2_inode_large *desc = inode;
 	size_t size = fs->super->s_inode_size;
 	__u16 old_lo;
@@ -599,9 +630,11 @@ static errcode_t ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
 	}
 
 	inum = ext2fs_cpu_to_le32(inum);
+	gen = inode->i_generation;
 	ncrc = ext2fs_crc32c_le(~0, fs->super->s_uuid,
 				sizeof(fs->super->s_uuid));
 	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&inum, sizeof(inum));
+	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&gen, sizeof(gen));
 	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)desc, size);
 	*crc = ncrc;
 
diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index 0d1b7b8..cb1e5a7 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -93,12 +93,14 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	inode.i_size = fs->blocksize;
 
 	/*
-	 * Write out the inode and inode data block
+	 * Write out the inode and inode data block.  The inode generation
+	 * number is assigned by write_new_inode, which means that the
+	 * call to write_dir_block must come after it.
 	 */
-	retval = ext2fs_write_dir_block4(fs, blk, block, 0, ino);
+	retval = ext2fs_write_new_inode(fs, ino, &inode);
 	if (retval)
 		goto cleanup;
-	retval = ext2fs_write_new_inode(fs, ino, &inode);
+	retval = ext2fs_write_dir_block4(fs, blk, block, 0, ino);
 	if (retval)
 		goto cleanup;
 

