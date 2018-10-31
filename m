Return-Path: <SRS0=VEyz=NL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:47198 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725731AbeKAEMI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Nov 2018 00:12:08 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 4/7] ext4: lost brelse in ext4_xattr_get_block()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
References: <cover.1541011937.git.vvs@virtuozzo.com>
Message-ID: <42b953ae-72de-4196-09b3-dbac68af9c85@virtuozzo.com>
Date: Wed, 31 Oct 2018 22:12:43 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1541011937.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixes dec214d00e0d ("ext4: xattr inode deduplication") # 4.13

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ext4/xattr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index dc1aeab06dba..07c3a115f7ae 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2272,8 +2272,10 @@ static struct buffer_head *ext4_xattr_get_block(struct inode *inode)
 	if (!bh)
 		return ERR_PTR(-EIO);
 	error = ext4_xattr_check_block(inode, bh);
-	if (error)
+	if (error) {
+		brelse(bh);
 		return ERR_PTR(error);
+	}
 	return bh;
 }
 
-- 
2.17.1
