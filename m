From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] ext4: fix shared/002 and 004 fail issue in xfstests
Date: Mon,  7 Apr 2014 23:41:15 +0900
Message-ID: <1396881675-7272-1-git-send-email-linkinjeon@gmail.com>
Cc: linux-ext4@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
	Namjae Jeon <namjae.jeon@samsung.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43485 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbaDGOlh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Apr 2014 10:41:37 -0400
Received: by mail-pa0-f49.google.com with SMTP id lj1so6800776pab.22
        for <linux-ext4@vger.kernel.org>; Mon, 07 Apr 2014 07:41:37 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Namjae Jeon <namjae.jeon@samsung.com>

When mounting ext4 with data=journal option, shared/002 and 004 are
failed on xfstests. Calling ext4_force_commit before
filemap_write_and_wait_range is needed to flush all data into journal
on this case.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ext4/extents.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 243a02e..dc9333f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5375,6 +5375,13 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	punch_start = offset >> EXT4_BLOCK_SIZE_BITS(sb);
 	punch_stop = (offset + len) >> EXT4_BLOCK_SIZE_BITS(sb);
 
+	/* Call ext4_force_commit to flush all data in case of data=journal. */
+	if (ext4_should_journal_data(inode)) {
+		ret = ext4_force_commit(inode->i_sb);
+		if (ret)
+			return ret;
+	}
+
 	/* Write out all dirty pages */
 	ret = filemap_write_and_wait_range(inode->i_mapping, offset, -1);
 	if (ret)
-- 
1.7.9.5

