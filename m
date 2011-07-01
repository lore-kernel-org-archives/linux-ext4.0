From: "Yury V. Zaytsev" <yury@shurup.com>
Subject: [PATCH v2] mke2fs: check that auto-detected blocksize <=
 sys_page_size
Date: Fri, 01 Jul 2011 17:27:31 +0200
Message-ID: <1309534051.9412.58.camel@newpride>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Amir Goldstein <amir73il@gmail.com>,
	Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgateway3.uni-freiburg.de ([132.230.2.213]:37144 "EHLO
	mailgateway3.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756566Ab1GAP1f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jul 2011 11:27:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Block size can be specified manually via the -b option or deduced
automatically. Unfortunately, the check that it is still smaller than
the system page size is only performed right after the command line
options are parsed.

Therefore, if buggy or inappropriately installed/configured hardware
hints that larger block sizes have to be used, mkfs will silently create
a file system which can not be mounted on the system in question.

By moving the check beyond the last assignment to blocksize it is now
ensured, that mkfs will issue a warning even if inappropriate blocksize
was auto-detected.

The new behavior can be easily tested, by exporting the following
variables before running mkfs:

    export MKE2FS_DEVICE_SECTSIZE=8912
    export MKE2FS_DEVICE_PHYS_SECTSIZE=8912

Signed-off-by: Yury V. Zaytsev <yury@shurup.com>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
---
 misc/mke2fs.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 05cbbce..8faf12a 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1514,17 +1514,6 @@ profile_error:
 		ext2fs_close(jfs);
 	}
 
-	if (blocksize > sys_page_size) {
-		if (!force) {
-			com_err(program_name, 0,
-				_("%d-byte blocks too big for system (max %d)"),
-				blocksize, sys_page_size);
-			proceed_question();
-		}
-		fprintf(stderr, _("Warning: %d-byte blocks too big for system "
-				  "(max %d), forced to continue\n"),
-			blocksize, sys_page_size);
-	}
 	if (optind < argc) {
 		fs_blocks_count = parse_num_blocks2(argv[optind++],
 						   fs_param.s_log_block_size);
@@ -1833,6 +1822,19 @@ profile_error:
 
 	blocksize = EXT2_BLOCK_SIZE(&fs_param);
 
+	/* This check should happen beyond the last assignment to blocksize */
+	if (blocksize > sys_page_size) {
+		if (!force) {
+			com_err(program_name, 0,
+				_("%d-byte blocks too big for system (max %d)"),
+				blocksize, sys_page_size);
+			proceed_question();
+		}
+		fprintf(stderr, _("Warning: %d-byte blocks too big for system "
+				  "(max %d), forced to continue\n"),
+			blocksize, sys_page_size);
+	}
+
 	lazy_itable_init = 0;
 	if (access("/sys/fs/ext4/features/lazy_itable_init", R_OK) == 0)
 		lazy_itable_init = 1;
-- 
1.7.5.4



