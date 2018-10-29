Return-Path: <SRS0=ufRS=NJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:46092 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727647AbeJ3Ags (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 29 Oct 2018 20:36:48 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 2/7] ext4 resize: missing brelse() after errors in
 set_flexbg_block_bitmap()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org,
        Yongqiang Yang <xiaoqiangnk@gmail.com>,
        Yongqiang Yang <xiaoqiangnk@gmail.com>
Message-ID: <335a6774-8328-b6c6-ea41-919607c9c6d1@virtuozzo.com>
Date: Mon, 29 Oct 2018 18:25:11 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixes 33afdcc5402d ("ext4: add a function which sets up group blocks ...")
#? cc: stable@vger.kernel.org # 3.3+

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 fs/ext4/resize.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index c3fa30878ca8..0a4dc6217e78 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -459,16 +459,18 @@ static int set_flexbg_block_bitmap(struct super_block *sb, handle_t *handle,
 
 		BUFFER_TRACE(bh, "get_write_access");
 		err = ext4_journal_get_write_access(handle, bh);
-		if (err)
+		if (err) {
+			brelse(bh);
 			return err;
+		}
 		ext4_debug("mark block bitmap %#04llx (+%llu/%u)\n",
 			   first_cluster, first_cluster - start, count2);
 		ext4_set_bits(bh->b_data, first_cluster - start, count2);
 
 		err = ext4_handle_dirty_metadata(handle, NULL, bh);
+		brelse(bh);
 		if (unlikely(err))
 			return err;
-		brelse(bh);
 	}
 
 	return 0;
-- 
2.17.1
