From: Niu Yawei <yawei.niu@gmail.com>
Subject: [PATCH] tune2fs: update i_size in ext2fs_file_write()
Date: Thu, 12 Sep 2013 22:21:50 +0800
Message-ID: <5231CDFE.8050206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, yawei.niu@intel.com
To: adityakali@google.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:56030 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3ILOVx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Sep 2013 10:21:53 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro12so10614719pbb.13
        for <linux-ext4@vger.kernel.org>; Thu, 12 Sep 2013 07:21:53 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_file_write() needs to update i_size on successful write,
otherwise, ext2fs_file_read() in same open/close cycle will not
be able to read the just written data.

Which result in the the problem of quotacheck triggered on
'tune2fs -O quota' failed to write back multiple users/groups
accounting information.

Signed-off-by: Niu Yawei <yawei.niu@intel.com>
---
 lib/ext2fs/fileio.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 1f7002c..b1b5540 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -304,6 +304,13 @@ errcode_t ext2fs_file_write(ext2_file_t file, const
void *buf,
 		ptr += c;
 		count += c;
 		nbytes -= c;
+
+		/* Update inode size */
+		if (EXT2_I_SIZE(&file->inode) < file->pos) {
+			retval = ext2fs_file_set_size2(file, file->pos);
+			if (retval)
+				goto fail;
+		}
 	}

 fail:
-- 
1.7.1
