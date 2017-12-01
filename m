From: piaojun <piaojun@huawei.com>
Subject: [PATCH] ext4: no need flush workqueue before destroying it
Date: Fri, 1 Dec 2017 15:44:00 +0800
Message-ID: <5A210840.1020807@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:11464 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbdLAHoJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Dec 2017 02:44:09 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

destroy_workqueue() will do flushing work for us.

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 fs/ext4/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0556cd0..2f46b0b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -870,7 +870,6 @@ static void ext4_put_super(struct super_block *sb)
 	ext4_unregister_li_request(sb);
 	ext4_quota_off_umount(sb);

-	flush_workqueue(sbi->rsv_conversion_wq);
 	destroy_workqueue(sbi->rsv_conversion_wq);

 	if (sbi->s_journal) {
-- 
