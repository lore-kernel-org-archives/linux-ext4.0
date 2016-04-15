From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2image: don't leak progress info to stdout
Date: Thu, 14 Apr 2016 22:20:46 -0500
Message-ID: <57105E0E.1040006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Alex Markley <alex@malexmedia.net>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbcDODUs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Apr 2016 23:20:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit c8ee0d60 fixed most of these, but missed this one.

# e2image -r -p <device> - > imagefile

leads to a corrupted image due to the "Scanning inodes..."
printf going to stdout.

Reported-by: Alex Markley <alex@malexmedia.net>
Addresses-Red-Hat-Bugzilla: #1327329
Signed-off-by: Eric Sandeen <sandeen@redhat.com>

diff --git a/misc/e2image.c b/misc/e2image.c
index e9b4ae2..690ad2c 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -1285,7 +1285,7 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
 
 	mark_table_blocks(fs);
 	if (show_progress)
-		printf("%s", _("Scanning inodes...\n"));
+		fprintf(stderr, "%s", _("Scanning inodes...\n"));
 
 	retval = ext2fs_open_inode_scan(fs, 0, &scan);
 	if (retval) {

