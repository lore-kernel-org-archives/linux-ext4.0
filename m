Return-Path: <SRS0=XuXQ=NS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:37756 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbeKHDBm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Nov 2018 22:01:42 -0500
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2] ext4: lost brelse in __ext4_read_dirblock()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-kernel@vger.kernel.org
References: <6e5c9e17-5916-7296-35a0-cc0600a79f27@virtuozzo.com>
Message-ID: <e269cf8c-b5ca-3eed-bd60-a8629378db8b@virtuozzo.com>
Date: Wed, 7 Nov 2018 20:30:17 +0300
MIME-Version: 1.0
In-Reply-To: <6e5c9e17-5916-7296-35a0-cc0600a79f27@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixes dc6982ff4db1 ("ext4: refactor code to read directory blocks ...")
Cc: stable@kernel.org # 3.9

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ext4/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index d388cce72db2..6a6b90363ef1 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -126,6 +126,7 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
 	if (!is_dx_block && type == INDEX) {
 		ext4_error_inode(inode, func, line, block,
 		       "directory leaf block found instead of index block");
+		brelse(bh);
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 	if (!ext4_has_metadata_csum(inode->i_sb) ||
-- 
2.17.1
