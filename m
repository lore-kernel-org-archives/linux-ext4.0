Return-Path: <SRS0=QTyG=PS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:35840 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725536AbfAJGDP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 10 Jan 2019 01:03:15 -0500
From: "zhangyi (F)" <yi.zhang@huawei.com>
To: <linux-ext4@vger.kernel.org>
CC: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <miaoxie@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH 2/2] ext4: fix compile error when using BUFFER_TRACE
Date: Thu, 10 Jan 2019 14:06:39 +0800
Message-ID: <1547100399-127915-3-git-send-email-yi.zhang@huawei.com>
In-Reply-To: <1547100399-127915-1-git-send-email-yi.zhang@huawei.com>
References: <1547100399-127915-1-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix compile error below when using BUFFER_TRACE.

fs/ext4/inode.c: In function ‘ext4_expand_extra_isize’:
fs/ext4/inode.c:5979:19: error: request for member ‘bh’ in something not a structure or union
  BUFFER_TRACE(iloc.bh, "get_write_access");

Fixes: c03b45b853f58 ("ext4, project: expand inode extra size if possible")
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 22a9d81..b7384d5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5976,7 +5976,7 @@ int ext4_expand_extra_isize(struct inode *inode,
 
 	ext4_write_lock_xattr(inode, &no_expand);
 
-	BUFFER_TRACE(iloc.bh, "get_write_access");
+	BUFFER_TRACE(iloc->bh, "get_write_access");
 	error = ext4_journal_get_write_access(handle, iloc->bh);
 	if (error) {
 		brelse(iloc->bh);
-- 
2.7.4
