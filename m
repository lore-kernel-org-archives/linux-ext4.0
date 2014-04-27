From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/7] mke2fs: don't complain if the regular file is too small
Date: Sat, 26 Apr 2014 20:00:30 -0400
Message-ID: <1398556834-31913-3-git-send-email-tytso@mit.edu>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34706 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbaD0AAq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Apr 2014 20:00:46 -0400
In-Reply-To: <1398556834-31913-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't ask the user if it's OK that a regular file is smaller than the
requested size.  This test only makes sense if we are creating the
file system on a block device.  This allow users to not need to
manually answer the "proceed?" question when creating a file system
backed by a simple file.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/mke2fs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 3c62ede..fa61e7b 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1383,7 +1383,7 @@ static void PRS(int argc, char *argv[])
 	unsigned long	flex_bg_size = 0;
 	double		reserved_ratio = -1.0;
 	int		lsector_size = 0, psector_size = 0;
-	int		show_version_only = 0;
+	int		show_version_only = 0, is_device = 0;
 	unsigned long long num_inodes = 0; /* unsigned long long to catch too-large input */
 	errcode_t	retval;
 	char *		oldpath = getenv("PATH");
@@ -1749,7 +1749,7 @@ profile_error:
 	if (optind < argc)
 		usage();
 
-	if (!check_plausibility(device_name, 0, NULL) && !force)
+	if (!check_plausibility(device_name, 0, &is_device) && !force)
 		proceed_question();
 
 	check_mount(device_name, force, _("filesystem"));
@@ -1793,7 +1793,7 @@ profile_error:
 				fs_blocks_count &= ~((blk64_t) ((sys_page_size /
 					     EXT2_BLOCK_SIZE(&fs_param))-1));
 		}
-	} else if (!force && (fs_blocks_count > dev_size)) {
+	} else if (!force && is_device && (fs_blocks_count > dev_size)) {
 		com_err(program_name, 0, "%s",
 			_("Filesystem larger than apparent device size."));
 		proceed_question();
-- 
1.9.0

