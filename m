From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] mke2fs: sort "-d" option alphabetically
Date: Wed, 18 Nov 2015 21:53:26 -0700
Message-ID: <1447908806-16433-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-so.shaw.ca ([64.59.136.139]:58401 "EHLO
	smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbbKSFBt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Nov 2015 00:01:49 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Move the mke2fs "-d" option to be alphabetical like other options.

Rename "root_dir" to "src_root_dir" to avoid confusion with the
actual root inode in the new filesystem.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 misc/mke2fs.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 179a4d1..9aaafbc 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -109,7 +109,7 @@ static char *mount_dir;
 char *journal_device;
 static int sync_kludge;	/* Set using the MKE2FS_SYNC env. option */
 char **fs_types;
-const char *root_dir;  /* Copy files from the specified directory */
+const char *src_root_dir;  /* Copy files from the specified directory */
 static char *undo_file;
 
 static profile_t	profile;
@@ -1552,7 +1552,7 @@ profile_error:
 	}
 
 	while ((c = getopt (argc, argv,
-		    "b:ce:g:i:jl:m:no:qr:s:t:d:vC:DE:FG:I:J:KL:M:N:O:R:ST:U:Vz:")) != EOF) {
+		    "b:cd:e:g:i:jl:m:no:qr:s:t:vC:DE:FG:I:J:KL:M:N:O:R:ST:U:Vz:")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = parse_num_blocks2(optarg, -1);
@@ -1585,6 +1585,9 @@ profile_error:
 				exit(1);
 			}
 			break;
+		case 'd':
+			src_root_dir = optarg;
+			break;
 		case 'D':
 			direct_io = 1;
 			break;
@@ -1765,9 +1768,6 @@ profile_error:
 		case 'U':
 			fs_uuid = optarg;
 			break;
-		case 'd':
-			root_dir = optarg;
-			break;
 		case 'v':
 			verbose = 1;
 			break;
@@ -3143,11 +3143,11 @@ no_journal:
 	if (retval)
 		com_err(program_name, retval, "while creating huge files");
 	/* Copy files from the specified directory */
-	if (root_dir) {
+	if (src_root_dir) {
 		if (!quiet)
 			printf("%s", _("Copying files into the device: "));
 
-		retval = populate_fs(fs, EXT2_ROOT_INO, root_dir,
+		retval = populate_fs(fs, EXT2_ROOT_INO, src_root_dir,
 				     EXT2_ROOT_INO);
 		if (retval) {
 			com_err(program_name, retval, "%s",
-- 
1.7.3.4

