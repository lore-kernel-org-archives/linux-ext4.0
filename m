Return-Path: <SRS0=ufRS=NJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:46090 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727647AbeJ3Agp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 29 Oct 2018 20:36:45 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 5/7] ext4 resize: lost brelse() in update_backups()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Message-ID: <f55088b4-5696-55ed-0190-5848e3403007@virtuozzo.com>
Date: Mon, 29 Oct 2018 18:25:28 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

bh was not released after error in ext4_journal_get_write_access()

Fixes ac27a0ec112a ("ext4: initial copy of files from ext3")
#? cc: stable <stable@vger.kernel.org>     # 2.6.19 or even earlier in ext3

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 fs/ext4/resize.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index ff8389ac4769..26bcb53e5869 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1122,8 +1122,10 @@ static void update_backups(struct super_block *sb, sector_t blk_off, char *data,
 			   backup_block, backup_block -
 			   ext4_group_first_block_no(sb, group));
 		BUFFER_TRACE(bh, "get_write_access");
-		if ((err = ext4_journal_get_write_access(handle, bh)))
+		if ((err = ext4_journal_get_write_access(handle, bh))) {
+			brelse(bh);
 			break;
+		}
 		lock_buffer(bh);
 		memcpy(bh->b_data, data, size);
 		if (rest)
-- 
2.17.1
