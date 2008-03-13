From: Theodore Ts'o <tytso@mit.edu>
Subject: [E2FSPROGS PATCH 2/4] libext2fs: Add ext2fs_dblist_get_last() and ext2fs_dblist_drop_last()
Date: Thu, 13 Mar 2008 01:12:25 -0400
Message-ID: <1205385147-12855-2-git-send-email-tytso@mit.edu>
References: <1205385147-12855-1-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: bas@dev.tetra.nl
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:38332 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751335AbYCMFMi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 01:12:38 -0400
In-Reply-To: <1205385147-12855-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add two new functions which allows the caller to examine the last
directory block entry added to the list, and to drop if it necessary.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/dblist.c       |   26 ++++++++++++++++++++++++++
 lib/ext2fs/ext2_err.et.in |    3 +++
 lib/ext2fs/ext2fs.h       |    3 +++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/dblist.c b/lib/ext2fs/dblist.c
index 21b36aa..3bf63a0 100644
--- a/lib/ext2fs/dblist.c
+++ b/lib/ext2fs/dblist.c
@@ -259,3 +259,29 @@ int ext2fs_dblist_count(ext2_dblist dblist)
 {
 	return (int) dblist->count;
 }
+
+errcode_t ext2fs_dblist_get_last(ext2_dblist dblist, 
+				 struct ext2_db_entry **entry)
+{
+	errcode_t		retval;
+
+	EXT2_CHECK_MAGIC(dblist, EXT2_ET_MAGIC_DBLIST);
+
+	if (dblist->count == 0)
+		return EXT2_ET_DBLIST_EMPTY;
+
+	if (entry)
+		*entry = dblist->list + ( (int) dblist->count-1);
+	return 0;
+}
+
+errcode_t ext2fs_dblist_drop_last(ext2_dblist dblist)
+{	
+	EXT2_CHECK_MAGIC(dblist, EXT2_ET_MAGIC_DBLIST);
+
+	if (dblist->count == 0)
+		return EXT2_ET_DBLIST_EMPTY;
+
+	dblist->count--;
+	return 0;
+}
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index eda4bb4..7451242 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -326,5 +326,8 @@ ec	EXT2_ET_TDB_ERR_NOEXIST,
 ec	EXT2_ET_TDB_ERR_RDONLY,
 	"TDB: Write not permitted"
 
+ec	EXT2_ET_DBLIST_EMPTY,
+	"Ext2fs directory block list is empty"
+
 	end
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 0b2c321..d098961 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -652,6 +652,9 @@ extern errcode_t ext2fs_set_dir_block(ext2_dblist dblist, ext2_ino_t ino,
 extern errcode_t ext2fs_copy_dblist(ext2_dblist src,
 				    ext2_dblist *dest);
 extern int ext2fs_dblist_count(ext2_dblist dblist);
+extern errcode_t ext2fs_dblist_get_last(ext2_dblist dblist, 
+					struct ext2_db_entry **entry);
+extern errcode_t ext2fs_dblist_drop_last(ext2_dblist dblist);
 
 /* dblist_dir.c */
 extern errcode_t
-- 
1.5.4.1.144.gdfee-dirty

