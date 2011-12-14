From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 22/51] libext2fs: Add dx_root/dx_node checksum calculation and
	verification helpers
Date: Tue, 13 Dec 2011 17:15:45 -0800
Message-ID: <20111214011545.20947.2313.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55565 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346Ab1LNBPx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Dec 2011 20:15:53 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 13 Dec 2011 20:15:52 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBE1Fnp2344450
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 20:15:49 -0500
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBE1Fk5f021366
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 18:15:48 -0700
In-Reply-To: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Verify and calculate checksums of htree internal node blocks.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/csum.c         |  145 +++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_err.et.in |    3 +
 lib/ext2fs/ext2fs.h       |    4 +
 3 files changed, 152 insertions(+), 0 deletions(-)


diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 28d7ef1..31dc4dc 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -30,6 +30,151 @@
 #define STATIC static
 #endif
 
+static __u16 do_nothing16(__u16 x)
+{
+	return x;
+}
+
+static __u16 disk_to_host16(__u16 x)
+{
+	return ext2fs_le16_to_cpu(x);
+}
+
+static errcode_t __get_dx_countlimit(ext2_filsys fs,
+				     struct ext2_dir_entry *dirent,
+				     struct ext2_dx_countlimit **cc,
+				     int *offset,
+				     int need_swab)
+{
+	struct ext2_dir_entry *dp;
+	struct ext2_dx_root_info *root;
+	struct ext2_dx_countlimit *c;
+	int count_offset, max_sane_entries;
+	unsigned int rec_len;
+	__u16 (*translate)(__u16) = (need_swab ? disk_to_host16 : do_nothing16);
+
+	rec_len = translate(dirent->rec_len);
+
+	if (rec_len == fs->blocksize && translate(dirent->name_len) == 0)
+		count_offset = 8;
+	else if (rec_len == 12) {
+		dp = (struct ext2_dir_entry *)(((void *)dirent) + rec_len);
+		rec_len = translate(dp->rec_len);
+		if (rec_len != fs->blocksize - 12)
+			return EXT2_ET_DB_NOT_FOUND;
+		root = (struct ext2_dx_root_info *)(((void *)dp + 12));
+		if (root->reserved_zero ||
+		    root->info_length != sizeof(struct ext2_dx_root_info))
+			return EXT2_ET_DB_NOT_FOUND;
+		count_offset = 32;
+	} else
+		return EXT2_ET_DB_NOT_FOUND;
+
+	c = (struct ext2_dx_countlimit *)(((void *)dirent) + count_offset);
+	max_sane_entries = (fs->blocksize - count_offset) /
+			   sizeof(struct ext2_dx_entry);
+	if (ext2fs_le16_to_cpu(c->limit) > max_sane_entries ||
+	    ext2fs_le16_to_cpu(c->count) > max_sane_entries)
+		return EXT2_ET_DIR_NO_SPACE_FOR_CSUM;
+
+	if (offset)
+		*offset = count_offset;
+	if (cc)
+		*cc = c;
+
+	return 0;
+}
+
+errcode_t ext2fs_get_dx_countlimit(ext2_filsys fs,
+				   struct ext2_dir_entry *dirent,
+				   struct ext2_dx_countlimit **cc,
+				   int *offset)
+{
+	return __get_dx_countlimit(fs, dirent, cc, offset, 0);
+}
+
+static errcode_t ext2fs_dx_csum(ext2_filsys fs, ext2_ino_t inum,
+				struct ext2_dir_entry *dirent,
+				__u32 *crc, int count_offset, int count,
+				struct ext2_dx_tail *t)
+{
+	errcode_t retval = 0;
+	char *buf = (char *)dirent;
+	int size;
+	__u32 ncrc, old_csum;
+
+	size = count_offset + (count * sizeof(struct ext2_dx_entry));
+	old_csum = t->checksum;
+	t->checksum = 0;
+
+	inum = ext2fs_cpu_to_le32(inum);
+	ncrc = ext2fs_crc32c_le(~0, fs->super->s_uuid,
+				sizeof(fs->super->s_uuid));
+	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&inum, sizeof(inum));
+	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)buf, size);
+	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)t,
+				sizeof(struct ext2_dx_tail));
+	t->checksum = old_csum;
+
+	*crc = ncrc;
+
+	return retval;
+}
+
+static int ext2fs_dx_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+				 struct ext2_dir_entry *dirent)
+{
+	__u32 calculated;
+	errcode_t retval;
+	struct ext2_dx_countlimit *c;
+	struct ext2_dx_tail *t;
+	int count_offset, limit, count;
+
+	retval = __get_dx_countlimit(fs, dirent, &c, &count_offset, 1);
+	if (retval)
+		return 1;
+	limit = ext2fs_le16_to_cpu(c->limit);
+	count = ext2fs_le16_to_cpu(c->count);
+	if (count_offset + (limit * sizeof(struct ext2_dx_entry)) >
+	    fs->blocksize - sizeof(struct ext2_dx_tail))
+		return 0;
+	/* htree structs are accessed in LE order */
+	t = (struct ext2_dx_tail *)(((struct ext2_dx_entry *)c) + limit);
+	retval = ext2fs_dx_csum(fs, inum, dirent, &calculated, count_offset,
+				count, t);
+	if (retval)
+		return 0;
+
+	return ext2fs_le32_to_cpu(t->checksum) == calculated;
+}
+
+static errcode_t ext2fs_dx_csum_set(ext2_filsys fs, ext2_ino_t inum,
+				    struct ext2_dir_entry *dirent)
+{
+	__u32 crc;
+	errcode_t retval = 0;
+	struct ext2_dx_countlimit *c;
+	struct ext2_dx_tail *t;
+	int count_offset, limit, count;
+
+	retval = __get_dx_countlimit(fs, dirent, &c, &count_offset, 1);
+	if (retval)
+		return retval;
+	limit = ext2fs_le16_to_cpu(c->limit);
+	count = ext2fs_le16_to_cpu(c->count);
+	if (count_offset + (limit * sizeof(struct ext2_dx_entry)) >
+	    fs->blocksize - sizeof(struct ext2_dx_tail))
+		return EXT2_ET_DIR_NO_SPACE_FOR_CSUM;
+	t = (struct ext2_dx_tail *)(((struct ext2_dx_entry *)c) + limit);
+
+	/* htree structs are accessed in LE order */
+	retval = ext2fs_dx_csum(fs, inum, dirent, &crc, count_offset, count, t);
+	if (retval)
+		return retval;
+	t->checksum = ext2fs_cpu_to_le32(crc);
+	return retval;
+}
+
 #define EXT3_EXTENT_TAIL_OFFSET(hdr)	(sizeof(struct ext3_extent_header) + \
 	(sizeof(struct ext3_extent) * ext2fs_le16_to_cpu((hdr)->eh_max)))
 
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 9019026..1e51384 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -452,4 +452,7 @@ ec	EXT2_ET_INODE_BITMAP_CSUM_INVALID,
 ec	EXT2_ET_EXTENT_CSUM_INVALID,
 	"Extent block checksum does not match extent block"
 
+ec	EXT2_ET_DIR_NO_SPACE_FOR_CSUM,
+	"Directory block does not have space for checksum"
+
 	end
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 1394d02..da598d0 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -940,6 +940,10 @@ extern __u32 ext2fs_crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 ext2fs_crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern errcode_t ext2fs_get_dx_countlimit(ext2_filsys fs,
+					  struct ext2_dir_entry *dirent,
+					  struct ext2_dx_countlimit **cc,
+					  int *offset);
 extern errcode_t ext2fs_extent_block_csum_set(ext2_filsys fs,
 					      ext2_ino_t inum,
 					      struct ext3_extent_header *eh);

