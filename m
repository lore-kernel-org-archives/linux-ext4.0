From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/14] misc: fix undo file setup
Date: Wed, 13 May 2015 17:21:27 -0700
Message-ID: <20150514002127.10785.17635.stgit@birch.djwong.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22792 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbbENAVc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 May 2015 20:21:32 -0400
In-Reply-To: <20150514002108.10785.85860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix Coverity bugs 1297094-1297101 by fixing all the mutations in the
*_setup_tdb() functions, fixing buffer overflows, and checking
return values.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debugfs.c |   29 ++++++++++++------------
 e2fsck/unix.c     |   12 +++++++---
 misc/e2undo.c     |   64 +++++++++++++++++++++++++++++++++--------------------
 misc/mke2fs.c     |   12 +++++++---
 misc/tune2fs.c    |   63 +++++++++++++++++++++++++++++-----------------------
 resize/main.c     |   29 ++++++++++++------------
 6 files changed, 121 insertions(+), 88 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 4b88f73..c677f5f 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -55,11 +55,12 @@ static int debugfs_setup_tdb(const char *device_name, char *undo_file,
 	errcode_t retval = ENOMEM;
 	char *tdb_dir = NULL, *tdb_file = NULL;
 	char *dev_name, *tmp_name;
-	int free_tdb_dir = 0;
 
 	/* (re)open a specific undo file */
 	if (undo_file && undo_file[0] != 0) {
-		set_undo_io_backing_manager(*io_ptr);
+		retval = set_undo_io_backing_manager(*io_ptr);
+		if (retval)
+			goto err;
 		*io_ptr = undo_io_manager;
 		retval = set_undo_io_backup_file(undo_file);
 		if (retval)
@@ -68,7 +69,7 @@ static int debugfs_setup_tdb(const char *device_name, char *undo_file,
 			"using the command:\n"
 			"    e2undo %s %s\n\n",
 			undo_file, device_name);
-		return 0;
+		return retval;
 	}
 
 	/*
@@ -76,19 +77,18 @@ static int debugfs_setup_tdb(const char *device_name, char *undo_file,
 	 * nice
 	 */
 	tdb_dir = getenv("E2FSPROGS_UNDO_DIR");
+	if (!tdb_dir)
+		tdb_dir = "/var/lib/e2fsprogs";
 
-	if (tdb_dir == NULL || !strcmp(tdb_dir, "none") || (tdb_dir[0] == 0) ||
-	    access(tdb_dir, W_OK)) {
-		if (free_tdb_dir)
-			free(tdb_dir);
+	if (!strcmp(tdb_dir, "none") || (tdb_dir[0] == 0) ||
+	    access(tdb_dir, W_OK))
 		return 0;
-	}
 
 	tmp_name = strdup(device_name);
 	if (!tmp_name)
 		goto errout;
 	dev_name = basename(tmp_name);
-	tdb_file = malloc(strlen(tdb_dir) + 8 + strlen(dev_name) + 7 + 1);
+	tdb_file = malloc(strlen(tdb_dir) + 9 + strlen(dev_name) + 7 + 1);
 	if (!tdb_file) {
 		free(tmp_name);
 		goto errout;
@@ -98,10 +98,14 @@ static int debugfs_setup_tdb(const char *device_name, char *undo_file,
 
 	if ((unlink(tdb_file) < 0) && (errno != ENOENT)) {
 		retval = errno;
+		com_err("debugfs", retval,
+			"while trying to delete %s", tdb_file);
 		goto errout;
 	}
 
-	set_undo_io_backing_manager(*io_ptr);
+	retval = set_undo_io_backing_manager(*io_ptr);
+	if (retval)
+		goto errout;
 	*io_ptr = undo_io_manager;
 	retval = set_undo_io_backup_file(tdb_file);
 	if (retval)
@@ -110,14 +114,9 @@ static int debugfs_setup_tdb(const char *device_name, char *undo_file,
 		"using the command:\n"
 		"    e2undo %s %s\n\n", tdb_file, device_name);
 
-	if (free_tdb_dir)
-		free(tdb_dir);
 	free(tdb_file);
 	return 0;
-
 errout:
-	if (free_tdb_dir)
-		free(tdb_dir);
 	free(tdb_file);
 err:
 	com_err("debugfs", retval, "while trying to setup undo file\n");
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 940ecb4..9ef4b1e 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1242,7 +1242,9 @@ static int e2fsck_setup_tdb(e2fsck_t ctx, io_manager *io_ptr)
 
 	/* (re)open a specific undo file */
 	if (ctx->undo_file && ctx->undo_file[0] != 0) {
-		set_undo_io_backing_manager(*io_ptr);
+		retval = set_undo_io_backing_manager(*io_ptr);
+		if (retval)
+			goto err;
 		*io_ptr = undo_io_manager;
 		retval = set_undo_io_backup_file(ctx->undo_file);
 		if (retval)
@@ -1251,7 +1253,7 @@ static int e2fsck_setup_tdb(e2fsck_t ctx, io_manager *io_ptr)
 			 "using the command:\n"
 			 "    e2undo %s %s\n\n"),
 			ctx->undo_file, ctx->filesystem_name);
-		return 0;
+		return retval;
 	}
 
 	/*
@@ -1287,10 +1289,14 @@ static int e2fsck_setup_tdb(e2fsck_t ctx, io_manager *io_ptr)
 
 	if ((unlink(tdb_file) < 0) && (errno != ENOENT)) {
 		retval = errno;
+		com_err(ctx->program_name, retval,
+			_("while trying to delete %s"), tdb_file);
 		goto errout;
 	}
 
-	set_undo_io_backing_manager(*io_ptr);
+	retval = set_undo_io_backing_manager(*io_ptr);
+	if (retval)
+		goto errout;
 	*io_ptr = undo_io_manager;
 	retval = set_undo_io_backup_file(tdb_file);
 	if (retval)
diff --git a/misc/e2undo.c b/misc/e2undo.c
index 3f312c6..6123c48 100644
--- a/misc/e2undo.c
+++ b/misc/e2undo.c
@@ -204,29 +204,29 @@ static int e2undo_setup_tdb(const char *name, io_manager *io_ptr)
 {
 	errcode_t retval = 0;
 	const char *tdb_dir;
-	char *tdb_file;
+	char *tdb_file = NULL;
 	char *dev_name, *tmp_name;
 
 	/* (re)open a specific undo file */
 	if (undo_file && undo_file[0] != 0) {
-		set_undo_io_backing_manager(*io_ptr);
+		retval = set_undo_io_backing_manager(*io_ptr);
+		if (retval)
+			goto err;
 		*io_ptr = undo_io_manager;
-		set_undo_io_backup_file(undo_file);
-		printf(_("To undo the e2undo operation please run "
-			 "the command\n    e2undo %s %s\n\n"),
+		retval = set_undo_io_backup_file(undo_file);
+		if (retval)
+			goto err;
+		printf(_("Overwriting existing filesystem; this can be undone "
+			 "using the command:\n"
+			 "    e2undo %s %s\n\n"),
 			 undo_file, name);
 		return retval;
 	}
 
-	tmp_name = strdup(name);
-	if (!tmp_name) {
-	alloc_fn_fail:
-		com_err(prg_name, ENOMEM, "%s",
-			_("Couldn't allocate memory for tdb filename\n"));
-		return ENOMEM;
-	}
-	dev_name = basename(tmp_name);
-
+	/*
+	 * Configuration via a conf file would be
+	 * nice
+	 */
 	tdb_dir = getenv("E2FSPROGS_UNDO_DIR");
 	if (!tdb_dir)
 		tdb_dir = "/var/lib/e2fsprogs";
@@ -235,27 +235,43 @@ static int e2undo_setup_tdb(const char *name, io_manager *io_ptr)
 	    access(tdb_dir, W_OK))
 		return 0;
 
-	tdb_file = malloc(strlen(tdb_dir) + 9 + strlen(dev_name) + 7 + 1);
-	if (!tdb_file)
-		goto alloc_fn_fail;
+	tmp_name = strdup(name);
+	if (!tmp_name)
+		goto errout;
+	dev_name = basename(tmp_name);
+	tdb_file = malloc(strlen(tdb_dir) + 8 + strlen(dev_name) + 7 + 1);
+	if (!tdb_file) {
+		free(tmp_name);
+		goto errout;
+	}
 	sprintf(tdb_file, "%s/e2undo-%s.e2undo", tdb_dir, dev_name);
+	free(tmp_name);
 
 	if ((unlink(tdb_file) < 0) && (errno != ENOENT)) {
 		retval = errno;
 		com_err(prg_name, retval,
 			_("while trying to delete %s"), tdb_file);
-		free(tdb_file);
-		return retval;
+		goto errout;
 	}
 
-	set_undo_io_backing_manager(*io_ptr);
+	retval = set_undo_io_backing_manager(*io_ptr);
+	if (retval)
+		goto errout;
 	*io_ptr = undo_io_manager;
-	set_undo_io_backup_file(tdb_file);
-	printf(_("To undo the e2undo operation please run "
-		 "the command\n    e2undo %s %s\n\n"),
+	retval = set_undo_io_backup_file(tdb_file);
+	if (retval)
+		goto errout;
+	printf(_("Overwriting existing filesystem; this can be undone "
+		 "using the command:\n"
+		 "    e2undo %s %s\n\n"),
 		 tdb_file, name);
+
 	free(tdb_file);
-	free(tmp_name);
+	return 0;
+errout:
+	free(tdb_file);
+err:
+	com_err(prg_name, retval, "while trying to setup undo file\n");
 	return retval;
 }
 
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 05a16d6..78b1252 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2500,7 +2500,9 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 
 	/* (re)open a specific undo file */
 	if (undo_file && undo_file[0] != 0) {
-		set_undo_io_backing_manager(*io_ptr);
+		retval = set_undo_io_backing_manager(*io_ptr);
+		if (retval)
+			goto err;
 		*io_ptr = undo_io_manager;
 		retval = set_undo_io_backup_file(undo_file);
 		if (retval)
@@ -2508,7 +2510,7 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 		printf(_("Overwriting existing filesystem; this can be undone "
 			 "using the command:\n"
 			 "    e2undo %s %s\n\n"), undo_file, name);
-		return 0;
+		return retval;
 	}
 
 	/*
@@ -2544,10 +2546,14 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 
 	if ((unlink(tdb_file) < 0) && (errno != ENOENT)) {
 		retval = errno;
+		com_err(program_name, retval,
+			_("while trying to delete %s"), tdb_file);
 		goto errout;
 	}
 
-	set_undo_io_backing_manager(*io_ptr);
+	retval = set_undo_io_backing_manager(*io_ptr);
+	if (retval)
+		goto errout;
 	*io_ptr = undo_io_manager;
 	retval = set_undo_io_backup_file(tdb_file);
 	if (retval)
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index f97ec25..d2e8b20 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2529,38 +2529,29 @@ static int tune2fs_setup_tdb(const char *name, io_manager *io_ptr)
 {
 	errcode_t retval = 0;
 	const char *tdb_dir;
-	char *tdb_file;
+	char *tdb_file = NULL;
 	char *dev_name, *tmp_name;
 
 	/* (re)open a specific undo file */
 	if (undo_file && undo_file[0] != 0) {
-		set_undo_io_backing_manager(*io_ptr);
+		retval = set_undo_io_backing_manager(*io_ptr);
+		if (retval)
+			goto err;
 		*io_ptr = undo_io_manager;
-		set_undo_io_backup_file(undo_file);
-		printf(_("To undo the tune2fs operation please run "
-			 "the command\n    e2undo %s %s\n\n"),
+		retval = set_undo_io_backup_file(undo_file);
+		if (retval)
+			goto err;
+		printf(_("Overwriting existing filesystem; this can be undone "
+			 "using the command:\n"
+			 "    e2undo %s %s\n\n"),
 			 undo_file, name);
 		return retval;
 	}
 
-#if 0 /* FIXME!! */
 	/*
 	 * Configuration via a conf file would be
 	 * nice
 	 */
-	profile_get_string(profile, "scratch_files",
-					"directory", 0, 0,
-					&tdb_dir);
-#endif
-	tmp_name = strdup(name);
-	if (!tmp_name) {
-	alloc_fn_fail:
-		com_err(program_name, ENOMEM, "%s",
-			_("Couldn't allocate memory for tdb filename\n"));
-		return ENOMEM;
-	}
-	dev_name = basename(tmp_name);
-
 	tdb_dir = getenv("E2FSPROGS_UNDO_DIR");
 	if (!tdb_dir)
 		tdb_dir = "/var/lib/e2fsprogs";
@@ -2569,27 +2560,43 @@ static int tune2fs_setup_tdb(const char *name, io_manager *io_ptr)
 	    access(tdb_dir, W_OK))
 		return 0;
 
+	tmp_name = strdup(name);
+	if (!tmp_name)
+		goto errout;
+	dev_name = basename(tmp_name);
 	tdb_file = malloc(strlen(tdb_dir) + 9 + strlen(dev_name) + 7 + 1);
-	if (!tdb_file)
-		goto alloc_fn_fail;
+	if (!tdb_file) {
+		free(tmp_name);
+		goto errout;
+	}
 	sprintf(tdb_file, "%s/tune2fs-%s.e2undo", tdb_dir, dev_name);
+	free(tmp_name);
 
 	if ((unlink(tdb_file) < 0) && (errno != ENOENT)) {
 		retval = errno;
 		com_err(program_name, retval,
 			_("while trying to delete %s"), tdb_file);
-		free(tdb_file);
-		return retval;
+		goto errout;
 	}
 
-	set_undo_io_backing_manager(*io_ptr);
+	retval = set_undo_io_backing_manager(*io_ptr);
+	if (retval)
+		goto errout;
 	*io_ptr = undo_io_manager;
-	set_undo_io_backup_file(tdb_file);
-	printf(_("To undo the tune2fs operation please run "
-		 "the command\n    e2undo %s %s\n\n"),
+	retval = set_undo_io_backup_file(tdb_file);
+	if (retval)
+		goto errout;
+	printf(_("Overwriting existing filesystem; this can be undone "
+		 "using the command:\n"
+		 "    e2undo %s %s\n\n"),
 		 tdb_file, name);
+
 	free(tdb_file);
-	free(tmp_name);
+	return 0;
+errout:
+	free(tdb_file);
+err:
+	com_err("tune2fs", retval, "while trying to setup undo file\n");
 	return retval;
 }
 
diff --git a/resize/main.c b/resize/main.c
index a61943e..9da3a95 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -170,11 +170,12 @@ static int resize2fs_setup_tdb(const char *device_name, char *undo_file,
 	errcode_t retval = ENOMEM;
 	char *tdb_dir = NULL, *tdb_file = NULL;
 	char *dev_name, *tmp_name;
-	int free_tdb_dir = 0;
 
 	/* (re)open a specific undo file */
 	if (undo_file && undo_file[0] != 0) {
-		set_undo_io_backing_manager(*io_ptr);
+		retval = set_undo_io_backing_manager(*io_ptr);
+		if (retval)
+			goto err;
 		*io_ptr = undo_io_manager;
 		retval = set_undo_io_backup_file(undo_file);
 		if (retval)
@@ -183,7 +184,7 @@ static int resize2fs_setup_tdb(const char *device_name, char *undo_file,
 			 "using the command:\n"
 			 "    e2undo %s %s\n\n"),
 			undo_file, device_name);
-		return 0;
+		return retval;
 	}
 
 	/*
@@ -191,19 +192,18 @@ static int resize2fs_setup_tdb(const char *device_name, char *undo_file,
 	 * nice
 	 */
 	tdb_dir = getenv("E2FSPROGS_UNDO_DIR");
+	if (!tdb_dir)
+		tdb_dir = "/var/lib/e2fsprogs";
 
-	if (tdb_dir == NULL || !strcmp(tdb_dir, "none") || (tdb_dir[0] == 0) ||
-	    access(tdb_dir, W_OK)) {
-		if (free_tdb_dir)
-			free(tdb_dir);
+	if (!strcmp(tdb_dir, "none") || (tdb_dir[0] == 0) ||
+	    access(tdb_dir, W_OK))
 		return 0;
-	}
 
 	tmp_name = strdup(device_name);
 	if (!tmp_name)
 		goto errout;
 	dev_name = basename(tmp_name);
-	tdb_file = malloc(strlen(tdb_dir) + 8 + strlen(dev_name) + 7 + 1);
+	tdb_file = malloc(strlen(tdb_dir) + 11 + strlen(dev_name) + 7 + 1);
 	if (!tdb_file) {
 		free(tmp_name);
 		goto errout;
@@ -213,10 +213,14 @@ static int resize2fs_setup_tdb(const char *device_name, char *undo_file,
 
 	if ((unlink(tdb_file) < 0) && (errno != ENOENT)) {
 		retval = errno;
+		com_err(program_name, retval,
+			_("while trying to delete %s"), tdb_file);
 		goto errout;
 	}
 
-	set_undo_io_backing_manager(*io_ptr);
+	retval = set_undo_io_backing_manager(*io_ptr);
+	if (retval)
+		goto errout;
 	*io_ptr = undo_io_manager;
 	retval = set_undo_io_backup_file(tdb_file);
 	if (retval)
@@ -225,14 +229,9 @@ static int resize2fs_setup_tdb(const char *device_name, char *undo_file,
 		 "using the command:\n"
 		 "    e2undo %s %s\n\n"), tdb_file, device_name);
 
-	if (free_tdb_dir)
-		free(tdb_dir);
 	free(tdb_file);
 	return 0;
