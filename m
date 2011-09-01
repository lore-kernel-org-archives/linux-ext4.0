From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 24/37] libext2fs: Add dx_root/dx_node checksum calculation and
	verification helpers
Date: Wed, 31 Aug 2011 17:37:44 -0700
Message-ID: <20110901003744.1176.39972.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59222 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756835Ab1IAAhu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 20:37:50 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p8107bwb000899
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:07:37 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810bn2Y209040
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:37:49 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p810bk8P009415
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 21:37:49 -0300
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Verify and calculate checksums of htree internal node blocks.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/csum.c    |  107 ++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/dirhash.c |   41 +++++++++++++++++++
 lib/ext2fs/ext2fs.h  |    8 ++++
 3 files changed, 156 insertions(+), 0 deletions(-)


diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index fdca971..4963524 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -29,6 +29,113 @@
 #define STATIC static
 #endif
 
+__u32 ext2fs_dx_csum(ext2_filsys fs, ext2_ino_t inum,
+		     struct ext2_dir_entry *dirent)
+{
+	char *buf = (char *)dirent;
+	struct ext2_dx_countlimit *c;
+	int size, count_offset, limit, count;
+	__u32 crc = 0;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	c = ext2fs_get_dx_countlimit(fs, dirent, &count_offset);
+	if (!c)
+		return 0;
+	limit = ext2fs_le16_to_cpu(c->limit);
+	count = ext2fs_le16_to_cpu(c->count);
+	if (count_offset + (limit * sizeof(struct ext2_dx_entry)) >
+	    fs->blocksize - sizeof(struct ext2_dx_tail))
+		return 0;
+
+	size = count_offset + (count * sizeof(struct ext2_dx_entry));
+
+	/*
+	 * The dx_root/dx_entry structures are always accessed via
+	 * le*_to_cpu helpers and don't need swapping here.  However, the
+	 * dirent container fields need to be swapped.
+	 */
+#ifdef WORDS_BIGENDIAN
+	errcode_t retval;
+
+	retval = ext2fs_get_mem(fs->blocksize, &buf);
+	if (retval)
+		return 0;
+	memcpy(buf, dirent, fs->blocksize);
+	retval = ext2fs_dirent_swab_out(fs, buf, 0);
+	if (retval) {
+		crc = 0;
+		goto out;
+	}
+#endif
+
+	inum = ext2fs_cpu_to_le32(inum);
+	crc = crc32c_le(~0, fs->super->s_uuid, sizeof(fs->super->s_uuid));
+	crc = crc32c_le(crc, (char *)&inum, sizeof(inum));
+	crc = crc32c_le(crc, buf, size);
+
+#ifdef WORDS_BIGENDIAN
+out:
+	ext2fs_free_mem(&buf);
+#endif
+
+	return crc;
+}
+
+int ext2fs_dx_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+			  struct ext2_dir_entry *dirent)
+{
+	struct ext2_dx_countlimit *c;
+	struct ext2_dx_tail *t;
+	int count_offset, limit, count;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	c = ext2fs_get_dx_countlimit(fs, dirent, &count_offset);
+	if (!c)
+		return 1;
+	limit = ext2fs_le16_to_cpu(c->limit);
+	count = ext2fs_le16_to_cpu(c->count);
+	if (count_offset + (limit * sizeof(struct ext2_dx_entry)) >
+	    fs->blocksize - sizeof(struct ext2_dx_tail))
+		return 0;
+	/* htree structs are accessed in LE order */
+	t = (struct ext2_dx_tail *)(((struct ext2_dx_entry *)c) + limit);
+	if (ext2fs_le32_to_cpu(t->checksum) != ext2fs_dx_csum(fs, inum, dirent))
+		return 0;
+
+	return 1;
+}
+
+void ext2fs_dx_csum_set(ext2_filsys fs, ext2_ino_t inum,
+			struct ext2_dir_entry *dirent)
+{
+	struct ext2_dx_countlimit *c;
+	struct ext2_dx_tail *t;
+	int count_offset, limit, count;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	c = ext2fs_get_dx_countlimit(fs, dirent, &count_offset);
+	if (!c)
+		return;
+	limit = ext2fs_le16_to_cpu(c->limit);
+	count = ext2fs_le16_to_cpu(c->count);
+	if (count_offset + (limit * sizeof(struct ext2_dx_entry)) >
+	    fs->blocksize - sizeof(struct ext2_dx_tail))
+		return;
+	t = (struct ext2_dx_tail *)(((struct ext2_dx_entry *)c) + limit);
+
+	/* htree structs are accessed in LE order */
+	t->checksum = ext2fs_cpu_to_le32(ext2fs_dx_csum(fs, inum, dirent));
+}
+
 #define EXT3_EXTENT_TAIL_OFFSET(hdr)	(sizeof(struct ext3_extent_header) + \
 	(sizeof(struct ext3_extent) * ext2fs_le16_to_cpu((hdr)->eh_max)))
 
diff --git a/lib/ext2fs/dirhash.c b/lib/ext2fs/dirhash.c
index a069706..76ac274 100644
--- a/lib/ext2fs/dirhash.c
+++ b/lib/ext2fs/dirhash.c
@@ -255,3 +255,44 @@ errcode_t ext2fs_dirhash(int version, const char *name, int len,
 		*ret_minor_hash = minor_hash;
 	return 0;
 }
+
+struct ext2_dx_countlimit *ext2fs_get_dx_countlimit(ext2_filsys fs,
+		struct ext2_dir_entry *dirent, int *offset)
+{
+	struct ext2_dir_entry *dp;
+	struct ext2_dx_root_info *root;
+	struct ext2_dx_countlimit *c;
+	int count_offset, max_sane_entries;
+	unsigned int rec_len;
+	errcode_t retval;
+
+	retval = ext2fs_get_rec_len(fs, dirent, &rec_len);
+	if (retval)
+		return NULL;
+
+	if (rec_len == fs->blocksize && dirent->name_len == 0)
+		count_offset = 8;
+	else if (rec_len == 12) {
+		dp = (struct ext2_dir_entry *)(((void *)dirent) + rec_len);
+		retval = ext2fs_get_rec_len(fs, dp, &rec_len);
+		if (retval || rec_len != fs->blocksize - 12)
+			return NULL;
+		root = (struct ext2_dx_root_info *)(((void *)dp + 12));
+		if (root->reserved_zero ||
+		    root->info_length != sizeof(struct ext2_dx_root_info))
+			return NULL;
+		count_offset = 32;
+	} else
+		return NULL;
+
+	c = (struct ext2_dx_countlimit *)(((void *)dirent) + count_offset);
+	max_sane_entries = (fs->blocksize - count_offset) /
+			   sizeof(struct ext2_dx_entry);
+	if (ext2fs_le16_to_cpu(c->limit) > max_sane_entries ||
+	    ext2fs_le16_to_cpu(c->count) > max_sane_entries)
+		return NULL;
+
+	if (offset)
+		*offset = count_offset;
+	return c;
+}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 1e3e9f1..7110f72 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -894,6 +894,12 @@ extern __u32 crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern __u32 ext2fs_dx_csum(ext2_filsys fs, ext2_ino_t inum,
+			    struct ext2_dir_entry *dirent);
+extern int ext2fs_dx_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+				 struct ext2_dir_entry *dirent);
+extern void ext2fs_dx_csum_set(ext2_filsys fs, ext2_ino_t inum,
+			       struct ext2_dir_entry *dirent);
 extern __u32 ext2fs_extent_block_csum(ext2_filsys fs, ext2_ino_t inum,
 				      struct ext3_extent_header *eh);
 extern int ext2fs_extent_block_csum_verify(ext2_filsys fs,
@@ -983,6 +989,8 @@ extern errcode_t ext2fs_write_dir_block3(ext2_filsys fs, blk64_t block,
 					 void *buf, int flags);
 
 /* dirhash.c */
+extern struct ext2_dx_countlimit *ext2fs_get_dx_countlimit(ext2_filsys fs,
+				struct ext2_dir_entry *dirent, int *offset);
 extern errcode_t ext2fs_dirhash(int version, const char *name, int len,
 				const __u32 *seed,
 				ext2_dirhash_t *ret_hash,

