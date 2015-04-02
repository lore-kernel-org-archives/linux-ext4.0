From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 13/35] e2undo: fix memory leaks and tweak the error messages
 somewhat
Date: Wed, 01 Apr 2015 19:35:26 -0700
Message-ID: <20150402023526.25243.88182.stgit@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48413 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbbDBCf3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2015 22:35:29 -0400
In-Reply-To: <20150402023359.25243.79782.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix memory leaks and improve the error messages to make it easier
to figure out why e2undo went wrong.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/e2undo.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)


diff --git a/misc/e2undo.c b/misc/e2undo.c
index a43c26f..d828d3b 100644
--- a/misc/e2undo.c
+++ b/misc/e2undo.c
@@ -49,7 +49,7 @@ static int check_filesystem(TDB_CONTEXT *tdb, io_channel channel)
 	retval = io_channel_read_blk64(channel, 1, -SUPERBLOCK_SIZE, &super);
 	if (retval) {
 		com_err(prg_name, retval,
-			"%s", _("Failed to read the file system data \n"));
+			"%s", _("while reading filesystem superblock."));
 		return retval;
 	}
 
@@ -58,16 +58,16 @@ static int check_filesystem(TDB_CONTEXT *tdb, io_channel channel)
 	tdb_data = tdb_fetch(tdb, tdb_key);
 	if (!tdb_data.dptr) {
 		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
-		com_err(prg_name, retval,
-			_("Failed tdb_fetch %s\n"), tdb_errorstr(tdb));
+		com_err(prg_name, retval, "%s",
+			_("while fetching last mount time."));
 		return retval;
 	}
 
 	s_mtime = *(__u32 *)tdb_data.dptr;
+	free(tdb_data.dptr);
 	if (super.s_mtime != s_mtime) {
-
 		com_err(prg_name, 0,
-			_("The file system Mount time didn't match %u\n"),
+			_("The filesystem last mount time didn't match %u."),
 			s_mtime);
 
 		return  -1;
@@ -79,14 +79,14 @@ static int check_filesystem(TDB_CONTEXT *tdb, io_channel channel)
 	tdb_data = tdb_fetch(tdb, tdb_key);
 	if (!tdb_data.dptr) {
 		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
-		com_err(prg_name, retval,
-			_("Failed tdb_fetch %s\n"), tdb_errorstr(tdb));
+		com_err(prg_name, retval, "%s", _("while fetching UUID"));
 		return retval;
 	}
 	memcpy(s_uuid, tdb_data.dptr, sizeof(s_uuid));
+	free(tdb_data.dptr);
 	if (memcmp(s_uuid, super.s_uuid, sizeof(s_uuid))) {
 		com_err(prg_name, 0, "%s",
-			_("The file system UUID didn't match \n"));
+			_("The filesystem UUID didn't match."));
 		return -1;
 	}
 
@@ -104,12 +104,12 @@ static int set_blk_size(TDB_CONTEXT *tdb, io_channel channel)
 	tdb_data = tdb_fetch(tdb, tdb_key);
 	if (!tdb_data.dptr) {
 		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
-		com_err(prg_name, retval,
-			_("Failed tdb_fetch %s\n"), tdb_errorstr(tdb));
+		com_err(prg_name, retval, "%s", _("while fetching block size"));
 		return retval;
 	}
 
 	block_size = *(int *)tdb_data.dptr;
+	free(tdb_data.dptr);
 #ifdef DEBUG
 	printf("Block size %d\n", block_size);
 #endif
@@ -129,6 +129,7 @@ int main(int argc, char *argv[])
 	blk64_t  blk_num;
 	char *device_name, *tdb_file;
 	io_manager manager = unix_io_manager;
+	void *old_dptr = NULL;
 
 #ifdef ENABLE_NLS
 	setlocale(LC_MESSAGES, "");
@@ -160,20 +161,20 @@ int main(int argc, char *argv[])
 
 	if (!tdb) {
 		com_err(prg_name, errno,
-				_("Failed tdb_open %s\n"), tdb_file);
+				_("while opening undo file `%s'\n"), tdb_file);
 		exit(1);
 	}
 
 	retval = ext2fs_check_if_mounted(device_name, &mount_flags);
 	if (retval) {
 		com_err(prg_name, retval, _("Error while determining whether "
-				"%s is mounted.\n"), device_name);
+				"%s is mounted."), device_name);
 		exit(1);
 	}
 
 	if (mount_flags & EXT2_MF_MOUNTED) {
 		com_err(prg_name, retval, "%s", _("e2undo should only be run "
-						"on unmounted file system\n"));
+						"on unmounted filesystems"));
 		exit(1);
 	}
 
@@ -181,7 +182,7 @@ int main(int argc, char *argv[])
 				IO_FLAG_EXCLUSIVE | IO_FLAG_RW,  &channel);
 	if (retval) {
 		com_err(prg_name, retval,
-				_("Failed to open %s\n"), device_name);
+				_("while opening `%s'"), device_name);
 		exit(1);
 	}
 
@@ -194,30 +195,34 @@ int main(int argc, char *argv[])
 	}
 
 	for (key = tdb_firstkey(tdb); key.dptr; key = tdb_nextkey(tdb, key)) {
+		free(old_dptr);
+		old_dptr = key.dptr;
 		if (!strcmp((char *) key.dptr, (char *) mtime_key) ||
 		    !strcmp((char *) key.dptr, (char *) uuid_key) ||
 		    !strcmp((char *) key.dptr, (char *) blksize_key)) {
 			continue;
 		}
 
+		blk_num = *(blk64_t *)key.dptr;
 		data = tdb_fetch(tdb, key);
 		if (!data.dptr) {
-			com_err(prg_name, 0,
-				_("Failed tdb_fetch %s\n"), tdb_errorstr(tdb));
+			retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
+			com_err(prg_name, retval,
+				_("while fetching block %llu."), blk_num);
 			exit(1);
 		}
-		blk_num = *(blk64_t *)key.dptr;
 		printf(_("Replayed transaction of size %zd at location %llu\n"),
 							data.dsize, blk_num);
 		retval = io_channel_write_blk64(channel, blk_num,
 						-data.dsize, data.dptr);
+		free(data.dptr);
 		if (retval == -1) {
 			com_err(prg_name, retval,
-					_("Failed write %s\n"),
-					strerror(errno));
+				_("while writing block %llu."), blk_num);
 			exit(1);
 		}
 	}
+	free(old_dptr);
 	io_channel_close(channel);
 	tdb_close(tdb);
 

