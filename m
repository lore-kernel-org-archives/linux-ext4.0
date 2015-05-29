From: Chao Yu <chao2.yu@samsung.com>
Subject: [PATCH 1/2] ext4 crypto: release crypto resource when module exit
Date: Fri, 29 May 2015 10:55:37 +0800
Message-ID: <002801d099bb$13ec4610$3bc4d230$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, mhalcrow@google.com, jaegeuk@kernel.org
To: 'Ext4 Developers List' <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:60857 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbbE2C4l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 May 2015 22:56:41 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NP3001E1C664520@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Fri, 29 May 2015 11:56:30 +0900 (KST)
Content-language: zh-cn
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Crypto resource should be released when ext4 module exits, otherwise
it will cause memory leak.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index aa7621f..e0952b9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5640,6 +5640,7 @@ out7:
 
 static void __exit ext4_exit_fs(void)
 {
+	ext4_exit_crypto();
 	ext4_destroy_lazyinit_thread();
 	unregister_as_ext2();
 	unregister_as_ext3();
-- 
2.3.3


