From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 13/15] mke2fs: fix potential memory leak in mke2fs_setup_tdb()
Date: Mon, 29 Nov 2010 17:55:15 +0900
Message-ID: <1291020917-8671-14-git-send-email-namhyung@gmail.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51817 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0K2Izx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 03:55:53 -0500
Received: by mail-gw0-f46.google.com with SMTP id 20so1866691gwj.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 00:55:53 -0800 (PST)
In-Reply-To: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

'tmp_name' allocated by strdup() should also be freed if error.
Also check return value of set_undo_io_backup_file() for possible
memory failure. A whitespace fix is added too.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 misc/mke2fs.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 6e2092d..644b287 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1882,15 +1882,17 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 
 	tmp_name = strdup(name);
 	if (!tmp_name) {
-	alloc_fn_fail:
-		com_err(program_name, ENOMEM, 
+alloc_fn_fail:
+		com_err(program_name, ENOMEM,
 			_("Couldn't allocate memory for tdb filename\n"));
 		return ENOMEM;
 	}
 	device_name = basename(tmp_name);
 	tdb_file = malloc(strlen(tdb_dir) + 8 + strlen(device_name) + 7 + 1);
-	if (!tdb_file)
+	if (!tdb_file) {
+		free(tmp_name);
 		goto alloc_fn_fail;
+	}
 	sprintf(tdb_file, "%s/mke2fs-%s.e2undo", tdb_dir, device_name);
 
 	if (!access(tdb_file, F_OK)) {
@@ -1899,6 +1901,7 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 			com_err(program_name, retval,
 				_("while trying to delete %s"),
 				tdb_file);
+			free(tmp_name);
 			free(tdb_file);
 			return retval;
 		}
@@ -1906,7 +1909,7 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 
 	set_undo_io_backing_manager(*io_ptr);
 	*io_ptr = undo_io_manager;
-	set_undo_io_backup_file(tdb_file);
+	retval = set_undo_io_backup_file(tdb_file);
 	printf(_("Overwriting existing filesystem; this can be undone "
 		 "using the command:\n"
 		 "    e2undo %s %s\n\n"), tdb_file, name);
-- 
1.7.0.4

