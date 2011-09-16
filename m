From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 25/25] mke2fs: free tdb_dir string if it came from the profile
Date: Fri, 16 Sep 2011 15:49:40 -0500
Message-ID: <1316206180-6375-26-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46742 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab1IPUtr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:47 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

if tdb_dir points to a string allocated from profile_get_string,
it should be freed again before we exit.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 misc/mke2fs.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index e30c070..3076830 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2024,18 +2024,21 @@ open_err_out:
 static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 {
 	errcode_t retval = ENOMEM;
-	char *tdb_dir, *tdb_file = NULL;
+	char *tdb_dir = NULL, *tdb_file = NULL;
 	char *device_name, *tmp_name;
+	int free_tdb_dir = 0;
 
 	/*
 	 * Configuration via a conf file would be
 	 * nice
 	 */
 	tdb_dir = getenv("E2FSPROGS_UNDO_DIR");
-	if (!tdb_dir)
+	if (!tdb_dir) {
 		profile_get_string(profile, "defaults",
 				   "undo_dir", 0, "/var/lib/e2fsprogs",
 				   &tdb_dir);
+		free_tdb_dir = 1;
+	}
 
 	if (!strcmp(tdb_dir, "none") || (tdb_dir[0] == 0) ||
 	    access(tdb_dir, W_OK))
@@ -2069,10 +2072,14 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 		 "using the command:\n"
 		 "    e2undo %s %s\n\n"), tdb_file, name);
 
+	if (free_tdb_dir)
+		free(tdb_dir);
 	free(tdb_file);
 	return 0;
 
 errout:
+	if (free_tdb_dir)
+		free(tdb_dir);
 	free(tdb_file);
 	com_err(program_name, retval,
 		_("while trying to setup undo file\n"));
-- 
1.7.4.1

