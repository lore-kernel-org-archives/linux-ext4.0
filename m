From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/2] misc: fix resource leaks in e2fsprogs
Date: Wed, 18 Dec 2013 17:15:22 -0800
Message-ID: <20131219011522.16794.68027.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21711 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3LSBP2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Dec 2013 20:15:28 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix leaked resources and an unnecessary error check created by earlier
cleanup patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debugfs.c   |    2 --
 e2fsck/profile.c    |    4 +++-
 lib/ext2fs/icount.c |    5 ++++-
 lib/ss/invocation.c |    1 +
 4 files changed, 8 insertions(+), 4 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index f9eb578..e09d8c0 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -288,8 +288,6 @@ void do_init_filesys(int argc, char **argv)
 	if (err)
 		return;
 	ext2fs_blocks_count_set(&param, blocks);
-	if (err)
-		return;
 	retval = ext2fs_initialize(argv[1], 0, &param,
 				   unix_io_manager, &current_fs);
 	if (retval) {
diff --git a/e2fsck/profile.c b/e2fsck/profile.c
index 92aa893..50a9ad9 100644
--- a/e2fsck/profile.c
+++ b/e2fsck/profile.c
@@ -318,8 +318,10 @@ profile_init(const char **files, profile_t *ret_profile)
         /* if the filenames list is not specified return an empty profile */
         if ( files ) {
 	    for (fs = files; !PROFILE_LAST_FILESPEC(*fs); fs++) {
-		if (array)
+		if (array) {
 			free_list(array);
+			array = NULL;
+		}
 		retval = get_dirlist(*fs, &array);
 		if (retval == 0) {
 			if (!array)
diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
index c5ebf74..e51be73 100644
--- a/lib/ext2fs/icount.c
+++ b/lib/ext2fs/icount.c
@@ -193,8 +193,11 @@ errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
 	uuid_unparse(fs->super->s_uuid, uuid);
 	sprintf(fn, "%s/%s-icount-XXXXXX", tdb_dir, uuid);
 	fd = mkstemp(fn);
-	if (fd < 0)
+	if (fd < 0) {
+		ext2fs_free_mem(&fn);
+		ext2fs_free_icount(icount);
 		return fd;
+	}
 
 	/*
 	 * This is an overestimate of the size that we will need; the
diff --git a/lib/ss/invocation.c b/lib/ss/invocation.c
index 08b66f2..8294a02 100644
--- a/lib/ss/invocation.c
+++ b/lib/ss/invocation.c
@@ -49,6 +49,7 @@ int ss_create_invocation(subsystem_name, version_string, info_ptr,
 				     ((unsigned)sci_idx+2)*size);
 	if (table == NULL) {
 		*code_ptr = errno;
+		free(new_table);
 		return 0;
 	}
 	table[sci_idx+1] = (ss_data *) NULL;

