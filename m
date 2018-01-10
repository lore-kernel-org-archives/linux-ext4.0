From: piaojun <piaojun@huawei.com>
Subject: [PATCH] ext4: no need flush workqueue before destroying it
Date: Wed, 10 Jan 2018 08:19:13 +0800
Message-ID: <5A555C01.8000400@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <adilger.kernel@dilger.ca>, <arnd@arndb.de>,
        Ted Tso <tytso@mit.edu>, <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:51051 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752057AbeAJATX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Jan 2018 19:19:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

destroy_workqueue() will do flushing work for us.

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
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
