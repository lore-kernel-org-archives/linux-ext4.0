From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 20/74] mke2fs: don't leak memory
Date: Tue, 10 Dec 2013 17:20:33 -0800
Message-ID: <20131211012033.30655.20463.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42601 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab3LKBUj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:20:39 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/mke2fs.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 19b6e85..c1cbcaa 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -93,7 +93,7 @@ gid_t	root_gid;
 int	journal_size;
 int	journal_flags;
 int	lazy_itable_init;
-char	*bad_blocks_filename;
+char	*bad_blocks_filename = NULL;
 __u32	fs_stride;
 int	quotatype = -1;  /* Initialize both user and group quotas by default */
 
@@ -1139,6 +1139,7 @@ static char **parse_fs_type(const char *fs_type,
 
 	parse_str = malloc(strlen(usage_types)+1);
 	if (!parse_str) {
+		free(profile_type);
 		free(list.list);
 		return 0;
 	}
@@ -1509,7 +1510,8 @@ profile_error:
 			discard = 0;
 			break;
 		case 'l':
-			bad_blocks_filename = malloc(strlen(optarg)+1);
+			bad_blocks_filename = realloc(bad_blocks_filename,
+						      strlen(optarg) + 1);
 			if (!bad_blocks_filename) {
 				com_err(program_name, ENOMEM,
 					_("in malloc for bad_blocks_filename"));
@@ -2262,8 +2264,11 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 	}
 
 	if (!strcmp(tdb_dir, "none") || (tdb_dir[0] == 0) ||
-	    access(tdb_dir, W_OK))
+	    access(tdb_dir, W_OK)) {
+		if (free_tdb_dir)
+			free(tdb_dir);
 		return 0;
+	}
 
 	tmp_name = strdup(name);
 	if (!tmp_name)

