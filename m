From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/5] ext4: remove unnecessary wait for extent conversion in ext4_fallocate()
Date: Mon, 25 Feb 2013 20:07:42 +0400
Message-ID: <1361808463-25471-4-git-send-email-dmonakhov@openvz.org>
References: <1361808463-25471-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:40716 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759947Ab3BYQI4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2013 11:08:56 -0500
In-Reply-To: <1361808463-25471-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Now that we don't merge uninitialized extents anymore,
ext4_fallocate() is free to operate on the inode while there are still
some extent conversions pending - it won't disturb them in any way.

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Reviewed-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 78c2a91..c89e850 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4391,8 +4391,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (len <= EXT_UNINIT_MAX_LEN << blkbits)
 		flags |= EXT4_GET_BLOCKS_NO_NORMALIZE;
 
-	/* Prevent race condition between unwritten */
-	ext4_flush_unwritten_io(inode);
 retry:
 	while (ret >= 0 && ret < max_blocks) {
 		map.m_lblk = map.m_lblk + ret;
-- 
1.7.1

