From: Joseph Qi <joseph.qi@huawei.com>
Subject: [PATCH] ext4: use local variable journal when calling jbd2_journal_unlock_updates
 in ext4_freeze
Date: Mon, 20 Jan 2014 12:25:33 +0800
Message-ID: <52DCA53D.1030608@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:63338 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbaATEZm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Jan 2014 23:25:42 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Local variable journal is already defined for EXT4_SB(sb)->s_journal in
ext4_freeze, so just use it when calling jbd2_journal_unlock_updates.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c977f4e..e151d35 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4700,7 +4700,7 @@ static int ext4_freeze(struct super_block *sb)
 	error = ext4_commit_super(sb, 1);
 out:
 	/* we rely on upper layer to stop further updates */
-	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+	jbd2_journal_unlock_updates(journal);
 	return error;
 }

-- 
1.8.4.3

