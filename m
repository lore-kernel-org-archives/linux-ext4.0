From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 28/37] tune2fs: Rebuild and checksum directories when toggling
	metadata_csum or changing UUID
Date: Wed, 31 Aug 2011 17:38:11 -0700
Message-ID: <20110901003811.1176.6578.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e34.co.us.ibm.com ([32.97.110.152]:48886 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab1IAAiS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 20:38:18 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810cDjN021697
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:38:13 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810cDfh161114
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:38:13 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7VIcBgA027830
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 12:38:12 -0600
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since all the metadata checksums depend on the fs UUID, tune2fs must be able to
rewrite the checksums of _all_ metadata.  It's not that hard to add in the bits
to resize the directory block structures at the same time.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/tune2fs.c |  198 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 197 insertions(+), 1 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 0c0a911..ba5b9d2 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -97,6 +97,8 @@ struct blk_move {
 
 
 static const char *please_fsck = N_("Please run e2fsck on the filesystem.\n");
+static const char *please_dir_fsck =
+		N_("Please run e2fsck -D on the filesystem.\n");
 
 #ifdef CONFIG_BUILD_FINDFS
 void do_findfs(int argc, char **argv);
@@ -343,6 +345,18 @@ static int check_fsck_needed(ext2_filsys fs)
 	return 1;
 }
 
+static void request_dir_fsck_afterwards(ext2_filsys fs)
+{
+	static int requested;
+
+	if (requested++)
+		return;
+	fs->super->s_state &= ~EXT2_VALID_FS;
+	printf("\n%s\n", _(please_dir_fsck));
+	if (mount_flags & EXT2_MF_READONLY)
+		printf(_("(and reboot afterwards!)\n"));
+}
+
 static void request_fsck_afterwards(ext2_filsys fs)
 {
 	static int requested = 0;
@@ -399,6 +413,177 @@ static errcode_t rewrite_extents(ext2_filsys fs, ext2_ino_t ino,
 }
 
 /*
+ * Rewrite directory blocks with checksums
+ */
+struct rewrite_dir_context {
+	char *buf;
+	errcode_t errcode;
+	ext2_ino_t dir;
+	int is_htree;
+};
+
+static int rewrite_dir_block(ext2_filsys fs,
+			     blk64_t	*blocknr,
+			     e2_blkcnt_t blockcnt,
+			     blk64_t	ref_block EXT2FS_ATTR((unused)),
+			     int	ref_offset EXT2FS_ATTR((unused)),
+			     void	*priv_data)
+{
+	struct ext2_dx_countlimit *dcl = NULL;
+	struct rewrite_dir_context *ctx = priv_data;
+	int dcl_offset, changed = 0;
+
+	ctx->errcode = ext2fs_read_dir_block3(fs, *blocknr, ctx->buf, 0,
+					      ctx->dir);
+	if (ctx->errcode)
+		return BLOCK_ABORT;
+
+	/* if htree node... */
+	if (ctx->is_htree)
+		dcl = ext2fs_get_dx_countlimit(fs,
+				(struct ext2_dir_entry *)ctx->buf, &dcl_offset);
+	if (dcl) {
+		if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+			/* Ensure limit is the max size */
+			int max_entries = (fs->blocksize - dcl_offset) /
+					  sizeof(struct ext2_dx_entry);
+			if (ext2fs_le16_to_cpu(dcl->limit) != max_entries) {
+				changed = 1;
+				dcl->limit = ext2fs_cpu_to_le16(max_entries);
+			}
+		} else {
+			/* If htree block is full then rebuild the dir */
+			if (ext2fs_le16_to_cpu(dcl->count) ==
+			    ext2fs_le16_to_cpu(dcl->limit)) {
+				request_dir_fsck_afterwards(fs);
+				return 0;
+			}
+			/*
+			 * Ensure dcl->limit is small enough to leave room for
+			 * the checksum tail.
+			 */
+			int max_entries = (fs->blocksize - (dcl_offset +
+						sizeof(struct ext2_dx_tail))) /
+					  sizeof(struct ext2_dx_entry);
+			if (ext2fs_le16_to_cpu(dcl->limit) != max_entries)
+				dcl->limit = ext2fs_cpu_to_le16(max_entries);
+			/* Always rewrite checksum */
+			changed = 1;
+		}
+	} else {
+		int rec_len, name_size;
+		char *top = ctx->buf + fs->blocksize;
+		struct ext2_dir_entry *de = (struct ext2_dir_entry *)ctx->buf;
+		struct ext2_dir_entry *last_de = NULL, *penultimate_de = NULL;
+
+		/* Find last and penultimate dirent */
+		while ((char *)de < top) {
+			penultimate_de = last_de;
+			last_de = de;
+			ctx->errcode = ext2fs_get_rec_len(fs, de, &rec_len);
+			if (!ctx->errcode && !rec_len)
+				ctx->errcode = EXT2_ET_DIR_CORRUPTED;
+			if (ctx->errcode)
+				return BLOCK_ABORT;
+			de = (struct ext2_dir_entry *)(((void *)de) + rec_len);
+		}
+		ctx->errcode = ext2fs_get_rec_len(fs, last_de, &rec_len);
+		if (ctx->errcode)
+			return BLOCK_ABORT;
+		name_size = last_de->name_len & 0xFF;
+
+		if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+			if (!penultimate_de)
+				return 0;
+			if (last_de->inode ||
+			    name_size ||
+			    rec_len != sizeof(struct ext2_dir_entry_tail))
+				return 0;
+			/*
+			 * The last dirent is unused and the right length to
+			 * have stored a checksum.  Erase it.
+			 */
+			ctx->errcode = ext2fs_get_rec_len(fs, penultimate_de,
+							  &rec_len);
+			if (!rec_len)
+				ctx->errcode = EXT2_ET_DIR_CORRUPTED;
+			if (ctx->errcode)
+				return BLOCK_ABORT;
+			ext2fs_set_rec_len(fs, rec_len +
+					sizeof(struct ext2_dir_entry_tail),
+					penultimate_de);
+			changed = 1;
+		} else {
+			int csum_size = sizeof(struct ext2_dir_entry_tail);
+			struct ext2_dir_entry_tail *t;
+
+			/*
+			 * If the last dirent looks like the tail, just update
+			 * the checksum.
+			 */
+			if (!last_de->inode && !name_size &&
+			    rec_len == csum_size) {
+				changed = 1;
+				goto out;
+			}
+			if (name_size & 3)
+				name_size = (name_size & ~3) + 4;
+			/* If there's not enough space for the tail, e2fsck */
+			if (rec_len <= (8 + name_size + csum_size)) {
+				request_dir_fsck_afterwards(fs);
+				return 0;
+			}
+			/* Shorten that last de and insert the tail */
+			ext2fs_set_rec_len(fs, rec_len - csum_size, last_de);
+			t = (struct ext2_dir_entry_tail *)
+					(ctx->buf + fs->blocksize - csum_size);
+			bzero(t, csum_size);
+			ext2fs_set_rec_len(fs, csum_size,
+					   (struct ext2_dir_entry *)t);
+
+			/* Always update checksum */
+			changed = 1;
+		}
+	}
+
+out:
+	if (!changed)
+		return 0;
+
+	ctx->errcode = ext2fs_write_dir_block3(fs, *blocknr, ctx->buf,
+					       0, ctx->dir);
+	if (ctx->errcode)
+		return BLOCK_ABORT;
+
+	return 0;
+}
+
+errcode_t rewrite_directory(ext2_filsys fs, ext2_ino_t dir,
+			    struct ext2_inode_large *inode)
+{
+	errcode_t	retval;
+	struct rewrite_dir_context ctx;
+
+	retval = ext2fs_get_mem(fs->blocksize, &ctx.buf);
+	if (retval)
+		return retval;
+
+	ctx.is_htree = (inode->i_flags & EXT2_INDEX_FL);
+	ctx.dir = dir;
+	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_READ_ONLY |
+						BLOCK_FLAG_DATA_ONLY,
+				       0, rewrite_dir_block, &ctx);
+
+	ext2fs_free_mem(&ctx.buf);
+	if (retval)
+		return retval;
+
+	return ctx.errcode;
+}
+
+/*
  * Forcibly set checksums in all inodes.
  */
 static void rewrite_inodes(ext2_filsys fs)
@@ -437,6 +622,15 @@ static void rewrite_inodes(ext2_filsys fs)
 				"while rewriting extents");
 			exit(1);
 		}
+
+		if (LINUX_S_ISDIR(inode->i_mode)) {
+			retval = rewrite_directory(fs, ino, inode);
+			if (retval) {
+				com_err("rewrite_directory", retval,
+					"while rewriting directories");
+				exit(1);
+			}
+		}
 	} while (ino);
 	ext2fs_close_inode_scan(scan);
 }
@@ -1948,7 +2142,9 @@ retry_open:
 			fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 		}
 		ext2fs_mark_super_dirty(fs);
-		rewrite_checksums = 1;
+		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+			rewrite_checksums = 1;
 	}
 	if (rewrite_checksums)
 		rewrite_metadata_checksums(fs);

