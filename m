From: Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH] ext4 crypto: prevent mount when blocksize != pagesize
Date: Fri, 12 Jun 2015 00:12:47 +0900
Message-ID: <1434035567-12651-1-git-send-email-waydi1@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Seunghun Lee <waydi1@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f194.google.com ([209.85.192.194]:36484 "EHLO
	mail-pd0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679AbbFKPNA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Jun 2015 11:13:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Encryption mode is unsupported when blocksize != pagesize.

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 fs/ext4/super.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 31e85be..032c9e3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1583,6 +1583,15 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 			IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, arg);
 	} else if (token == Opt_test_dummy_encryption) {
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
+		int blocksize =
+			BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
+
+		if (blocksize != PAGE_CACHE_SIZE) {
+			ext4_msg(sb, KERN_ERR,
+				"unsupported blocksize for Test dummy encryption mode");
+			return -1;
+		}
+
 		sbi->s_mount_flags |= EXT4_MF_TEST_DUMMY_ENCRYPTION;
 		ext4_msg(sb, KERN_WARNING,
 			 "Test dummy encryption mode enabled");
-- 
2.3.5

