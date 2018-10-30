Return-Path: <SRS0=zKcc=NK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:45974 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725743AbeJaGxX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 31 Oct 2018 02:53:23 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2 05/11] ext4 resize: lost rollback in ext4_resize_fs()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
References: <cover.1540935522.git.vvs@virtuozzo.com>
Message-ID: <916ed44d-d137-060a-bfc3-1925afa03b04@virtuozzo.com>
Date: Wed, 31 Oct 2018 00:58:09 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1540935522.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixes 117fff10d7f1 ("ext4: grow the s_flex_groups array as needed ...") # 3.7

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ext4/resize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 3df326ee6d50..5fee65afd58b 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -2022,7 +2022,7 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 
 	err = ext4_alloc_flex_bg_array(sb, n_group + 1);
 	if (err)
-		return err;
+		goto out;
 
 	err = ext4_mb_alloc_groupinfo(sb, n_group + 1);
 	if (err)
-- 
2.17.1
