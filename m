Return-Path: <SRS0=ufRS=NJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:46088 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727456AbeJ3Agm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 29 Oct 2018 20:36:42 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 7/7] ext4 resize: lost resize_inode cleanup before retry in
 ext4_resize_fs()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Message-ID: <cc935d9e-0e59-fba9-ecdd-a01b435eb5bd@virtuozzo.com>
Date: Mon, 29 Oct 2018 18:25:40 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixes 1c6bd7173d66 ("ext4: convert file system to meta_bg if needed ...")
#? cc: stable <stable@vger.kernel.org>     # 3.7+

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 fs/ext4/resize.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 16b7cfe485d7..3006ede18773 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -2059,6 +2059,10 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
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
