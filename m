From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] debugfs: add better error checking when printing extended attributes
Date: Fri, 29 Aug 2014 15:54:06 -0400
Message-ID: <1409342046-11307-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56355 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310AbaH2TyK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Aug 2014 15:54:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check to make sure the length of the name and value fields in the
extended attribute don't result in overrun the bounds of the inode.

Addresses-Coverity-Bug: #709517

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 debugfs/debugfs.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 00c2d38..5423634 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -535,7 +535,6 @@ static void internal_dump_inode_extra(FILE *out,
 	struct ext2_ext_attr_entry *entry;
 	__u32 *magic;
 	char *start, *end;
-	unsigned int storage_size;
 
 	fprintf(out, "Size of extra inode fields: %u\n", inode->i_extra_isize);
 	if (inode->i_extra_isize > EXT2_INODE_SIZE(current_fs->super) -
@@ -544,9 +543,6 @@ static void internal_dump_inode_extra(FILE *out,
 				inode->i_extra_isize);
 		return;
 	}
-	storage_size = EXT2_INODE_SIZE(current_fs->super) -
-			EXT2_GOOD_OLD_INODE_SIZE -
-			inode->i_extra_isize;
 	magic = (__u32 *)((char *)inode + EXT2_GOOD_OLD_INODE_SIZE +
 			inode->i_extra_isize);
 	if (*magic == EXT2_EXT_ATTR_MAGIC) {
@@ -557,17 +553,19 @@ static void internal_dump_inode_extra(FILE *out,
 		while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
 			struct ext2_ext_attr_entry *next =
 				EXT2_EXT_ATTR_NEXT(entry);
-			if (entry->e_value_size > storage_size ||
-					(char *) next >= end) {
+			char *name = EXT2_EXT_ATTR_NAME(entry);
+			char *value = start + entry->e_value_offs;
+
+			if (name + entry->e_name_len >= end ||
+			    value + entry->e_value_size >= end ||
+			    (char *) next >= end) {
 				fprintf(out, "invalid EA entry in inode\n");
 				return;
 			}
 			fprintf(out, "  ");
-			dump_xattr_string(out, EXT2_EXT_ATTR_NAME(entry),
-					  entry->e_name_len);
+			dump_xattr_string(out, name, entry->e_name_len);
 			fprintf(out, " = \"");
-			dump_xattr_string(out, start + entry->e_value_offs,
-						entry->e_value_size);
+			dump_xattr_string(out, value, entry->e_value_size);
 			fprintf(out, "\" (%u)\n", entry->e_value_size);
 			entry = next;
 		}
-- 
2.1.0

