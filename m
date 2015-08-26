From: Jan Kara <jack@suse.com>
Subject: [PATCH 09/21] mke2fs: Allow specifying number of reserved inodes
Date: Wed, 26 Aug 2015 18:22:24 +0200
Message-ID: <1440606156-5754-10-git-send-email-jack@suse.com>
References: <1440606156-5754-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33542 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756941AbbHZQWy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 12:22:54 -0400
In-Reply-To: <1440606156-5754-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Add option to specify number of reserved inodes in the created
filesystem.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 misc/mke2fs.8.in |  6 ++++++
 misc/mke2fs.c    | 40 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 40c40d3ed065..4165c0a9d051 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -384,6 +384,12 @@ Do not attempt to discard blocks at mkfs time.
 @QUOTA_MAN_COMMENT@.B quota
 @QUOTA_MAN_COMMENT@feature is set. Without this extended option, the default
 @QUOTA_MAN_COMMENT@behavior is to initialize both user and group quotas.
+.TP
+.BI reserved_inodes= number
+Specify the number of inodes reserved for system files. This number must be
+at least 10. Currently 10 is enough but future features may require additional
+reserved inodes. Reserving more inodes after the file system is created
+requires full file system scan which can take a long time.
 .RE
 .TP
 .BI \-f " fragment-size"
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 78b1252d8519..d61d1a332e67 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1024,6 +1024,34 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				r_usage++;
 				continue;
 			}
+		} else if (!strcmp(token, "reserved_inodes")) {
+			unsigned int reserved_inodes;
+
+			if (!arg) {
+				r_usage++;
+				badopt = token;
+				continue;
+			}
+			reserved_inodes = strtoul(arg, &p, 0);
+			if (*p) {
+				fprintf(stderr,
+					_("Invalid number of reserved inodes "
+					  "%s\n"),
+					arg);
+				r_usage++;
+				continue;
+			}
+			/* Ino 0 is invalid so bump by 1... */
+			reserved_inodes++;
+			if (reserved_inodes < EXT2_GOOD_OLD_FIRST_INO) {
+				fprintf(stderr,
+					_("Too few reserved inodes "
+					  "%s (must be at least %u)\n"),
+					arg, EXT2_GOOD_OLD_FIRST_INO - 1);
+				r_usage++;
+				continue;
+			}
+			param->s_first_ino = reserved_inodes;
 		} else {
 			r_usage++;
 			badopt = token;
@@ -1049,7 +1077,8 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			"\ttest_fs\n"
 			"\tdiscard\n"
 			"\tnodiscard\n"
-			"\tquotatype=<usr OR grp>\n\n"),
+			"\tquotatype=<usr OR grp>\n"
+			"\treserved_inodes=<number of reserved inodes>\n\n"),
 			badopt ? badopt : "");
 		free(buf);
 		exit(1);
@@ -2422,6 +2451,15 @@ profile_error:
 		exit(1);
 	}
 
+	/* Count with one more inode for lost+found */
+	if (fs_param.s_first_ino >= fs_param.s_inodes_count + 1) {
+		com_err(program_name, 0, _("asked for more reserved inodes than filesystem has "
+			"available (%u >= %u)\n"),
+			(unsigned int)fs_param.s_first_ino,
+			(unsigned int)fs_param.s_inodes_count + 1);
+		exit(1);
+	}
+
 	/*
 	 * Calculate number of blocks to reserve
 	 */
-- 
2.1.4

