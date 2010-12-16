From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH v2 13/15] mke2fs: fix potential memory leak in mke2fs_setup_tdb()
Date: Thu, 16 Dec 2010 18:42:05 +0900
Message-ID: <1292492525-6829-1-git-send-email-namhyung@gmail.com>
References: <1291206772.1684.26.camel@leonhard>
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33801 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab0LPJma (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Dec 2010 04:42:30 -0500
Received: by pva4 with SMTP id 4so466255pva.19
        for <linux-ext4@vger.kernel.org>; Thu, 16 Dec 2010 01:42:30 -0800 (PST)
In-Reply-To: <1291206772.1684.26.camel@leonhard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

'tmp_name' allocated by strdup() should also be freed if error.
Also check return value of set_undo_io_backup_file() for possible
memory failure. And move label 'alloc_fn_fail' to the end of the
function.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 misc/mke2fs.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 6e2092dc051e..2150f62c3e4c 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1881,12 +1881,8 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 		return 0;
 
 	tmp_name = strdup(name);
-	if (!tmp_name) {
-	alloc_fn_fail:
-		com_err(program_name, ENOMEM, 
-			_("Couldn't allocate memory for tdb filename\n"));
-		return ENOMEM;
-	}
+	if (!tmp_name)
+		goto alloc_fn_fail;
 	device_name = basename(tmp_name);
 	tdb_file = malloc(strlen(tdb_dir) + 8 + strlen(device_name) + 7 + 1);
 	if (!tdb_file)
@@ -1899,6 +1895,7 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 			com_err(program_name, retval,
 				_("while trying to delete %s"),
 				tdb_file);
+			free(tmp_name);
 			free(tdb_file);
 			return retval;
 		}
@@ -1906,7 +1903,7 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 
 	set_undo_io_backing_manager(*io_ptr);
 	*io_ptr = undo_io_manager;
-	set_undo_io_backup_file(tdb_file);
+	retval = set_undo_io_backup_file(tdb_file);
 	printf(_("Overwriting existing filesystem; this can be undone "
 		 "using the command:\n"
 		 "    e2undo %s %s\n\n"), tdb_file, name);
@@ -1914,6 +1911,12 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 	free(tdb_file);
 	free(tmp_name);
 	return retval;
+
+alloc_fn_fail:
+	free(tmp_name);
+	com_err(program_name, ENOMEM,
+		_("Couldn't allocate memory for tdb filename\n"));
+	return ENOMEM;
 }
 
 #ifdef __linux__
-- 
1.7.3.3.400.g93cef

