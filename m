From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] mke2fs: Don't erase flash device if "-n" is given
Date: Tue,  7 Jun 2011 10:22:29 -0600
Message-ID: <1307463749-16498-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:62989 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1FGQWc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 12:22:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If "mke2fs -n" is used, there should be no changes to the underlying
device.  Unfortunately, when the "discard" option was added in commit
c7cd908be59f48c66b4f3ac9a631ffe3dde4f1ab, it did not check for the "-n"
flag, and will discard all data on a flash device even if "-n" is given.

Check for the "noaction" flag before discarding any filesystem data.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 misc/mke2fs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index ddfa929..9472016 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2132,7 +2132,7 @@ int main (int argc, char *argv[])
 	}
 
 	/* Can't undo discard ... */
-	if (discard && (io_ptr != undo_io_manager)) {
+	if (!noaction && discard && (io_ptr != undo_io_manager)) {
 		retval = mke2fs_discard_device(fs);
 		if (!retval && io_channel_discard_zeroes_data(fs->io)) {
 			if (verbose)
-- 
1.7.3.4

