From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH v2] ext4: directly leave out of ext4_find_delalloc_range() if filesystem mount with "nodelalloc"
Date: Thu,  8 Dec 2011 14:59:54 +0800
Message-ID: <1323327594-4914-1-git-send-email-hao.bigrat@gmail.com>
References: <1323237879-31800-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36219 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab1LHHAJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Dec 2011 02:00:09 -0500
Received: by iakc1 with SMTP id c1so2133793iak.19
        for <linux-ext4@vger.kernel.org>; Wed, 07 Dec 2011 23:00:09 -0800 (PST)
In-Reply-To: <1323237879-31800-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

We found performance regression when using bigalloc with "nodelalloc"  (1MB cluster size):

1. mke2fs -C 1048576 -O ^has_journal,bigalloc /dev/sda
2. mount -o nodelalloc /dev/sda /test/
3. time dd if=/dev/zero of=/test/io bs=1048576 count=1024

The "dd" will cost about 2 seconds to finish, but if we mke2fs without "bigalloc",
"dd" will only cost lesss than 1 second.

The reason is:  when using ext4 with "nodelalloc", it will call ext4_find_delalloc_cluster() nearly
everytime it call ext4_ext_map_blocks(), and ext4_find_delalloc_range() will also scan all pages
in cluster because no buffer is "delayed".
A cluster has 256 pages (1MB cluster), so it will scan 256 * 256k pags when creating a 1G file. That
severely hurts the performance.

Therefore, we return out from ext4_find_delalloc_range() when using "nodelalloc".

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/extents.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 61fa9e1..60f5f25 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3282,6 +3282,9 @@ static int ext4_find_delalloc_range(struct inode *inode,
 	ext4_lblk_t i, pg_lblk;
 	pgoff_t index;
 
+	if (!test_opt(inode->i_sb, DELALLOC))
+		return 0;
+
 	/* reverse search wont work if fs block size is less than page size */
 	if (inode->i_blkbits < PAGE_CACHE_SHIFT)
 		search_hint_reverse = 0;
-- 
1.7.4.1

