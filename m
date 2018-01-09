From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: [PATCH] ext4: use strlcpy() instead of strncpy()
Date: Tue, 9 Jan 2018 16:58:39 +0800
Message-ID: <1515488319-23779-1-git-send-email-wangxiongfeng2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>, <wangxiongfeng2@huawei.com>
To: <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:50218 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751728AbeAIIx0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Jan 2018 03:53:26 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3044ABC37D117
        for <linux-ext4@vger.kernel.org>; Tue,  9 Jan 2018 16:53:13 +0800 (CST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Xiongfeng Wang <xiongfeng.wang@linaro.org>

gcc-8 reports

fs/ext4/super.c: In function '__save_error_info.isra.6':
./include/linux/string.h:245:9: warning: '__builtin_strncpy' specified
bound 32 equals destination size [-Wstringop-truncation]

We need to use strlcpy() to make sure the dest string is nul-terminated.

Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
---
 fs/ext4/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7c46693..051b988 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -323,11 +323,11 @@ static void __save_error_info(struct super_block *sb, const char *func,
 		return;
 	es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
 	es->s_last_error_time = cpu_to_le32(get_seconds());
-	strncpy(es->s_last_error_func, func, sizeof(es->s_last_error_func));
+	strlcpy(es->s_last_error_func, func, sizeof(es->s_last_error_func));
 	es->s_last_error_line = cpu_to_le32(line);
 	if (!es->s_first_error_time) {
 		es->s_first_error_time = es->s_last_error_time;
-		strncpy(es->s_first_error_func, func,
+		strlcpy(es->s_first_error_func, func,
 			sizeof(es->s_first_error_func));
 		es->s_first_error_line = cpu_to_le32(line);
 		es->s_first_error_ino = es->s_last_error_ino;
-- 
1.8.3.1
