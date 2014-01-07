From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 07/10] libext2fs: fix memory leaks on error paths in ext2fs_create_icount_tdb
Date: Tue,  7 Jan 2014 09:53:11 -0500
Message-ID: <1389106394-31898-7-git-send-email-tytso@mit.edu>
References: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46597 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbaAGOxW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 09:53:22 -0500
In-Reply-To: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Addresses-Coverity-Id: #1138575

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/icount.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
index c5ebf74..80085e1 100644
--- a/lib/ext2fs/icount.c
+++ b/lib/ext2fs/icount.c
@@ -192,10 +192,12 @@ errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
 		goto errout;
 	uuid_unparse(fs->super->s_uuid, uuid);
 	sprintf(fn, "%s/%s-icount-XXXXXX", tdb_dir, uuid);
+	icount->tdb_fn = fn;
 	fd = mkstemp(fn);
-	if (fd < 0)
-		return fd;
-
+	if (fd < 0) {
+		retval = errno;
+		goto errout;
+	}
 	/*
 	 * This is an overestimate of the size that we will need; the
 	 * ideal value is the number of used inodes with a count
@@ -206,18 +208,15 @@ errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
 	 */
 	num_inodes = fs->super->s_inodes_count - fs->super->s_free_inodes_count;
 
-	icount->tdb_fn = fn;
 	icount->tdb = tdb_open(fn, num_inodes, TDB_NOLOCK | TDB_NOSYNC,
 			       O_RDWR | O_CREAT | O_TRUNC, 0600);
-	if (icount->tdb) {
-		close(fd);
-		*ret = icount;
-		return 0;
-	}
-
-	retval = errno;
 	close(fd);
