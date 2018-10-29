Return-Path: <SRS0=ufRS=NJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:46114 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbeJ3AhN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 29 Oct 2018 20:37:13 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 6/7] ext4 resize: lost rollback in ext4_resize_fs()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Message-ID: <0a8fb3b8-9f2b-9d66-0785-afee16b6e16c@virtuozzo.com>
Date: Mon, 29 Oct 2018 18:25:34 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixes 117fff10d7f1 ("ext4: grow the s_flex_groups array as needed ...")
#? cc: stable <stable@vger.kernel.org>     # 3.7+

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 fs/ext4/resize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 26bcb53e5869..16b7cfe485d7 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -2023,7 +2023,7 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 
 	err = ext4_alloc_flex_bg_array(sb, n_group + 1);
 	if (err)
-		return err;
+		goto out;
 
 	err = ext4_mb_alloc_groupinfo(sb, n_group + 1);
 	if (err)
-- 
2.17.1
