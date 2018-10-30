Return-Path: <SRS0=zKcc=NK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:45980 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725743AbeJaGxa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 31 Oct 2018 02:53:30 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2 06/11] ext4 resize: lost resize_inode cleanup before retry
 in ext4_resize_fs()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
References: <cover.1540935522.git.vvs@virtuozzo.com>
Message-ID: <85ecdd2d-e034-4b15-a872-f8399582b56a@virtuozzo.com>
Date: Wed, 31 Oct 2018 00:58:16 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1540935522.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixes 1c6bd7173d66 ("ext4: convert file system to meta_bg if needed ...") # 3.7

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ext4/resize.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 5fee65afd58b..85158e9de7c2 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -2058,6 +2058,10 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 		n_blocks_count_retry = 0;
 		free_flex_gd(flex_gd);
 		flex_gd = NULL;
+		if (resize_inode) {
+			iput(resize_inode);
+			resize_inode = NULL;
+		}
 		goto retry;
 	}
 
-- 
2.17.1
