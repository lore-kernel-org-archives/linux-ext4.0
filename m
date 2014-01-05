From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/4] libext2fs: fix potential memory leak in qcow2_write_raw_image()
Date: Sun,  5 Jan 2014 01:26:41 -0500
Message-ID: <1388903203-5067-2-git-send-email-tytso@mit.edu>
References: <1388903203-5067-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@google.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46012 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbaAEG0q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jan 2014 01:26:46 -0500
In-Reply-To: <1388903203-5067-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Theodore Ts'o <tytso@google.com>

Addresses-Coverity-ID: #1049179
Addresses-Coverity-ID: #1049180

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/qcow2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/qcow2.c b/lib/ext2fs/qcow2.c
index 547edc0..c7cdbee 100644
--- a/lib/ext2fs/qcow2.c
+++ b/lib/ext2fs/qcow2.c
@@ -235,8 +235,10 @@ int qcow2_write_raw_image(int qcow2_fd, int raw_fd,
 	}
 
 	/* Resize the output image to the filesystem size */
-	if (ext2fs_llseek(raw_fd, img.image_size - 1, SEEK_SET) < 0)
-		return errno;
+	if (ext2fs_llseek(raw_fd, img.image_size - 1, SEEK_SET) < 0) {
+		ret = errno;
+		goto out;
+	}
 
 	((char *)copy_buf)[0] = 0;
 	size = write(raw_fd, copy_buf, 1);
-- 
1.8.5.rc3.362.gdf10213

