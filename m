From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v2] ext4: fix shared/002 and 004 fail issue in xfstests
Date: Wed,  9 Apr 2014 22:54:29 +0900
Message-ID: <1397051669-2645-1-git-send-email-linkinjeon@gmail.com>
Cc: linux-ext4@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
	Namjae Jeon <namjae.jeon@samsung.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:39922 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbaDINzE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2014 09:55:04 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so2470569pdj.22
        for <linux-ext4@vger.kernel.org>; Wed, 09 Apr 2014 06:55:04 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Namjae Jeon <namjae.jeon@samsung.com>

When mounting ext4 with data=journal option, xfstest shared/002 and
shared/004 are currently failing as checksum computed for testfile
does not match with the checksum computed in other journal modes.
In case of data=journal mode, a call to filemap_write_and_wait_range
will not flush anything to disk as buffers are not marked dirty in
write_end. In collapse range this call is followed by a call to
truncate_pagecache_range. Due to this, when checksum is computed,
a portion of file is re-read from disk which replace valid data with
NULL bytes and hence the reason for the difference in checksum.

Calling ext4_force_commit before filemap_write_and_wait_range solves
the issue as it will mark the buffers dirty during commit transaction
which can be later synced by a call to filemap_write_and_wait_range.

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

