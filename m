From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH 20/24] ext4: return actual error on ext4_init_fs
Date: Tue, 17 Jun 2014 22:32:54 +0800
Message-ID: <53A05196.60801@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50458 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbaFQOeK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jun 2014 10:34:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jie Liu <jeff.liu@oracle.com>

Return the actual error code if call kset_create_and_add() failed

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/ext4/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b9b9aab..5912193 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5545,8 +5545,8 @@ static int __init ext4_init_fs(void)
 	if (err)
 		goto out6;
 	ext4_kset = kset_create_and_add("ext4", NULL, fs_kobj);
-	if (!ext4_kset) {
-		err = -ENOMEM;
+	if (IS_ERR(ext4_kset)) {
+		err = PTR_ERR(ext4_kset);
 		goto out5;
 	}
 	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
-- 
1.8.3.2
