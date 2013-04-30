From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] mke2fs: sort option parsing, deprecate "-R"
Date: Mon, 29 Apr 2013 18:16:01 -0600
Message-ID: <1367280961-16458-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:22613 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3D3AQE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Apr 2013 20:16:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A minor cleanup to order the command-line option parsing in
alphabetical order, except for "-E" and "-R", which need to
be co-located.

Print a message that the "-R" option is deprecated.  It has
been deprecated since 2005 (commit c6a44136b9b).

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 misc/mke2fs.c           |   81 ++++++++++++++++++++++++----------------------
 tests/m_raid_opt/script |    2 +-
 2 files changed, 43 insertions(+), 40 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index fe5ce7d..ac5071c 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1357,6 +1357,16 @@ profile_error:
 		case 'D':
 			direct_io = 1;
 			break;
+		case 'R':
+			com_err(program_name, 0,
+				_("'-R' is deprecated, use '-E' instead"));
+			/* fallthrough */
+		case 'E':
+			extended_opts = optarg;
+			break;
+		case 'F':
+			force++;
+			break;
 		case 'g':
 			fs_param.s_blocks_per_group = strtoul(optarg, &tmp, 0);
 			if (*tmp) {
@@ -1396,6 +1406,18 @@ profile_error:
 				exit(1);
 			}
 			break;
+		case 'I':
+			inode_size = strtoul(optarg, &tmp, 0);
+			if (*tmp) {
+				com_err(program_name, 0,
+					_("invalid inode size - %s"), optarg);
+				exit(1);
+			}
+			break;
+		case 'j':
+			if (!journal_size)
+				journal_size = -1;
+			break;
 		case 'J':
 			parse_journal_opts(optarg);
 			break;
@@ -1406,10 +1428,6 @@ profile_error:
 					  "instead!\n"));
 			discard = 0;
 			break;
-		case 'j':
-			if (!journal_size)
-				journal_size = -1;
-			break;
 		case 'l':
 			bad_blocks_filename = malloc(strlen(optarg)+1);
 			if (!bad_blocks_filename) {
@@ -1419,6 +1437,9 @@ profile_error:
 			}
 			strcpy(bad_blocks_filename, optarg);
 			break;
+		case 'L':
+			volume_label = optarg;
+			break;
 		case 'm':
 			reserved_ratio = strtod(optarg, &tmp);
 			if ( *tmp || reserved_ratio > 50 ||
@@ -1429,12 +1450,26 @@ profile_error:
 				exit(1);
 			}
 			break;
+		case 'M':
+			mount_dir = optarg;
+			break;
 		case 'n':
 			noaction++;
 			break;
+		case 'N':
+			num_inodes = strtoul(optarg, &tmp, 0);
+			if (*tmp) {
+				com_err(program_name, 0,
+					_("bad num inodes - %s"), optarg);
+					exit(1);
+			}
+			break;
 		case 'o':
 			creator_os = optarg;
 			break;
+		case 'O':
+			fs_features = optarg;
+			break;
 		case 'q':
 			quiet = 1;
 			break;
@@ -1450,41 +1485,6 @@ profile_error:
 		case 's':	/* deprecated */
 			s_opt = atoi(optarg);
 			break;
-		case 'I':
-			inode_size = strtoul(optarg, &tmp, 0);
-			if (*tmp) {
-				com_err(program_name, 0,
-					_("invalid inode size - %s"), optarg);
-				exit(1);
-			}
-			break;
-		case 'v':
-			verbose = 1;
-			break;
-		case 'F':
-			force++;
-			break;
-		case 'L':
-			volume_label = optarg;
-			break;
-		case 'M':
-			mount_dir = optarg;
-			break;
-		case 'N':
-			num_inodes = strtoul(optarg, &tmp, 0);
-			if (*tmp) {
-				com_err(program_name, 0,
-					_("bad num inodes - %s"), optarg);
-					exit(1);
-			}
-			break;
-		case 'O':
-			fs_features = optarg;
-			break;
-		case 'E':
-		case 'R':
-			extended_opts = optarg;
-			break;
 		case 'S':
 			super_only = 1;
 			break;
@@ -1507,6 +1507,9 @@ profile_error:
 		case 'U':
 			fs_uuid = optarg;
 			break;
+		case 'v':
+			verbose = 1;
+			break;
 		case 'V':
 			/* Print version number and exit */
 			show_version_only++;
diff --git a/tests/m_raid_opt/script b/tests/m_raid_opt/script
index 1e47cc1..296fe94 100644
--- a/tests/m_raid_opt/script
+++ b/tests/m_raid_opt/script
@@ -1,4 +1,4 @@
 DESCRIPTION="raid options"
 FS_SIZE=131072
-MKE2FS_OPTS="-R stride=13 -O sparse_super -g 1024"
+MKE2FS_OPTS="-E stride=13 -O sparse_super -g 1024"
 . $cmd_dir/run_mke2fs
-- 
1.7.3.4

