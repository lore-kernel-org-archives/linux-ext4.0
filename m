From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v2] ext4: fix shared/002 and 004 teacase fail issue in xfstests
Date: Wed, 09 Apr 2014 19:23:54 +0900
Message-ID: <001301cf53dd$cf23c720$6d6b5560$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'linux-ext4' <linux-ext4@vger.kernel.org>,
	Ashish Sangwan <a.sangwan@samsung.com>, linkinjeon@gmail.com
To: 'Theodore Ts'o' <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:46609 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442AbaDIKXz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2014 06:23:55 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N3R006HXE7ULF10@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 09 Apr 2014 19:23:54 +0900 (KST)
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Namjae Jeon <namjae.jeon@samsung.com>

When mounting ext4 with data=journal option, xfstest shared/002 and
shared/004
are currently failing as checksum computed for testfile does not match with
the checksum computed in other journal modes. In case of data=journal mode,
a call to filemap_write_and_wait_range will not flush anything to disk as
buffers are not marked dirty in write_end. In collapse range this call is
followed by a call to truncate_pagecache_range. Due to this, when checksum
is
computed, a portion of file is re-read from disk which replace valid data
with
NULL bytes and hence the reason for the difference in checksum.

Calling ext4_force_commit before filemap_write_and_wait_range solves the
issue
as it will mark the buffers dirty during commit transaction which can be
later
synced by a call to filemap_write_and_wait_range.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ext4/extents.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d7a78ed..ec1d9c4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5112,6 +5112,13 @@ int ext4_collapse_range(struct inode *inode, loff_t
offset, loff_t len)
 	punch_start = offset >> EXT4_BLOCK_SIZE_BITS(sb);
 	punch_stop = (offset + len) >> EXT4_BLOCK_SIZE_BITS(sb);
 
+	/* Call ext4_force_commit to flush all data in case of
data=journal.*/
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
1.7.11-rc0

