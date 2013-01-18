From: Jan Kara <jack@suse.cz>
Subject: [PATCH 05/12] ext4: Remove unnecessary wait for extent conversion in ext4_fallocate()
Date: Fri, 18 Jan 2013 13:00:39 +0100
Message-ID: <1358510446-19174-6-git-send-email-jack@suse.cz>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab3ARMA6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2013 07:00:58 -0500
In-Reply-To: <1358510446-19174-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that we don't merge uninitialized extents anymore, ext4_fallocate()
is free to operate on the inode while there are still some extent
conversions pending - it won't disturb them in any way.

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f1ce33a..5c7a46a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4406,8 +4406,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (len <= EXT_UNINIT_MAX_LEN << blkbits)
 		flags |= EXT4_GET_BLOCKS_NO_NORMALIZE;
 
-	/* Prevent race condition between unwritten */
-	ext4_flush_unwritten_io(inode);
 retry:
 	while (ret >= 0 && ret < max_blocks) {
 		map.m_lblk = map.m_lblk + ret;
-- 
1.7.1

