From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 24/49] e2fsck: insert a missing dirent tail for checksums if
 possible
Date: Mon, 10 Mar 2014 23:56:31 -0700
Message-ID: <20140311065631.30585.50975.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32727 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbaCKG4f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:56:35 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If e2fsck is writing a block of directory entries to disk, it should
adjust the dirents to add the dirent tail if one is missing.  It's not
a big deal if there's no space to do this since rehash (pass 3A) will
reconstruct directories for us.  However, we may as well avoid
unnecessary work.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass2.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 5488c73..99b4042 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -739,6 +739,41 @@ static int is_last_entry(ext2_filsys fs, int inline_data_size,
 		return (offset < fs->blocksize - csum_size);
 }
 
+static errcode_t insert_dirent_tail(ext2_filsys fs, void *dirbuf)
+{
+	struct ext2_dir_entry *d;
+	void *top;
+	struct ext2_dir_entry_tail *t;
+	unsigned int rec_len;
+
+	d = dirbuf;
+	top = EXT2_DIRENT_TAIL(dirbuf, fs->blocksize);
+
+	rec_len = d->rec_len;
+	while (rec_len && !(rec_len & 0x3)) {
+		d = (struct ext2_dir_entry *)(((char *)d) + rec_len);
+		if (((void *)d) + d->rec_len >= top)
+			break;
+		rec_len = d->rec_len;
+	}
+
+	if (d != top) {
+		size_t min_size = EXT2_DIR_REC_LEN(
+				ext2fs_dirent_name_len(dirbuf));
+		if (min_size > d->rec_len - sizeof(struct ext2_dir_entry_tail))
+			return EXT2_ET_DIR_NO_SPACE_FOR_CSUM;
+		d->rec_len -= sizeof(struct ext2_dir_entry_tail);
+	}
+
+	t = (struct ext2_dir_entry_tail *)top;
+	if (t->det_reserved_zero1 ||
+	    t->det_rec_len != sizeof(struct ext2_dir_entry_tail) ||
+	    t->det_reserved_name_len != EXT2_DIR_NAME_LEN_CSUM)
+		ext2fs_initialize_dirent_tail(fs, t);
+
+	return 0;
+}
+
 static int check_dir_block(ext2_filsys fs,
 			   struct ext2_db_entry2 *db,
 			   void *priv_data)
@@ -1275,7 +1310,11 @@ skip_checksum:
 		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
 		    is_leaf &&
+		    !inline_data_size &&
 		    !ext2fs_dirent_has_tail(fs, (struct ext2_dir_entry *)buf))
+		{
+			if (insert_dirent_tail(fs, buf) == 0)
+				goto write_and_fix;
 			e2fsck_rehash_dir_later(ctx, ino);
 
 write_and_fix:

