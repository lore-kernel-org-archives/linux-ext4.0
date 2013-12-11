From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 59/74] debugfs: dump all extended attributes
Date: Tue, 10 Dec 2013 17:24:52 -0800
Message-ID: <20131211012452.30655.26956.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43774 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3LKBY6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:24:58 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use the new extended attribute APIs to display all extended attributes
(current code does not look in the EA block) and display full names
(current code ignores name index too).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debugfs.c           |   68 +++++++++++++++++++++++++------------------
 tests/r_inline_xattr/expect |    6 +---
 2 files changed, 42 insertions(+), 32 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 578d577..e37d3f5 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -543,34 +543,45 @@ static void internal_dump_inode_extra(FILE *out,
 				inode->i_extra_isize);
 		return;
 	}
-	storage_size = EXT2_INODE_SIZE(current_fs->super) -
-			EXT2_GOOD_OLD_INODE_SIZE -
-			inode->i_extra_isize;
-	magic = (__u32 *)((char *)inode + EXT2_GOOD_OLD_INODE_SIZE +
-			inode->i_extra_isize);
-	if (*magic == EXT2_EXT_ATTR_MAGIC) {
-		fprintf(out, "Extended attributes stored in inode body: \n");
-		end = (char *) inode + EXT2_INODE_SIZE(current_fs->super);
-		start = (char *) magic + sizeof(__u32);
-		entry = (struct ext2_ext_attr_entry *) start;
-		while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
-			struct ext2_ext_attr_entry *next =
-				EXT2_EXT_ATTR_NEXT(entry);
-			if (entry->e_value_size > storage_size ||
-					(char *) next >= end) {
-				fprintf(out, "invalid EA entry in inode\n");
-				return;
-			}
-			fprintf(out, "  ");
-			dump_xattr_string(out, EXT2_EXT_ATTR_NAME(entry),
-					  entry->e_name_len);
-			fprintf(out, " = \"");
-			dump_xattr_string(out, start + entry->e_value_offs,
-						entry->e_value_size);
-			fprintf(out, "\" (%u)\n", entry->e_value_size);
-			entry = next;
-		}
-	}
+}
+
+/* Dump extended attributes */
+static int dump_attr(char *name, char *value, size_t value_len, void *data)
+{
+	FILE *out = data;
+
+	fprintf(out, "  ");
+	dump_xattr_string(out, name, strlen(name));
+	fprintf(out, " = \"");
+	dump_xattr_string(out, value, value_len);
+	fprintf(out, "\" (%zu)\n", value_len);
+
+	return 0;
+}
+
+static void dump_inode_attributes(FILE *out, ext2_ino_t ino)
+{
+	struct ext2_xattr_handle *h;
+	errcode_t err;
+
+	err = ext2fs_xattrs_open(current_fs, ino, &h);
+	if (err)
+		return;
+
+	err = ext2fs_xattrs_read(h);
+	if (err)
+		goto out;
+
+	if (ext2fs_xattrs_count(h) == 0)
+		goto out;
+
+	fprintf(out, "Extended attributes:\n");
+	err = ext2fs_xattrs_iterate(h, dump_attr, out);
+	if (err)
+		goto out;
+
+out:
+	err = ext2fs_xattrs_close(&h);
 }
 
 static void dump_blocks(FILE *f, const char *prefix, ext2_ino_t inode)
@@ -818,6 +829,7 @@ void internal_dump_inode(FILE *out, const char *prefix,
 	if (EXT2_INODE_SIZE(current_fs->super) > EXT2_GOOD_OLD_INODE_SIZE)
 		internal_dump_inode_extra(out, prefix, inode_num,
 					  (struct ext2_inode_large *) inode);
+	dump_inode_attributes(out, inode_num);
 	if (current_fs->super->s_creator_os == EXT2_OS_LINUX &&
 	    current_fs->super->s_feature_ro_compat &
 		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
diff --git a/tests/r_inline_xattr/expect b/tests/r_inline_xattr/expect
index 9e71264..c7aa088 100644
--- a/tests/r_inline_xattr/expect
+++ b/tests/r_inline_xattr/expect
@@ -1,8 +1,7 @@
 resize2fs test
 debugfs -R ''stat file'' test.img 2>&1 | grep ''^Inode\|in inode body\|name = ''
 Inode: 1550   Type: regular    Mode:  0644   Flags: 0x0
-Extended attributes stored in inode body: 
-  name = "propervalue" (11)
+  user.name = "propervalue" (11)
 Exit status is 0
 resize2fs test.img 5M
 Resizing the filesystem on test.img to 5120 (1k) blocks.
@@ -11,6 +10,5 @@ The filesystem on test.img is now 5120 blocks long.
 Exit status is 0
 debugfs -R ''stat file'' test.img 2>&1 | grep ''^Inode\|in inode body\|name = ''
 Inode: 12   Type: regular    Mode:  0644   Flags: 0x0
-Extended attributes stored in inode body: 
-  name = "propervalue" (11)
+  user.name = "propervalue" (11)
 Exit status is 0

