From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/39] libext2fs: zero the EA block buffer before filling it
Date: Sat, 25 Oct 2014 13:56:49 -0700
Message-ID: <20141025205649.532.60741.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sami Liedes <sami.liedes@iki.fi>, linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43740 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaJYU5c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:57:32 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When writing an extended attribute (EA) block, it's quite possible
that the EA formatting code will not write the entire buffer.
Therefore, we must zero the buffer beforehand to avoid writing random
heap contents to disk.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Sami Liedes <sami.liedes@iki.fi>
---
 lib/ext2fs/ext_attr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index b52abb5..c397e00 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -550,7 +550,7 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 
 write_ea_block:
 	/* Write the EA block */
-	err = ext2fs_get_mem(handle->fs->blocksize, &block_buf);
+	err = ext2fs_get_memzero(handle->fs->blocksize, &block_buf);
 	if (err)
 		goto out;
 

