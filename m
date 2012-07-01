From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 34/35 v3] mke2fs: enable inline_data feature on ext4dev filesystem
Date: Sun,  1 Jul 2012 21:48:57 +0800
Message-ID: <1341150538-32047-35-git-send-email-wenqing.lz@taobao.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49296 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab2GANlw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:41:52 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so6469492pbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:41:52 -0700 (PDT)
In-Reply-To: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Now inline_data feature gets stable.  So we enable it on ext4dev filesystem.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/mke2fs.conf.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
index 178733f..4c5dba7 100644
--- a/misc/mke2fs.conf.in
+++ b/misc/mke2fs.conf.in
@@ -16,7 +16,7 @@
 		inode_size = 256
 	}
 	ext4dev = {
-		features = has_journal,extent,huge_file,flex_bg,metadata_csum,64bit,dir_nlink,extra_isize
+		features = has_journal,extent,huge_file,flex_bg,metadata_csum,inline_data,64bit,dir_nlink,extra_isize
 		inode_size = 256
 		options = test_fs=1
 	}
-- 
1.7.4.1

