From: Fabrice Jouhaud <yargil@free.fr>
Subject: [PATCH v3] [SIGNED-OFF] ext4: don't work without procfs
Date: Thu,  6 Oct 2011 17:51:16 +0200
Message-ID: <1317916276-2509-1-git-send-email-yargil@free.fr>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-kernel@vger.kernel.org, Yargil <yargil@free.fr>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:45440 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab1JFPwj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Oct 2011 11:52:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yargil <yargil@free.fr>

Regression from commit dd68314ccf3fb918c1fb6471817edbc60ece4b52
The problem come from the test of the return value of proc_mkdir
that is always false without procfs and abort the init of ext4.

Signed-off-by: Fabrice Jouhaud <yargil@free.fr>
---
 fs/ext4/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 44d0c8d..9b51b17 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4985,8 +4985,10 @@ static int __init ext4_init_fs(void)
 	if (!ext4_kset)
 		goto out6;
 	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
+#ifdef CONFIG_PROC_FS
 	if (!ext4_proc_root)
 		goto out5;
+#endif
 
 	err = ext4_init_feat_adverts();
 	if (err)
-- 
1.7.2.5

