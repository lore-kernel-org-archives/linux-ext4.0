Return-Path: <SRS0=VEyz=NL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:47174 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725731AbeKAELm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Nov 2018 00:11:42 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 1/7] ext4: lost brelse in __ext4_read_dirblock()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
References: <cover.1541011937.git.vvs@virtuozzo.com>
Message-ID: <60f19df8-1e65-99a0-cb6b-696d1b530fd4@virtuozzo.com>
Date: Wed, 31 Oct 2018 22:12:18 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1541011937.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixes dc6982ff4db1 ("ext4: refactor code to read directory blocks ...") # 3.9

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ext4/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index d388cce72db2..1a21e59ede72 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -111,6 +111,7 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
 	if (!bh) {
 		ext4_error_inode(inode, func, line, block,
 				 "Directory hole found");
+		brelse(bh);
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 	dirent = (struct ext4_dir_entry *) bh->b_data;
-- 
2.17.1
